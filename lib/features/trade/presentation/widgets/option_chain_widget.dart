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
    final hasPrice = widget.optionChain.underlyingPrice > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Index price box (moved from top-right as requested)
          if (hasPrice)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.optionChain.underlying,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.trending_up,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '₹${widget.optionChain.underlyingPrice.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              widget.optionChain.underlying,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          const Spacer(),
          
          // Refresh Button
          if (widget.onRefresh != null)
            IconButton(
              onPressed: widget.onRefresh,
              icon: Icon(
                Icons.refresh,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              tooltip: 'Refresh Data',
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
    // Calculate minimum table width to prevent column compression
    const premiumColWidth = 90.0;
    const strikeColWidth = 100.0;
    const tableHPad = 16.0;
    const minTableWidth = (premiumColWidth * 4) + strikeColWidth + (tableHPad * 2); // 4 premium cols + 1 strike + padding
    
    return Column(
      children: [
        // Fixed header with horizontal scroll
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: minTableWidth),
            child: _buildTableHeader(context),
          ),
        ),
        // Scrollable data rows
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: minTableWidth),
              child: SingleChildScrollView(
                child: _buildTableRows(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    const premiumColWidth = 90.0;
    const strikeColWidth = 100.0;
    const tableHPad = 16.0;
    
    return Column(
      children: [
        // Main section headers: CALL | Strike Price | PUT
        Container(
          padding: const EdgeInsets.symmetric(horizontal: tableHPad, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? theme.colorScheme.surfaceVariant : Colors.grey[100],
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor.withOpacity(0.5),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // CALL section header
              SizedBox(
                width: premiumColWidth * 2,
                child: Text(
                  'CALL',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.green[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // Strike section header
              SizedBox(
                width: strikeColWidth,
                child: Text(
                  'Strike',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // PUT section header
              SizedBox(
                width: premiumColWidth * 2,
                child: Text(
                  'PUT',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.red[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        
        // Column headers: Ask, Bid for each side
        Container(
          padding: const EdgeInsets.symmetric(horizontal: tableHPad, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor,
                width: 1.5,
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(width: premiumColWidth, child: _buildColumnHeaderText('Ask', theme)),
              SizedBox(width: premiumColWidth, child: _buildColumnHeaderText('Bid', theme)),
              const SizedBox(width: strikeColWidth),
              SizedBox(width: premiumColWidth, child: _buildColumnHeaderText('Bid', theme)),
              SizedBox(width: premiumColWidth, child: _buildColumnHeaderText('Ask', theme)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildColumnHeaderText(String text, ThemeData theme) {
    return Text(
      text,
      style: theme.textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface.withOpacity(0.7),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTableRows(BuildContext context) {
    if (widget.optionChain.strikes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.table_chart_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'Waiting for option chain data...',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Data may be unavailable outside market hours.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    // Build rows with index price inserted between appropriate strikes
    final underlyingPrice = widget.optionChain.underlyingPrice;
    final rows = <Widget>[];
    bool indexPriceInserted = false;
    
    for (int i = 0; i < widget.optionChain.strikes.length; i++) {
      final strike = widget.optionChain.strikes[i];
      
      // Insert index price row before the strike that's just above the underlying price
      if (!indexPriceInserted && 
          underlyingPrice > 0 && 
          strike.strikePrice > underlyingPrice) {
        rows.add(_buildIndexPriceRow(context, underlyingPrice));
        indexPriceInserted = true;
      }
      
      rows.add(_buildTableRow(context, strike));
    }
    
    return Column(children: rows);
  }

  Widget _buildTableRow(BuildContext context, StrikePriceData strike) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final call = strike.call;
    final put = strike.put;
    final underlyingPrice = widget.optionChain.underlyingPrice;
    const premiumColWidth = 90.0;
    const strikeColWidth = 100.0;
    const tableHPad = 16.0;
    
    // Calculate ITM separately for CALL and PUT
    // CALL is ITM when underlying > strike
    // PUT is ITM when underlying < strike
    final isCallItm = call != null && underlyingPrice > strike.strikePrice;
    final isPutItm = put != null && underlyingPrice < strike.strikePrice;
    
    // Subtle ITM backgrounds (cream/beige)
    Color? callBgColor;
    Color? putBgColor;
    
    if (!strike.isAtm) {
      if (isCallItm) {
        callBgColor = isDark ? const Color(0xFF2A3A2E) : const Color(0xFFFFF8E1);
      }
      if (isPutItm) {
        putBgColor = isDark ? const Color(0xFF3A2E2E) : const Color(0xFFFFF8E1);
      }
    }

    return MouseRegion(
      onHover: (event) {
        final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final position = renderBox.globalToLocal(event.position);
          final rowWidth = renderBox.size.width;
          final isCallSide = position.dx < rowWidth * 0.5;
          final side = isCallSide ? 'CE' : 'PE';
          final price = isCallSide ? (call?.ask ?? call?.bid ?? 0) : (put?.ask ?? put?.bid ?? 0);
          
          _onRowHover(
            strike.strikePrice.toStringAsFixed(0),
            side,
            price,
            Offset(position.dx + 20, position.dy - 20),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor.withOpacity(0.3),
              width: 0.5,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: tableHPad, vertical: 10),
          child: Row(
            children: [
              // CALL Ask - exact same structure as header
              Container(
                width: premiumColWidth,
                color: callBgColor,
                alignment: Alignment.center,
                child: _buildPremiumText(call?.ask, theme, isCall: true),
              ),
              // CALL Bid - exact same structure as header
              Container(
                width: premiumColWidth,
                color: callBgColor,
                alignment: Alignment.center,
                child: _buildPremiumText(call?.bid, theme, isCall: true),
              ),
              
                // Strike (center) - Distinct background (removed blue ATM border)
                Container(
                  width: strikeColWidth,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A1F2E) : const Color(0xFFF5F5F5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    strike.strikePrice.toStringAsFixed(0),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              
              // PUT Bid - exact same structure as header
              Container(
                width: premiumColWidth,
                color: putBgColor,
                alignment: Alignment.center,
                child: _buildPremiumText(put?.bid, theme, isCall: false),
              ),
              // PUT Ask - exact same structure as header
              Container(
                width: premiumColWidth,
                color: putBgColor,
                alignment: Alignment.center,
                child: _buildPremiumText(put?.ask, theme, isCall: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumText(double? price, ThemeData theme, {bool isCall = true}) {
    final hasValue = price != null && price > 0;
    
    return Text(
      // Remove ₹ from strike premiums (bid/ask) as requested
      hasValue ? price!.toStringAsFixed(2) : '-',
      style: TextStyle(
        fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal,
        fontFamily: 'monospace',
        fontSize: 12,
        color: hasValue
            ? (isCall ? Colors.green[800] : Colors.red[800])
            : theme.colorScheme.onSurface.withOpacity(0.3),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildIndexPriceRow(BuildContext context, double underlyingPrice) {
    final theme = Theme.of(context);
    const premiumColWidth = 90.0;
    const strikeColWidth = 100.0;
    const tableHPad = 16.0;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: tableHPad, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.red.shade400, width: 2),
          bottom: BorderSide(color: Colors.red.shade400, width: 2),
        ),
        color: Colors.red.shade50.withOpacity(0.3),
      ),
      child: Row(
        children: [
          // Empty space for CALL columns
          Container(width: premiumColWidth * 2),
          
          // Index price in center
          Container(
            width: strikeColWidth,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  underlyingPrice.toStringAsFixed(2),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.red.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          // Empty space for PUT columns
          Container(width: premiumColWidth * 2),
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

  Widget _buildInteractiveDataCell(double? value, double width) {
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