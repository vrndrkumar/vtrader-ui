import 'package:flutter/material.dart';
import '../../domain/models/position_model.dart';
import '../../../../core/theme/app_colors.dart';

class PositionCard extends StatelessWidget {
  final PositionModel position;
  final VoidCallback? onStopLoss;
  final VoidCallback? onExit;
  final bool showActions;

  const PositionCard({
    super.key,
    required this.position,
    this.onStopLoss,
    this.onExit,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPnlPositive = position.pnl >= 0;
    final isLong = position.type == PositionType.long;
    final isOpen = position.status == PositionStatus.open;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isOpen ? Colors.pink.withOpacity(0.05) : theme.cardColor,
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: _buildCompactRow(context, theme, isPnlPositive, isLong, isOpen),
      ),
    );
  }

  Widget _buildCompactRow(BuildContext context, ThemeData theme, bool isPnlPositive, bool isLong, bool isOpen) {
    return Row(
      children: [
        // Name column - Symbol with instrument details
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                position.symbol,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                position.instrument,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        // Qty column
        Expanded(
          flex: 1,
          child: Text(
            '${isLong ? '' : '-'}${position.quantity}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w500,
              color: isLong ? AppColors.success : AppColors.error,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Avg column
        Expanded(
          flex: 1,
          child: Text(
            position.avgPrice.toStringAsFixed(2),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // LTP column
        Expanded(
          flex: 1,
          child: Text(
            position.ltp.toStringAsFixed(2),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Stop Loss column
        Expanded(
          flex: 1,
          child: showActions && isOpen
              ? Center(
                  child: GestureDetector(
                    onTap: onStopLoss,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 16,
                        color: AppColors.info,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        // P/L column
        Expanded(
          flex: 1,
          child: Text(
            position.pnl.toStringAsFixed(2),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w600,
              color: isPnlPositive ? AppColors.success : AppColors.error,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Exit column
        Expanded(
          flex: 1,
          child: showActions && isOpen
              ? Center(
                  child: GestureDetector(
                    onTap: onExit,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

}
