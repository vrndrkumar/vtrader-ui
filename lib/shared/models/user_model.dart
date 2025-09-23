import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

/// User model representing authenticated user data
@JsonSerializable()
@HiveType(typeId: 0)
class UserModel extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String email;
  
  @HiveField(2)
  final String firstName;
  
  @HiveField(3)
  final String lastName;
  
  @HiveField(4)
  final String? contactNumber;
  
  @HiveField(5)
  final String? profilePicture;
  
  @HiveField(6)
  final DateTime createdAt;
  
  @HiveField(7)
  final DateTime updatedAt;
  
  @HiveField(8)
  final UserPreferences preferences;
  
  @HiveField(9)
  final UserSubscription subscription;

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.contactNumber,
    this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
    required this.preferences,
    required this.subscription,
  });

  /// Full name getter
  String get fullName => '$firstName $lastName';

  /// Display name getter (falls back to email if name is empty)
  String get displayName {
    final name = fullName.trim();
    return name.isNotEmpty ? name : email;
  }

  /// Check if user has premium subscription
  bool get isPremium => subscription.isPremium;

  /// Factory constructor from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Create a copy with updated fields
  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? contactNumber,
    String? profilePicture,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserPreferences? preferences,
    UserSubscription? subscription,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      contactNumber: contactNumber ?? this.contactNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      preferences: preferences ?? this.preferences,
      subscription: subscription ?? this.subscription,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        contactNumber,
        profilePicture,
        createdAt,
        updatedAt,
        preferences,
        subscription,
      ];
}

/// User preferences model
@JsonSerializable()
@HiveType(typeId: 1)
class UserPreferences extends Equatable {
  @HiveField(0)
  final String theme; // 'light', 'dark', 'system'
  
  @HiveField(1)
  final String currency;
  
  @HiveField(2)
  final String timezone;
  
  @HiveField(3)
  final bool emailNotifications;
  
  @HiveField(4)
  final bool pushNotifications;
  
  @HiveField(5)
  final bool tradingAlerts;
  
  @HiveField(6)
  final Map<String, dynamic> chartSettings;

  const UserPreferences({
    this.theme = 'system',
    this.currency = 'USD',
    this.timezone = 'UTC',
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.tradingAlerts = true,
    this.chartSettings = const {},
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);

  UserPreferences copyWith({
    String? theme,
    String? currency,
    String? timezone,
    bool? emailNotifications,
    bool? pushNotifications,
    bool? tradingAlerts,
    Map<String, dynamic>? chartSettings,
  }) {
    return UserPreferences(
      theme: theme ?? this.theme,
      currency: currency ?? this.currency,
      timezone: timezone ?? this.timezone,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      tradingAlerts: tradingAlerts ?? this.tradingAlerts,
      chartSettings: chartSettings ?? this.chartSettings,
    );
  }

  @override
  List<Object?> get props => [
        theme,
        currency,
        timezone,
        emailNotifications,
        pushNotifications,
        tradingAlerts,
        chartSettings,
      ];
}

/// User subscription model
@JsonSerializable()
@HiveType(typeId: 2)
class UserSubscription extends Equatable {
  @HiveField(0)
  final String plan; // 'free', 'premium', 'pro'
  
  @HiveField(1)
  final DateTime? expiresAt;
  
  @HiveField(2)
  final bool isActive;
  
  @HiveField(3)
  final Map<String, bool> features;

  const UserSubscription({
    this.plan = 'free',
    this.expiresAt,
    this.isActive = true,
    this.features = const {},
  });

  /// Check if user has premium subscription
  bool get isPremium => plan != 'free' && isActive;

  /// Check if subscription is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if user has access to specific feature
  bool hasFeature(String featureName) {
    return features[featureName] ?? false;
  }

  factory UserSubscription.fromJson(Map<String, dynamic> json) =>
      _$UserSubscriptionFromJson(json);

  Map<String, dynamic> toJson() => _$UserSubscriptionToJson(this);

  UserSubscription copyWith({
    String? plan,
    DateTime? expiresAt,
    bool? isActive,
    Map<String, bool>? features,
  }) {
    return UserSubscription(
      plan: plan ?? this.plan,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      features: features ?? this.features,
    );
  }

  @override
  List<Object?> get props => [plan, expiresAt, isActive, features];
}

