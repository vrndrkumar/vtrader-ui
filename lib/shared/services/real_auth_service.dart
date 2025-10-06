import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/api_models.dart';
import 'api_service.dart';
import 'storage_service.dart';
import 'master_data_service.dart';
import 'auth_service.dart';
import 'broker_service.dart';
import '../../core/constants/app_constants.dart';
import '../../main.dart';
import '../providers/auth_provider.dart';
import '../../features/broker/presentation/providers/broker_providers.dart';

/// Real API authentication service implementation
class RealAuthService extends AuthService {
  UserModel? _currentUser;
  UserPreferencesResponse? _userPreferences;
  BrokerPreferences? _defaultBroker;
  
  // ProviderContainer reference for invalidating providers on logout
  static ProviderContainer? _providerContainer;
  
  /// Set the provider container for state management
  static void setProviderContainer(ProviderContainer container) {
    _providerContainer = container;
  }
  
  @override
  UserModel? get currentUser => _currentUser;

  @override
  bool get isAuthenticated => _currentUser != null;

  @override
  Stream<UserModel?> get authStateChanges async* {
    yield _currentUser;
  }

  @override
  Future<void> initService() async {
    try {
      // Try to restore session from storage
      await _restoreSession();
    } catch (e) {
      print('Auth service initialization error: $e');
      // Continue without session restoration
    }
  }

  /// Restore session from storage
  Future<void> _restoreSession() async {
    try {
      print('Attempting to restore session from storage...');
      final userData = StorageService.getString(AppConstants.userDataKey);
      final token = StorageService.getString(AppConstants.authTokenKey);
      final preferencesData = StorageService.getString(AppConstants.userPreferencesKey);
      final brokerData = StorageService.getString(AppConstants.brokerPreferencesKey);
      
      print('Storage check - userData: ${userData != null ? "exists" : "null"}, token: ${token != null ? "exists" : "null"}');
      
      if (userData != null && token != null) {
        print('Restoring user session...');
        final userJson = jsonDecode(userData);
        _currentUser = UserModel.fromJson(userJson);
        
        if (preferencesData != null) {
          final preferencesJson = jsonDecode(preferencesData);
          _userPreferences = UserPreferencesResponse.fromJson(preferencesJson);
          
          // Set theme from preferences
          _applyThemeFromPreferences();
        }
        
        if (brokerData != null) {
          final brokerJson = jsonDecode(brokerData);
          _defaultBroker = BrokerPreferences.fromJson(brokerJson);
        }
        
        print('Session restored successfully. User: ${_currentUser?.email}, isAuthenticated: $isAuthenticated');
      } else {
        print('No valid session found in storage. User will need to login.');
      }
    } catch (e) {
      print('Failed to restore session: $e');
      await _clearSession();
    }
  }

  @override
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('=== SIGNIN METHOD CALLED ===');
      print('Email: $email, Password: ${password.length} chars');
      
      // Check if this is a demo user
      if (email == 'demo@vtrader.in') {
        print('Demo user detected');
        return await _handleDemoLogin(email, password);
      }
      
      print('Real user login - making API call...');

      // Make API call to real backend
      final response = await ApiService.instance.post<Map<String, dynamic>>(
        AppConstants.loginEndpoint,
        body: {
          'username': email,
          'password': password,
        },
      );

      if (!response.isSuccess) {
        print('API Error: ${response.errorMessage}');
        return AuthResult.failure(response.errorMessage);
      }

      // Debug: Print the actual response data
      print('API Response Data: ${response.data}');
      
      // Check if response data is null or not a Map
      if (response.data == null) {
        return AuthResult.failure('Invalid response from server');
      }

      // Parse login response with better error handling
      LoginResponse loginData;
      try {
        loginData = LoginResponse.fromJson(response.data!);
      } catch (e) {
        print('JSON Parsing Error: $e');
        print('Raw Response: ${response.data}');
        return AuthResult.failure('Failed to parse server response: $e');
      }
      
      // Convert API user to UserModel
      print('Converting API user to UserModel...');
      UserModel user;
      try {
        user = _convertApiUserToUserModel(loginData.user);
        print('UserModel created successfully: ${user.email}');
      } catch (e) {
        print('Error converting API user to UserModel: $e');
        return AuthResult.failure('Failed to process user data: $e');
      }
      
      // Save session data
      print('About to save session...');
      try {
        await _saveSession(user, loginData);
        print('Session saved successfully');
      } catch (e) {
        print('Error saving session: $e');
        return AuthResult.failure('Failed to save session: $e');
      }
      
      print('Login completed. Final auth state - isAuthenticated: $isAuthenticated, user: ${_currentUser?.email}');
      
      // Fetch master data after successful signin
      try {
        await MasterDataService.instance.fetchIndices();
      } catch (e) {
        print('Failed to fetch master data after signin: $e');
        // Don't fail signin if master data fetch fails
      }

      // Initialize broker data after successful signin
      try {
        // Broker initialization will be handled separately
      } catch (e) {
        print('Failed to initialize broker data after signin: $e');
        // Don't fail signin if broker data fetch fails
      }

      return AuthResult.success(user: user, token: loginData.token);
    } catch (e) {
      print('Auth error: $e');
      return AuthResult.failure('Authentication failed: ${e.toString()}');
    }
  }

  /// Handle demo user login (bypass real API)
  Future<AuthResult> _handleDemoLogin(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (password != 'password123') {
      return AuthResult.failure('Invalid email or password');
    }

    // Create demo user
    final user = UserModel(
      id: 'demo_user',
      email: email,
      firstName: 'Demo',
      lastName: 'User',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
      preferences: const UserPreferences(),
      subscription: const UserSubscription(),
      roles: 'USER',
    );

    // Save session
    await _saveSession(user, null);

    // Fetch master data after successful signin
    try {
      await MasterDataService.instance.fetchIndices();
    } catch (e) {
      print('Failed to fetch master data after signin: $e');
      // Don't fail signin if master data fetch fails
    }

    return AuthResult.success(user: user, token: 'demo_token');
  }

  /// Convert API user response to UserModel
  UserModel _convertApiUserToUserModel(UserResponse apiUser) {
    return UserModel(
      id: apiUser.id.toString(),
      email: apiUser.emailId,
      firstName: apiUser.firstName,
      lastName: apiUser.lastName,
      contactNumber: apiUser.mobileNumber,
      createdAt: DateTime.now().subtract(const Duration(days: 30)), // Default value
      updatedAt: DateTime.now(),
      preferences: const UserPreferences(),
      subscription: const UserSubscription(),
      roles: apiUser.roles,
    );
  }

  /// Save session data
  Future<void> _saveSession(UserModel user, LoginResponse? loginData) async {
    print('Saving session for user: ${user.email}');
    _currentUser = user;
    
    // Save user data
    await StorageService.setString(AppConstants.userDataKey, jsonEncode(user.toJson()));
    
    if (loginData != null) {
      // Save token
      await StorageService.setString(AppConstants.authTokenKey, loginData.token);
      
      // Save preferences
      _userPreferences = loginData.preferences;
      await StorageService.setString(
        AppConstants.userPreferencesKey, 
        jsonEncode(loginData.preferences.toJson())
      );
      
      // Save default broker
      _defaultBroker = loginData.preferences.defaultBroker;
      if (_defaultBroker != null) {
        await StorageService.setString(
          AppConstants.brokerPreferencesKey, 
          jsonEncode(_defaultBroker!.toJson())
        );
      }
      
      // Apply theme from preferences
      _applyThemeFromPreferences();
    } else {
      // Demo user - generate a token
      await StorageService.setString(AppConstants.authTokenKey, 'demo_token');
    }
    
    print('Session saved successfully. isAuthenticated: $isAuthenticated');
  }

  /// Apply theme from user preferences
  void _applyThemeFromPreferences() {
    if (_userPreferences?.webPreference?.theme != null) {
      final theme = _userPreferences!.webPreference!.theme.toLowerCase();
      
      // Convert API theme to ThemeMode
      ThemeMode themeMode;
      switch (theme) {
        case 'dark':
          themeMode = ThemeMode.dark;
          break;
        case 'light':
          themeMode = ThemeMode.light;
          break;
        default:
          themeMode = ThemeMode.system;
      }
      
      // Store theme mode index for ThemeModeNotifier
      StorageService.setInt(AppConstants.themeModeKey, themeMode.index);
      
      // Notify the global theme notifier to reload the theme
      ThemeModeNotifier.globalInstance?.reloadTheme();
      
      print('Applied theme from API: $theme -> ThemeMode.$themeMode');
    }
  }

  @override
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? contactNumber,
    String? theme,
  }) async {
    try {
      // Create registration request
      final registrationRequest = RegistrationRequest(
        emailId: email,
        userPassword: password,
        mobileNumber: contactNumber ?? '',
        firstName: firstName,
        lastName: lastName,
        preferences: RegistrationPreferences(
          theme: theme ?? 'light',
          prefType: 'WEB', // For web platform
        ),
      );

      // Make API call to registration endpoint
      final response = await ApiService.instance.post<Map<String, dynamic>>(
        AppConstants.registrationEndpoint,
        body: registrationRequest.toJson(),
      );

      if (!response.isSuccess) {
        print('Registration API Error: ${response.errorMessage}');
        return AuthResult.failure(response.errorMessage);
      }

      // Debug: Print the actual response data
      print('Registration API Response Data: ${response.data}');
      
      // Check if response data is null or not a Map
      if (response.data == null) {
        return AuthResult.failure('Invalid response from server');
      }

      // Registration successful - return success without auto-login
      // User will need to login separately after registration
      return AuthResult.success(
        user: null, // No user object for registration
        token: null, // No token for registration
      );
    } catch (e) {
      print('Registration error: $e');
      return AuthResult.failure('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<AuthResult> signOut() async {
    try {
      print('Starting logout process...');
      
      // Call logout endpoint if authenticated
      if (isAuthenticated) {
        print('User is authenticated, calling logout API...');
        try {
          final response = await ApiService.instance.post(AppConstants.logoutEndpoint);
          if (response.isSuccess) {
            print('Logout API call successful');
          } else {
            print('Logout API call failed: ${response.errorMessage}');
          }
        } catch (e) {
          print('Logout API call exception: $e');
          // Continue with local logout even if API call fails
        }
      } else {
        print('User is not authenticated, skipping API call');
      }
      
      print('Clearing local session...');
      await _clearSession();
      print('Logout completed successfully');
      return AuthResult.success();
    } catch (e) {
      print('Sign out error: $e');
      return AuthResult.failure('Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<AuthResult> sendPasswordReset(String email) async {
    // This would need to be implemented when the backend supports it
    return AuthResult.failure('Password reset is not yet available');
  }

  @override
  Future<AuthResult> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    // This would need to be implemented when the backend supports it
    return AuthResult.failure('Password reset is not yet available');
  }

  @override
  Future<AuthResult> updateProfile({
    String? firstName,
    String? lastName,
    String? profilePicture,
  }) async {
    if (_currentUser == null) {
      return AuthResult.failure('User not authenticated');
    }

    // This would need to be implemented when the backend supports it
    return AuthResult.failure('Profile update is not yet available');
  }

  @override
  Future<AuthResult> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_currentUser == null) {
      return AuthResult.failure('User not authenticated');
    }

    // This would need to be implemented when the backend supports it
    return AuthResult.failure('Password change is not yet available');
  }

  @override
  Future<AuthResult> deleteAccount() async {
    if (_currentUser == null) {
      return AuthResult.failure('User not authenticated');
    }

    // This would need to be implemented when the backend supports it
    return AuthResult.failure('Account deletion is not yet available');
  }

  @override
  Future<AuthResult> refreshToken() async {
    if (_currentUser == null) {
      return AuthResult.failure('User not authenticated');
    }

    try {
      final response = await ApiService.instance.post<Map<String, dynamic>>(
        AppConstants.refreshTokenEndpoint,
      );

      if (!response.isSuccess) {
        return AuthResult.failure(response.errorMessage);
      }

      // Update token
      final newToken = response.data!['token'] as String;
      await StorageService.setString(AppConstants.authTokenKey, newToken);

      return AuthResult.success(user: _currentUser, token: newToken);
    } catch (e) {
      return AuthResult.failure('Token refresh failed: ${e.toString()}');
    }
  }

  /// Clear session data
  Future<void> _clearSession() async {
    print('Clearing session data...');
    _currentUser = null;
    _userPreferences = null;
    _defaultBroker = null;
    
    print('Removing storage data...');
    await StorageService.clearUser();
    await StorageService.remove(AppConstants.userDataKey);
    await StorageService.remove(AppConstants.authTokenKey);
    await StorageService.remove(AppConstants.userPreferencesKey);
    await StorageService.remove(AppConstants.brokerPreferencesKey);
    await StorageService.remove(AppConstants.refreshTokenKey);
    print('Session data cleared successfully');
    
    // Invalidate all providers to clear cached data
    _invalidateAllProviders();
    
    // Notify auth state provider
    _notifyAuthStateChange();
  }
  
  /// Invalidate all user-specific providers
  void _invalidateAllProviders() {
    if (_providerContainer != null) {
      print('Invalidating all providers...');
      try {
        // Import the provider file dynamically to avoid circular dependency
        // The providers will be invalidated by calling invalidate on the container
        _providerContainer!.invalidate(brokersProvider);
        print('Successfully invalidated providers');
      } catch (e) {
        print('Error invalidating providers: $e');
      }
    }
  }
  
  /// Notify auth state provider of changes
  void _notifyAuthStateChange() {
    if (_providerContainer != null) {
      try {
        // Notify auth state provider
        _providerContainer!.read(authStateProvider.notifier).reload();
      } catch (e) {
        print('Error notifying auth state: $e');
      }
    }
  }

  /// Get user preferences
  UserPreferencesResponse? get userPreferences => _userPreferences;

  /// Get default broker
  BrokerPreferences? get defaultBroker => _defaultBroker;

  /// Get default quantity for a symbol
  int getDefaultQuantity(String symbol) {
    return _defaultBroker?.getDefaultQuantity(symbol) ?? 0;
  }

  /// Check if user has a specific role
  bool hasRole(String role) {
    return _currentUser?.roles?.contains(role) ?? false;
  }

  /// Get user's theme preference
  String? getThemePreference() {
    return _userPreferences?.webPreference?.theme;
  }

  /// Get user's language preference
  String? getLanguagePreference() {
    return _userPreferences?.webPreference?.language;
  }
}
