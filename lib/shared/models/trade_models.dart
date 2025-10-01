import 'package:json_annotation/json_annotation.dart';

part 'trade_models.g.dart';

/// Trade data model
@JsonSerializable()
class Trade {
  @JsonKey(name: 'trade_id')
  final String tradeId;
  
  @JsonKey(name: 'user_id')
  final int userId;
  
  @JsonKey(name: 'broker_name')
  final String brokerName;
  
  @JsonKey(name: 'symbol_name')
  final String symbolName;
  
  @JsonKey(name: 'group_name')
  final String groupName;
  
  @JsonKey(name: 'total_quantity')
  final int totalQuantity;
  
  @JsonKey(name: 'avg_entry_price')
  final double avgEntryPrice;
  
  @JsonKey(name: 'avg_exit_price')
  final double avgExitPrice;
  
  @JsonKey(name: 'realized_pnl')
  final double realizedPnl;
  
  @JsonKey(name: 'unrealized_pnl')
  final double unrealizedPnl;
  
  final String status;
  
  @JsonKey(name: 'first_placed_time')
  final String firstPlacedTime;
  
  @JsonKey(name: 'last_updated_time')
  final String lastUpdatedTime;
  
  @JsonKey(name: 'order_count')
  final int orderCount;

  const Trade({
    required this.tradeId,
    required this.userId,
    required this.brokerName,
    required this.symbolName,
    required this.groupName,
    required this.totalQuantity,
    required this.avgEntryPrice,
    required this.avgExitPrice,
    required this.realizedPnl,
    required this.unrealizedPnl,
    required this.status,
    required this.firstPlacedTime,
    required this.lastUpdatedTime,
    required this.orderCount,
  });

  factory Trade.fromJson(Map<String, dynamic> json) => _$TradeFromJson(json);
  Map<String, dynamic> toJson() => _$TradeToJson(this);

  /// Get formatted P&L value
  double get pnlValue => realizedPnl + unrealizedPnl;

  /// Check if trade is profitable
  bool get isProfitable => pnlValue > 0;

  /// Get trade status color
  TradeStatus get tradeStatus {
    switch (status.toUpperCase()) {
      case 'OPEN':
        return TradeStatus.open;
      case 'CLOSED':
        return TradeStatus.closed;
      case 'PARTIALLY_CLOSED':
        return TradeStatus.partiallyClosed;
      default:
        return TradeStatus.unknown;
    }
  }

  /// Get formatted quantity
  int get quantityValue => totalQuantity;

  /// Get formatted entry price
  double get entryPriceValue => avgEntryPrice;

  /// Get formatted exit price
  double get exitPriceValue => avgExitPrice;

  /// Get parsed first placed time
  DateTime? get firstPlacedDateTime {
    try {
      return DateTime.parse(firstPlacedTime);
    } catch (e) {
      return null;
    }
  }

  /// Get parsed last updated time
  DateTime? get lastUpdatedDateTime {
    try {
      return DateTime.parse(lastUpdatedTime);
    } catch (e) {
      return null;
    }
  }
}

/// Trades API response model
@JsonSerializable()
class TradesResponse {
  final bool status;
  final List<Trade> data;

  const TradesResponse({
    required this.status,
    required this.data,
  });

  factory TradesResponse.fromJson(Map<String, dynamic> json) => _$TradesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TradesResponseToJson(this);
}

/// Trade status enum
enum TradeStatus {
  open,
  closed,
  partiallyClosed,
  unknown,
}

/// Order data model
@JsonSerializable()
class Order {
  final int? id;
  final double? price;
  final String? orderId;
  final String? txnType;
  final int? quantity;
  final String? updatedAt;
  final String? placedTime;
  final String? symbolName;
  final String? orderStatus;
  final String? groupName;

  const Order({
    this.id,
    this.price,
    this.orderId,
    this.txnType,
    this.quantity,
    this.updatedAt,
    this.placedTime,
    this.symbolName,
    this.orderStatus,
    this.groupName,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);

  /// Get formatted quantity
  int get quantityValue => quantity ?? 0;

  /// Get formatted price
  double get priceValue => price ?? 0.0;

  /// Get parsed placed time
  DateTime? get placedDateTime {
    if (placedTime == null) return null;
    try {
      return DateTime.parse(placedTime!);
    } catch (e) {
      return null;
    }
  }

  /// Get parsed updated time
  DateTime? get updatedDateTime {
    if (updatedAt == null) return null;
    try {
      return DateTime.parse(updatedAt!);
    } catch (e) {
      return null;
    }
  }

  /// Check if order is buy side
  bool get isBuy => (txnType?.toUpperCase() ?? '') == 'BUY';

  /// Get order status color
  OrderStatus get orderStatusEnum {
    switch ((orderStatus?.toUpperCase() ?? '')) {
      case 'COMPLETE':
      case 'EXECUTED':
      case 'FILLED':
        return OrderStatus.executed;
      case 'PENDING':
      case 'OPEN':
        return OrderStatus.pending;
      case 'CANCELLED':
        return OrderStatus.cancelled;
      case 'REJECTED':
        return OrderStatus.rejected;
      default:
        return OrderStatus.unknown;
    }
  }

  /// Get string representation of any field
  String getStringValue(dynamic value) {
    if (value == null) return 'N/A';
    return value.toString();
  }
}

/// Orders API response model
@JsonSerializable()
class OrdersResponse {
  final bool status;
  final List<Order> data;

  const OrdersResponse({
    required this.status,
    required this.data,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) => _$OrdersResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OrdersResponseToJson(this);
}

/// Tag/Group data model
@JsonSerializable()
class Tag {
  final int id;
  final int userId;
  final String name;
  final String createdAt;
  final String updatedAt;

  const Tag({
    required this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  Map<String, dynamic> toJson() => _$TagToJson(this);
}

/// Tags response model
@JsonSerializable()
class TagsResponse {
  final bool status;
  final List<Tag> data;

  const TagsResponse({
    required this.status,
    required this.data,
  });

  factory TagsResponse.fromJson(Map<String, dynamic> json) => _$TagsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TagsResponseToJson(this);
}

/// Broker data model
@JsonSerializable()
class Broker {
  final int id;
  final String name;
  @JsonKey(name: 'is_active')
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  const Broker({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Broker.fromJson(Map<String, dynamic> json) => _$BrokerFromJson(json);
  Map<String, dynamic> toJson() => _$BrokerToJson(this);

  /// Get display name for dropdown
  String get displayName => name;
}

/// Broker master API response model
@JsonSerializable()
class BrokerMasterResponse {
  final bool status;
  final List<Broker> data;

  const BrokerMasterResponse({
    required this.status,
    required this.data,
  });

  factory BrokerMasterResponse.fromJson(Map<String, dynamic> json) => _$BrokerMasterResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BrokerMasterResponseToJson(this);
}

/// Order status enum
enum OrderStatus {
  executed,
  pending,
  cancelled,
  rejected,
  unknown,
}

/// Trade filter parameters
class TradeFilters {
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? groupName;
  final String? brokerName;

  const TradeFilters({
    this.fromDate,
    this.toDate,
    this.groupName,
    this.brokerName,
  });

  /// Convert to query parameters
  Map<String, String> toQueryParams() {
    final params = <String, String>{};
    
    if (fromDate != null) {
      params['fromDate'] = fromDate!.toIso8601String().split('T')[0];
    }
    
    if (toDate != null) {
      params['toDate'] = toDate!.toIso8601String().split('T')[0];
    }
    
    if (groupName != null && groupName!.isNotEmpty) {
      params['groupName'] = groupName!;
    }
    
    if (brokerName != null && brokerName!.isNotEmpty) {
      params['brokerName'] = brokerName!;
    }
    
    return params;
  }

  /// Create copy with updated values
  TradeFilters copyWith({
    DateTime? fromDate,
    DateTime? toDate,
    String? groupName,
    String? brokerName,
  }) {
    return TradeFilters(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      groupName: groupName ?? this.groupName,
      brokerName: brokerName ?? this.brokerName,
    );
  }

  /// Check if any filters are applied
  bool get hasFilters {
    return fromDate != null || 
           toDate != null || 
           (groupName != null && groupName!.isNotEmpty) ||
           (brokerName != null && brokerName!.isNotEmpty);
  }
}
