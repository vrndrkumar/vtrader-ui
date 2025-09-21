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
    // Create a unique key based on option chain data
    final dataKey = '${optionChain.underlying}_${optionChain.underlyingPrice}_${optionChain.strikes.length}';
    print('OptionChainWidget build called for ${optionChain.underlying} with ${optionChain.strikes.length} strikes');
    
    return Container(
      key: ValueKey(dataKey),
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
    return Column(
      children: [
        // Fixed header
        Container(
          color: Theme.of(context).cardColor,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildTableHeader(context),
          ),
        ),
        const Divider(height: 1),
        // Scrollable data rows
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: _buildTableRows(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Call side headers
          _buildHeaderCell('OI', 60),
          _buildHeaderCell('Volume', 70),
          _buildHeaderCell('IV', 50),
          _buildHeaderCell('LTP', 60),
          _buildHeaderCell('Chg', 80),
          _buildHeaderCell('Bid', 60),
          _buildHeaderCell('Ask', 60),
          
          // Strike header (center)
          _buildHeaderCell('Strike', 80, isCenter: true),
          
          // Put side headers
          _buildHeaderCell('Bid', 60),
          _buildHeaderCell('Ask', 60),
          _buildHeaderCell('Chg', 80),
          _buildHeaderCell('LTP', 60),
          _buildHeaderCell('IV', 50),
          _buildHeaderCell('Volume', 70),
          _buildHeaderCell('OI', 60),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width, {bool isCenter = false}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        textAlign: isCenter ? TextAlign.center : TextAlign.right,
      ),
    );
  }

  Widget _buildTableRows(BuildContext context) {
    return Column(
      children: optionChain.strikes.map((strike) => _buildTableRow(context, strike)).toList(),
    );
  }

  Widget _buildTableRow(BuildContext context, StrikePriceData strike) {
    final theme = Theme.of(context);
    final call = strike.call;
    final put = strike.put;
    
    Color? rowColor;
    if (strike.isAtm) {
      rowColor = theme.colorScheme.primary.withOpacity(0.1);
    } else if (strike.isItm) {
      rowColor = theme.colorScheme.secondary.withOpacity(0.05);
    }

    return Container(
      color: rowColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Call side
          _buildDataCell(call?.openInterest?.toString() ?? '-', 60),
          _buildDataCell(call?.volume.toString() ?? '-', 70),
          _buildDataCell(call?.iv.toStringAsFixed(1) ?? '-', 50),
          _buildPriceDataCell(call?.ltp, 60),
          _buildChangeDataCell(call?.change, call?.changePercent, 80),
          _buildDataCell(call?.bid.toStringAsFixed(2) ?? '-', 60),
          _buildDataCell(call?.ask.toStringAsFixed(2) ?? '-', 60),
          
          // Strike price (center)
          _buildStrikeCell(strike, 80, context),
          
          // Put side
          _buildDataCell(put?.bid.toStringAsFixed(2) ?? '-', 60),
          _buildDataCell(put?.ask.toStringAsFixed(2) ?? '-', 60),
          _buildChangeDataCell(put?.change, put?.changePercent, 80),
          _buildPriceDataCell(put?.ltp, 60),
          _buildDataCell(put?.iv.toStringAsFixed(1) ?? '-', 50),
          _buildDataCell(put?.volume.toString() ?? '-', 70),
          _buildDataCell(put?.openInterest?.toString() ?? '-', 60),
        ],
      ),
    );
  }

  Widget _buildDataCell(String value, double width) {
    return SizedBox(
      width: width,
      child: Text(
        value,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildPriceDataCell(double? price, double width) {
    return SizedBox(
      width: width,
      child: Text(
        price?.toStringAsFixed(2) ?? '-',
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: 'monospace',
          fontSize: 11,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildChangeDataCell(double? change, double? changePercent, double width) {
    if (change == null || changePercent == null) {
      return _buildDataCell('-', width);
    }
    
    final isPositive = change >= 0;
    final color = isPositive ? AppColors.success : AppColors.error;
    
    return SizedBox(
      width: width,
      child: Text(
        '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}\n(${changePercent.toStringAsFixed(1)}%)',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
          fontFamily: 'monospace',
          fontSize: 10,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildStrikeCell(StrikePriceData strike, double width, BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: strike.isAtm 
              ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
              : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          strike.strikePrice.toStringAsFixed(0),
          style: TextStyle(
            fontWeight: strike.isAtm ? FontWeight.bold : FontWeight.w500,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
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