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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Header Section
            _buildHeroHeader(context, isMobile),
            
            // Main Content
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20.0 : 32.0,
                vertical: isMobile ? 24.0 : 32.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Key Metrics Row
                  _buildKeyMetricsRow(context, isMobile),
                  SizedBox(height: isMobile ? 24 : 32),

                  // Main Content Grid
                  if (!isMobile) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              _buildPerformanceChart(context),
                              const SizedBox(height: 24),
                              _buildRecentTrades(context),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            children: [
                              _buildQuickActions(context, isMobile),
                              const SizedBox(height: 24),
                              _buildAdditionalMetrics(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    _buildKeyMetricsRow(context, isMobile),
                    const SizedBox(height: 24),
                    _buildPerformanceChart(context),
                    const SizedBox(height: 24),
                    _buildRecentTrades(context),
                    const SizedBox(height: 24),
                    _buildQuickActions(context, isMobile),
                    const SizedBox(height: 24),
                    _buildAdditionalMetrics(context),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20.0 : 32.0,
        vertical: isMobile ? 24.0 : 32.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Dashboard icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.bar_chart_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trading Dashboard',
                  style: AppTypography.headlineMedium.copyWith(
                    fontWeight: AppTypography.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Monitor your trading performance and recent activity',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          
          // Hamburger menu
          IconButton(
            onPressed: () {
              // TODO: Implement menu functionality
            },
            icon: Icon(
              Icons.menu_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyMetricsRow(BuildContext context, bool isMobile) {
    if (_isLoading) {
      return _buildLoadingMetrics(isMobile);
    }
    
    if (_error != null) {
      return _buildErrorMetrics(isMobile);
    }

    final totalPnl = _trades?.fold<double>(0.0, (sum, trade) => sum + trade.pnlValue) ?? 0.0;
    final totalTrades = _trades?.length ?? 0;
    final winRate = totalTrades > 0 ? 
        (_trades!.where((trade) => trade.pnlValue > 0).length / totalTrades * 100) : 0.0;
    final activePositions = _trades?.where((trade) => trade.status == 'OPEN').length ?? 0;

    return Row(
      children: [
        Expanded(
          child: _buildCompactMetric(
            'Total P&L',
            '₹${totalPnl.toStringAsFixed(2)}',
            totalPnl >= 0 ? AppColors.success : AppColors.error,
            Icons.account_balance_wallet_rounded,
            totalPnl >= 0 ? '+${(totalPnl / 1000).toStringAsFixed(1)}K' : '${(totalPnl / 1000).toStringAsFixed(1)}K',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildCompactMetric(
            'Win Rate',
            '${winRate.toStringAsFixed(1)}%',
            winRate >= 50 ? AppColors.success : AppColors.error,
            Icons.percent_rounded,
            '${_trades?.where((trade) => trade.pnlValue > 0).length ?? 0}/${totalTrades}',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildCompactMetric(
            'Total Trades',
            totalTrades.toString(),
            AppColors.primary,
            Icons.swap_horiz_rounded,
            '+$totalTrades',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildCompactMetric(
            'Active Positions',
            activePositions.toString(),
            AppColors.warning,
            Icons.account_balance_rounded,
            activePositions > 0 ? '+$activePositions' : '0',
          ),
        ),
      ],
    );
  }

  Widget _buildCompactMetric(String label, String value, Color color, IconData icon, String change) {
    return GestureDetector(
      onTap: () => AppRouter.goToTrades(context),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      change,
                      style: AppTypography.caption.copyWith(
                        color: color,
                        fontWeight: AppTypography.medium,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                value,
                style: AppTypography.headlineMedium.copyWith(
                  fontWeight: AppTypography.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingMetrics(bool isMobile) {
    return Row(
      children: List.generate(4, (index) => 
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < 3 ? 16 : 0),
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMetrics(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 32,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              'Failed to load metrics',
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
      ),
    );
  }

  Widget _buildPerformanceChart(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingChart();
    }
    
    if (_error != null) {
      return _buildErrorChart();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Cumulative P&L Trend',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: AppTypography.semiBold,
                ),
              ),
              const Spacer(),
              _buildTimeFilterButtons(),
            ],
          ),
          const SizedBox(height: 20),
          
          // Chart placeholder - in a real app, you'd use a chart library like fl_chart
          _buildChartPlaceholder(),
        ],
      ),
    );
  }

  Widget _buildTimeFilterButtons() {
    return Row(
      children: [
        _buildTimeFilterButton('Daily', true),
        const SizedBox(width: 8),
        _buildTimeFilterButton('Weekly', false),
        const SizedBox(width: 8),
        _buildTimeFilterButton('Monthly', false),
      ],
    );
  }

  Widget _buildTimeFilterButton(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement time filter functionality
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected 
                ? AppColors.primary.withOpacity(0.3)
                : Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: isSelected 
                ? AppColors.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: isSelected 
                ? AppTypography.medium
                : AppTypography.regular,
          ),
        ),
      ),
    );
  }

  Widget _buildChartPlaceholder() {
    final totalPnl = _trades?.fold<double>(0.0, (sum, trade) => sum + trade.pnlValue) ?? 0.0;
    final isPositive = totalPnl >= 0;
    
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Line chart area
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: CustomPaint(
                painter: _LineChartPainter(isPositive),
                size: const Size(double.infinity, double.infinity),
              ),
            ),
          ),
          // Volume bars area
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: CustomPaint(
                painter: _VolumeBarsPainter(),
                size: const Size(double.infinity, double.infinity),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingChart() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorChart() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 32,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 8),
            Text(
              'Failed to load chart',
              style: AppTypography.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
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
              Expanded(child: _buildModernStatCard(context, loadingStats[0])),
              const SizedBox(width: 16),
              Expanded(child: _buildModernStatCard(context, loadingStats[1])),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildModernStatCard(context, loadingStats[2])),
              const SizedBox(width: 16),
              Expanded(child: _buildModernStatCard(context, loadingStats[3])),
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
            child: _buildModernStatCard(context, stat),
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
              Expanded(child: _buildModernStatCard(context, errorStats[0])),
              const SizedBox(width: 16),
              Expanded(child: _buildModernStatCard(context, errorStats[1])),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildModernStatCard(context, errorStats[2])),
              const SizedBox(width: 16),
              Expanded(child: _buildModernStatCard(context, errorStats[3])),
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
            child: _buildModernStatCard(context, stat),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildModernStatCard(BuildContext context, _StatCard stat) {
    return GestureDetector(
      onTap: () => AppRouter.goToTrades(context),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  stat.color.withOpacity(0.02),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: stat.color.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: stat.color.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: stat.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        stat.icon,
                        color: stat.color,
                        size: 20,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: (stat.isPositive ? AppColors.success : AppColors.error)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            stat.change,
                            style: AppTypography.caption.copyWith(
                              color: stat.isPositive ? AppColors.success : AppColors.error,
                              fontWeight: AppTypography.medium,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: stat.color.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  stat.value,
                  style: AppTypography.headlineMedium.copyWith(
                    fontWeight: AppTypography.bold,
                    color: stat.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat.title,
                  style: AppTypography.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: AppTypography.medium,
                  ),
                ),
              ],
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
        icon: Icons.add_rounded,
        color: AppColors.primary,
        onTap: () => AppRouter.goToAddTrade(context),
      ),
      _QuickAction(
        title: 'View Journal',
        subtitle: 'Browse all trades',
        icon: Icons.description_rounded,
        color: AppColors.secondary,
        onTap: () => AppRouter.goToTrades(context),
      ),
      _QuickAction(
        title: 'Live Trading',
        subtitle: 'Open trading interface',
        icon: Icons.show_chart_rounded,
        color: AppColors.success,
        onTap: () => AppRouter.goToTradePage(context),
      ),
      _QuickAction(
        title: 'Analytics',
        subtitle: 'View performance',
        icon: Icons.bar_chart_rounded,
        color: AppColors.warning,
        onTap: () => AppRouter.goToAnalytics(context),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
          
          Column(
            children: actions.map((action) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildSimpleActionTile(context, action),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleActionTile(BuildContext context, _QuickAction action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: action.color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: action.color.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                action.icon,
                color: action.color,
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  action.title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: AppTypography.medium,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTrades(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Recent Trades',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: AppTypography.semiBold,
                ),
              ),
              const Spacer(),
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
            _buildTradesTable(),
          ],
        ],
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

  Widget _buildTradesTable() {
    final recentTrades = _trades!.take(5).toList();
    
    return Column(
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'Symbol',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: AppTypography.medium,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Qty',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: AppTypography.medium,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Status',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: AppTypography.medium,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'P&L',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: AppTypography.medium,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Entry/Exit',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: AppTypography.medium,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        
        // Table rows
        ...recentTrades.map((trade) => _buildTradeTableRow(trade)),
        
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

  Widget _buildTradeTableRow(Trade trade) {
    final pnlColor = trade.pnlValue >= 0 ? AppColors.success : AppColors.error;
    final statusColor = trade.status == 'OPEN' ? AppColors.warning : 
                       trade.status == 'CLOSED' ? AppColors.success : AppColors.primary;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              trade.symbolName,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: AppTypography.medium,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: Text(
              trade.quantityValue.toString(),
              style: AppTypography.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: Container(
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
                  fontSize: 10,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              '₹${trade.pnlValue.toStringAsFixed(2)}',
              style: AppTypography.bodySmall.copyWith(
                fontWeight: AppTypography.medium,
                color: pnlColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '₹${trade.entryPriceValue.toStringAsFixed(2)}/₹${trade.exitPriceValue.toStringAsFixed(2)}',
              style: AppTypography.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
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

  Widget _buildAdditionalMetrics(BuildContext context) {
    if (_trades == null || _trades!.isEmpty) {
      return _buildEmptyAdditionalMetrics();
    }

    final trades = _trades!;
    final bestTrade = trades.reduce((a, b) => a.pnlValue > b.pnlValue ? a : b);
    final worstTrade = trades.reduce((a, b) => a.pnlValue < b.pnlValue ? a : b);
    final avgTradeSize = trades.fold<double>(0.0, (sum, trade) => sum + trade.quantityValue) / trades.length;
    final totalVolume = trades.fold<double>(0.0, (sum, trade) => sum + (trade.quantityValue * trade.entryPriceValue));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Metrics',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: AppTypography.semiBold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildSimpleMetricItem('Best Trade', bestTrade.symbolName, '₹${bestTrade.pnlValue.toStringAsFixed(2)}', AppColors.success),
          _buildSimpleMetricItem('Worst Trade', worstTrade.symbolName, '₹${worstTrade.pnlValue.toStringAsFixed(2)}', AppColors.error),
          _buildSimpleMetricItem('Avg Trade Size', '${avgTradeSize.toStringAsFixed(0)}', 'units', AppColors.primary),
          _buildSimpleMetricItem('Total Volume', '₹${(totalVolume / 1000).toStringAsFixed(1)}K', 'traded', AppColors.secondary),
        ],
      ),
    );
  }

  Widget _buildSimpleMetricItem(String label, String value, String subValue, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: AppTypography.medium,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: AppTypography.semiBold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Text(
            subValue,
            style: AppTypography.bodySmall.copyWith(
              color: color,
              fontWeight: AppTypography.medium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAdditionalMetrics() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 32,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              'No metrics available',
              style: AppTypography.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
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

class _LineChartPainter extends CustomPainter {
  final bool isPositive;

  _LineChartPainter(this.isPositive);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isPositive ? AppColors.success : AppColors.error
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    final points = _generateChartPoints(size);
    
    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = isPositive ? AppColors.success : AppColors.error
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 3.0, pointPaint);
    }
  }

  List<Offset> _generateChartPoints(Size size) {
    final points = <Offset>[];
    final width = size.width;
    final height = size.height;
    
    // Generate a simple upward trend for positive, downward for negative
    for (int i = 0; i < 10; i++) {
      final x = (width / 9) * i;
      final y = isPositive 
          ? height - (height / 10) * (i + 1) + (i * 2) // Upward trend
          : (height / 10) * (i + 1) - (i * 2); // Downward trend
      points.add(Offset(x, y));
    }
    
    return points;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _VolumeBarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final barWidth = size.width / 10;
    
    for (int i = 0; i < 10; i++) {
      final x = barWidth * i;
      final barHeight = (size.height * 0.3) + (i % 3) * (size.height * 0.1);
      final rect = Rect.fromLTWH(x + 2, size.height - barHeight, barWidth - 4, barHeight);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


