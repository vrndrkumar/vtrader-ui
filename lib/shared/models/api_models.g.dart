// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationRequest _$RegistrationRequestFromJson(Map<String, dynamic> json) =>
    RegistrationRequest(
      emailId: json['emailId'] as String,
      userPassword: json['userPassword'] as String,
      mobileNumber: json['mobileNumber'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      preferences: RegistrationPreferences.fromJson(
          json['preferences'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RegistrationRequestToJson(
        RegistrationRequest instance) =>
    <String, dynamic>{
      'emailId': instance.emailId,
      'userPassword': instance.userPassword,
      'mobileNumber': instance.mobileNumber,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'preferences': instance.preferences,
    };

RegistrationPreferences _$RegistrationPreferencesFromJson(
        Map<String, dynamic> json) =>
    RegistrationPreferences(
      theme: json['theme'] as String,
      prefType: json['prefType'] as String,
    );

Map<String, dynamic> _$RegistrationPreferencesToJson(
        RegistrationPreferences instance) =>
    <String, dynamic>{
      'theme': instance.theme,
      'prefType': instance.prefType,
    };

BrokerPreferences _$BrokerPreferencesFromJson(Map<String, dynamic> json) =>
    BrokerPreferences(
      id: (json['id'] as num).toInt(),
      isDefault: json['default'] as bool?,
      quantity: (json['quantity'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      brokerName: json['brokerName'] as String,
      displayName: json['displayName'] as String,
    );

Map<String, dynamic> _$BrokerPreferencesToJson(BrokerPreferences instance) =>
    <String, dynamic>{
      'id': instance.id,
      'default': instance.isDefault,
      'quantity': instance.quantity,
      'brokerName': instance.brokerName,
      'displayName': instance.displayName,
    };

UserPreferencesResponse _$UserPreferencesResponseFromJson(
        Map<String, dynamic> json) =>
    UserPreferencesResponse(
      WEB: (json['WEB'] as List<dynamic>?)
          ?.map((e) => WebPreference.fromJson(e as Map<String, dynamic>))
          .toList(),
      BROKER: (json['BROKER'] as List<dynamic>?)
          ?.map((e) => BrokerPreferences.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserPreferencesResponseToJson(
        UserPreferencesResponse instance) =>
    <String, dynamic>{
      'WEB': instance.WEB,
      'BROKER': instance.BROKER,
    };

WebPreference _$WebPreferenceFromJson(Map<String, dynamic> json) =>
    WebPreference(
      id: (json['id'] as num).toInt(),
      theme: json['theme'] as String,
      language: json['language'] as String,
    );

Map<String, dynamic> _$WebPreferenceToJson(WebPreference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theme': instance.theme,
      'language': instance.language,
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      token: json['token'] as String,
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
      preferences: UserPreferencesResponse.fromJson(
          json['preferences'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'user': instance.user,
      'preferences': instance.preferences,
    };

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
      id: (json['id'] as num).toInt(),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      emailId: json['emailId'] as String,
      mobileNumber: json['mobileNumber'] as String?,
      roles: json['roles'] as String,
    );

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'emailId': instance.emailId,
      'mobileNumber': instance.mobileNumber,
      'roles': instance.roles,
    };
