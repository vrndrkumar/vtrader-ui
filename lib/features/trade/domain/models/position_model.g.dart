// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PositionModel _$PositionModelFromJson(Map<String, dynamic> json) =>
    PositionModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      quantity: (json['quantity'] as num).toInt(),
      avgPrice: (json['avgPrice'] as num).toDouble(),
      ltp: (json['ltp'] as num).toDouble(),
      pnl: (json['pnl'] as num).toDouble(),
      pnlPercent: (json['pnlPercent'] as num).toDouble(),
      isLong: json['isLong'] as bool,
      instrument: json['instrument'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      exitedAt: json['exitedAt'] == null
          ? null
          : DateTime.parse(json['exitedAt'] as String),
      dayBuyAvgPrice: (json['dayBuyAvgPrice'] as num?)?.toDouble() ?? 0.0,
      daySellAvgPrice: (json['daySellAvgPrice'] as num?)?.toDouble() ?? 0.0,
      realisedPnl: (json['realisedPnl'] as num?)?.toDouble() ?? 0.0,
      unrealisedMtm: (json['unrealisedMtm'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$PositionModelToJson(PositionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'quantity': instance.quantity,
      'avgPrice': instance.avgPrice,
      'ltp': instance.ltp,
      'pnl': instance.pnl,
      'pnlPercent': instance.pnlPercent,
      'isLong': instance.isLong,
      'instrument': instance.instrument,
      'createdAt': instance.createdAt.toIso8601String(),
      'exitedAt': instance.exitedAt?.toIso8601String(),
      'dayBuyAvgPrice': instance.dayBuyAvgPrice,
      'daySellAvgPrice': instance.daySellAvgPrice,
      'realisedPnl': instance.realisedPnl,
      'unrealisedMtm': instance.unrealisedMtm,
    };

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      instrument: json['instrument'] as String,
      orderType: $enumDecode(_$OrderTypeEnumMap, json['orderType']),
      side: $enumDecode(_$OrderSideEnumMap, json['side']),
      quantity: (json['quantity'] as num).toInt(),
      filledQuantity: (json['filledQuantity'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toDouble(),
      triggerPrice: (json['triggerPrice'] as num?)?.toDouble(),
      status: $enumDecode(_$OrderStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      rejectionReason: json['rejectionReason'] as String?,
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'instrument': instance.instrument,
      'orderType': _$OrderTypeEnumMap[instance.orderType]!,
      'side': _$OrderSideEnumMap[instance.side]!,
      'quantity': instance.quantity,
      'filledQuantity': instance.filledQuantity,
      'price': instance.price,
      'triggerPrice': instance.triggerPrice,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'rejectionReason': instance.rejectionReason,
    };

const _$OrderTypeEnumMap = {
  OrderType.market: 'market',
  OrderType.limit: 'limit',
  OrderType.stopLoss: 'stop_loss',
  OrderType.stopLossMarket: 'stop_loss_market',
};

const _$OrderSideEnumMap = {
  OrderSide.buy: 'buy',
  OrderSide.sell: 'sell',
};

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.open: 'open',
  OrderStatus.partial: 'partial',
  OrderStatus.complete: 'complete',
  OrderStatus.cancelled: 'cancelled',
  OrderStatus.rejected: 'rejected',
};
