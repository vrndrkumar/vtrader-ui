import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FloatingTradeWidget extends StatefulWidget {
  final String strike;
  final String side; // 'CE' or 'PE'
  final double price;
  final VoidCallback? onBuy;
  final VoidCallback? onSell;
  final VoidCallback? onChart;

  const FloatingTradeWidget({
    super.key,
    required this.strike,
    required this.side,
    required this.price,
    this.onBuy,
    this.onSell,
    this.onChart,
  });

  @override
  State<FloatingTradeWidget> createState() => _FloatingTradeWidgetState();
}

class _FloatingTradeWidgetState extends State<FloatingTradeWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.dividerColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Buy button
            _buildActionButton(
              'Buy',
              AppColors.success,
              widget.onBuy,
              theme,
            ),
            const SizedBox(width: 4),
            // Sell button
            _buildActionButton(
              'Sell',
              AppColors.error,
              widget.onSell,
              theme,
            ),
            const SizedBox(width: 4),
            // Chart button
            _buildActionButton(
              'Chart',
              theme.colorScheme.primary,
              widget.onChart,
              theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    Color color,
    VoidCallback? onTap,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap: () {
        print('$label button clicked for ${widget.strike} ${widget.side}');
        onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
