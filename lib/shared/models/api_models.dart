import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_models.g.dart';

/// Registration request model
@JsonSerializable()
class RegistrationRequest extends Equatable {
  final String emailId;
  final String userPassword;
  final String mobileNumber;
  final String firstName;
  final String lastName;
  final RegistrationPreferences preferences;

  const RegistrationRequest({
    required this.emailId,
    required this.userPassword,
    required this.mobileNumber,
    required this.firstName,
    required this.lastName,
    required this.preferences,
  });

  factory RegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$RegistrationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationRequestToJson(this);

  @override
  List<Object?> get props => [
        emailId,
        userPassword,
        mobileNumber,
        firstName,
        lastName,
        preferences,
      ];
}

/// Registration preferences model
@JsonSerializable()
class RegistrationPreferences extends Equatable {
  final String theme;
  final String prefType;

  const RegistrationPreferences({
    required this.theme,
    required this.prefType,
  });

  factory RegistrationPreferences.fromJson(Map<String, dynamic> json) =>
      _$RegistrationPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationPreferencesToJson(this);

  @override
  List<Object?> get props => [theme, prefType];
}

/// Broker preferences model for API response
@JsonSerializable()
class BrokerPreferences extends Equatable {
  final int id;
  @JsonKey(name: 'default')
  final bool? isDefault; // Renamed from 'default' to avoid keyword conflict
  final Map<String, int>? quantity;
  final String brokerName;
  final String displayName;

  const BrokerPreferences({
    required this.id,
    this.isDefault,
    this.quantity,
    required this.brokerName,
    required this.displayName,
  });

  factory BrokerPreferences.fromJson(Map<String, dynamic> json) =>
      _$BrokerPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$BrokerPreferencesToJson(this);

  /// Get default quantity for a symbol
  int getDefaultQuantity(String symbol) {
    return quantity?[symbol] ?? 0;
  }

  /// Check if this broker has quantity for a symbol
  bool hasQuantityFor(String symbol) {
    return quantity?.containsKey(symbol) == true && quantity![symbol]! > 0;
  }

  @override
  List<Object?> get props => [id, isDefault, quantity, brokerName, displayName];
}

/// User preferences model for API response
@JsonSerializable()
class UserPreferencesResponse extends Equatable {
  @JsonKey(name: 'WEB')
  final List<WebPreference>? WEB;
  @JsonKey(name: 'BROKER')
  final List<BrokerPreferences>? BROKER;

  const UserPreferencesResponse({
    this.WEB,
    this.BROKER,
  });

  factory UserPreferencesResponse.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferencesResponseToJson(this);

  /// Get web preferences (theme, language)
  WebPreference? get webPreference => WEB?.isNotEmpty == true ? WEB!.first : null;

  /// Get default broker
  BrokerPreferences? get defaultBroker {
    if (BROKER == null || BROKER!.isEmpty) return null;
    try {
      return BROKER!.firstWhere((b) => b.isDefault == true);
    } catch (e) {
      return BROKER!.first;
    }
  }

  /// Get broker by name
  BrokerPreferences? getBrokerByName(String brokerName) {
    if (BROKER == null) return null;
    try {
      return BROKER!.firstWhere((b) => b.brokerName == brokerName);
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [WEB, BROKER];
}

/// Web preferences model for API response
@JsonSerializable()
class WebPreference extends Equatable {
  final int id;
  final String theme;
  final String language;

  const WebPreference({
    required this.id,
    required this.theme,
    required this.language,
  });

  factory WebPreference.fromJson(Map<String, dynamic> json) =>
      _$WebPreferenceFromJson(json);

  Map<String, dynamic> toJson() => _$WebPreferenceToJson(this);

  @override
  List<Object?> get props => [id, theme, language];
}

/// Login response model
@JsonSerializable()
class LoginResponse extends Equatable {
  final String token;
  final UserResponse user;
  final UserPreferencesResponse preferences;

  const LoginResponse({
    required this.token,
    required this.user,
    required this.preferences,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  @override
  List<Object?> get props => [token, user, preferences];
}

/// User response model from API
@JsonSerializable()
class UserResponse extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String emailId;
  final String? mobileNumber;
  final String roles;

  const UserResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.emailId,
    this.mobileNumber,
    required this.roles,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);

  /// Full name getter
  String get fullName => '$firstName $lastName';

  /// Display name getter
  String get displayName {
    final name = fullName.trim();
    return name.isNotEmpty ? name : emailId;
  }

  @override
  List<Object?> get props => [id, firstName, lastName, emailId, mobileNumber, roles];
}
