import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/models/option_chain_model.dart';
import '../../../../shared/services/option_chain_websocket_service.dart';
import '../../../../generated/protos/option_chain.pb.dart' as proto;

/// Service to convert WebSocket Protobuf data to app's OptionChain model
class RealOptionChainService {
  static RealOptionChainService? _instance;
  StreamSubscription<proto.OptionChain>? _wsSubscription;
  StreamSubscription<String>? _statusSubscription;
  StreamSubscription<String>? _errorSubscription;

  final StreamController<OptionChainModel?> _optionChainController = 
      StreamController<OptionChainModel?>.broadcast();
  final StreamController<String> _statusController = 
      StreamController<String>.broadcast();

  String _currentIndex = '';
  String _currentExpiry = '';
  double _currentUnderlyingPrice = 0.0;

  /// Singleton instance
  static RealOptionChainService get instance {
    _instance ??= RealOptionChainService._();
    return _instance!;
  }

  RealOptionChainService._();

  /// Stream of parsed option chain data
  Stream<OptionChainModel?> get optionChainStream => _optionChainController.stream;

  /// Stream of connection status
  Stream<String> get statusStream => _statusController.stream;

  /// Current option chain
  OptionChainModel? _currentOptionChain;
  OptionChainModel? get currentOptionChain => _currentOptionChain;

  /// Initialize the service
  Future<void> initialize() async {
    debugPrint('🚀 RealOptionChainService: Initializing...');

    // Connect to WebSocket
    await OptionChainWebSocketService.instance.connect();

    // Listen to WebSocket data stream
    _wsSubscription = OptionChainWebSocketService.instance.optionChainStream.listen(
      _handleProtobufData,
      onError: (error) {
        debugPrint('❌ RealOptionChainService: Error in WebSocket stream: $error');
      },
    );

    // Listen to WebSocket status
    _statusSubscription = OptionChainWebSocketService.instance.statusStream.listen(
      (status) {
        debugPrint('🔌 RealOptionChainService: WebSocket status: $status');
        _statusController.add(status);
      },
    );

    // Listen to WebSocket errors
    _errorSubscription = OptionChainWebSocketService.instance.errorStream.listen(
      (error) {
        debugPrint('❌ RealOptionChainService: WebSocket error: $error');
      },
    );

    debugPrint('✅ RealOptionChainService: Initialized');
  }

  /// Subscribe to option chain for specific index and expiry
  Future<void> subscribeToOptionChain(String index, String expiry) async {
    debugPrint('📡 RealOptionChainService: Subscribing to $index - $expiry');
    
    _currentIndex = index;
    _currentExpiry = expiry;

    // Subscribe via WebSocket
    await OptionChainWebSocketService.instance.subscribe(index, expiry);
  }

  /// Unsubscribe from current option chain
  Future<void> unsubscribe() async {
    debugPrint('📡 RealOptionChainService: Unsubscribing');
    await OptionChainWebSocketService.instance.unsubscribe();
    _currentIndex = '';
    _currentExpiry = '';
  }

  /// Handle incoming Protobuf data and convert to app model
  void _handleProtobufData(proto.OptionChain protobufChain) {
    try {
      debugPrint('📊 RealOptionChainService: Processing ${protobufChain.options.length} options');

      if (protobufChain.options.isEmpty) {
        debugPrint('⚠️ RealOptionChainService: Received empty option chain');
        return;
      }

      // Group options by strike price
      final Map<double, Map<String, proto.OptionData>> strikeMap = {};
      
      for (final option in protobufChain.options) {
        final strike = option.strikePrice;
        
        if (!strikeMap.containsKey(strike)) {
          strikeMap[strike] = {};
        }
        
        final optionType = option.optionType.toUpperCase();
        strikeMap[strike]![optionType] = option;

        // Update underlying price (assume it's similar across options)
        if (optionType == 'CE' || optionType == 'CALL') {
          // Estimate underlying price from ATM options
          _currentUnderlyingPrice = strike;
        }
      }

      // Convert to StrikePriceData list
      final List<StrikePriceData> strikes = [];
      
      for (final entry in strikeMap.entries) {
        final strikePrice = entry.key;
        final options = entry.value;
        
        final callOption = options['CE'] ?? options['CALL'];
        final putOption = options['PE'] ?? options['PUT'];

        if (callOption == null || putOption == null) {
          continue; // Skip incomplete strikes
        }

        final call = _convertProtobufToOptionData(callOption);
        final put = _convertProtobufToOptionData(putOption);

        final isAtm = (_currentUnderlyingPrice - strikePrice).abs() < 50.0;
        final isItm = strikePrice < _currentUnderlyingPrice;

        strikes.add(StrikePriceData(
          strikePrice: strikePrice,
          isAtm: isAtm,
          isItm: isItm,
          call: call,
          put: put,
        ));
      }

      // Sort strikes by price
      strikes.sort((a, b) => a.strikePrice.compareTo(b.strikePrice));

      // Parse expiry
      final expiry = _parseExpiry(_currentExpiry);

      // Create option chain model
      final optionChain = OptionChainModel(
        underlying: _currentIndex,
        underlyingPrice: _currentUnderlyingPrice,
        expiry: expiry,
        strikes: strikes,
        lastUpdated: DateTime.now(),
      );

      _currentOptionChain = optionChain;
      _optionChainController.add(optionChain);

      debugPrint('✅ RealOptionChainService: Processed ${strikes.length} strikes for $_currentIndex');
    } catch (e, stackTrace) {
      debugPrint('❌ RealOptionChainService: Error processing protobuf data: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Convert Protobuf OptionData to app's OptionData model
  OptionData _convertProtobufToOptionData(proto.OptionData protobufData) {
    return OptionData(
      ltp: protobufData.ltp,
      bid: protobufData.bid,
      ask: protobufData.ask,
      volume: protobufData.volume.toInt(),
      openInterest: protobufData.oi.toInt(),
      change: protobufData.ltpch,
      changePercent: protobufData.ltpchp,
      iv: 0.0, // Not provided in protobuf, could calculate or fetch separately
      delta: 0.0,
      gamma: 0.0,
      theta: 0.0,
      vega: 0.0,
    );
  }

  /// Parse expiry string to DateTime
  DateTime _parseExpiry(String expiryStr) {
    try {
      // Handle format: "14/10/2025"
      if (expiryStr.contains('/')) {
        final parts = expiryStr.split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
      }

      // Handle format: "14OCT25"
      if (RegExp(r'^\d{2}[A-Z]{3}\d{2}$').hasMatch(expiryStr)) {
        final day = int.parse(expiryStr.substring(0, 2));
        final monthStr = expiryStr.substring(2, 5);
        final year = 2000 + int.parse(expiryStr.substring(5, 7));

        const monthMap = {
          'JAN': 1, 'FEB': 2, 'MAR': 3, 'APR': 4, 'MAY': 5, 'JUN': 6,
          'JUL': 7, 'AUG': 8, 'SEP': 9, 'OCT': 10, 'NOV': 11, 'DEC': 12,
        };

        final month = monthMap[monthStr] ?? 1;
        return DateTime(year, month, day);
      }

      return DateTime.now();
    } catch (e) {
      debugPrint('⚠️ RealOptionChainService: Error parsing expiry: $e');
      return DateTime.now();
    }
  }

  /// Dispose of the service
  void dispose() {
    debugPrint('🔌 RealOptionChainService: Disposing');
    _wsSubscription?.cancel();
    _statusSubscription?.cancel();
    _errorSubscription?.cancel();
    _optionChainController.close();
    _statusController.close();
    OptionChainWebSocketService.instance.disconnect();
  }
}

