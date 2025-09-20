import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/app_button.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    final stats = [
      _StatCard(
        title: 'Total P&L',
        value: '+\$2,450.50',
        change: '+12.5%',
        isPositive: true,
        icon: Icons.trending_up,
        color: AppColors.success,
      ),
      _StatCard(
        title: 'Win Rate',
        value: '68.5%',
        change: '+2.1%',
        isPositive: true,
        icon: Icons.percent,
        color: AppColors.primary,
      ),
      _StatCard(
        title: 'Total Trades',
        value: '127',
        change: '+8',
        isPositive: true,
        icon: Icons.swap_horiz,
        color: AppColors.secondary,
      ),
      _StatCard(
        title: 'Active Positions',
        value: '5',
        change: '-2',
        isPositive: false,
        icon: Icons.account_balance,
        color: AppColors.warning,
      ),
    ];

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

  Widget _buildStatCard(BuildContext context, _StatCard stat) {
    return Card(
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
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isMobile) {
    final actions = [
      _QuickAction(
        title: 'Add Trade',
        subtitle: 'Record a new trade',
        icon: Icons.add_circle_outline,
        color: AppColors.primary,
        onTap: () {
          // Navigate to add trade page
        },
      ),
      _QuickAction(
        title: 'View Journal',
        subtitle: 'Browse all trades',
        icon: Icons.book_outlined,
        color: AppColors.secondary,
        onTap: () {
          // Navigate to trade journal
        },
      ),
      _QuickAction(
        title: 'Live Trading',
        subtitle: 'Open trading interface',
        icon: Icons.trending_up,
        color: AppColors.success,
        onTap: () {
          // Navigate to trade page
        },
      ),
      _QuickAction(
        title: 'Analytics',
        subtitle: 'View performance',
        icon: Icons.analytics_outlined,
        color: AppColors.warning,
        onTap: () {
          // Navigate to analytics
        },
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
                  onPressed: () {
                    // Navigate to trade journal
                  },
                  size: AppButtonSize.small,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Placeholder for recent trades list
            Center(
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
                    onPressed: () {
                      // Navigate to add trade
                    },
                    size: AppButtonSize.small,
                  ),
                ],
              ),
            ),
          ],
        ),
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

