import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/position_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/user_config_service.dart';
import '../../data/services/position_service.dart';
import '../../../../shared/services/broker_selection_service.dart';
import '../../../../shared/models/api_models.dart';
import 'position_card.dart';
import 'order_card.dart';

class PositionsOrdersWidget extends ConsumerStatefulWidget {
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
  ConsumerState<PositionsOrdersWidget> createState() => _PositionsOrdersWidgetState();
}

class _PositionsOrdersWidgetState extends ConsumerState<PositionsOrdersWidget>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _positionsTabController;
  late TabController _ordersTabController;
  
  List<PositionModel> _allPositions = [];
  List<OrderModel> _allOrders = [];
  bool _isLoading = false;
  final UserConfigService _userConfig = UserConfigService();

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _positionsTabController = TabController(length: 2, vsync: this);
    _ordersTabController = TabController(length: 3, vsync: this);
    _initializeAndLoadData();
  }

  Future<void> _initializeAndLoadData() async {
    await _userConfig.initialize();
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
      if (_userConfig.useLiveData) {
        // Get current broker from broker selection service
        final currentBroker = ref.read(brokerSelectionProvider);
        
        // Load from live API with current broker
        print('Loading live data for broker: $currentBroker');
        _allPositions = await PositionService.fetchPositions(brokerName: currentBroker);
      } else {
        // Load mock data
        print('Loading mock data');
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
    // Classify using live quantity: open when quantity > 0, closed when == 0
    final openPositions = _allPositions.where((p) => p.quantity > 0).length;
    final closedPositions = _allPositions.where((p) => p.quantity == 0).length;
    final openOrders = _allOrders.where((o) => o.status == OrderStatus.pending || o.status == OrderStatus.open).length;
    final completedOrders = _allOrders.where((o) => o.status == OrderStatus.complete).length;
    final rejectedOrders = _allOrders.where((o) => o.status == OrderStatus.rejected).length;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Broker selector row - always show
          Row(
            children: [
              Icon(Icons.account_balance, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Broker:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildBrokerSelector(context),
              ),
              IconButton(
                icon: Icon(Icons.refresh, size: 18, color: theme.colorScheme.primary),
                onPressed: _loadData,
                tooltip: 'Refresh positions & orders',
              ),
            ],
          ),
          const SizedBox(height: 8),
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
                    onPressed: () async {
                      await _userConfig.toggleLiveData(!_userConfig.useLiveData);
                      setState(() {});
                      _loadData();
                    },
                    icon: Icon(
                      _userConfig.useLiveData ? Icons.cloud_done : Icons.cloud_off,
                      color: _userConfig.useLiveData ? AppColors.success : AppColors.neutral,
                    ),
                    tooltip: _userConfig.useLiveData ? 'Using Live Data' : 'Using Mock Data',
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
    // Open when quantity > 0; closed when == 0
    final openPositions = _allPositions.where((p) => p.quantity > 0).toList();
    final closedPositions = _allPositions.where((p) => p.quantity == 0).toList();

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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Name',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          if (showActions)
            Expanded(
              flex: 1,
              child: Text(
                'Qty',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            flex: 1,
            child: Text(
              'LTP',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Buy Avg',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Sell Avg',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Realised PNL',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (showActions)
            Expanded(
              flex: 1,
              child: Text(
                'Unrealised MTM',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          if (showActions)
            Expanded(
              flex: 1,
              child: Text(
                'Stop Loss',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          if (showActions)
            Expanded(
              flex: 1,
              child: Text(
                'P/L',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          if (showActions)
            Expanded(
              flex: 1,
              child: Text(
                'Exit',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
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
        content: Text('Set stop loss for ${position.symbol} ${position.isLong ? "LONG" : "SHORT"} position?'),
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
        content: Text('Exit ${position.symbol} ${position.isLong ? "LONG" : "SHORT"} position?\n\nCurrent P&L: ₹${position.pnl.toStringAsFixed(2)}'),
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

  Widget _buildBrokerSelector(BuildContext context) {
    final theme = Theme.of(context);
    final brokerService = ref.read(brokerSelectionProvider.notifier);
    final availableBrokers = brokerService.getAvailableBrokers();
    final currentBroker = ref.watch(brokerSelectionProvider);

    if (availableBrokers.isEmpty || availableBrokers.length == 1) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Text(
          currentBroker ?? 'FINVASIA',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: DropdownButton<String>(
        value: currentBroker,
        isExpanded: true,
        underline: const SizedBox(),
        icon: Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary),
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
        items: availableBrokers.map((broker) {
          return DropdownMenuItem<String>(
            value: broker.brokerName,
            child: Row(
              children: [
                Icon(
                  Icons.account_balance,
                  size: 16,
                  color: broker.brokerName == currentBroker 
                      ? theme.colorScheme.primary 
                      : theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 8),
                Text(broker.displayName),
              ],
            ),
          );
        }).toList(),
        onChanged: (String? newBroker) {
          if (newBroker != null && newBroker != currentBroker) {
            // Schedule the state update to avoid build-during-build error
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                brokerService.switchBroker(newBroker);
                _loadData(); // Reload data with new broker
              }
            });
          }
        },
      ),
    );
  }
}