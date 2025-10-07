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
    final isLong = position.isLong;
    // Treat position as open when live quantity > 0; closed when == 0
    final isOpen = position.quantity > 0;

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

        // Qty column (only meaningful for open positions)
        if (showActions)
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

        // Day Buy Avg
        Expanded(
          flex: 1,
          child: Text(
            position.dayBuyAvgPrice.toStringAsFixed(2),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Day Sell Avg
        Expanded(
          flex: 1,
          child: Text(
            position.daySellAvgPrice.toStringAsFixed(2),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Realised PNL
        Expanded(
          flex: 1,
          child: Text(
            position.realisedPnl.toStringAsFixed(2),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w500,
              color: position.realisedPnl >= 0 ? AppColors.success : AppColors.error,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Unrealised MTM (only relevant for open positions)
        if (showActions)
          Expanded(
            flex: 1,
            child: Text(
              position.unrealisedMtm.toStringAsFixed(2),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w500,
                color: position.unrealisedMtm >= 0 ? AppColors.success : AppColors.error,
              ),
              textAlign: TextAlign.center,
            ),
          ),

        // Stop Loss column (only for open positions)
        if (showActions)
          Expanded(
            flex: 1,
            child: isOpen
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

        // P/L column (hide in closed where realised already shown)
        if (showActions)
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

        // Exit column (only for open positions)
        if (showActions)
          Expanded(
            flex: 1,
            child: isOpen
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
