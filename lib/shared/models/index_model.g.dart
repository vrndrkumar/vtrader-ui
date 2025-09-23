// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IndexModel _$IndexModelFromJson(Map<String, dynamic> json) => IndexModel(
      id: (json['id'] as num).toInt(),
      exchange: json['exchange'] as String,
      symbolCode: json['symbolCode'] as String,
      symbolName: json['symbolName'] as String,
      tokenId: (json['tokenId'] as num).toInt(),
      lot: (json['lot'] as num).toInt(),
      strikeDifference: (json['strikeDifference'] as num).toInt(),
      expiryDays: json['expiryDays'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$IndexModelToJson(IndexModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'exchange': instance.exchange,
      'symbolCode': instance.symbolCode,
      'symbolName': instance.symbolName,
      'tokenId': instance.tokenId,
      'lot': instance.lot,
      'strikeDifference': instance.strikeDifference,
      'expiryDays': instance.expiryDays,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

MasterDataResponse _$MasterDataResponseFromJson(Map<String, dynamic> json) =>
    MasterDataResponse(
      indices: (json['indices'] as List<dynamic>)
          .map((e) => IndexModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MasterDataResponseToJson(MasterDataResponse instance) =>
    <String, dynamic>{
      'indices': instance.indices,
    };
