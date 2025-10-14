import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/option_chain_websocket_service.dart';

/// Floating action button for WebSocket testing
class FloatingWSTestButton extends ConsumerStatefulWidget {
  const FloatingWSTestButton({super.key});

  @override
  ConsumerState<FloatingWSTestButton> createState() => _FloatingWSTestButtonState();
}

class _FloatingWSTestButtonState extends ConsumerState<FloatingWSTestButton> {
  bool _showPanel = false;
  String _status = 'disconnected';
  int _messageCount = 0;
  List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _listenToWebSocket();
  }

  void _listenToWebSocket() {
    OptionChainWebSocketService.instance.statusStream.listen((status) {
      if (mounted) {
        setState(() => _status = status);
        _addLog('Status: $status');
      }
    });

    OptionChainWebSocketService.instance.optionChainStream.listen((data) {
      if (mounted) {
        setState(() => _messageCount++);
        _addLog('Data: ${data.options.length} options');
      }
    });

    OptionChainWebSocketService.instance.errorStream.listen((error) {
      _addLog('ERROR: $error');
    });
  }

  void _addLog(String message) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    setState(() {
      _logs.insert(0, '[$timestamp] $message');
      if (_logs.length > 20) _logs.removeLast();
    });
    debugPrint('🔧 WS: $message');
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = _status == 'connected' ? Colors.green : Colors.red;

    return Stack(
      children: [
        // Floating Action Button
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            onPressed: () => setState(() => _showPanel = !_showPanel),
            backgroundColor: statusColor,
            icon: Icon(
              _status == 'connected' ? Icons.wifi : Icons.wifi_off,
              color: Colors.white,
            ),
            label: Text(
              'WS Test ($_messageCount)',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Test Panel
        if (_showPanel)
          Positioned(
            right: 16,
            bottom: 80,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 400,
                height: 500,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor, width: 3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.settings_input_antenna, color: statusColor),
                        const SizedBox(width: 8),
                        const Text(
                          'WebSocket Test',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => setState(() => _showPanel = false),
                        ),
                      ],
                    ),
                    const Divider(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: statusColor),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Status: ${_status.toUpperCase()}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Messages: $_messageCount',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _addLog('CONNECT clicked');
                            OptionChainWebSocketService.instance.connect();
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          child: const Text('CONNECT'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _addLog('DISCONNECT clicked');
                            OptionChainWebSocketService.instance.disconnect();
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: const Text('DISCONNECT'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _addLog('SUBSCRIBE clicked: NIFTY 14OCT25');
                            OptionChainWebSocketService.instance.subscribe('NIFTY', '14OCT25');
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          child: const Text('SUBSCRIBE'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Logs:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
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
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

