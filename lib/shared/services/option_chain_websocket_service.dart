import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../generated/protos/option_chain.pb.dart';

/// WebSocket service for real-time option chain data using Protobuf
class OptionChainWebSocketService {
  static OptionChainWebSocketService? _instance;
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;
  String? _currentChannel;
  bool _isConnecting = false;
  bool _shouldReconnect = true;

  // Stream controllers
  final StreamController<OptionChain> _optionChainController = 
      StreamController<OptionChain>.broadcast();
  final StreamController<String> _statusController = 
      StreamController<String>.broadcast();
  final StreamController<String> _errorController = 
      StreamController<String>.broadcast();

  /// Singleton instance
  static OptionChainWebSocketService get instance {
    _instance ??= OptionChainWebSocketService._();
    return _instance!;
  }

  OptionChainWebSocketService._();

  /// WebSocket URL (WSS for secure connection)
  static const String _webSocketUrl = 'wss://apivtrader.a.pinggy.link';

  /// Stream of option chain data (Protobuf decoded)
  Stream<OptionChain> get optionChainStream => _optionChainController.stream;

  /// Stream of connection status
  Stream<String> get statusStream => _statusController.stream;

  /// Stream of errors
  Stream<String> get errorStream => _errorController.stream;

  /// Current connection status
  bool get isConnected => _channel != null;

  /// Current subscribed channel
  String? get currentChannel => _currentChannel;

  /// Connect to WebSocket server
  Future<void> connect() async {
    if (_isConnecting || isConnected) {
      debugPrint('🔌 WebSocket: Already connected or connecting');
      return;
    }

    try {
      _isConnecting = true;
      _statusController.add('connecting');
      
      debugPrint('🔌 WebSocket: Connecting to $_webSocketUrl');

      _channel = WebSocketChannel.connect(
        Uri.parse(_webSocketUrl),
      );

      // Wait for connection to establish
      await _channel!.ready.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('WebSocket connection timeout');
        },
      );

      debugPrint('✅ WebSocket: Connected successfully');
      _statusController.add('connected');
      _isConnecting = false;

      // Listen for messages
      _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
        cancelOnError: false,
      );

      // Start heartbeat to keep connection alive
      _startHeartbeat();

    } catch (e) {
      _isConnecting = false;
      debugPrint('❌ WebSocket: Connection failed: $e');
      _statusController.add('error');
      _errorController.add('Connection failed: $e');
      _scheduleReconnect();
    }
  }

  /// Handle incoming messages
  void _handleMessage(dynamic message) {
    try {
      // Flutter Web may deliver binary frames as Uint8List, ByteBuffer, or List<int>.
      Uint8List? bytes;
      if (message is Uint8List) {
        bytes = message;
      } else if (message is ByteBuffer) {
        bytes = message.asUint8List();
      } else if (message is List<int>) {
        bytes = Uint8List.fromList(message);
      }

      if (bytes != null) {
        // Decode Protobuf message
        final optionChain = OptionChain.fromBuffer(bytes);

        // Emit to stream
        _optionChainController.add(optionChain);
        return;
      }

      if (message is String) {
        debugPrint('📨 WebSocket: Received text message: $message');
        
        // Handle text responses (subscription confirmations, errors, etc.)
        try {
          final data = jsonDecode(message);
          if (data['type'] == 'error') {
            _errorController.add(data['message'] ?? 'Unknown error');
          } else if (data['type'] == 'subscribed') {
            debugPrint('✅ WebSocket: Subscription confirmed for ${data['channel']}');
          } else if (data['type'] == 'unsubscribed') {
            debugPrint('✅ WebSocket: Unsubscription confirmed for ${data['channel']}');
          }
        } catch (e) {
          debugPrint('⚠️ WebSocket: Non-JSON text message: $message');
        }
      } else {
        debugPrint('⚠️ WebSocket: Unknown message type: ${message.runtimeType}');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ WebSocket: Error handling message: $e');
      debugPrint('Stack trace: $stackTrace');
      _errorController.add('Error parsing message: $e');
    }
  }

  /// Handle WebSocket errors
  void _handleError(dynamic error) {
    debugPrint('❌ WebSocket: Error occurred: $error');
    _statusController.add('error');
    _errorController.add('WebSocket error: $error');
    _scheduleReconnect();
  }

  /// Handle WebSocket disconnection
  void _handleDisconnect() {
    debugPrint('🔌 WebSocket: Connection closed');
    _statusController.add('disconnected');
    _channel = null;
    _scheduleReconnect();
  }

  /// Subscribe to option chain for specific index and expiry
  /// Format: OPTION_CHAIN_<INDEX>_<EXPIRY>
  /// Example: OPTION_CHAIN_NIFTY_20OCT25
  Future<void> subscribe(String index, String expiry) async {
    // Ensure we're connected
    if (!isConnected) {
      await connect();
    }

    // Convert expiry format if needed (14/10/2025 -> 14OCT25)
    final formattedExpiry = _formatExpiryForChannel(expiry);
    final channel = 'OPTION_CHAIN_${index.toUpperCase()}_$formattedExpiry';

    // Unsubscribe from current channel if different
    if (_currentChannel != null && _currentChannel != channel) {
      await unsubscribe();
    }

    try {
      final message = jsonEncode({
        'action': 'subscribe',
        'channel': channel,
      });

      _channel?.sink.add(message);
      _currentChannel = channel;
      
      debugPrint('📡 WebSocket: Subscribed to $channel');
    } catch (e) {
      debugPrint('❌ WebSocket: Failed to subscribe: $e');
      _errorController.add('Failed to subscribe: $e');
    }
  }

  /// Unsubscribe from current channel
  Future<void> unsubscribe() async {
    if (_currentChannel == null || !isConnected) {
      return;
    }

    try {
      final message = jsonEncode({
        'action': 'unsubscribe',
        'channel': _currentChannel,
      });

      _channel?.sink.add(message);
      
      debugPrint('📡 WebSocket: Unsubscribed from $_currentChannel');
      _currentChannel = null;
    } catch (e) {
      debugPrint('❌ WebSocket: Failed to unsubscribe: $e');
      _errorController.add('Failed to unsubscribe: $e');
    }
  }

  /// Format expiry for channel subscription
  /// Converts "14/10/2025" to "14OCT25"
  String _formatExpiryForChannel(String expiry) {
    try {
      // If already in correct format (14OCT25), return as-is
      if (RegExp(r'^\d{2}[A-Z]{3}\d{2}$').hasMatch(expiry)) {
        return expiry;
      }

      // Parse from dropdown format (14/10/2025)
      final parts = expiry.split('/');
      if (parts.length == 3) {
        final day = parts[0].padLeft(2, '0');
        final month = int.parse(parts[1]);
        final year = parts[2].substring(2); // Last 2 digits

        const months = [
          '', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
          'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
        ];

        return '$day${months[month]}$year';
      }

      return expiry; // Return as-is if can't parse
    } catch (e) {
      debugPrint('⚠️ WebSocket: Error formatting expiry: $e');
      return expiry;
    }
  }

  /// Start heartbeat to keep connection alive
  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (isConnected) {
        try {
          final heartbeat = jsonEncode({
            'action': 'ping',
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          });
          _channel?.sink.add(heartbeat);
          debugPrint('💓 WebSocket: Heartbeat sent');
        } catch (e) {
          debugPrint('⚠️ WebSocket: Heartbeat failed: $e');
        }
      } else {
        timer.cancel();
      }
    });
  }

  /// Schedule reconnection attempt
  void _scheduleReconnect() {
    if (!_shouldReconnect) {
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      debugPrint('🔄 WebSocket: Attempting to reconnect...');
      connect().then((_) {
        // Re-subscribe to current channel if we had one
        if (_currentChannel != null) {
          // Extract index and expiry from channel name
          final parts = _currentChannel!.split('_');
          if (parts.length >= 3) {
            final index = parts[2];
            final expiry = parts.length > 3 ? parts[3] : '';
            subscribe(index, expiry);
          }
        }
      });
    });
  }

  /// Disconnect from WebSocket
  void disconnect() {
    debugPrint('🔌 WebSocket: Disconnecting...');
    _shouldReconnect = false;
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    
    if (_currentChannel != null) {
      unsubscribe();
    }
    
    _channel?.sink.close();
    _channel = null;
    _currentChannel = null;
    _statusController.add('disconnected');
  }

  /// Dispose of the service
  void dispose() {
    disconnect();
    _optionChainController.close();
    _statusController.close();
    _errorController.close();
  }
}

