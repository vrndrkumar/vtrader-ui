import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:candlesticks/candlesticks.dart';
import '../../domain/models/option_chain_model.dart';
import '../../../../core/theme/app_colors.dart';

class ChartWidget extends StatefulWidget {
  final List<CandleData> candleData;
  final String symbol;
  final VoidCallback? onRefresh;

  const ChartWidget({
    super.key,
    required this.candleData,
    required this.symbol,
    this.onRefresh,
  });

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  String selectedTimeframe = '1D';
  final List<String> timeframes = ['1m', '5m', '15m', '1H', '1D', '1W'];

  @override
  Widget build(BuildContext context) {
    print('ChartWidget build called for ${widget.symbol} with ${widget.candleData.length} candles');
    return Container(
      constraints: const BoxConstraints(minWidth: 300, minHeight: 200), // Minimum size
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          const Divider(height: 1),
          Expanded(
            child: _buildChart(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;
        
        return Container(
          padding: EdgeInsets.all(isNarrow ? 8 : 16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${widget.symbol} Chart',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isNarrow ? 16 : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.onRefresh != null)
                    IconButton(
                      onPressed: widget.onRefresh,
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Refresh',
                      iconSize: isNarrow ? 20 : 24,
                    ),
                ],
              ),
              if (!isNarrow) const SizedBox(height: 8),
              // Timeframe selector
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: isNarrow 
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _buildTimeframeButtons(theme, isNarrow),
                    )
                  : _buildTimeframeButtons(theme, isNarrow),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeframeButtons(ThemeData theme, bool isNarrow) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: timeframes.map((timeframe) {
        final isSelected = timeframe == selectedTimeframe;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedTimeframe = timeframe;
            });
          },
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
                fontSize: isNarrow ? 10 : null,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChart(BuildContext context) {
    if (widget.candleData.isEmpty) {
      return const Center(
        child: Text('No chart data available'),
      );
    }

    // Convert our CandleData to the candlesticks package format
    final candles = widget.candleData.map((data) => Candle(
      date: data.time,
      high: data.high,
      low: data.low,
      open: data.open,
      close: data.close,
      volume: data.volume.toDouble(),
    )).toList();

    // Create a unique key based on symbol and first/last candle data
    final dataKey = candles.isNotEmpty 
        ? '${widget.symbol}_${candles.first.close}_${candles.last.close}_${candles.length}'
        : '${widget.symbol}_empty';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 400;
        
        return Padding(
          padding: EdgeInsets.all(isNarrow ? 8 : 16),
          child: Candlesticks(
            key: ValueKey(dataKey),
            candles: candles,
            onLoadMoreCandles: () async {
              // Placeholder for loading more data
              return;
            },
            actions: constraints.maxWidth > 300 ? [
              ToolBarAction(
                onPressed: () {
                  widget.onRefresh?.call();
                },
                child: Icon(Icons.refresh, size: isNarrow ? 16 : 20),
              ),
            ] : [],
          ),
        );
      },
    );
  }

  LineChartData _buildLineChartData(BuildContext context) {
    final theme = Theme.of(context);
    final spots = widget.candleData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.close);
    }).toList();

    final minY = widget.candleData.map((e) => e.low).reduce((a, b) => a < b ? a : b);
    final maxY = widget.candleData.map((e) => e.high).reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.1;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        verticalInterval: (spots.length / 6).ceilToDouble(),
        horizontalInterval: (maxY - minY) / 5,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: theme.dividerColor.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: theme.dividerColor.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: (spots.length / 6).ceilToDouble(),
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < widget.candleData.length) {
                final date = widget.candleData[value.toInt()].time;
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    '${date.day}/${date.month}',
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: (maxY - minY) / 5,
            reservedSize: 60,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(
                  '₹${value.toStringAsFixed(0)}',
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.5),
        ),
      ),
      minX: 0,
      maxX: (spots.length - 1).toDouble(),
      minY: minY - padding,
      maxY: maxY + padding,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          color: AppColors.primary,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.primary.withOpacity(0.1),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              if (spot.x.toInt() >= 0 && spot.x.toInt() < widget.candleData.length) {
                final candle = widget.candleData[spot.x.toInt()];
                return LineTooltipItem(
                  '${candle.time.day}/${candle.time.month}/${candle.time.year}\n'
                  'O: ₹${candle.open.toStringAsFixed(2)}\n'
                  'H: ₹${candle.high.toStringAsFixed(2)}\n'
                  'L: ₹${candle.low.toStringAsFixed(2)}\n'
                  'C: ₹${candle.close.toStringAsFixed(2)}\n'
                  'Vol: ${candle.volume}',
                  TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }
              return null;
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
        getTouchedSpotIndicator: (barData, spotIndexes) {
          return spotIndexes.map((index) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
              FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 6,
                  color: AppColors.primary,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
              ),
            );
          }).toList();
        },
      ),
    );
  }
}
