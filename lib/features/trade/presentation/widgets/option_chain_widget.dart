import 'package:flutter/material.dart';
import '../../domain/models/option_chain_model.dart';
import '../../../../core/theme/app_colors.dart';

class OptionChainWidget extends StatelessWidget {
  final OptionChainModel optionChain;
  final VoidCallback? onRefresh;

  const OptionChainWidget({
    super.key,
    required this.optionChain,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 300), // Minimum width
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
            child: _buildOptionChainTable(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = optionChain.underlyingPrice >= 0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '${optionChain.underlying} Option Chain',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onRefresh != null)
                IconButton(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh',
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Underlying: ',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    '₹${optionChain.underlyingPrice.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isPositive ? AppColors.success : AppColors.error,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Expiry: ',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    '${optionChain.expiry.day}/${optionChain.expiry.month}/${optionChain.expiry.year}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionChainTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowHeight: 56,
          dataRowMinHeight: 48,
          dataRowMaxHeight: 48,
          columnSpacing: 12,
          horizontalMargin: 16,
          columns: const [
            DataColumn(
              label: Text('OI', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Volume', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('IV', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('LTP', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Chg', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Bid', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Ask', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Strike', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Bid', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Ask', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Chg', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('LTP', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('IV', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Volume', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('OI', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
          ],
          rows: optionChain.strikes.map((strike) => _buildDataRow(context, strike)).toList(),
        ),
      ),
    );
  }

  DataRow _buildDataRow(BuildContext context, StrikePriceData strike) {
    final theme = Theme.of(context);
    final call = strike.call;
    final put = strike.put;
    
    Color? rowColor;
    if (strike.isAtm) {
      rowColor = theme.colorScheme.primary.withOpacity(0.1);
    } else if (strike.isItm) {
      rowColor = theme.colorScheme.secondary.withOpacity(0.05);
    }

    return DataRow(
      color: rowColor != null ? MaterialStateProperty.all(rowColor) : null,
      cells: [
        // Call side
        DataCell(_buildNumericCell(call?.openInterest?.toString() ?? '-', context)),
        DataCell(_buildNumericCell(call?.volume.toString() ?? '-', context)),
        DataCell(_buildNumericCell(call?.iv.toStringAsFixed(1) ?? '-', context)),
        DataCell(_buildPriceCell(call?.ltp, context)),
        DataCell(_buildChangeCell(call?.change, call?.changePercent, context)),
        DataCell(_buildNumericCell(call?.bid.toStringAsFixed(2) ?? '-', context)),
        DataCell(_buildNumericCell(call?.ask.toStringAsFixed(2) ?? '-', context)),
        
        // Strike price (center)
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: strike.isAtm 
                  ? theme.colorScheme.primary.withOpacity(0.2)
                  : null,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              strike.strikePrice.toStringAsFixed(0),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: strike.isAtm ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ),
        
        // Put side
        DataCell(_buildNumericCell(put?.bid.toStringAsFixed(2) ?? '-', context)),
        DataCell(_buildNumericCell(put?.ask.toStringAsFixed(2) ?? '-', context)),
        DataCell(_buildChangeCell(put?.change, put?.changePercent, context)),
        DataCell(_buildPriceCell(put?.ltp, context)),
        DataCell(_buildNumericCell(put?.iv.toStringAsFixed(1) ?? '-', context)),
        DataCell(_buildNumericCell(put?.volume.toString() ?? '-', context)),
        DataCell(_buildNumericCell(put?.openInterest?.toString() ?? '-', context)),
      ],
    );
  }

  Widget _buildNumericCell(String value, BuildContext context) {
    return Text(
      value,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontFamily: 'monospace',
      ),
    );
  }

  Widget _buildPriceCell(double? price, BuildContext context) {
    if (price == null) return const Text('-');
    
    return Text(
      price.toStringAsFixed(2),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w500,
        fontFamily: 'monospace',
      ),
    );
  }

  Widget _buildChangeCell(double? change, double? changePercent, BuildContext context) {
    if (change == null || changePercent == null) return const Text('-');
    
    final isPositive = change >= 0;
    final color = isPositive ? AppColors.success : AppColors.error;
    
    return Text(
      '${isPositive ? '+' : ''}${change.toStringAsFixed(2)} (${changePercent.toStringAsFixed(1)}%)',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: color,
        fontWeight: FontWeight.w500,
        fontFamily: 'monospace',
      ),
    );
  }
}