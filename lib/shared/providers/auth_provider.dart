import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Auth state provider that notifies listeners when auth state changes
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier();
});

/// Auth state
class AuthState {
  final UserModel? user;
  final bool isAuthenticated;
  final bool isLoading;

  const AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isAuthenticated,
    bool? isLoading,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Auth state notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(const AuthState()) {
    _init();
  }

  void _init() {
    final currentUser = AuthService.instance.currentUser;
    final isAuthenticated = AuthService.instance.isAuthenticated;
    state = AuthState(
      user: currentUser,
      isAuthenticated: isAuthenticated,
    );
  }

  /// Update auth state when user signs in
  void signIn(UserModel user) {
    state = AuthState(
      user: user,
      isAuthenticated: true,
    );
  }

  /// Update auth state when user signs out
  void signOut() {
    state = const AuthState(
      user: null,
      isAuthenticated: false,
    );
  }

  /// Reload current user from auth service
  void reload() {
    final currentUser = AuthService.instance.currentUser;
    final isAuthenticated = AuthService.instance.isAuthenticated;
    state = AuthState(
      user: currentUser,
      isAuthenticated: isAuthenticated,
    );
  }
}

/// Current user provider
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authStateProvider).user;
});

/// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isAuthenticated;
});

