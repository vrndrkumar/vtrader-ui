import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:candlesticks/candlesticks.dart';
import '../../domain/models/option_chain_model.dart';
import '../../data/services/chart_data_service.dart';
import '../../data/services/real_option_chain_service.dart';
import '../../../../shared/providers/master_data_provider.dart';

/// Real-time chart widget with API integration and WebSocket updates
class RealtimeChartWidget extends ConsumerStatefulWidget {
  const RealtimeChartWidget({super.key});

  @override
  ConsumerState<RealtimeChartWidget> createState() => _RealtimeChartWidgetState();
}

class _RealtimeChartWidgetState extends ConsumerState<RealtimeChartWidget> {
  final ChartDataService _chartService = ChartDataService.instance;
  final RealOptionChainService _wsService = RealOptionChainService.instance;
  
  List<CandleData> _candleData = [];
  String _selectedSymbol = 'NIFTY';
  int _selectedFrequency = 1; // Default 1 min
  bool _isLoading = false;
  String? _errorMessage;
  
  StreamSubscription<OptionChainModel?>? _wsSubscription;
  Timer? _updateTimer;

  final Map<String, int> _timeframeMap = {
    '1m': 1,
    '5m': 5,
    '10m': 10,
    '15m': 15,
    '30m': 30,
    '1H': 60,
  };

  @override
  void initState() {
    super.initState();
    _setupWebSocketListener();
    // Defer data loading until after the first frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadChartData();
    });
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    _updateTimer?.cancel();
    super.dispose();
  }

  /// Load historical chart data from API
  Future<void> _loadChartData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final candleData = await _chartService.fetchCandleData(
        symbol: _selectedSymbol,
        frequency: _selectedFrequency,
      );

      if (mounted) {
        setState(() {
          _candleData = candleData;
          _isLoading = false;
        });
        
        print('📊 Loaded ${candleData.length} candles for $_selectedSymbol ($_selectedFrequency min)');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load chart data: $e';
        });
      }
    }
  }

  /// Setup WebSocket listener for real-time updates
  void _setupWebSocketListener() {
    _wsSubscription = _wsService.optionChainStream.listen((optionChain) {
      if (optionChain != null && 
          optionChain.underlying == _selectedSymbol &&
          _candleData.isNotEmpty) {
        // Schedule update after current frame to avoid setState during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _updateLastCandle(optionChain.underlyingPrice);
          }
        });
      }
    });
  }

  /// Update last candle with real-time price
  void _updateLastCandle(double currentPrice) {
    if (_candleData.isEmpty || !mounted) return;

    setState(() {
      final lastCandle = _candleData.last;
      _candleData[_candleData.length - 1] = _chartService.updateLastCandle(
        lastCandle,
        currentPrice,
      );
    });
  }

  /// Handle symbol change
  void _onSymbolChanged(String? newSymbol) {
    if (newSymbol != null && newSymbol != _selectedSymbol) {
      setState(() {
        _selectedSymbol = newSymbol;
      });
      _loadChartData();
    }
  }

  /// Handle timeframe change
  void _onTimeframeChanged(String timeframe) {
    final frequency = _timeframeMap[timeframe];
    if (frequency != null && frequency != _selectedFrequency) {
      setState(() {
        _selectedFrequency = frequency;
      });
      _loadChartData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      constraints: const BoxConstraints(minWidth: 300, minHeight: 200),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          const Divider(height: 1),
          Expanded(
            child: _buildChartContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final masterDataState = ref.watch(masterDataStateProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;

        return Container(
          padding: EdgeInsets.all(isNarrow ? 8 : 16),
          child: Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Index dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  borderRadius: BorderRadius.circular(8),
                  color: theme.colorScheme.surface,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSymbol,
                    isDense: true,
                    onChanged: masterDataState.isLoading ? null : _onSymbolChanged,
                    items: masterDataState.indices.map((index) {
                      return DropdownMenuItem<String>(
                        value: index.symbolCode,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              index.symbolName,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: isNarrow ? 12 : 14,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              index.exchange,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                                fontSize: isNarrow ? 10 : 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Timeframe selector
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _timeframeMap.keys.map((timeframe) {
                    final isSelected = _timeframeMap[timeframe] == _selectedFrequency;
                    return GestureDetector(
                      onTap: () => _onTimeframeChanged(timeframe),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isNarrow ? 8 : 12,
                          vertical: isNarrow ? 4 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? theme.colorScheme.primary : null,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          timeframe,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isSelected ? Colors.white : null,
                            fontWeight: isSelected ? FontWeight.bold : null,
                            fontSize: isNarrow ? 10 : 12,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Refresh button
              IconButton(
                onPressed: _isLoading ? null : _loadChartData,
                icon: Icon(
                  Icons.refresh,
                  size: isNarrow ? 18 : 22,
                ),
                tooltip: 'Refresh Chart',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChartContent(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadChartData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_candleData.isEmpty) {
      return const Center(
        child: Text('No chart data available'),
      );
    }

    // Convert to candlesticks package format (newest first)
    final candles = _candleData.reversed.map((data) => Candle(
      date: data.time,
      high: data.high,
      low: data.low,
      open: data.open,
      close: data.close,
      volume: data.volume.toDouble(),
    )).toList();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Candlesticks(
        candles: candles,
        onLoadMoreCandles: () async {
          // Future: implement pagination
          return Future.value();
        },
      ),
    );
  }
}

