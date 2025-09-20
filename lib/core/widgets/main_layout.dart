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
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => _onItemTapped(index, items),
            labelType: NavigationRailLabelType.selected,
            leading: Column(
              children: [
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  onPressed: () => context.go('/trades/add'),
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 16),
                const ThemeToggleButton(),
              ],
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: PopupMenuButton<String>(
                    onSelected: _handleMenuAction,
                    child: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
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
                ),
              ),
            ),
            destinations: items.map((item) {
              return NavigationRailDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.selectedIcon),
                label: Text(item.label),
              );
            }).toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, List<NavigationItem> items) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
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
                ),

                // Navigation items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = _selectedIndex == index;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: ListTile(
                          leading: Icon(
                            isSelected ? item.selectedIcon : item.icon,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          title: Text(
                            item.label,
                            style: AppTypography.bodyMedium.copyWith(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? AppTypography.medium
                                  : AppTypography.regular,
                            ),
                          ),
                          selected: isSelected,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onTap: () => _onItemTapped(index, items),
                        ),
                      );
                    },
                  ),
                ),

                // Footer
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const ThemeToggleButton(),
                          const Spacer(),
                          PopupMenuButton<String>(
                            onSelected: _handleMenuAction,
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 16,
                                  child: Icon(Icons.person, size: 20),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AuthService.instance.currentUser?.displayName ?? 'User',
                                      style: AppTypography.bodySmall.copyWith(
                                        fontWeight: AppTypography.medium,
                                      ),
                                    ),
                                    Text(
                                      'View profile',
                                      style: AppTypography.caption.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: widget.child),
        ],
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

