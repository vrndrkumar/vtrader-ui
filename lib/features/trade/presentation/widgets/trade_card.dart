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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trade.symbolName,
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          trade.groupName,
                          style: AppTypography.bodySmall.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      trade.status,
                      style: AppTypography.labelSmall.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Stats row
              if (isMobile) ...[
                // Mobile layout - stacked
                _buildStatRow(context, [
                  _StatItem('Quantity', trade.totalQuantity),
                  _StatItem('Orders', trade.orderCount.toString()),
                ]),
                const SizedBox(height: 8),
                _buildStatRow(context, [
                  _StatItem('Entry', '₹${trade.entryPriceValue.toStringAsFixed(2)}'),
                  _StatItem('Exit', '₹${trade.exitPriceValue.toStringAsFixed(2)}'),
                ]),
              ] else ...[
                // Desktop layout - single row
                _buildStatRow(context, [
                  _StatItem('Quantity', trade.totalQuantity),
                  _StatItem('Entry', '₹${trade.entryPriceValue.toStringAsFixed(2)}'),
                  _StatItem('Exit', '₹${trade.exitPriceValue.toStringAsFixed(2)}'),
                  _StatItem('Orders', trade.orderCount.toString()),
                ]),
              ],
              
              const SizedBox(height: 12),
              
              // Bottom row
              Row(
                children: [
                  Expanded(
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
                          style: AppTypography.titleMedium.copyWith(
                            color: pnlColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Last Updated',
                        style: AppTypography.labelSmall.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        _formatDate(trade.lastUpdatedDateTime),
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
