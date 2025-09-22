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

class _FloatingTradeWidgetState extends State<FloatingTradeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Material(
              elevation: 16,
              borderRadius: BorderRadius.circular(16),
              color: Colors.transparent,
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 220,
                  maxWidth: 260,
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark 
                        ? Colors.white.withOpacity(0.1) 
                        : Colors.black.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.1 : 0.05),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(theme, isDark),
                    _buildActionButtons(theme, isDark),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.white.withOpacity(0.05) 
            : Colors.grey.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          // Strike and side info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.strike} ${widget.side}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  '₹${widget.price.toStringAsFixed(2)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark 
                        ? Colors.white.withOpacity(0.7) 
                        : Colors.black.withOpacity(0.6),
                    fontFamily: 'monospace',
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Close button
          GestureDetector(
            onTap: () {
              _animationController.reverse().then((_) {
                // Widget will be removed by parent
              });
            },
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: isDark 
                    ? Colors.white.withOpacity(0.1) 
                    : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.close,
                size: 14,
                color: isDark 
                    ? Colors.white.withOpacity(0.7) 
                    : Colors.black.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Buy button
          Expanded(
            child: _buildModernButton(
              label: 'BUY',
              icon: Icons.trending_up,
              color: AppColors.success,
              onTap: widget.onBuy,
              theme: theme,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 8),
          // Sell button
          Expanded(
            child: _buildModernButton(
              label: 'SELL',
              icon: Icons.trending_down,
              color: AppColors.error,
              onTap: widget.onSell,
              theme: theme,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 8),
          // Chart button
          _buildChartButton(theme, isDark),
        ],
      ),
    );
  }

  Widget _buildModernButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
    required ThemeData theme,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () {
        print('$label button clicked for ${widget.strike} ${widget.side}');
        onTap?.call();
      },
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color,
              color.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartButton(ThemeData theme, bool isDark) {
    return GestureDetector(
      onTap: () {
        print('Chart button clicked for ${widget.strike} ${widget.side}');
        widget.onChart?.call();
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDark 
              ? Colors.white.withOpacity(0.1) 
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark 
                ? Colors.white.withOpacity(0.2) 
                : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.show_chart,
          size: 16,
          color: isDark 
              ? Colors.white.withOpacity(0.8) 
              : Colors.black.withOpacity(0.7),
        ),
      ),
    );
  }
}
