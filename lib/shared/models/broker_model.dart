import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'broker_model.g.dart';

/// Broker model representing a connected broker account
@JsonSerializable()
@HiveType(typeId: 7)
class BrokerModel extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final BrokerType type;
  
  @HiveField(3)
  final String accountId;
  
  @HiveField(4)
  final String? apiKey;
  
  @HiveField(5)
  final String? apiSecret;
  
  @HiveField(6)
  final bool isConnected;
  
  @HiveField(7)
  final DateTime? lastSyncAt;
  
  @HiveField(8)
  final BrokerSyncSettings syncSettings;
  
  @HiveField(9)
  final Map<String, dynamic> metadata;
  
  @HiveField(10)
  final DateTime createdAt;
  
  @HiveField(11)
  final DateTime updatedAt;

  const BrokerModel({
    required this.id,
    required this.name,
    required this.type,
    required this.accountId,
    this.apiKey,
    this.apiSecret,
    this.isConnected = false,
    this.lastSyncAt,
    required this.syncSettings,
    this.metadata = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if broker credentials are configured
  bool get hasCredentials => apiKey != null && apiSecret != null;

  /// Check if auto-sync is enabled
  bool get isAutoSyncEnabled => syncSettings.autoSync;

  /// Get display name for the broker
  String get displayName => '$name ($accountId)';

  /// Check if broker needs authentication
  bool get needsAuth => !isConnected || !hasCredentials;

  /// Get sync status description
  String get syncStatusDescription {
    if (!isConnected) return 'Disconnected';
    if (lastSyncAt == null) return 'Never synced';
    
    final now = DateTime.now();
    final diff = now.difference(lastSyncAt!);
    
    if (diff.inMinutes < 1) return 'Just synced';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  factory BrokerModel.fromJson(Map<String, dynamic> json) =>
      _$BrokerModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrokerModelToJson(this);

  BrokerModel copyWith({
    String? id,
    String? name,
    BrokerType? type,
    String? accountId,
    String? apiKey,
    String? apiSecret,
    bool? isConnected,
    DateTime? lastSyncAt,
    BrokerSyncSettings? syncSettings,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BrokerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      accountId: accountId ?? this.accountId,
      apiKey: apiKey ?? this.apiKey,
      apiSecret: apiSecret ?? this.apiSecret,
      isConnected: isConnected ?? this.isConnected,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      syncSettings: syncSettings ?? this.syncSettings,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        accountId,
        apiKey,
        apiSecret,
        isConnected,
        lastSyncAt,
        syncSettings,
        metadata,
        createdAt,
        updatedAt,
      ];
}

/// Broker type enumeration
@HiveType(typeId: 8)
enum BrokerType {
  @HiveField(0)
  zerodha,
  @HiveField(1)
  upstox,
  @HiveField(2)
  angelOne,
  @HiveField(3)
  iifl,
  @HiveField(4)
  fyers,
  @HiveField(5)
  interactive,
  @HiveField(6)
  custom,
}

/// Broker sync settings
@JsonSerializable()
@HiveType(typeId: 9)
class BrokerSyncSettings extends Equatable {
  @HiveField(0)
  final bool autoSync;
  
  @HiveField(1)
  final int syncIntervalMinutes;
  
  @HiveField(2)
  final bool syncOrders;
  
  @HiveField(3)
  final bool syncPositions;
  
  @HiveField(4)
  final bool syncHoldings;
  
  @HiveField(5)
  final bool syncTrades;
  
  @HiveField(6)
  final DateTime? lastAutoSyncAt;
  
  @HiveField(7)
  final List<String> syncSymbols; // Empty means sync all

  const BrokerSyncSettings({
    this.autoSync = false,
    this.syncIntervalMinutes = 15,
    this.syncOrders = true,
    this.syncPositions = true,
    this.syncHoldings = false,
    this.syncTrades = true,
    this.lastAutoSyncAt,
    this.syncSymbols = const [],
  });

  /// Check if it's time for next auto sync
  bool get isTimeForAutoSync {
    if (!autoSync || lastAutoSyncAt == null) return false;
    
    final now = DateTime.now();
    final nextSyncTime = lastAutoSyncAt!.add(
      Duration(minutes: syncIntervalMinutes),
    );
    
    return now.isAfter(nextSyncTime);
  }

  factory BrokerSyncSettings.fromJson(Map<String, dynamic> json) =>
      _$BrokerSyncSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$BrokerSyncSettingsToJson(this);

  BrokerSyncSettings copyWith({
    bool? autoSync,
    int? syncIntervalMinutes,
    bool? syncOrders,
    bool? syncPositions,
    bool? syncHoldings,
    bool? syncTrades,
    DateTime? lastAutoSyncAt,
    List<String>? syncSymbols,
  }) {
    return BrokerSyncSettings(
      autoSync: autoSync ?? this.autoSync,
      syncIntervalMinutes: syncIntervalMinutes ?? this.syncIntervalMinutes,
      syncOrders: syncOrders ?? this.syncOrders,
      syncPositions: syncPositions ?? this.syncPositions,
      syncHoldings: syncHoldings ?? this.syncHoldings,
      syncTrades: syncTrades ?? this.syncTrades,
      lastAutoSyncAt: lastAutoSyncAt ?? this.lastAutoSyncAt,
      syncSymbols: syncSymbols ?? this.syncSymbols,
    );
  }

  @override
  List<Object?> get props => [
        autoSync,
        syncIntervalMinutes,
        syncOrders,
        syncPositions,
        syncHoldings,
        syncTrades,
        lastAutoSyncAt,
        syncSymbols,
      ];
}

/// Position model representing current positions
@JsonSerializable()
@HiveType(typeId: 10)
class PositionModel extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String symbol;
  
  @HiveField(2)
  final String brokerId;
  
  @HiveField(3)
  final double quantity;
  
  @HiveField(4)
  final double averagePrice;
  
  @HiveField(5)
  final double currentPrice;
  
  @HiveField(6)
  final PositionType type;
  
  @HiveField(7)
  final String? product; // MIS, CNC, NRML
  
  @HiveField(8)
  final DateTime updatedAt;

  const PositionModel({
    required this.id,
    required this.symbol,
    required this.brokerId,
    required this.quantity,
    required this.averagePrice,
    required this.currentPrice,
    required this.type,
    this.product,
    required this.updatedAt,
  });

  /// Calculate unrealized P&L
  double get unrealizedPnl {
    final priceChange = currentPrice - averagePrice;
    return priceChange * quantity.abs();
  }

  /// Calculate unrealized P&L percentage
  double get unrealizedPnlPercentage {
    if (averagePrice == 0) return 0.0;
    return (unrealizedPnl / (averagePrice * quantity.abs())) * 100;
  }

  /// Check if position is profitable
  bool get isProfitable => unrealizedPnl > 0;

  /// Get position value
  double get positionValue => currentPrice * quantity.abs();

  factory PositionModel.fromJson(Map<String, dynamic> json) =>
      _$PositionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PositionModelToJson(this);

  PositionModel copyWith({
    String? id,
    String? symbol,
    String? brokerId,
    double? quantity,
    double? averagePrice,
    double? currentPrice,
    PositionType? type,
    String? product,
    DateTime? updatedAt,
  }) {
    return PositionModel(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      brokerId: brokerId ?? this.brokerId,
      quantity: quantity ?? this.quantity,
      averagePrice: averagePrice ?? this.averagePrice,
      currentPrice: currentPrice ?? this.currentPrice,
      type: type ?? this.type,
      product: product ?? this.product,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        symbol,
        brokerId,
        quantity,
        averagePrice,
        currentPrice,
        type,
        product,
        updatedAt,
      ];
}

/// Position type enumeration
@HiveType(typeId: 11)
enum PositionType {
  @HiveField(0)
  long,
  @HiveField(1)
  short,
}

