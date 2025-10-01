import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/services/trades_service.dart';
import '../../../../shared/models/trade_models.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  List<Trade>? _trades;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTrades();
  }

  Future<void> _loadTrades() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      final tradesResponse = await TradesService.getTrades();
      setState(() {
        _trades = tradesResponse.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),
            const SizedBox(height: 24),

            // Quick Stats
            _buildQuickStats(context, isMobile),
            const SizedBox(height: 24),

            // Quick Actions
            _buildQuickActions(context, isMobile),
            const SizedBox(height: 24),

            // Recent Activity
            if (!isMobile) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildRecentTrades(context),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildPortfolioOverview(context),
                  ),
                ],
              ),
            ] else ...[
              _buildRecentTrades(context),
              const SizedBox(height: 24),
              _buildPortfolioOverview(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: AppTypography.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Welcome back to your trading journal',
          style: AppTypography.bodyMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context, bool isMobile) {
    final stats = _calculateStats();
    
    if (_isLoading) {
      return _buildLoadingStats(isMobile);
    }
    
    if (_error != null) {
      return _buildErrorStats(isMobile);
    }

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildStatCard(context, stats[0])),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard(context, stats[1])),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatCard(context, stats[2])),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard(context, stats[3])),
            ],
          ),
        ],
      );
    }

    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _buildStatCard(context, stat),
          ),
        );
      }).toList(),
    );
  }

  List<_StatCard> _calculateStats() {
    if (_trades == null || _trades!.isEmpty) {
      return [
        _StatCard(
          title: 'Total P&L',
          value: '₹0.00',
          change: '0%',
          isPositive: true,
          icon: Icons.trending_up,
          color: AppColors.success,
        ),
        _StatCard(
          title: 'Win Rate',
          value: '0%',
          change: '0%',
          isPositive: true,
          icon: Icons.percent,
          color: AppColors.primary,
        ),
        _StatCard(
          title: 'Total Trades',
          value: '0',
          change: '0',
          isPositive: true,
          icon: Icons.swap_horiz,
          color: AppColors.secondary,
        ),
        _StatCard(
          title: 'Active Positions',
          value: '0',
          change: '0',
          isPositive: true,
          icon: Icons.account_balance,
          color: AppColors.warning,
        ),
      ];
    }

    final trades = _trades!;
    final totalPnl = trades.fold<double>(0.0, (sum, trade) => sum + trade.pnlValue);
    final totalTrades = trades.length;
    final winningTrades = trades.where((trade) => trade.pnlValue > 0).length;
    final winRate = totalTrades > 0 ? (winningTrades / totalTrades * 100) : 0.0;
    final activePositions = trades.where((trade) => trade.status == 'OPEN').length;

    return [
      _StatCard(
        title: 'Total P&L',
        value: '₹${totalPnl.toStringAsFixed(2)}',
        change: totalPnl >= 0 ? '+${(totalPnl / 1000).toStringAsFixed(1)}K' : '${(totalPnl / 1000).toStringAsFixed(1)}K',
        isPositive: totalPnl >= 0,
        icon: Icons.trending_up,
        color: totalPnl >= 0 ? AppColors.success : AppColors.error,
      ),
      _StatCard(
        title: 'Win Rate',
        value: '${winRate.toStringAsFixed(1)}%',
        change: '${winningTrades}/${totalTrades}',
        isPositive: winRate >= 50,
        icon: Icons.percent,
        color: winRate >= 50 ? AppColors.success : AppColors.error,
      ),
      _StatCard(
        title: 'Total Trades',
        value: totalTrades.toString(),
        change: '+${totalTrades}',
        isPositive: true,
        icon: Icons.swap_horiz,
        color: AppColors.secondary,
      ),
      _StatCard(
        title: 'Active Positions',
        value: activePositions.toString(),
        change: activePositions > 0 ? '+${activePositions}' : '0',
        isPositive: activePositions > 0,
        icon: Icons.account_balance,
        color: AppColors.warning,
      ),
    ];
  }

  Widget _buildLoadingStats(bool isMobile) {
    final loadingStats = List.generate(4, (index) => _StatCard(
      title: 'Loading...',
      value: '...',
      change: '...',
      isPositive: true,
      icon: Icons.hourglass_empty,
      color: AppColors.primary,
    ));

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildStatCard(context, loadingStats[0])),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard(context, loadingStats[1])),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatCard(context, loadingStats[2])),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard(context, loadingStats[3])),
            ],
          ),
        ],
      );
    }

    return Row(
      children: loadingStats.map((stat) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _buildStatCard(context, stat),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildErrorStats(bool isMobile) {
    final errorStats = [
      _StatCard(
        title: 'Error',
        value: 'Failed',
        change: 'Retry',
        isPositive: false,
        icon: Icons.error_outline,
        color: AppColors.error,
      ),
      _StatCard(
        title: 'Error',
        value: 'Failed',
        change: 'Retry',
        isPositive: false,
        icon: Icons.error_outline,
        color: AppColors.error,
      ),
      _StatCard(
        title: 'Error',
        value: 'Failed',
        change: 'Retry',
        isPositive: false,
        icon: Icons.error_outline,
        color: AppColors.error,
      ),
      _StatCard(
        title: 'Error',
        value: 'Failed',
        change: 'Retry',
        isPositive: false,
        icon: Icons.error_outline,
        color: AppColors.error,
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildStatCard(context, errorStats[0])),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard(context, errorStats[1])),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatCard(context, errorStats[2])),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard(context, errorStats[3])),
            ],
          ),
        ],
      );
    }

    return Row(
      children: errorStats.map((stat) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _buildStatCard(context, stat),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatCard(BuildContext context, _StatCard stat) {
    return GestureDetector(
      onTap: () => AppRouter.goToTrades(context),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        stat.icon,
                        color: stat.color,
                        size: 24,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: (stat.isPositive ? AppColors.success : AppColors.error)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              stat.change,
                              style: AppTypography.caption.copyWith(
                                color: stat.isPositive ? AppColors.success : AppColors.error,
                                fontWeight: AppTypography.medium,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: stat.color.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    stat.value,
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: AppTypography.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stat.title,
                    style: AppTypography.bodySmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isMobile) {
    final actions = [
      _QuickAction(
        title: 'Add Trade',
        subtitle: 'Record a new trade',
        icon: Icons.add_circle_outline,
        color: AppColors.primary,
        onTap: () => AppRouter.goToAddTrade(context),
      ),
      _QuickAction(
        title: 'View Journal',
        subtitle: 'Browse all trades',
        icon: Icons.book_outlined,
        color: AppColors.secondary,
        onTap: () => AppRouter.goToTrades(context),
      ),
      _QuickAction(
        title: 'Live Trading',
        subtitle: 'Open trading interface',
        icon: Icons.trending_up,
        color: AppColors.success,
        onTap: () => AppRouter.goToTradePage(context),
      ),
      _QuickAction(
        title: 'Analytics',
        subtitle: 'View performance',
        icon: Icons.analytics_outlined,
        color: AppColors.warning,
        onTap: () => AppRouter.goToAnalytics(context),
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: AppTypography.semiBold,
              ),
            ),
            const SizedBox(height: 16),
            if (isMobile) ...[
              ...actions.map((action) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildActionTile(context, action),
              )),
            ] else ...[
              Row(
                children: actions.map((action) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: _buildActionCard(context, action),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, _QuickAction action) {
    return InkWell(
      onTap: action.onTap,
      borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        ),
        child: Column(
          children: [
            Icon(
              action.icon,
              color: action.color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              action.title,
              style: AppTypography.labelLarge.copyWith(
                fontWeight: AppTypography.semiBold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              action.subtitle,
              style: AppTypography.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, _QuickAction action) {
    return ListTile(
      leading: Icon(action.icon, color: action.color),
      title: Text(action.title),
      subtitle: Text(action.subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: action.onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      ),
    );
  }

  Widget _buildRecentTrades(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Trades',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
                AppButton.text(
                  text: 'View All',
                  onPressed: () => AppRouter.goToTrades(context),
                  size: AppButtonSize.small,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (_isLoading) ...[
              _buildLoadingTrades(),
            ] else if (_error != null) ...[
              _buildErrorTrades(),
            ] else if (_trades == null || _trades!.isEmpty) ...[
              _buildEmptyTrades(),
            ] else ...[
              _buildTradesList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingTrades() {
    return Center(
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading trades...',
            style: AppTypography.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorTrades() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load trades',
            style: AppTypography.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          AppButton.outline(
            text: 'Retry',
            onPressed: _loadTrades,
            size: AppButtonSize.small,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTrades() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.swap_horiz,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No recent trades',
            style: AppTypography.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          AppButton.outline(
            text: 'Add Your First Trade',
            onPressed: () => AppRouter.goToAddTrade(context),
            size: AppButtonSize.small,
          ),
        ],
      ),
    );
  }

  Widget _buildTradesList() {
    final recentTrades = _trades!.take(5).toList();
    
    return Column(
      children: [
        ...recentTrades.map((trade) => _buildTradeItem(trade)),
        if (_trades!.length > 5) ...[
          const SizedBox(height: 8),
          Center(
            child: AppButton.text(
              text: 'View ${_trades!.length - 5} more trades',
              onPressed: () => AppRouter.goToTrades(context),
              size: AppButtonSize.small,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTradeItem(Trade trade) {
    final pnlColor = trade.pnlValue >= 0 ? AppColors.success : AppColors.error;
    final statusColor = trade.status == 'OPEN' ? AppColors.warning : 
                       trade.status == 'CLOSED' ? AppColors.success : AppColors.primary;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trade.symbolName,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        trade.status,
                        style: AppTypography.caption.copyWith(
                          color: statusColor,
                          fontWeight: AppTypography.medium,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Qty: ${trade.quantityValue}',
                      style: AppTypography.caption.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${trade.pnlValue.toStringAsFixed(2)}',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: AppTypography.semiBold,
                  color: pnlColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                trade.groupName,
                style: AppTypography.caption.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioOverview(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Portfolio Overview',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: AppTypography.semiBold,
              ),
            ),
            const SizedBox(height: 16),
            // Placeholder for portfolio chart
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.show_chart,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Portfolio Chart',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Coming Soon',
                      style: AppTypography.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
    required this.color,
  });
}

class _QuickAction {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

