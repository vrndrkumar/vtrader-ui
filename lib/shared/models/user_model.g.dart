// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      email: fields[1] as String,
      firstName: fields[2] as String,
      lastName: fields[3] as String,
      contactNumber: fields[4] as String?,
      profilePicture: fields[5] as String?,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
      preferences: fields[8] as UserPreferences,
      subscription: fields[9] as UserSubscription,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.firstName)
      ..writeByte(3)
      ..write(obj.lastName)
      ..writeByte(4)
      ..write(obj.contactNumber)
      ..writeByte(5)
      ..write(obj.profilePicture)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.preferences)
      ..writeByte(9)
      ..write(obj.subscription);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserPreferencesAdapter extends TypeAdapter<UserPreferences> {
  @override
  final int typeId = 1;

  @override
  UserPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPreferences(
      theme: fields[0] as String,
      currency: fields[1] as String,
      timezone: fields[2] as String,
      emailNotifications: fields[3] as bool,
      pushNotifications: fields[4] as bool,
      tradingAlerts: fields[5] as bool,
      chartSettings: (fields[6] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserPreferences obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.theme)
      ..writeByte(1)
      ..write(obj.currency)
      ..writeByte(2)
      ..write(obj.timezone)
      ..writeByte(3)
      ..write(obj.emailNotifications)
      ..writeByte(4)
      ..write(obj.pushNotifications)
      ..writeByte(5)
      ..write(obj.tradingAlerts)
      ..writeByte(6)
      ..write(obj.chartSettings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserSubscriptionAdapter extends TypeAdapter<UserSubscription> {
  @override
  final int typeId = 2;

  @override
  UserSubscription read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSubscription(
      plan: fields[0] as String,
      expiresAt: fields[1] as DateTime?,
      isActive: fields[2] as bool,
      features: (fields[3] as Map).cast<String, bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserSubscription obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.plan)
      ..writeByte(1)
      ..write(obj.expiresAt)
      ..writeByte(2)
      ..write(obj.isActive)
      ..writeByte(3)
      ..write(obj.features);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSubscriptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      contactNumber: json['contactNumber'] as String?,
      profilePicture: json['profilePicture'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      preferences:
          UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
      subscription: UserSubscription.fromJson(
          json['subscription'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'contactNumber': instance.contactNumber,
      'profilePicture': instance.profilePicture,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'preferences': instance.preferences,
      'subscription': instance.subscription,
    };

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      theme: json['theme'] as String? ?? 'system',
      currency: json['currency'] as String? ?? 'USD',
      timezone: json['timezone'] as String? ?? 'UTC',
      emailNotifications: json['emailNotifications'] as bool? ?? true,
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      tradingAlerts: json['tradingAlerts'] as bool? ?? true,
      chartSettings: json['chartSettings'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'theme': instance.theme,
      'currency': instance.currency,
      'timezone': instance.timezone,
      'emailNotifications': instance.emailNotifications,
      'pushNotifications': instance.pushNotifications,
      'tradingAlerts': instance.tradingAlerts,
      'chartSettings': instance.chartSettings,
    };

UserSubscription _$UserSubscriptionFromJson(Map<String, dynamic> json) =>
    UserSubscription(
      plan: json['plan'] as String? ?? 'free',
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      features: (json['features'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
    );

Map<String, dynamic> _$UserSubscriptionToJson(UserSubscription instance) =>
    <String, dynamic>{
      'plan': instance.plan,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'isActive': instance.isActive,
      'features': instance.features,
    };
