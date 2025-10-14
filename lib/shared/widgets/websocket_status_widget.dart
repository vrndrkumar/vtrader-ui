import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/option_chain_websocket_service.dart';

/// Widget to display WebSocket connection status for debugging
class WebSocketStatusWidget extends ConsumerStatefulWidget {
  const WebSocketStatusWidget({super.key});

  @override
  ConsumerState<WebSocketStatusWidget> createState() => _WebSocketStatusWidgetState();
}

class _WebSocketStatusWidgetState extends ConsumerState<WebSocketStatusWidget> {
  String _status = 'disconnected';
  String? _currentChannel;
  int _messageCount = 0;
  String? _lastError;
  String _testChannel = 'OPTION_CHAIN_NIFTY_14OCT25';
  final TextEditingController _channelController = TextEditingController();
  List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _channelController.text = _testChannel;
    _listenToWebSocket();
    _addLog('Widget initialized');
  }

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  void _addLog(String message) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    if (mounted) {
      setState(() {
        _logs.insert(0, '[$timestamp] $message');
        if (_logs.length > 10) _logs.removeLast();
      });
    }
    debugPrint('🔧 WS Test: $message');
  }

  void _listenToWebSocket() {
    // Listen to status changes
    OptionChainWebSocketService.instance.statusStream.listen((status) {
      _addLog('Status changed: $status');
      if (mounted) {
        setState(() {
          _status = status;
        });
      }
    });

    // Listen to option chain data (to count messages)
    OptionChainWebSocketService.instance.optionChainStream.listen((data) {
      _addLog('Received data: ${data.options.length} options');
      if (mounted) {
        setState(() {
          _messageCount++;
        });
      }
    });

    // Listen to errors
    OptionChainWebSocketService.instance.errorStream.listen((error) {
      _addLog('Error: $error');
      if (mounted) {
        setState(() {
          _lastError = error;
        });
      }
    });

    // Update current channel periodically
    _updateCurrentChannel();
  }

  void _updateCurrentChannel() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _currentChannel = OptionChainWebSocketService.instance.currentChannel;
        });
        _updateCurrentChannel(); // Continue updating
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Color statusColor;
    IconData statusIcon;
    
    switch (_status) {
      case 'connected':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'connecting':
        statusColor = Colors.orange;
        statusIcon = Icons.sync;
        break;
      case 'error':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.cloud_off;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        border: Border.all(color: statusColor, width: 3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(statusIcon, color: statusColor, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WebSocket Test Panel',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      _status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'Messages: $_messageCount',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _channelController,
                  decoration: InputDecoration(
                    labelText: 'Test Channel',
                    hintText: 'OPTION_CHAIN_NIFTY_14OCT25',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.podcasts),
                  ),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: _connect,
                icon: const Icon(Icons.wifi, size: 20),
                label: const Text('CONNECT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _disconnect,
                icon: const Icon(Icons.wifi_off, size: 20),
                label: const Text('DISCONNECT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _subscribe,
                icon: const Icon(Icons.send, size: 20),
                label: const Text('SUBSCRIBE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _clearLogs,
                icon: const Icon(Icons.clear, size: 20),
                label: const Text('CLEAR LOGS'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
          if (_currentChannel != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.podcasts, color: Colors.blue, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Active Channel: $_currentChannel',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (_logs.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      _logs[index],
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: Colors.greenAccent,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _connect() {
    _addLog('Connecting to WebSocket...');
    OptionChainWebSocketService.instance.connect();
  }

  void _disconnect() {
    _addLog('Disconnecting from WebSocket...');
    OptionChainWebSocketService.instance.disconnect();
  }

  void _subscribe() {
    final channel = _channelController.text.trim();
    if (channel.isEmpty) {
      _addLog('ERROR: Channel is empty');
      return;
    }
    
    _addLog('Subscribing to: $channel');
    
    // Parse channel format: OPTION_CHAIN_INDEX_EXPIRY
    final parts = channel.split('_');
    if (parts.length >= 4) {
      final index = parts[2];
      final expiry = parts[3];
      _addLog('Parsed: Index=$index, Expiry=$expiry');
      OptionChainWebSocketService.instance.subscribe(index, expiry);
    } else {
      _addLog('ERROR: Invalid channel format. Use: OPTION_CHAIN_INDEX_EXPIRY');
    }
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
  }
}
