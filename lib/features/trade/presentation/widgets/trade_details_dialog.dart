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
  
  // Tag management state
  List<Tag> _availableTags = [];
  bool _isLoadingTags = false;

  @override
  void initState() {
    super.initState();
    _loadTradeOrders();
    _loadAvailableTags();
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

  Future<void> _loadAvailableTags() async {
    setState(() {
      _isLoadingTags = true;
    });

    try {
      final tags = await TradesService.getAvailableTags();
      setState(() {
        _availableTags = tags;
        _isLoadingTags = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingTags = false;
      });
      print('Error loading tags: $e');
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
            
            // Orders section with compact tag management
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
                  child: _buildClickableDetailItem('Group', widget.trade.groupName, onTap: _showManageTagsDialog),
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

  Widget _buildClickableDetailItem(String label, String value, {Color? valueColor, required VoidCallback onTap}) {
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
        GestureDetector(
          onTap: onTap,
          child: Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: valueColor ?? Theme.of(context).colorScheme.primary,
              decoration: TextDecoration.underline,
              decorationColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Orders header with compact tag management
        Row(
          children: [
            Text(
              'Orders',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            // Tag management area matching page theme
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Create button matching theme
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _showCreateTagDialog,
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add,
                              size: 12,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Create and apply tag to all trades',
                              style: AppTypography.labelSmall.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Manage button matching theme
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _showManageTagsDialog,
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bookmark_outline,
                              size: 12,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Manage tags',
                              style: AppTypography.labelSmall.copyWith(
                                color: Theme.of(context).colorScheme.onSecondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                  child: _buildClickableOrderDetailItem('Group', order.getStringValue(order.groupName), onTap: _showManageTagsDialog),
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

  Widget _buildClickableOrderDetailItem(String label, String value, {Color? valueColor, required VoidCallback onTap}) {
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
        GestureDetector(
          onTap: onTap,
          child: Text(
            value,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
              color: valueColor ?? Theme.of(context).colorScheme.primary,
              decoration: TextDecoration.underline,
              decorationColor: Theme.of(context).colorScheme.primary,
            ),
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

  Widget _buildTagManagementSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Tag Management',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Current Group: ${widget.trade.groupName}',
                  style: AppTypography.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _showCreateTagDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Create and apply tag to all trades',
                            style: AppTypography.bodySmall.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _showManageTagsDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bookmark_outline,
                          size: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Manage tags',
                          style: AppTypography.bodySmall.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void _showCreateTagDialog() {
    showDialog(
      context: context,
      builder: (context) => _CreateTagDialog(
        tradeId: widget.trade.tradeId,
        orderCount: _ordersData?.data.length ?? 0,
        onTagCreated: () {
          _loadAvailableTags();
          // Optionally reload orders to show updated tags
          _loadTradeOrders();
        },
      ),
    );
  }

  void _showManageTagsDialog() {
    showDialog(
      context: context,
      builder: (context) => _ManageTagsDialog(
        availableTags: _availableTags,
        tradeId: widget.trade.tradeId,
        orders: _ordersData?.data ?? [],
        onTagsUpdated: () {
          _loadAvailableTags();
          _loadTradeOrders();
        },
      ),
    );
  }
}

/// Dialog for creating new tags
class _CreateTagDialog extends StatefulWidget {
  final String tradeId;
  final int orderCount;
  final VoidCallback onTagCreated;

  const _CreateTagDialog({
    required this.tradeId,
    required this.orderCount,
    required this.onTagCreated,
  });

  @override
  State<_CreateTagDialog> createState() => _CreateTagDialogState();
}

class _CreateTagDialogState extends State<_CreateTagDialog> {
  final TextEditingController _tagNameController = TextEditingController();
  bool _isCreating = false;
  bool _applyToAllTrades = true;

  @override
  void dispose() {
    _tagNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create New Tag',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tagNameController,
              decoration: const InputDecoration(
                labelText: 'Tag Name',
                hintText: 'Enter tag name (e.g., MANUAL, STRATEGY_A)',
                border: OutlineInputBorder(),
              ),
              enabled: !_isCreating,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _applyToAllTrades,
              onChanged: _isCreating ? null : (value) {
                setState(() {
                  _applyToAllTrades = value ?? true;
                });
              },
              title: Text(
                'Apply to all orders in this trade',
                style: AppTypography.bodyMedium,
              ),
              subtitle: Text(
                'This will update all ${_getOrderCount()} orders in trade ${widget.tradeId}',
                style: AppTypography.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isCreating ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isCreating ? null : _createTag,
                  child: _isCreating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create Tag'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _getOrderCount() {
    return widget.orderCount;
  }

  Future<void> _createTag() async {
    if (_tagNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a tag name')),
      );
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      await TradesService.createTag(
        name: _tagNameController.text.trim(),
        applyToTrade: _applyToAllTrades,
        tradeId: widget.tradeId,
      );

      if (mounted) {
        Navigator.of(context).pop();
        widget.onTagCreated();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tag "${_tagNameController.text.trim()}" created successfully'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating tag: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }
}

/// Dialog for managing existing tags
class _ManageTagsDialog extends StatefulWidget {
  final List<Tag> availableTags;
  final String tradeId;
  final List<Order> orders;
  final VoidCallback onTagsUpdated;

  const _ManageTagsDialog({
    required this.availableTags,
    required this.tradeId,
    required this.orders,
    required this.onTagsUpdated,
  });

  @override
  State<_ManageTagsDialog> createState() => _ManageTagsDialogState();
}

class _ManageTagsDialogState extends State<_ManageTagsDialog> {
  bool _isUpdating = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        height: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage Tags',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Trade: ${widget.tradeId}',
              style: AppTypography.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Orders: ${widget.orders.length}',
              style: AppTypography.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.availableTags.length,
                itemBuilder: (context, index) {
                  final tag = widget.availableTags[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(tag.name),
                      subtitle: Text(tag.createdAt != null ? 'Created: ${_formatDate(tag.createdAt!)}' : 'No creation date'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: _isUpdating ? null : () => _applyTagToTrade(tag),
                            child: const Text('Apply to Trade'),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: _isUpdating ? null : () => _editTag(tag),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: _isUpdating ? null : () => _deleteTag(tag),
                            icon: const Icon(Icons.delete),
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isUpdating ? null : () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Future<void> _applyTagToTrade(Tag tag) async {
    setState(() {
      _isUpdating = true;
    });

    try {
      if (tag.id == null) {
        throw Exception('Tag ID is null');
      }
      await TradesService.applyTagToTrade(
        tagId: tag.id!,
        tradeId: widget.tradeId,
      );

      if (mounted) {
        widget.onTagsUpdated();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tag "${tag.name}" applied to trade successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error applying tag: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _editTag(Tag tag) async {
    // TODO: Implement edit tag functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit tag functionality coming soon')),
    );
  }

  Future<void> _deleteTag(Tag tag) async {
    // TODO: Implement delete tag functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Delete tag functionality coming soon')),
    );
  }
}
