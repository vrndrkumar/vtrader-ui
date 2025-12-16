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
      // Confirm data is arriving from socket:
      debugPrint('✅ RealOptionChainService: protobuf received, options=${protobufChain.options.length}');

      if (protobufChain.options.isEmpty) {
        return;
      }

      // Underlying snapshot (first record often has strikePrice < 0 / empty optionType)
      final first = protobufChain.options.first;
      if (first.strikePrice < 0 || first.optionType.isEmpty) {
        _currentUnderlyingPrice = first.ltp;
      }

      // Build per-strike aggregation WITHOUT requiring both sides.
      final Map<double, _StrikeAgg> strikeMap = {};
      for (final opt in protobufChain.options) {
        // skip underlying/meta row
        if (opt.strikePrice < 0 || opt.optionType.isEmpty) continue;

        final strike = opt.strikePrice;
        final type = opt.optionType.toUpperCase();
        final agg = strikeMap.putIfAbsent(strike, () => _StrikeAgg(strike));
        if (type == 'CE' || type == 'CALL') {
          agg.call = opt;
        } else if (type == 'PE' || type == 'PUT') {
          agg.put = opt;
        }
      }

      final List<StrikePriceData> strikes = strikeMap.values.map((agg) {
        final call = agg.call == null ? null : _convertProtobufToOptionData(agg.call!);
        final put = agg.put == null ? null : _convertProtobufToOptionData(agg.put!);
        final isAtm = (_currentUnderlyingPrice - agg.strikePrice).abs() < 100.0;
        final isItm = agg.strikePrice < _currentUnderlyingPrice;
        return StrikePriceData(
          strikePrice: agg.strikePrice,
          call: call,
          put: put,
          isAtm: isAtm,
          isItm: isItm,
        );
      }).toList()
        ..sort((a, b) => a.strikePrice.compareTo(b.strikePrice));

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

    } catch (e, stackTrace) {
      debugPrint('❌ RealOptionChainService: Error processing protobuf data: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Convert Protobuf OptionData to app's OptionData model
  OptionData _convertProtobufToOptionData(proto.OptionData protobufData) {
    return OptionData(
      // Only bid/ask are required for the table. Everything else is intentionally ignored.
      ltp: 0.0,
      bid: protobufData.bid,
      ask: protobufData.ask,
      volume: 0,
      openInterest: 0,
      change: 0.0,
      changePercent: 0.0,
      iv: 0.0,
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

class _StrikeAgg {
  final double strikePrice;
  proto.OptionData? call;
  proto.OptionData? put;
  _StrikeAgg(this.strikePrice);
}

