import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/models/trade_models.dart';
import '../../../../shared/services/trades_service.dart';
import '../../../../shared/widgets/app_button.dart';

/// Trade details dialog
class TradeDetailsDialog extends StatefulWidget {
  final Trade trade;

  const TradeDetailsDialog({
    super.key,
    required this.trade,
  });

  @override
  State<TradeDetailsDialog> createState() => _TradeDetailsDialogState();
}

class _TradeDetailsDialogState extends State<TradeDetailsDialog> {
  bool _isLoadingOrders = false;
  OrdersResponse? _ordersData;
  String? _ordersError;

  @override
  void initState() {
    super.initState();
    _loadTradeOrders();
  }

  Future<void> _loadTradeOrders() async {
    setState(() {
      _isLoadingOrders = true;
      _ordersError = null;
    });

    try {
      final ordersResponse = await TradesService.getTradeOrders(widget.trade.tradeId);
      setState(() {
        _ordersData = ordersResponse;
        _isLoadingOrders = false;
      });
    } catch (e) {
      setState(() {
        _ordersError = e.toString();
        _isLoadingOrders = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.trade.symbolName,
                        style: AppTypography.headlineSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Trade ID: ${widget.trade.tradeId}',
                        style: AppTypography.bodySmall.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Trade details
            _buildTradeDetails(),
            
            const SizedBox(height: 16),
            
            // Orders section
            Expanded(
              child: _buildOrdersSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTradeDetails() {
    final pnlColor = widget.trade.isProfitable ? AppColors.success : AppColors.error;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trade Details',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem('Group', widget.trade.groupName),
                ),
                Expanded(
                  child: _buildDetailItem('Broker', widget.trade.brokerName),
                ),
                Expanded(
                  child: _buildDetailItem('Status', widget.trade.status),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem('Quantity', widget.trade.totalQuantity.toString()),
                ),
                Expanded(
                  child: _buildDetailItem('Entry Price', '₹${widget.trade.entryPriceValue.toStringAsFixed(2)}'),
                ),
                Expanded(
                  child: _buildDetailItem('Exit Price', '₹${widget.trade.exitPriceValue.toStringAsFixed(2)}'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    'P&L', 
                    '₹${widget.trade.pnlValue.toStringAsFixed(2)}',
                    valueColor: pnlColor,
                  ),
                ),
                Expanded(
                  child: _buildDetailItem('Orders', widget.trade.orderCount.toString()),
                ),
                Expanded(
                  child: _buildDetailItem(
                    'First Placed', 
                    _formatDateTime(widget.trade.firstPlacedDateTime),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Orders',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _buildOrdersContent(),
        ),
      ],
    );
  }

  Widget _buildOrdersContent() {
    if (_isLoadingOrders) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_ordersError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading orders',
              style: AppTypography.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _ordersError!,
              style: AppTypography.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AppButton(
              text: 'Retry',
              onPressed: _loadTradeOrders,
              type: AppButtonType.outline,
              size: AppButtonSize.small,
            ),
          ],
        ),
      );
    }

    if (_ordersData == null || _ordersData!.data.isEmpty) {
      return const Center(
        child: Text('No orders found for this trade'),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_ordersData!.data.length} Orders',
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _ordersData!.data.length,
            itemBuilder: (context, index) {
              final order = _ordersData!.data[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildOrderCard(order),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    final statusColor = _getOrderStatusColor(order.orderStatusEnum);
    final sideColor = order.isBuy ? AppColors.success : AppColors.error;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                        order.getStringValue(order.orderId),
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${order.getStringValue(order.txnType)}',
                        style: AppTypography.bodySmall.copyWith(
                          color: sideColor,
                          fontWeight: FontWeight.w500,
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
                    order.getStringValue(order.orderStatus),
                    style: AppTypography.labelSmall.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Order details
            Row(
              children: [
                Expanded(
                  child: _buildOrderDetailItem('Quantity', order.getStringValue(order.quantity)),
                ),
                Expanded(
                  child: _buildOrderDetailItem('Price', '₹${order.priceValue.toStringAsFixed(2)}'),
                ),
                Expanded(
                  child: _buildOrderDetailItem('Symbol', order.getStringValue(order.symbolName)),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  child: _buildOrderDetailItem('Group', order.getStringValue(order.groupName)),
                ),
                Expanded(
                  child: _buildOrderDetailItem('Placed Time', _formatDateTime(order.placedDateTime)),
                ),
                Expanded(
                  child: _buildOrderDetailItem('Updated Time', _formatDateTime(order.updatedDateTime)),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: [
                Expanded(
                  child: _buildOrderDetailItem('Order ID', order.getStringValue(order.id)),
                ),
                const Expanded(child: SizedBox()), // Empty space
                const Expanded(child: SizedBox()), // Empty space
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getOrderStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.executed:
        return AppColors.success;
      case OrderStatus.pending:
        return AppColors.warning;
      case OrderStatus.cancelled:
        return AppColors.secondary;
      case OrderStatus.rejected:
        return AppColors.error;
      default:
        return AppColors.secondary;
    }
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM dd, yyyy HH:mm').format(date);
  }
}
