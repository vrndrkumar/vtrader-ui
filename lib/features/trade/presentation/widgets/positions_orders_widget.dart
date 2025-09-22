import 'package:flutter/material.dart';
import '../../domain/models/position_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/services/position_service.dart';
import 'position_card.dart';
import 'order_card.dart';

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
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _positionsTabController;
  late TabController _ordersTabController;
  
  List<PositionModel> _allPositions = [];
  List<OrderModel> _allOrders = [];
  bool _isLoading = false;
  bool _useLiveData = false;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _positionsTabController = TabController(length: 2, vsync: this);
    _ordersTabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _positionsTabController.dispose();
    _ordersTabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_useLiveData) {
        // Load from live API
        _allPositions = await PositionService.fetchPositions();
      } else {
        // Load mock data
        _allPositions = PositionService.getMockPositions();
      }
      _allOrders = PositionService.getMockOrders();
    } catch (e) {
      print('Error loading data: $e');
      // Fallback to mock data
      _allPositions = PositionService.getMockPositions();
      _allOrders = PositionService.getMockOrders();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 300, minHeight: 200),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          const Divider(height: 1),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _mainTabController,
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
    final openPositions = _allPositions.where((p) => p.status == PositionStatus.open).length;
    final closedPositions = _allPositions.where((p) => p.status == PositionStatus.closed).length;
    final openOrders = _allOrders.where((o) => o.status == OrderStatus.pending || o.status == OrderStatus.open).length;
    final completedOrders = _allOrders.where((o) => o.status == OrderStatus.complete).length;
    final rejectedOrders = _allOrders.where((o) => o.status == OrderStatus.rejected).length;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TabBar(
                  controller: _mainTabController,
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
                          const Icon(Icons.account_balance_wallet, size: 16),
                          const SizedBox(width: 4),
                          const Text('Positions'),
                          if (openPositions > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$openPositions',
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
                          const Icon(Icons.receipt_long, size: 16),
                          const SizedBox(width: 4),
                          const Text('Orders'),
                          if (openOrders > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$openOrders',
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
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _useLiveData = !_useLiveData;
                      });
                      _loadData();
                    },
                    icon: Icon(
                      _useLiveData ? Icons.cloud_done : Icons.cloud_off,
                      color: _useLiveData ? AppColors.success : AppColors.neutral,
                    ),
                    tooltip: _useLiveData ? 'Using Live Data' : 'Using Mock Data',
                  ),
                  IconButton(
                    onPressed: _loadData,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPositionsTab(BuildContext context) {
    final openPositions = _allPositions.where((p) => p.status == PositionStatus.open).toList();
    final closedPositions = _allPositions.where((p) => p.status == PositionStatus.closed).toList();

    return Column(
      children: [
        // Sub-tabs for Open/Closed positions
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TabBar(
            controller: _positionsTabController,
            isScrollable: false,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorWeight: 2,
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.trending_up, size: 16),
                    const SizedBox(width: 4),
                    const Text('Open'),
                    if (openPositions.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${openPositions.length}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.success,
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
                    const Icon(Icons.history, size: 16),
                    const SizedBox(width: 4),
                    const Text('Closed'),
                    if (closedPositions.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.neutral.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${closedPositions.length}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.neutral,
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
        // Content for positions
        Expanded(
          child: TabBarView(
            controller: _positionsTabController,
            children: [
              _buildPositionsList(context, openPositions, true),
              _buildPositionsList(context, closedPositions, false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPositionsList(BuildContext context, List<PositionModel> positions, bool showActions) {
    if (positions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              showActions ? Icons.account_balance_wallet_outlined : Icons.history,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              showActions ? 'No open positions' : 'No closed positions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header row
        _buildPositionsHeader(context, showActions),
        // Positions list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: positions.length,
            itemBuilder: (context, index) {
              final position = positions[index];
              return PositionCard(
                position: position,
                showActions: showActions,
                onStopLoss: () => _showStopLossDialog(context, position),
                onExit: () => _showExitDialog(context, position),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPositionsHeader(BuildContext context, bool showActions) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Name column
          Expanded(
            flex: 3,
            child: Text(
              'Name',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          // Qty column
          Expanded(
            flex: 1,
            child: Text(
              'Qty',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Avg column
          Expanded(
            flex: 1,
            child: Text(
              'Avg',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // LTP column
          Expanded(
            flex: 1,
            child: Text(
              'LTP',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Stop Loss column
          Expanded(
            flex: 1,
            child: showActions
                ? Text(
                    'Stop Loss',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  )
                : const SizedBox.shrink(),
          ),
          // P/L column
          Expanded(
            flex: 1,
            child: Text(
              'P/L',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Exit column
          Expanded(
            flex: 1,
            child: showActions
                ? Text(
                    'Exit',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersTab(BuildContext context) {
    final openOrders = _allOrders.where((o) => o.status == OrderStatus.pending || o.status == OrderStatus.open).toList();
    final completedOrders = _allOrders.where((o) => o.status == OrderStatus.complete).toList();
    final rejectedOrders = _allOrders.where((o) => o.status == OrderStatus.rejected).toList();

    return Column(
      children: [
        // Sub-tabs for Open/Completed/Rejected orders
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TabBar(
            controller: _ordersTabController,
            isScrollable: false,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorWeight: 2,
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.pending_actions, size: 16),
                    const SizedBox(width: 4),
                    const Text('Open'),
                    if (openOrders.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${openOrders.length}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.warning,
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
                    const Icon(Icons.check_circle, size: 16),
                    const SizedBox(width: 4),
                    const Text('Completed'),
                    if (completedOrders.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${completedOrders.length}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.success,
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
                    const Icon(Icons.cancel, size: 16),
                    const SizedBox(width: 4),
                    const Text('Rejected'),
                    if (rejectedOrders.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${rejectedOrders.length}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.error,
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
        // Content for orders
        Expanded(
          child: TabBarView(
            controller: _ordersTabController,
            children: [
              _buildOrdersList(context, openOrders),
              _buildOrdersList(context, completedOrders),
              _buildOrdersList(context, rejectedOrders),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersList(BuildContext context, List<OrderModel> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No orders found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          onCancel: () => _showCancelOrderDialog(context, order),
        );
      },
    );
  }

  // Dialog methods for actions
  void _showStopLossDialog(BuildContext context, PositionModel position) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Set Stop Loss'),
        content: Text('Set stop loss for ${position.symbol} ${position.type.name} position?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // TODO: Implement stop loss logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Stop loss set for ${position.symbol}')),
              );
            },
            child: const Text('Set SL'),
          ),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context, PositionModel position) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Exit Position'),
        content: Text('Exit ${position.symbol} ${position.type.name} position?\n\nCurrent P&L: ₹${position.pnl.toStringAsFixed(2)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // TODO: Implement exit position logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Position exited for ${position.symbol}')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  void _showCancelOrderDialog(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Order'),
        content: Text('Cancel ${order.symbol} ${order.side.name} order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // TODO: Implement cancel order logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Order cancelled for ${order.symbol}')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancel Order'),
          ),
        ],
      ),
    );
  }
}