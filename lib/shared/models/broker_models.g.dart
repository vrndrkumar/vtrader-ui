// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broker_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrokerInfo _$BrokerInfoFromJson(Map<String, dynamic> json) => BrokerInfo(
      userId: json['userId'] as String,
      password: json['password'] as String,
      vendorCode: json['vendorCode'] as String,
      apiKey: json['apiKey'] as String,
      secretKey: json['secretKey'] as String,
      twoFAKey: json['twoFAKey'] as String,
      imei: json['imei'] as String,
    );

Map<String, dynamic> _$BrokerInfoToJson(BrokerInfo instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'password': instance.password,
      'vendorCode': instance.vendorCode,
      'apiKey': instance.apiKey,
      'secretKey': instance.secretKey,
      'twoFAKey': instance.twoFAKey,
      'imei': instance.imei,
    };

BrokerQuantity _$BrokerQuantityFromJson(Map<String, dynamic> json) =>
    BrokerQuantity(
      nifty: (json['nifty'] as num).toInt(),
      sensex: (json['sensex'] as num).toInt(),
      stocks: (json['stocks'] as num).toInt(),
      banknifty: (json['banknifty'] as num).toInt(),
    );

Map<String, dynamic> _$BrokerQuantityToJson(BrokerQuantity instance) =>
    <String, dynamic>{
      'nifty': instance.nifty,
      'sensex': instance.sensex,
      'stocks': instance.stocks,
      'banknifty': instance.banknifty,
    };

BrokerPreferences _$BrokerPreferencesFromJson(Map<String, dynamic> json) =>
    BrokerPreferences(
      quantity:
          BrokerQuantity.fromJson(json['quantity'] as Map<String, dynamic>),
      brokerName: json['brokerName'] as String,
      displayName: json['displayName'] as String,
      defaultBroker: json['default'] as bool,
    );

Map<String, dynamic> _$BrokerPreferencesToJson(BrokerPreferences instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'brokerName': instance.brokerName,
      'displayName': instance.displayName,
      'default': instance.defaultBroker,
    };

Broker _$BrokerFromJson(Map<String, dynamic> json) => Broker(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      brokerInfo:
          BrokerInfo.fromJson(json['brokerInfo'] as Map<String, dynamic>),
      isActive: json['isActive'] as bool,
      brokerName: json['brokerName'] as String,
      preferences: BrokerPreferences.fromJson(
          json['preferences'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$BrokerToJson(Broker instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'brokerInfo': instance.brokerInfo,
      'isActive': instance.isActive,
      'brokerName': instance.brokerName,
      'preferences': instance.preferences,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

BrokersResponse _$BrokersResponseFromJson(Map<String, dynamic> json) =>
    BrokersResponse(
      status: json['status'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => Broker.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BrokersResponseToJson(BrokersResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
