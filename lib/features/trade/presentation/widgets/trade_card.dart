import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/models/trade_models.dart';

/// Individual trade card widget
class TradeCard extends StatelessWidget {
  final Trade trade;
  final bool isMobile;
  final VoidCallback onTap;

  const TradeCard({
    super.key,
    required this.trade,
    required this.isMobile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pnlColor = trade.isProfitable ? AppColors.success : AppColors.error;
    final statusColor = _getStatusColor(trade.tradeStatus);

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 8.0 : 0.0, 
        vertical: 3.0, // Reduced vertical margin
      ),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12.0 : 16.0,
            vertical: isMobile ? 8.0 : 10.0, // Reduced vertical padding
          ),
          child: isMobile ? _buildMobileLayout(context, pnlColor, statusColor) 
                          : _buildDesktopLayout(context, pnlColor, statusColor),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, Color pnlColor, Color statusColor) {
    return Column(
      children: [
        // Row 1: Symbol + Status + P&L
        Row(
          children: [
            // Symbol and Group
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trade.symbolName,
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    trade.groupName,
                    style: AppTypography.labelSmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor.withOpacity(0.3), width: 0.5),
              ),
              child: Text(
                trade.status,
                style: AppTypography.labelSmall.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 9,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // P&L
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${trade.pnlValue.toStringAsFixed(2)}',
                  style: AppTypography.titleSmall.copyWith(
                    color: pnlColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'P&L',
                  style: AppTypography.labelSmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        // Row 2: Quick stats
        Row(
          children: [
            _buildCompactStat(context, 'Qty', trade.totalQuantity.toString()),
            const SizedBox(width: 12),
            _buildCompactStat(context, 'Entry', '₹${trade.entryPriceValue.toStringAsFixed(2)}'),
            const SizedBox(width: 12),
            _buildCompactStat(context, 'Exit', '₹${trade.exitPriceValue.toStringAsFixed(2)}'),
            const Spacer(),
            Text(
              _formatDate(trade.lastUpdatedDateTime),
              style: AppTypography.labelSmall.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, Color pnlColor, Color statusColor) {
    return Row(
      children: [
        // Symbol and Group (20%)
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trade.symbolName,
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                trade.groupName,
                style: AppTypography.labelSmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        // Quantity (10%)
        Expanded(
          flex: 1,
          child: _buildInlineStat(context, 'Qty', trade.totalQuantity.toString()),
        ),
        // Entry Price (15%)
        Expanded(
          flex: 1,
          child: _buildInlineStat(context, 'Entry', '₹${trade.entryPriceValue.toStringAsFixed(2)}'),
        ),
        // Exit Price (15%)
        Expanded(
          flex: 1,
          child: _buildInlineStat(context, 'Exit', '₹${trade.exitPriceValue.toStringAsFixed(2)}'),
        ),
        // P&L (15%)
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'P&L',
                style: AppTypography.labelSmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '₹${trade.pnlValue.toStringAsFixed(2)}',
                style: AppTypography.bodyMedium.copyWith(
                  color: pnlColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Status + Date (20%)
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: statusColor.withOpacity(0.3), width: 0.5),
                ),
                child: Text(
                  trade.status,
                  style: AppTypography.labelSmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatDate(trade.lastUpdatedDateTime),
                style: AppTypography.labelSmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactStat(BuildContext context, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: AppTypography.labelSmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildInlineStat(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(BuildContext context, List<_StatItem> stats) {
    return Row(
      children: stats.map((stat) {
        final isLast = stat == stats.last;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.label,
                  style: AppTypography.labelSmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  stat.value,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getStatusColor(TradeStatus status) {
    switch (status) {
      case TradeStatus.open:
        return AppColors.primary;
      case TradeStatus.closed:
        return AppColors.success;
      case TradeStatus.partiallyClosed:
        return AppColors.warning;
      default:
        return AppColors.secondary;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM dd, HH:mm').format(date);
  }
}

/// Helper class for stat items
class _StatItem {
  final String label;
  final String value;

  const _StatItem(this.label, this.value);
}
