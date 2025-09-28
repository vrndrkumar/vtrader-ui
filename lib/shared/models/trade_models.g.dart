// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trade _$TradeFromJson(Map<String, dynamic> json) => Trade(
      tradeId: json['trade_id'] as String,
      userId: (json['user_id'] as num).toInt(),
      brokerName: json['broker_name'] as String,
      symbolName: json['symbol_name'] as String,
      groupName: json['group_name'] as String,
      totalQuantity: json['total_quantity'] as String,
      avgEntryPrice: json['avg_entry_price'] as String,
      avgExitPrice: json['avg_exit_price'] as String,
      realizedPnl: json['realized_pnl'] as String,
      unrealizedPnl: (json['unrealized_pnl'] as num).toDouble(),
      status: json['status'] as String,
      firstPlacedTime: json['first_placed_time'] as String,
      lastUpdatedTime: json['last_updated_time'] as String,
      orderCount: (json['order_count'] as num).toInt(),
    );

Map<String, dynamic> _$TradeToJson(Trade instance) => <String, dynamic>{
      'trade_id': instance.tradeId,
      'user_id': instance.userId,
      'broker_name': instance.brokerName,
      'symbol_name': instance.symbolName,
      'group_name': instance.groupName,
      'total_quantity': instance.totalQuantity,
      'avg_entry_price': instance.avgEntryPrice,
      'avg_exit_price': instance.avgExitPrice,
      'realized_pnl': instance.realizedPnl,
      'unrealized_pnl': instance.unrealizedPnl,
      'status': instance.status,
      'first_placed_time': instance.firstPlacedTime,
      'last_updated_time': instance.lastUpdatedTime,
      'order_count': instance.orderCount,
    };

TradesResponse _$TradesResponseFromJson(Map<String, dynamic> json) =>
    TradesResponse(
      status: json['status'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => Trade.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TradesResponseToJson(TradesResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: (json['id'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toDouble(),
      orderId: json['orderId'] as String?,
      txnType: json['txnType'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      updatedAt: json['updatedAt'] as String?,
      placedTime: json['placedTime'] as String?,
      symbolName: json['symbolName'] as String?,
      orderStatus: json['orderStatus'] as String?,
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'orderId': instance.orderId,
      'txnType': instance.txnType,
      'quantity': instance.quantity,
      'updatedAt': instance.updatedAt,
      'placedTime': instance.placedTime,
      'symbolName': instance.symbolName,
      'orderStatus': instance.orderStatus,
    };

OrdersResponse _$OrdersResponseFromJson(Map<String, dynamic> json) =>
    OrdersResponse(
      status: json['status'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrdersResponseToJson(OrdersResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

Broker _$BrokerFromJson(Map<String, dynamic> json) => Broker(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      isActive: json['is_active'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$BrokerToJson(Broker instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_active': instance.isActive,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

BrokerMasterResponse _$BrokerMasterResponseFromJson(
        Map<String, dynamic> json) =>
    BrokerMasterResponse(
      status: json['status'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => Broker.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BrokerMasterResponseToJson(
        BrokerMasterResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
