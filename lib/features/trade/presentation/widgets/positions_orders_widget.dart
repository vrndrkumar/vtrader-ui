import 'package:flutter/material.dart';
import '../../domain/models/position_model.dart';
import '../../../../core/theme/app_colors.dart';

class PositionsOrdersWidget extends StatefulWidget {
  final List<PositionModel> positions;
  final List<OrderModel> orders;
  final VoidCallback? onRefresh;

  const PositionsOrdersWidget({
    super.key,
    required this.positions,
    required this.orders,
    this.onRefresh,
  });

  @override
  State<PositionsOrdersWidget> createState() => _PositionsOrdersWidgetState();
}

class _PositionsOrdersWidgetState extends State<PositionsOrdersWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 300, minHeight: 150), // Minimum size
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
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPositionsTab(context),
                _buildOrdersTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: _tabController,
              isScrollable: false,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
              indicatorColor: theme.colorScheme.primary,
              indicatorWeight: 3,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Positions'),
                      if (widget.positions.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${widget.positions.length}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Orders'),
                      if (widget.orders.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${widget.orders.length}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.onRefresh != null)
            IconButton(
              onPressed: widget.onRefresh,
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
            ),
        ],
      ),
    );
  }

  Widget _buildPositionsTab(BuildContext context) {
    if (widget.positions.isEmpty) {
      return const Center(
        child: Text('You have no open positions'),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowHeight: 48,
          dataRowMinHeight: 44,
          dataRowMaxHeight: 44,
          columnSpacing: 16,
          horizontalMargin: 16,
          columns: const [
            DataColumn(
              label: Text('Symbol', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Avg Price', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('LTP', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('P&L', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('P&L %', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
          rows: widget.positions.map((position) => _buildPositionRow(context, position)).toList(),
        ),
      ),
    );
  }

  Widget _buildOrdersTab(BuildContext context) {
    if (widget.orders.isEmpty) {
      return const Center(
        child: Text('You have no orders'),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowHeight: 48,
          dataRowMinHeight: 44,
          dataRowMaxHeight: 44,
          columnSpacing: 16,
          horizontalMargin: 16,
          columns: const [
            DataColumn(
              label: Text('Symbol', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Side', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('Time', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
          rows: widget.orders.map((order) => _buildOrderRow(context, order)).toList(),
        ),
      ),
    );
  }

  DataRow _buildPositionRow(BuildContext context, PositionModel position) {
    final theme = Theme.of(context);
    final isPnlPositive = position.pnl >= 0;
    
    return DataRow(
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                position.symbol,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                position.instrument,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: position.type == PositionType.long
                  ? AppColors.success.withOpacity(0.2)
                  : AppColors.error.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              position.type.name.toUpperCase(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: position.type == PositionType.long
                    ? AppColors.success
                    : AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            position.quantity.toString(),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
            ),
          ),
        ),
        DataCell(
          Text(
            '₹${position.avgPrice.toStringAsFixed(2)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
            ),
          ),
        ),
        DataCell(
          Text(
            '₹${position.ltp.toStringAsFixed(2)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataCell(
          Text(
            '₹${position.pnl.toStringAsFixed(2)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isPnlPositive ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ),
        DataCell(
          Text(
            '${isPnlPositive ? '+' : ''}${position.pnlPercent.toStringAsFixed(2)}%',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isPnlPositive ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(position.status).withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              position.status.name.toUpperCase(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getStatusColor(position.status),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  DataRow _buildOrderRow(BuildContext context, OrderModel order) {
    final theme = Theme.of(context);
    
    return DataRow(
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                order.symbol,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                order.instrument,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            order.orderType.name.toUpperCase(),
            style: theme.textTheme.bodySmall,
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: order.side == OrderSide.buy
                  ? AppColors.success.withOpacity(0.2)
                  : AppColors.error.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order.side.name.toUpperCase(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: order.side == OrderSide.buy
                    ? AppColors.success
                    : AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            '${order.filledQuantity ?? 0}/${order.quantity}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
            ),
          ),
        ),
        DataCell(
          Text(
            order.price != null ? '₹${order.price!.toStringAsFixed(2)}' : 'Market',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getOrderStatusColor(order.status).withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              order.status.name.toUpperCase(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getOrderStatusColor(order.status),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Text(
            '${order.createdAt.hour.toString().padLeft(2, '0')}:${order.createdAt.minute.toString().padLeft(2, '0')}',
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(PositionStatus status) {
    switch (status) {
      case PositionStatus.open:
        return AppColors.success;
      case PositionStatus.closed:
        return AppColors.neutral;
      case PositionStatus.partial:
        return AppColors.warning;
    }
  }

  Color _getOrderStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
      case OrderStatus.open:
        return AppColors.warning;
      case OrderStatus.partial:
        return AppColors.info;
      case OrderStatus.complete:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.neutral;
      case OrderStatus.rejected:
        return AppColors.error;
    }
  }
}