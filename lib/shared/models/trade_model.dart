import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'trade_model.g.dart';

/// Trade model representing a single trade/order
@JsonSerializable()
@HiveType(typeId: 3)
class TradeModel extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String symbol;
  
  @HiveField(2)
  final TradeType type; // Long or Short
  
  @HiveField(3)
  final TradeStatus status;
  
  @HiveField(4)
  final OrderType orderType;
  
  @HiveField(5)
  final double quantity;
  
  @HiveField(6)
  final double entryPrice;
  
  @HiveField(7)
  final double? exitPrice;
  
  @HiveField(8)
  final double? stopLoss;
  
  @HiveField(9)
  final double? takeProfit;
  
  @HiveField(10)
  final DateTime entryTime;
  
  @HiveField(11)
  final DateTime? exitTime;
  
  @HiveField(12)
  final String? strategy;
  
  @HiveField(13)
  final List<String> tags;
  
  @HiveField(14)
  final String? notes;
  
  @HiveField(15)
  final String brokerId;
  
  @HiveField(16)
  final String? brokerOrderId;
  
  @HiveField(17)
  final double commission;
  
  @HiveField(18)
  final DateTime createdAt;
  
  @HiveField(19)
  final DateTime updatedAt;

  const TradeModel({
    required this.id,
    required this.symbol,
    required this.type,
    required this.status,
    required this.orderType,
    required this.quantity,
    required this.entryPrice,
    this.exitPrice,
    this.stopLoss,
    this.takeProfit,
    required this.entryTime,
    this.exitTime,
    this.strategy,
    this.tags = const [],
    this.notes,
    required this.brokerId,
    this.brokerOrderId,
    this.commission = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculate P&L for the trade
  double get pnl {
    if (exitPrice == null) return 0.0;
    
    final priceChange = type == TradeType.long
        ? exitPrice! - entryPrice
        : entryPrice - exitPrice!;
    
    return (priceChange * quantity) - commission;
  }

  /// Calculate P&L percentage
  double get pnlPercentage {
    if (exitPrice == null) return 0.0;
    
    final investment = entryPrice * quantity;
    return (pnl / investment) * 100;
  }

  /// Check if trade is profitable
  bool get isProfitable => pnl > 0;

  /// Check if trade is at breakeven
  bool get isBreakeven => pnl == 0;

  /// Get total trade value at entry
  double get entryValue => entryPrice * quantity;

  /// Get total trade value at exit
  double get exitValue => exitPrice != null ? exitPrice! * quantity : 0.0;

  /// Check if trade is open
  bool get isOpen => status == TradeStatus.open;

  /// Check if trade is closed
  bool get isClosed => status == TradeStatus.closed;

  /// Get trade duration in days
  int get durationInDays {
    final endTime = exitTime ?? DateTime.now();
    return endTime.difference(entryTime).inDays;
  }

  factory TradeModel.fromJson(Map<String, dynamic> json) =>
      _$TradeModelFromJson(json);

  Map<String, dynamic> toJson() => _$TradeModelToJson(this);

  TradeModel copyWith({
    String? id,
    String? symbol,
    TradeType? type,
    TradeStatus? status,
    OrderType? orderType,
    double? quantity,
    double? entryPrice,
    double? exitPrice,
    double? stopLoss,
    double? takeProfit,
    DateTime? entryTime,
    DateTime? exitTime,
    String? strategy,
    List<String>? tags,
    String? notes,
    String? brokerId,
    String? brokerOrderId,
    double? commission,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TradeModel(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      type: type ?? this.type,
      status: status ?? this.status,
      orderType: orderType ?? this.orderType,
      quantity: quantity ?? this.quantity,
      entryPrice: entryPrice ?? this.entryPrice,
      exitPrice: exitPrice ?? this.exitPrice,
      stopLoss: stopLoss ?? this.stopLoss,
      takeProfit: takeProfit ?? this.takeProfit,
      entryTime: entryTime ?? this.entryTime,
      exitTime: exitTime ?? this.exitTime,
      strategy: strategy ?? this.strategy,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      brokerId: brokerId ?? this.brokerId,
      brokerOrderId: brokerOrderId ?? this.brokerOrderId,
      commission: commission ?? this.commission,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        symbol,
        type,
        status,
        orderType,
        quantity,
        entryPrice,
        exitPrice,
        stopLoss,
        takeProfit,
        entryTime,
        exitTime,
        strategy,
        tags,
        notes,
        brokerId,
        brokerOrderId,
        commission,
        createdAt,
        updatedAt,
      ];
}

/// Trade type enumeration
@HiveType(typeId: 4)
enum TradeType {
  @HiveField(0)
  long,
  @HiveField(1)
  short,
}

/// Trade status enumeration
@HiveType(typeId: 5)
enum TradeStatus {
  @HiveField(0)
  open,
  @HiveField(1)
  closed,
  @HiveField(2)
  cancelled,
}

/// Order type enumeration
@HiveType(typeId: 6)
enum OrderType {
  @HiveField(0)
  market,
  @HiveField(1)
  limit,
  @HiveField(2)
  stop,
  @HiveField(3)
  stopLimit,
}

/// Trade summary model for analytics
@JsonSerializable()
class TradeSummary extends Equatable {
  final int totalTrades;
  final int winningTrades;
  final int losingTrades;
  final double totalPnl;
  final double winRate;
  final double averageWin;
  final double averageLoss;
  final double profitFactor;
  final double maxDrawdown;
  final double sharpeRatio;

  const TradeSummary({
    required this.totalTrades,
    required this.winningTrades,
    required this.losingTrades,
    required this.totalPnl,
    required this.winRate,
    required this.averageWin,
    required this.averageLoss,
    required this.profitFactor,
    required this.maxDrawdown,
    required this.sharpeRatio,
  });

  factory TradeSummary.fromTrades(List<TradeModel> trades) {
    final closedTrades = trades.where((t) => t.isClosed).toList();
    
    if (closedTrades.isEmpty) {
      return const TradeSummary(
        totalTrades: 0,
        winningTrades: 0,
        losingTrades: 0,
        totalPnl: 0.0,
        winRate: 0.0,
        averageWin: 0.0,
        averageLoss: 0.0,
        profitFactor: 0.0,
        maxDrawdown: 0.0,
        sharpeRatio: 0.0,
      );
    }

    final winningTrades = closedTrades.where((t) => t.isProfitable).toList();
    final losingTrades = closedTrades.where((t) => t.pnl < 0).toList();
    
    final totalPnl = closedTrades.fold(0.0, (sum, t) => sum + t.pnl);
    final winRate = (winningTrades.length / closedTrades.length) * 100;
    
    final averageWin = winningTrades.isNotEmpty
        ? winningTrades.fold(0.0, (sum, t) => sum + t.pnl) / winningTrades.length
        : 0.0;
    
    final averageLoss = losingTrades.isNotEmpty
        ? losingTrades.fold(0.0, (sum, t) => sum + t.pnl.abs()) / losingTrades.length
        : 0.0;
    
    final profitFactor = averageLoss != 0 ? averageWin / averageLoss : 0.0;
    
    // Simplified calculations for maxDrawdown and sharpeRatio
    // In a real implementation, these would be more sophisticated
    final maxDrawdown = losingTrades.isNotEmpty
        ? losingTrades.map((t) => t.pnl).reduce((a, b) => a < b ? a : b).abs()
        : 0.0;
    
    final sharpeRatio = 0.0; // Would need risk-free rate and volatility calculation

    return TradeSummary(
      totalTrades: closedTrades.length,
      winningTrades: winningTrades.length,
      losingTrades: losingTrades.length,
      totalPnl: totalPnl,
      winRate: winRate,
      averageWin: averageWin,
      averageLoss: averageLoss,
      profitFactor: profitFactor,
      maxDrawdown: maxDrawdown,
      sharpeRatio: sharpeRatio,
    );
  }

  factory TradeSummary.fromJson(Map<String, dynamic> json) =>
      _$TradeSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$TradeSummaryToJson(this);

  @override
  List<Object?> get props => [
        totalTrades,
        winningTrades,
        losingTrades,
        totalPnl,
        winRate,
        averageWin,
        averageLoss,
        profitFactor,
        maxDrawdown,
        sharpeRatio,
      ];
}

