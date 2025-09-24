import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../models/user_model.dart';
import 'storage_service.dart';
import 'master_data_service.dart';
import '../../core/constants/app_constants.dart';
import 'real_auth_service.dart';

/// Authentication service abstraction
/// This provides a clean interface for authentication operations
/// and can be easily swapped with different implementations (Firebase, REST API, etc.)
abstract class AuthService {
  static AuthService? _instance;
  
  /// Get the current auth service instance
  static AuthService get instance {
    _instance ??= RealAuthService();
    return _instance!;
  }

  /// Set a custom auth service implementation
  static void setInstance(AuthService authService) {
    _instance = authService;
  }

  /// Initialize the auth service
  static Future<void> init() async {
    await instance._init();
  }

  /// Internal initialization method
  Future<void> _init();

  /// Get current authenticated user
  UserModel? get currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated;

  /// Stream of authentication state changes
  Stream<UserModel?> get authStateChanges;

  /// Sign up with email and password
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? contactNumber,
  });

  /// Sign in with email and password
  Future<AuthResult> signIn({
    required String email,
    required String password,
  });

  /// Sign out current user
  Future<AuthResult> signOut();

  /// Send password reset email
  Future<AuthResult> sendPasswordReset(String email);

  /// Reset password with token
  Future<AuthResult> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Update user profile
  Future<AuthResult> updateProfile({
    String? firstName,
    String? lastName,
    String? profilePicture,
  });

  /// Change password
  Future<AuthResult> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Delete user account
  Future<AuthResult> deleteAccount();

  /// Refresh authentication token
  Future<AuthResult> refreshToken();
}

/// Authentication result wrapper
class AuthResult {
  final bool success;
  final String? message;
  final UserModel? user;
  final String? token;

  const AuthResult({
    required this.success,
    this.message,
    this.user,
    this.token,
  });

  factory AuthResult.success({UserModel? user, String? token}) {
    return AuthResult(
      success: true,
      user: user,
      token: token,
    );
  }

  factory AuthResult.failure(String message) {
    return AuthResult(
      success: false,
      message: message,
    );
  }
}

/// Mock implementation of AuthService for development and testing
/// Replace this with Firebase Auth, REST API, or other implementations
class MockAuthService extends AuthService {
  UserModel? _currentUser;
  final List<MockUser> _mockUsers = [];
  
  @override
  UserModel? get currentUser => _currentUser;

  @override
  bool get isAuthenticated => _currentUser != null;

  @override
  Stream<UserModel?> get authStateChanges async* {
    yield _currentUser;
  }

  @override
  Future<void> _init() async {
    // Temporarily disable session restoration to fix authentication
    // final userData = StorageService.getString(AppConstants.userDataKey);
    // final token = StorageService.getString(AppConstants.authTokenKey);
    
    // if (userData != null && token != null) {
    //   try {
    //     final userJson = jsonDecode(userData);
    //     _currentUser = UserModel.fromJson(userJson);
    //   } catch (e) {
    //     // Clear invalid session data
    //     await _clearSession();
    //   }
    // }

    // Initialize with some mock users for testing
    _initializeMockUsers();
  }

  void _initializeMockUsers() {
    _mockUsers.addAll([
      MockUser(
        email: 'demo@vtrader.in',
        password: _hashPassword('password123'),
        firstName: 'Demo',
        lastName: 'User',
      ),
      MockUser(
        email: 'trader@example.com',
        password: _hashPassword('trader123'),
        firstName: 'John',
        lastName: 'Trader',
      ),
    ]);
  }

  @override
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? contactNumber,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Validate input
    if (!_isValidEmail(email)) {
      return AuthResult.failure('Invalid email format');
    }

    // Temporarily removed password length validation
    // if (password.length < AppConstants.minPasswordLength) {
    //   return AuthResult.failure(
    //     'Password must be at least ${AppConstants.minPasswordLength} characters',
    //   );
    // }

    // Check if user already exists
    if (_mockUsers.any((user) => user.email == email)) {
      return AuthResult.failure('User already exists with this email');
    }

    // Create new user
    final mockUser = MockUser(
      email: email,
      password: _hashPassword(password),
      firstName: firstName,
      lastName: lastName,
      contactNumber: contactNumber,
    );

    _mockUsers.add(mockUser);

    // Create user model
    final user = UserModel(
      id: _generateUserId(),
      email: email,
      firstName: firstName,
      lastName: lastName,
      contactNumber: contactNumber,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      preferences: const UserPreferences(),
      subscription: const UserSubscription(),
    );

    // Save session
    await _saveSession(user);

    // Fetch master data after successful signup
    try {
      await MasterDataService.instance.fetchIndices();
    } catch (e) {
      print('Failed to fetch master data after signup: $e');
      // Don't fail signup if master data fetch fails
    }

    return AuthResult.success(user: user, token: _generateToken());
  }

  @override
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Find user
    MockUser? mockUser;
    try {
      mockUser = _mockUsers.firstWhere(
        (user) => user.email == email,
      );
    } catch (e) {
      return AuthResult.failure('Invalid email or password');
    }

    // Verify password
    if (mockUser.password != _hashPassword(password)) {
      return AuthResult.failure('Invalid email or password');
    }

    try {
      // Create user model
      final user = UserModel(
        id: _generateUserId(),
        email: mockUser.email,
        firstName: mockUser.firstName,
        lastName: mockUser.lastName,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
        preferences: const UserPreferences(),
        subscription: const UserSubscription(),
      );

    // Save session
    await _saveSession(user);

    // Fetch master data after successful signin
    try {
      await MasterDataService.instance.fetchIndices();
    } catch (e) {
      print('Failed to fetch master data after signin: $e');
      // Don't fail signin if master data fetch fails
    }

    return AuthResult.success(user: user, token: _generateToken());
    } catch (e) {
      print('Auth error: $e'); // Debug print
      return AuthResult.failure('Authentication failed: ${e.toString()}');
    }
  }

  @override
  Future<AuthResult> signOut() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    await _clearSession();
    return AuthResult.success();
  }

  @override
  Future<AuthResult> sendPasswordReset(String email) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (!_isValidEmail(email)) {
      return AuthResult.failure('Invalid email format');
    }

    // Check if user exists
    final userExists = _mockUsers.any((user) => user.email == email);
    if (!userExists) {
      return AuthResult.failure('No user found with this email');
    }

    // In a real implementation, this would send an email
    return AuthResult.success();
  }

  @override
  Future<AuthResult> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Temporarily removed password length validation
    // if (newPassword.length < AppConstants.minPasswordLength) {
    //   return AuthResult.failure(
    //     'Password must be at least ${AppConstants.minPasswordLength} characters',
    //   );
    // }

    // In a real implementation, this would validate the token
    // and update the password in the backend
    return AuthResult.success();
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

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Update user
    final updatedUser = _currentUser!.copyWith(
      firstName: firstName ?? _currentUser!.firstName,
      lastName: lastName ?? _currentUser!.lastName,
      profilePicture: profilePicture ?? _currentUser!.profilePicture,
      updatedAt: DateTime.now(),
    );

    await _saveSession(updatedUser);

    return AuthResult.success(user: updatedUser);
  }

  @override
  Future<AuthResult> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_currentUser == null) {
      return AuthResult.failure('User not authenticated');
    }

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Temporarily removed password length validation
    // if (newPassword.length < AppConstants.minPasswordLength) {
    //   return AuthResult.failure(
    //     'Password must be at least ${AppConstants.minPasswordLength} characters',
    //   );
    // }

    // In a real implementation, this would verify the current password
    // and update it in the backend
    return AuthResult.success();
  }

  @override
  Future<AuthResult> deleteAccount() async {
    if (_currentUser == null) {
      return AuthResult.failure('User not authenticated');
    }

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Remove from mock users
    _mockUsers.removeWhere((user) => user.email == _currentUser!.email);

    // Clear session
    await _clearSession();

    return AuthResult.success();
  }

  @override
  Future<AuthResult> refreshToken() async {
    if (_currentUser == null) {
      return AuthResult.failure('User not authenticated');
    }

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return AuthResult.success(
      user: _currentUser,
      token: _generateToken(),
    );
  }

  // Helper methods
  Future<void> _saveSession(UserModel user) async {
    _currentUser = user;
    // Temporarily disable Hive storage to fix authentication
    // await StorageService.saveUser(user);
    // await StorageService.setString(AppConstants.userDataKey, jsonEncode(user.toJson()));
    await StorageService.setString(AppConstants.authTokenKey, _generateToken());
  }

  Future<void> _clearSession() async {
    _currentUser = null;
    await StorageService.clearUser();
    await StorageService.remove(AppConstants.userDataKey);
    await StorageService.remove(AppConstants.authTokenKey);
    await StorageService.remove(AppConstants.refreshTokenKey);
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String _generateUserId() {
    return 'user_${DateTime.now().millisecondsSinceEpoch}';
  }

  String _generateToken() {
    return 'token_${DateTime.now().millisecondsSinceEpoch}_${_currentUser?.id}';
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

/// Mock user for testing
class MockUser {
  final String email;
  final String password; // Hashed
  final String firstName;
  final String lastName;
  final String? contactNumber;

  const MockUser({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.contactNumber,
  });
}

/// Firebase Auth implementation example
/// Uncomment and implement when using Firebase
/*
class FirebaseAuthService extends AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  @override
  UserModel? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    
    // Convert Firebase user to UserModel
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      firstName: user.displayName?.split(' ').first ?? '',
      lastName: user.displayName?.split(' ').skip(1).join(' ') ?? '',
      profilePicture: user.photoURL,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      updatedAt: DateTime.now(),
      preferences: const UserPreferences(),
      subscription: const UserSubscription(),
    );
  }

  @override
  bool get isAuthenticated => _firebaseAuth.currentUser != null;

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      // Convert to UserModel
      return currentUser;
    });
  }

  // Implement other methods...
}
*/

