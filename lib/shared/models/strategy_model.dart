import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'strategy_model.g.dart';

/// Strategy model representing trading strategies
@JsonSerializable()
@HiveType(typeId: 12)
class StrategyModel extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final StrategyType type;
  
  @HiveField(4)
  final List<String> symbols;
  
  @HiveField(5)
  final Map<String, dynamic> parameters;
  
  @HiveField(6)
  final StrategyRiskManagement riskManagement;
  
  @HiveField(7)
  final bool isActive;
  
  @HiveField(8)
  final String? color; // For UI display
  
  @HiveField(9)
  final DateTime createdAt;
  
  @HiveField(10)
  final DateTime updatedAt;

  const StrategyModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.symbols = const [],
    this.parameters = const {},
    required this.riskManagement,
    this.isActive = true,
    this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get display name with active status
  String get displayName => isActive ? name : '$name (Inactive)';

  /// Check if strategy applies to symbol
  bool appliesToSymbol(String symbol) {
    if (symbols.isEmpty) return true; // Applies to all symbols
    return symbols.contains(symbol);
  }

  factory StrategyModel.fromJson(Map<String, dynamic> json) =>
      _$StrategyModelFromJson(json);

  Map<String, dynamic> toJson() => _$StrategyModelToJson(this);

  StrategyModel copyWith({
    String? id,
    String? name,
    String? description,
    StrategyType? type,
    List<String>? symbols,
    Map<String, dynamic>? parameters,
    StrategyRiskManagement? riskManagement,
    bool? isActive,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StrategyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      symbols: symbols ?? this.symbols,
      parameters: parameters ?? this.parameters,
      riskManagement: riskManagement ?? this.riskManagement,
      isActive: isActive ?? this.isActive,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        type,
        symbols,
        parameters,
        riskManagement,
        isActive,
        color,
        createdAt,
        updatedAt,
      ];
}

/// Strategy type enumeration
@HiveType(typeId: 13)
enum StrategyType {
  @HiveField(0)
  scalping,
  @HiveField(1)
  dayTrading,
  @HiveField(2)
  swingTrading,
  @HiveField(3)
  positionTrading,
  @HiveField(4)
  arbitrage,
  @HiveField(5)
  momentum,
  @HiveField(6)
  meanReversion,
  @HiveField(7)
  breakout,
  @HiveField(8)
  custom,
}

/// Risk management settings for strategies
@JsonSerializable()
@HiveType(typeId: 14)
class StrategyRiskManagement extends Equatable {
  @HiveField(0)
  final double? maxLossPerTrade; // Maximum loss per trade in currency
  
  @HiveField(1)
  final double? maxLossPercentage; // Maximum loss percentage per trade
  
  @HiveField(2)
  final double? maxPositionSize; // Maximum position size
  
  @HiveField(3)
  final double? stopLossPercentage; // Default stop loss percentage
  
  @HiveField(4)
  final double? takeProfitPercentage; // Default take profit percentage
  
  @HiveField(5)
  final int? maxOpenTrades; // Maximum number of open trades
  
  @HiveField(6)
  final double? riskRewardRatio; // Minimum risk reward ratio
  
  @HiveField(7)
  final bool useTrailingStop;
  
  @HiveField(8)
  final double? trailingStopPercentage;

  const StrategyRiskManagement({
    this.maxLossPerTrade,
    this.maxLossPercentage,
    this.maxPositionSize,
    this.stopLossPercentage,
    this.takeProfitPercentage,
    this.maxOpenTrades,
    this.riskRewardRatio,
    this.useTrailingStop = false,
    this.trailingStopPercentage,
  });

  /// Calculate stop loss price for a given entry price
  double? calculateStopLoss(double entryPrice, bool isLong) {
    if (stopLossPercentage == null) return null;
    
    final percentage = stopLossPercentage! / 100;
    if (isLong) {
      return entryPrice * (1 - percentage);
    } else {
      return entryPrice * (1 + percentage);
    }
  }

  /// Calculate take profit price for a given entry price
  double? calculateTakeProfit(double entryPrice, bool isLong) {
    if (takeProfitPercentage == null) return null;
    
    final percentage = takeProfitPercentage! / 100;
    if (isLong) {
      return entryPrice * (1 + percentage);
    } else {
      return entryPrice * (1 - percentage);
    }
  }

  /// Calculate position size based on risk management rules
  double calculatePositionSize({
    required double entryPrice,
    required double stopLossPrice,
    required double accountBalance,
    double? maxRiskAmount,
  }) {
    final riskAmount = maxRiskAmount ?? 
        (maxLossPerTrade ?? (accountBalance * (maxLossPercentage ?? 2) / 100));
    
    final riskPerShare = (entryPrice - stopLossPrice).abs();
    if (riskPerShare == 0) return 0;
    
    double calculatedSize = riskAmount / riskPerShare;
    
    // Apply maximum position size limit
    if (maxPositionSize != null) {
      calculatedSize = calculatedSize.clamp(0, maxPositionSize!);
    }
    
    return calculatedSize;
  }

  factory StrategyRiskManagement.fromJson(Map<String, dynamic> json) =>
      _$StrategyRiskManagementFromJson(json);

  Map<String, dynamic> toJson() => _$StrategyRiskManagementToJson(this);

  StrategyRiskManagement copyWith({
    double? maxLossPerTrade,
    double? maxLossPercentage,
    double? maxPositionSize,
    double? stopLossPercentage,
    double? takeProfitPercentage,
    int? maxOpenTrades,
    double? riskRewardRatio,
    bool? useTrailingStop,
    double? trailingStopPercentage,
  }) {
    return StrategyRiskManagement(
      maxLossPerTrade: maxLossPerTrade ?? this.maxLossPerTrade,
      maxLossPercentage: maxLossPercentage ?? this.maxLossPercentage,
      maxPositionSize: maxPositionSize ?? this.maxPositionSize,
      stopLossPercentage: stopLossPercentage ?? this.stopLossPercentage,
      takeProfitPercentage: takeProfitPercentage ?? this.takeProfitPercentage,
      maxOpenTrades: maxOpenTrades ?? this.maxOpenTrades,
      riskRewardRatio: riskRewardRatio ?? this.riskRewardRatio,
      useTrailingStop: useTrailingStop ?? this.useTrailingStop,
      trailingStopPercentage: trailingStopPercentage ?? this.trailingStopPercentage,
    );
  }

  @override
  List<Object?> get props => [
        maxLossPerTrade,
        maxLossPercentage,
        maxPositionSize,
        stopLossPercentage,
        takeProfitPercentage,
        maxOpenTrades,
        riskRewardRatio,
        useTrailingStop,
        trailingStopPercentage,
      ];
}

/// Strategy performance metrics
@JsonSerializable()
class StrategyPerformance extends Equatable {
  final String strategyId;
  final int totalTrades;
  final int winningTrades;
  final double totalPnl;
  final double winRate;
  final double averageWin;
  final double averageLoss;
  final double profitFactor;
  final double maxDrawdown;
  final double sharpeRatio;
  final DateTime calculatedAt;

  const StrategyPerformance({
    required this.strategyId,
    required this.totalTrades,
    required this.winningTrades,
    required this.totalPnl,
    required this.winRate,
    required this.averageWin,
    required this.averageLoss,
    required this.profitFactor,
    required this.maxDrawdown,
    required this.sharpeRatio,
    required this.calculatedAt,
  });

  factory StrategyPerformance.fromJson(Map<String, dynamic> json) =>
      _$StrategyPerformanceFromJson(json);

  Map<String, dynamic> toJson() => _$StrategyPerformanceToJson(this);

  @override
  List<Object?> get props => [
        strategyId,
        totalTrades,
        winningTrades,
        totalPnl,
        winRate,
        averageWin,
        averageLoss,
        profitFactor,
        maxDrawdown,
        sharpeRatio,
        calculatedAt,
      ];
}

