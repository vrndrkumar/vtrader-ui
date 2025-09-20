import 'package:json_annotation/json_annotation.dart';

part 'position_model.g.dart';

@JsonSerializable()
class PositionModel {
  final String id;
  final String symbol;
  final String instrument;
  final PositionType type;
  final int quantity;
  final double avgPrice;
  final double ltp;
  final double pnl;
  final double pnlPercent;
  final DateTime createdAt;
  final DateTime? exitedAt;
  final PositionStatus status;

  const PositionModel({
    required this.id,
    required this.symbol,
    required this.instrument,
    required this.type,
    required this.quantity,
    required this.avgPrice,
    required this.ltp,
    required this.pnl,
    required this.pnlPercent,
    required this.createdAt,
    this.exitedAt,
    required this.status,
  });

  factory PositionModel.fromJson(Map<String, dynamic> json) =>
      _$PositionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PositionModelToJson(this);
}

@JsonSerializable()
class OrderModel {
  final String id;
  final String symbol;
  final String instrument;
  final OrderType orderType;
  final OrderSide side;
  final int quantity;
  final int? filledQuantity;
  final double? price;
  final double? triggerPrice;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? rejectionReason;

  const OrderModel({
    required this.id,
    required this.symbol,
    required this.instrument,
    required this.orderType,
    required this.side,
    required this.quantity,
    this.filledQuantity,
    this.price,
    this.triggerPrice,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.rejectionReason,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}

enum PositionType {
  @JsonValue('long')
  long,
  @JsonValue('short')
  short,
}

enum PositionStatus {
  @JsonValue('open')
  open,
  @JsonValue('closed')
  closed,
  @JsonValue('partial')
  partial,
}

enum OrderType {
  @JsonValue('market')
  market,
  @JsonValue('limit')
  limit,
  @JsonValue('stop_loss')
  stopLoss,
  @JsonValue('stop_loss_market')
  stopLossMarket,
}

enum OrderSide {
  @JsonValue('buy')
  buy,
  @JsonValue('sell')
  sell,
}

enum OrderStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('open')
  open,
  @JsonValue('partial')
  partial,
  @JsonValue('complete')
  complete,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('rejected')
  rejected,
}
