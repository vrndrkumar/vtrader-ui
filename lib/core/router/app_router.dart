import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/services/auth_service.dart';
import '../../shared/providers/auth_provider.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/trade/presentation/pages/trade_journal_page.dart';
import '../../features/trade/presentation/pages/trade_page.dart';
import '../../features/trade/presentation/pages/add_trade_page.dart';
import '../../features/broker/presentation/pages/broker_management_page.dart';
import '../../features/broker/presentation/pages/broker_integration_wizard.dart';
import '../widgets/main_layout.dart';
import '../../features/home/presentation/pages/home_page.dart';

/// Router configuration provider
final routerProvider = Provider<GoRouter>((ref) {
  // Watch auth state to trigger router refresh on auth changes
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      final isHomeRoute = state.matchedLocation == '/';
      final isLoginRoute = state.matchedLocation == '/login';
      final isRegisterRoute = state.matchedLocation == '/register';

      print('Router redirect - isAuthenticated: $isAuthenticated, location: ${state.matchedLocation}');

      // Allow access to auth routes and home page regardless of authentication
      if (isAuthRoute || isHomeRoute || isLoginRoute || isRegisterRoute) {
        // If authenticated and on auth/home routes, redirect to dashboard
        if (isAuthenticated) {
          print('Redirecting to /dashboard (authenticated user on auth/home route)');
          return '/dashboard';
        }
        // If not authenticated, allow access to these routes
        return null;
      }

      // For all other routes, require authentication
      if (!isAuthenticated) {
        print('Redirecting to /auth/sign-in (not authenticated, accessing protected route)');
        return '/auth/sign-in';
      }

      return null;
    },
    routes: [
      // Home page (landing page)
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      // Authentication routes
      GoRoute(
        path: '/auth',
        redirect: (context, state) => '/auth/sign-in',
      ),
      GoRoute(
        path: '/auth/sign-in',
        name: 'signIn',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/auth/sign-up',
        name: 'signUp',
        builder: (context, state) => const SignUpPage(),
      ),
      
      // Direct login/register routes for homepage links
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // Main app shell with navigation
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          // Dashboard
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardPage(),
          ),

          // Trade routes
          GoRoute(
            path: '/trades',
            name: 'trades',
            builder: (context, state) => const TradeJournalPage(),
            routes: [
              GoRoute(
                path: 'add',
                name: 'addTrade',
                builder: (context, state) => const AddTradePage(),
              ),
              GoRoute(
                path: ':tradeId/edit',
                name: 'editTrade',
                builder: (context, state) {
                  final tradeId = state.pathParameters['tradeId']!;
                  return AddTradePage(tradeId: tradeId);
                },
              ),
            ],
          ),

          // Trading interface
          GoRoute(
            path: '/trade',
            name: 'trade',
            builder: (context, state) {
              final symbol = state.uri.queryParameters['symbol'];
              return TradePage(symbol: symbol);
            },
          ),

          // Broker routes
          GoRoute(
            path: '/brokers',
            name: 'brokers',
            builder: (context, state) => const BrokerManagementPage(),
            routes: [
              GoRoute(
                path: 'add',
                name: 'addBroker',
                builder: (context, state) => const BrokerIntegrationWizard(),
              ),
            ],
          ),

          // Settings routes
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
            routes: [
              GoRoute(
                path: 'profile',
                name: 'profile',
                builder: (context, state) => const ProfilePage(),
              ),
              GoRoute(
                path: 'preferences',
                name: 'preferences',
                builder: (context, state) => const PreferencesPage(),
              ),
            ],
          ),

          // Analytics routes
          GoRoute(
            path: '/analytics',
            name: 'analytics',
            builder: (context, state) => const AnalyticsPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(error: state.error),
  );
});

/// Navigation helper methods
class AppRouter {
  static void goToSignIn(BuildContext context) {
    context.goNamed('signIn');
  }

  static void goToSignUp(BuildContext context) {
    context.goNamed('signUp');
  }

  static void goToForgotPassword(BuildContext context) {
    context.goNamed('forgotPassword');
  }

  static void goToDashboard(BuildContext context) {
    context.goNamed('dashboard');
  }

  static void goToTrades(BuildContext context) {
    context.goNamed('trades');
  }

  static void goToAddTrade(BuildContext context) {
    context.goNamed('addTrade');
  }

  static void goToEditTrade(BuildContext context, String tradeId) {
    context.goNamed('editTrade', pathParameters: {'tradeId': tradeId});
  }

  static void goToTradePage(BuildContext context, {String? symbol}) {
    final params = symbol != null ? {'symbol': symbol} : <String, String>{};
    context.goNamed('trade', queryParameters: params);
  }

  static void goToBrokers(BuildContext context) {
    context.goNamed('brokers');
  }

  static void goToAddBroker(BuildContext context) {
    context.goNamed('addBroker');
  }

  static void goToEditBroker(BuildContext context, String brokerId) {
    context.goNamed('editBroker', pathParameters: {'brokerId': brokerId});
  }

  static void goToSettings(BuildContext context) {
    context.goNamed('settings');
  }

  static void goToProfile(BuildContext context) {
    context.goNamed('profile');
  }

  static void goToPreferences(BuildContext context) {
    context.goNamed('preferences');
  }

  static void goToAnalytics(BuildContext context) {
    context.goNamed('analytics');
  }
}

// Placeholder pages - these will be implemented later
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Settings Page'),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Profile Page'),
      ),
    );
  }
}

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Preferences Page'),
      ),
    );
  }
}

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Analytics Page'),
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  final Exception? error;

  const ErrorPage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Oops! Something went wrong.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error?.toString() ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
