// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broker_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BrokerModelAdapter extends TypeAdapter<BrokerModel> {
  @override
  final int typeId = 7;

  @override
  BrokerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BrokerModel(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as BrokerType,
      accountId: fields[3] as String,
      apiKey: fields[4] as String?,
      apiSecret: fields[5] as String?,
      isConnected: fields[6] as bool,
      lastSyncAt: fields[7] as DateTime?,
      syncSettings: fields[8] as BrokerSyncSettings,
      metadata: (fields[9] as Map).cast<String, dynamic>(),
      createdAt: fields[10] as DateTime,
      updatedAt: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BrokerModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.accountId)
      ..writeByte(4)
      ..write(obj.apiKey)
      ..writeByte(5)
      ..write(obj.apiSecret)
      ..writeByte(6)
      ..write(obj.isConnected)
      ..writeByte(7)
      ..write(obj.lastSyncAt)
      ..writeByte(8)
      ..write(obj.syncSettings)
      ..writeByte(9)
      ..write(obj.metadata)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrokerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BrokerSyncSettingsAdapter extends TypeAdapter<BrokerSyncSettings> {
  @override
  final int typeId = 9;

  @override
  BrokerSyncSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BrokerSyncSettings(
      autoSync: fields[0] as bool,
      syncIntervalMinutes: fields[1] as int,
      syncOrders: fields[2] as bool,
      syncPositions: fields[3] as bool,
      syncHoldings: fields[4] as bool,
      syncTrades: fields[5] as bool,
      lastAutoSyncAt: fields[6] as DateTime?,
      syncSymbols: (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, BrokerSyncSettings obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.autoSync)
      ..writeByte(1)
      ..write(obj.syncIntervalMinutes)
      ..writeByte(2)
      ..write(obj.syncOrders)
      ..writeByte(3)
      ..write(obj.syncPositions)
      ..writeByte(4)
      ..write(obj.syncHoldings)
      ..writeByte(5)
      ..write(obj.syncTrades)
      ..writeByte(6)
      ..write(obj.lastAutoSyncAt)
      ..writeByte(7)
      ..write(obj.syncSymbols);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrokerSyncSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PositionModelAdapter extends TypeAdapter<PositionModel> {
  @override
  final int typeId = 10;

  @override
  PositionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PositionModel(
      id: fields[0] as String,
      symbol: fields[1] as String,
      brokerId: fields[2] as String,
      quantity: fields[3] as double,
      averagePrice: fields[4] as double,
      currentPrice: fields[5] as double,
      type: fields[6] as PositionType,
      product: fields[7] as String?,
      updatedAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PositionModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.symbol)
      ..writeByte(2)
      ..write(obj.brokerId)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.averagePrice)
      ..writeByte(5)
      ..write(obj.currentPrice)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.product)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BrokerTypeAdapter extends TypeAdapter<BrokerType> {
  @override
  final int typeId = 8;

  @override
  BrokerType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BrokerType.zerodha;
      case 1:
        return BrokerType.upstox;
      case 2:
        return BrokerType.angelOne;
      case 3:
        return BrokerType.iifl;
      case 4:
        return BrokerType.fyers;
      case 5:
        return BrokerType.interactive;
      case 6:
        return BrokerType.custom;
      default:
        return BrokerType.zerodha;
    }
  }

  @override
  void write(BinaryWriter writer, BrokerType obj) {
    switch (obj) {
      case BrokerType.zerodha:
        writer.writeByte(0);
        break;
      case BrokerType.upstox:
        writer.writeByte(1);
        break;
      case BrokerType.angelOne:
        writer.writeByte(2);
        break;
      case BrokerType.iifl:
        writer.writeByte(3);
        break;
      case BrokerType.fyers:
        writer.writeByte(4);
        break;
      case BrokerType.interactive:
        writer.writeByte(5);
        break;
      case BrokerType.custom:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrokerTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PositionTypeAdapter extends TypeAdapter<PositionType> {
  @override
  final int typeId = 11;

  @override
  PositionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PositionType.long;
      case 1:
        return PositionType.short;
      default:
        return PositionType.long;
    }
  }

  @override
  void write(BinaryWriter writer, PositionType obj) {
    switch (obj) {
      case PositionType.long:
        writer.writeByte(0);
        break;
      case PositionType.short:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrokerModel _$BrokerModelFromJson(Map<String, dynamic> json) => BrokerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$BrokerTypeEnumMap, json['type']),
      accountId: json['accountId'] as String,
      apiKey: json['apiKey'] as String?,
      apiSecret: json['apiSecret'] as String?,
      isConnected: json['isConnected'] as bool? ?? false,
      lastSyncAt: json['lastSyncAt'] == null
          ? null
          : DateTime.parse(json['lastSyncAt'] as String),
      syncSettings: BrokerSyncSettings.fromJson(
          json['syncSettings'] as Map<String, dynamic>),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BrokerModelToJson(BrokerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$BrokerTypeEnumMap[instance.type]!,
      'accountId': instance.accountId,
      'apiKey': instance.apiKey,
      'apiSecret': instance.apiSecret,
      'isConnected': instance.isConnected,
      'lastSyncAt': instance.lastSyncAt?.toIso8601String(),
      'syncSettings': instance.syncSettings,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$BrokerTypeEnumMap = {
  BrokerType.zerodha: 'zerodha',
  BrokerType.upstox: 'upstox',
  BrokerType.angelOne: 'angelOne',
  BrokerType.iifl: 'iifl',
  BrokerType.fyers: 'fyers',
  BrokerType.interactive: 'interactive',
  BrokerType.custom: 'custom',
};

BrokerSyncSettings _$BrokerSyncSettingsFromJson(Map<String, dynamic> json) =>
    BrokerSyncSettings(
      autoSync: json['autoSync'] as bool? ?? false,
      syncIntervalMinutes: (json['syncIntervalMinutes'] as num?)?.toInt() ?? 15,
      syncOrders: json['syncOrders'] as bool? ?? true,
      syncPositions: json['syncPositions'] as bool? ?? true,
      syncHoldings: json['syncHoldings'] as bool? ?? false,
      syncTrades: json['syncTrades'] as bool? ?? true,
      lastAutoSyncAt: json['lastAutoSyncAt'] == null
          ? null
          : DateTime.parse(json['lastAutoSyncAt'] as String),
      syncSymbols: (json['syncSymbols'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BrokerSyncSettingsToJson(BrokerSyncSettings instance) =>
    <String, dynamic>{
      'autoSync': instance.autoSync,
      'syncIntervalMinutes': instance.syncIntervalMinutes,
      'syncOrders': instance.syncOrders,
      'syncPositions': instance.syncPositions,
      'syncHoldings': instance.syncHoldings,
      'syncTrades': instance.syncTrades,
      'lastAutoSyncAt': instance.lastAutoSyncAt?.toIso8601String(),
      'syncSymbols': instance.syncSymbols,
    };

PositionModel _$PositionModelFromJson(Map<String, dynamic> json) =>
    PositionModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      brokerId: json['brokerId'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      averagePrice: (json['averagePrice'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
      type: $enumDecode(_$PositionTypeEnumMap, json['type']),
      product: json['product'] as String?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PositionModelToJson(PositionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'brokerId': instance.brokerId,
      'quantity': instance.quantity,
      'averagePrice': instance.averagePrice,
      'currentPrice': instance.currentPrice,
      'type': _$PositionTypeEnumMap[instance.type]!,
      'product': instance.product,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$PositionTypeEnumMap = {
  PositionType.long: 'long',
  PositionType.short: 'short',
};
