import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/option_chain_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/providers/master_data_provider.dart';
import '../../../../shared/models/index_model.dart';
import 'floating_trade_widget.dart';

class OptionChainWidget extends ConsumerStatefulWidget {
  final OptionChainModel optionChain;
  final VoidCallback? onRefresh;

  const OptionChainWidget({
    super.key,
    required this.optionChain,
    this.onRefresh,
  });

  @override
  ConsumerState<OptionChainWidget> createState() => _OptionChainWidgetState();
}

class _OptionChainWidgetState extends ConsumerState<OptionChainWidget> {
  String? _hoveredStrike;
  String? _hoveredSide;
  double? _hoveredPrice;
  Offset? _hoverPosition;
  String? _currentHoveredRow; // Track which row is currently hovered

  @override
  Widget build(BuildContext context) {
    // Create a unique key based on option chain data
    final dataKey = '${widget.optionChain.underlying}_${widget.optionChain.underlyingPrice}_${widget.optionChain.strikes.length}';
    print('OptionChainWidget build called for ${widget.optionChain.underlying} with ${widget.optionChain.strikes.length} strikes');
    
    return MouseRegion(
      onExit: (_) {
        setState(() {
          _hoveredStrike = null;
          _hoveredSide = null;
          _hoveredPrice = null;
          _hoverPosition = null;
          _currentHoveredRow = null;
        });
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
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
          ),
          // Floating trade widget
          if (_hoveredStrike != null && _hoveredSide != null && _hoveredPrice != null && _hoverPosition != null)
            Positioned(
              left: _hoverPosition!.dx,
              top: _hoverPosition!.dy,
              child: FloatingTradeWidget(
                strike: _hoveredStrike!,
                side: _hoveredSide!,
                price: _hoveredPrice!,
                onBuy: () => buyOption(_hoveredStrike!, _hoveredSide!),
                onSell: () => sellOption(_hoveredStrike!, _hoveredSide!),
                onChart: () => openChart('${_hoveredStrike!}_${_hoveredSide!}'),
              ),
            ),
        ],
      ),
    );
  }

  void buyOption(String strike, String side) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text("Buy Clicked"),
          content: Text("Buy $side of Strike $strike"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void sellOption(String strike, String side) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text("Sell Clicked"),
          content: Text("Sell $side of Strike $strike"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void openChart(String symbol) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text("Chart Clicked"),
          content: Text("Chart for $symbol"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void _onRowHover(String strike, String side, double price, Offset position) {
    final rowKey = '${strike}_$side';
    
    // Only update if we're hovering a different row
    if (_currentHoveredRow != rowKey) {
      print('Row hovered: $strike $side price: $price position: $position');
      setState(() {
        _hoveredStrike = strike;
        _hoveredSide = side;
        _hoveredPrice = price;
        _hoverPosition = position;
        _currentHoveredRow = rowKey;
      });
    }
  }


  String _formatExpiryForDropdown(String expiry) {
    try {
      final day = expiry.substring(0, 2);
      final monthStr = expiry.substring(2, 5);
      final year = '20${expiry.substring(5, 7)}';
      
      final monthMap = {
        'JAN': '1', 'FEB': '2', 'MAR': '3', 'APR': '4', 'MAY': '5', 'JUN': '6',
        'JUL': '7', 'AUG': '8', 'SEP': '9', 'OCT': '10', 'NOV': '11', 'DEC': '12',
      };
      
      final month = monthMap[monthStr] ?? '1';
      return '$day/$month/$year';
    } catch (e) {
      return expiry;
    }
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = widget.optionChain.underlyingPrice >= 0;
    final masterDataState = ref.watch(masterDataStateProvider);
    final selectedIndex = ref.watch(selectedIndexProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row with Price and Controls
          Row(
            children: [
              // Title
              Text(
                '${widget.optionChain.underlying} Option Chain',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 24),
              
              // Price next to title
              _buildPriceOnly(theme, isPositive),
              const SizedBox(width: 32),
              
              const Spacer(),
              
              // Refresh Button
              if (widget.onRefresh != null)
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: widget.onRefresh,
                    icon: Icon(
                      Icons.refresh,
                      color: theme.colorScheme.primary,
                    ),
                    tooltip: 'Refresh Data',
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceOnly(ThemeData theme, bool isPositive) {
    return Container(
      height: 32, // Fixed height to match expiry dropdown
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPositive 
            ? AppColors.success.withOpacity(0.1)
            : AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isPositive 
              ? AppColors.success.withOpacity(0.3)
              : AppColors.error.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            size: 14,
            color: isPositive ? AppColors.success : AppColors.error,
          ),
          const SizedBox(width: 6),
          Text(
            '₹${widget.optionChain.underlyingPrice.toStringAsFixed(2)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isPositive ? AppColors.success : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }



  Color _getIndexColor(String symbolCode) {
    switch (symbolCode) {
      case 'NIFTY':
        return Colors.blue;
      case 'BANKNIFTY':
        return Colors.green;
      case 'FINNIFTY':
        return Colors.orange;
      case 'BANKEX':
        return Colors.purple;
      case 'SENSEX':
        return Colors.red;
      default:
        return Colors.grey;
    }
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
      children: widget.optionChain.strikes.map((strike) => _buildTableRow(context, strike)).toList(),
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

    return MouseRegion(
      onHover: (event) {
        // Calculate position for floating widget
        final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final position = renderBox.globalToLocal(event.position);
          
          // Determine which side is being hovered based on mouse position
          final rowWidth = renderBox.size.width;
          final isCallSide = position.dx < rowWidth * 0.5;
          final side = isCallSide ? 'CE' : 'PE';
          final price = isCallSide ? (call?.ltp ?? 0) : (put?.ltp ?? 0);
          
          _onRowHover(
            strike.strikePrice.toStringAsFixed(0),
            side,
            price,
            Offset(position.dx + 20, position.dy - 20),
          );
        }
      },
      child: Container(
        color: rowColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Call side
            _buildDataCell(call?.openInterest?.toString() ?? '-', 60),
            _buildDataCell(call?.volume.toString() ?? '-', 70),
            _buildDataCell(call?.iv.toStringAsFixed(1) ?? '-', 50),
            _buildInteractiveDataCell(call?.ltp ?? 0, 60, strike.strikePrice.toStringAsFixed(0), 'CE', bid: call?.bid, ask: call?.ask),
            _buildChangeDataCell(call?.change, call?.changePercent, 80),
            _buildInteractiveDataCell(call?.bid ?? 0, 60, strike.strikePrice.toStringAsFixed(0), 'CE', bid: call?.bid, ask: call?.ask),
            _buildInteractiveDataCell(call?.ask ?? 0, 60, strike.strikePrice.toStringAsFixed(0), 'CE', bid: call?.bid, ask: call?.ask),
            
            // Strike price (center)
            _buildStrikeCell(strike, 80, context),
            
            // Put side
            _buildInteractiveDataCell(put?.bid ?? 0, 60, strike.strikePrice.toStringAsFixed(0), 'PE', bid: put?.bid, ask: put?.ask),
            _buildInteractiveDataCell(put?.ask ?? 0, 60, strike.strikePrice.toStringAsFixed(0), 'PE', bid: put?.bid, ask: put?.ask),
            _buildChangeDataCell(put?.change, put?.changePercent, 80),
            _buildInteractiveDataCell(put?.ltp ?? 0, 60, strike.strikePrice.toStringAsFixed(0), 'PE', bid: put?.bid, ask: put?.ask),
            _buildDataCell(put?.iv.toStringAsFixed(1) ?? '-', 50),
            _buildDataCell(put?.volume.toString() ?? '-', 70),
            _buildDataCell(put?.openInterest?.toString() ?? '-', 60),
          ],
        ),
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

  Widget _buildInteractiveDataCell(double value, double width, String strike, String optionType, {double? bid, double? ask}) {
    return _buildPriceDataCell(value, width);
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