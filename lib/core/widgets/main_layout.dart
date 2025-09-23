import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../constants/app_constants.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/widgets/theme_toggle_button.dart';

/// Main layout with responsive navigation
class MainLayout extends ConsumerStatefulWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  int _selectedIndex = 0;
  bool _isDrawerOpen = false;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Dashboard',
      route: '/dashboard',
      featureFlag: null,
    ),
    NavigationItem(
      icon: Icons.trending_up_outlined,
      selectedIcon: Icons.trending_up,
      label: 'Trade',
      route: '/trade',
      featureFlag: null,
    ),
    NavigationItem(
      icon: Icons.book_outlined,
      selectedIcon: Icons.book,
      label: 'Journal',
      route: '/trades',
      featureFlag: null,
    ),
    NavigationItem(
      icon: Icons.account_balance_outlined,
      selectedIcon: Icons.account_balance,
      label: 'Brokers',
      route: '/brokers',
      featureFlag: null,
    ),
    NavigationItem(
      icon: Icons.analytics_outlined,
      selectedIcon: Icons.analytics,
      label: 'Analytics',
      route: '/analytics',
      featureFlag: 'analytics', // Example feature flag
    ),
    NavigationItem(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: 'Settings',
      route: '/settings',
      featureFlag: null,
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _navigationItems.length; i++) {
      if (location.startsWith(_navigationItems[i].route)) {
        setState(() {
          _selectedIndex = i;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    
    // Filter navigation items based on feature flags
    final visibleItems = _navigationItems.where((item) {
      if (item.featureFlag == null) return true;
      // In a real app, you'd check feature flags here
      // return FeatureFlagService.isEnabled(item.featureFlag);
      return true; // For now, show all items
    }).toList();

    if (isMobile) {
      return _buildMobileLayout(context, visibleItems);
    } else if (isTablet) {
      return _buildTabletLayout(context, visibleItems);
    } else {
      return _buildDesktopLayout(context, visibleItems);
    }
  }

  Widget _buildMobileLayout(BuildContext context, List<NavigationItem> items) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getCurrentPageTitle()),
        actions: [
          const ThemeToggleButton(),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('Profile'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'signOut',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sign Out'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => _onItemTapped(index, items),
        destinations: items.map((item) {
          return NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, List<NavigationItem> items) {
    return Scaffold(
      body: Column(
        children: [
          _buildTopBar(context, items),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, List<NavigationItem> items) {
    return Scaffold(
      body: Column(
        children: [
          _buildTopBar(context, items),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, List<NavigationItem> items) {
    final theme = Theme.of(context);
    
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            // Company Logo and Name
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  AppConstants.appName,
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: AppTypography.bold,
                  ),
                ),
              ],
            ),
            
            const Spacer(),
            
            // Theme Toggle
            const ThemeToggleButton(),
            
            const SizedBox(width: 16),
            
            // User Profile with Navigation
            PopupMenuButton<String>(
              onSelected: _handleMenuAction,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 16,
                    child: Icon(Icons.person, size: 20),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AuthService.instance.currentUser?.displayName ?? 'Demo User',
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: AppTypography.medium,
                        ),
                      ),
                      Text(
                        'View profile',
                        style: AppTypography.caption.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              itemBuilder: (context) => [
                // Navigation Items
                const PopupMenuItem(
                  value: 'dashboard',
                  child: ListTile(
                    leading: Icon(Icons.dashboard_outlined),
                    title: Text('Dashboard'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'trade',
                  child: ListTile(
                    leading: Icon(Icons.trending_up_outlined),
                    title: Text('Trade'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'journal',
                  child: ListTile(
                    leading: Icon(Icons.book_outlined),
                    title: Text('Journal'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'brokers',
                  child: ListTile(
                    leading: Icon(Icons.account_balance_outlined),
                    title: Text('Brokers'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'analytics',
                  child: ListTile(
                    leading: Icon(Icons.analytics_outlined),
                    title: Text('Analytics'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'settings',
                  child: ListTile(
                    leading: Icon(Icons.settings_outlined),
                    title: Text('Settings'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuDivider(),
                // User Actions
                const PopupMenuItem(
                  value: 'profile',
                  child: ListTile(
                    leading: Icon(Icons.person_outline),
                    title: Text('Profile'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'preferences',
                  child: ListTile(
                    leading: Icon(Icons.tune),
                    title: Text('Preferences'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'signOut',
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Sign Out'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentPageTitle() {
    if (_selectedIndex >= 0 && _selectedIndex < _navigationItems.length) {
      return _navigationItems[_selectedIndex].label;
    }
    return AppConstants.appName;
  }

  void _onItemTapped(int index, List<NavigationItem> items) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      context.go(items[index].route);
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'dashboard':
        context.go('/dashboard');
        break;
      case 'trade':
        context.go('/trade');
        break;
      case 'journal':
        context.go('/trades');
        break;
      case 'brokers':
        context.go('/brokers');
        break;
      case 'analytics':
        context.go('/analytics');
        break;
      case 'settings':
        context.go('/settings');
        break;
      case 'profile':
        context.go('/settings/profile');
        break;
      case 'preferences':
        context.go('/settings/preferences');
        break;
      case 'signOut':
        _signOut();
        break;
    }
  }

  void _signOut() async {
    final result = await AuthService.instance.signOut();
    if (result.success && mounted) {
      context.go('/auth/sign-in');
    }
  }
}

/// Navigation item model
class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;
  final String? featureFlag;

  const NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
    this.featureFlag,
  });
}

