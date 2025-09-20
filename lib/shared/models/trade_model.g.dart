// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TradeModelAdapter extends TypeAdapter<TradeModel> {
  @override
  final int typeId = 3;

  @override
  TradeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TradeModel(
      id: fields[0] as String,
      symbol: fields[1] as String,
      type: fields[2] as TradeType,
      status: fields[3] as TradeStatus,
      orderType: fields[4] as OrderType,
      quantity: fields[5] as double,
      entryPrice: fields[6] as double,
      exitPrice: fields[7] as double?,
      stopLoss: fields[8] as double?,
      takeProfit: fields[9] as double?,
      entryTime: fields[10] as DateTime,
      exitTime: fields[11] as DateTime?,
      strategy: fields[12] as String?,
      tags: (fields[13] as List).cast<String>(),
      notes: fields[14] as String?,
      brokerId: fields[15] as String,
      brokerOrderId: fields[16] as String?,
      commission: fields[17] as double,
      createdAt: fields[18] as DateTime,
      updatedAt: fields[19] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TradeModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.symbol)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.orderType)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.entryPrice)
      ..writeByte(7)
      ..write(obj.exitPrice)
      ..writeByte(8)
      ..write(obj.stopLoss)
      ..writeByte(9)
      ..write(obj.takeProfit)
      ..writeByte(10)
      ..write(obj.entryTime)
      ..writeByte(11)
      ..write(obj.exitTime)
      ..writeByte(12)
      ..write(obj.strategy)
      ..writeByte(13)
      ..write(obj.tags)
      ..writeByte(14)
      ..write(obj.notes)
      ..writeByte(15)
      ..write(obj.brokerId)
      ..writeByte(16)
      ..write(obj.brokerOrderId)
      ..writeByte(17)
      ..write(obj.commission)
      ..writeByte(18)
      ..write(obj.createdAt)
      ..writeByte(19)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TradeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TradeTypeAdapter extends TypeAdapter<TradeType> {
  @override
  final int typeId = 4;

  @override
  TradeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TradeType.long;
      case 1:
        return TradeType.short;
      default:
        return TradeType.long;
    }
  }

  @override
  void write(BinaryWriter writer, TradeType obj) {
    switch (obj) {
      case TradeType.long:
        writer.writeByte(0);
        break;
      case TradeType.short:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TradeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TradeStatusAdapter extends TypeAdapter<TradeStatus> {
  @override
  final int typeId = 5;

  @override
  TradeStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TradeStatus.open;
      case 1:
        return TradeStatus.closed;
      case 2:
        return TradeStatus.cancelled;
      default:
        return TradeStatus.open;
    }
  }

  @override
  void write(BinaryWriter writer, TradeStatus obj) {
    switch (obj) {
      case TradeStatus.open:
        writer.writeByte(0);
        break;
      case TradeStatus.closed:
        writer.writeByte(1);
        break;
      case TradeStatus.cancelled:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TradeStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderTypeAdapter extends TypeAdapter<OrderType> {
  @override
  final int typeId = 6;

  @override
  OrderType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OrderType.market;
      case 1:
        return OrderType.limit;
      case 2:
        return OrderType.stop;
      case 3:
        return OrderType.stopLimit;
      default:
        return OrderType.market;
    }
  }

  @override
  void write(BinaryWriter writer, OrderType obj) {
    switch (obj) {
      case OrderType.market:
        writer.writeByte(0);
        break;
      case OrderType.limit:
        writer.writeByte(1);
        break;
      case OrderType.stop:
        writer.writeByte(2);
        break;
      case OrderType.stopLimit:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TradeModel _$TradeModelFromJson(Map<String, dynamic> json) => TradeModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      type: $enumDecode(_$TradeTypeEnumMap, json['type']),
      status: $enumDecode(_$TradeStatusEnumMap, json['status']),
      orderType: $enumDecode(_$OrderTypeEnumMap, json['orderType']),
      quantity: (json['quantity'] as num).toDouble(),
      entryPrice: (json['entryPrice'] as num).toDouble(),
      exitPrice: (json['exitPrice'] as num?)?.toDouble(),
      stopLoss: (json['stopLoss'] as num?)?.toDouble(),
      takeProfit: (json['takeProfit'] as num?)?.toDouble(),
      entryTime: DateTime.parse(json['entryTime'] as String),
      exitTime: json['exitTime'] == null
          ? null
          : DateTime.parse(json['exitTime'] as String),
      strategy: json['strategy'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      notes: json['notes'] as String?,
      brokerId: json['brokerId'] as String,
      brokerOrderId: json['brokerOrderId'] as String?,
      commission: (json['commission'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TradeModelToJson(TradeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'type': _$TradeTypeEnumMap[instance.type]!,
      'status': _$TradeStatusEnumMap[instance.status]!,
      'orderType': _$OrderTypeEnumMap[instance.orderType]!,
      'quantity': instance.quantity,
      'entryPrice': instance.entryPrice,
      'exitPrice': instance.exitPrice,
      'stopLoss': instance.stopLoss,
      'takeProfit': instance.takeProfit,
      'entryTime': instance.entryTime.toIso8601String(),
      'exitTime': instance.exitTime?.toIso8601String(),
      'strategy': instance.strategy,
      'tags': instance.tags,
      'notes': instance.notes,
      'brokerId': instance.brokerId,
      'brokerOrderId': instance.brokerOrderId,
      'commission': instance.commission,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$TradeTypeEnumMap = {
  TradeType.long: 'long',
  TradeType.short: 'short',
};

const _$TradeStatusEnumMap = {
  TradeStatus.open: 'open',
  TradeStatus.closed: 'closed',
  TradeStatus.cancelled: 'cancelled',
};

const _$OrderTypeEnumMap = {
  OrderType.market: 'market',
  OrderType.limit: 'limit',
  OrderType.stop: 'stop',
  OrderType.stopLimit: 'stopLimit',
};

TradeSummary _$TradeSummaryFromJson(Map<String, dynamic> json) => TradeSummary(
      totalTrades: (json['totalTrades'] as num).toInt(),
      winningTrades: (json['winningTrades'] as num).toInt(),
      losingTrades: (json['losingTrades'] as num).toInt(),
      totalPnl: (json['totalPnl'] as num).toDouble(),
      winRate: (json['winRate'] as num).toDouble(),
      averageWin: (json['averageWin'] as num).toDouble(),
      averageLoss: (json['averageLoss'] as num).toDouble(),
      profitFactor: (json['profitFactor'] as num).toDouble(),
      maxDrawdown: (json['maxDrawdown'] as num).toDouble(),
      sharpeRatio: (json['sharpeRatio'] as num).toDouble(),
    );

Map<String, dynamic> _$TradeSummaryToJson(TradeSummary instance) =>
    <String, dynamic>{
      'totalTrades': instance.totalTrades,
      'winningTrades': instance.winningTrades,
      'losingTrades': instance.losingTrades,
      'totalPnl': instance.totalPnl,
      'winRate': instance.winRate,
      'averageWin': instance.averageWin,
      'averageLoss': instance.averageLoss,
      'profitFactor': instance.profitFactor,
      'maxDrawdown': instance.maxDrawdown,
      'sharpeRatio': instance.sharpeRatio,
    };
