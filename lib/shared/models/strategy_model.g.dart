// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strategy_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StrategyModelAdapter extends TypeAdapter<StrategyModel> {
  @override
  final int typeId = 12;

  @override
  StrategyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StrategyModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      type: fields[3] as StrategyType,
      symbols: (fields[4] as List).cast<String>(),
      parameters: (fields[5] as Map).cast<String, dynamic>(),
      riskManagement: fields[6] as StrategyRiskManagement,
      isActive: fields[7] as bool,
      color: fields[8] as String?,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StrategyModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.symbols)
      ..writeByte(5)
      ..write(obj.parameters)
      ..writeByte(6)
      ..write(obj.riskManagement)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.color)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StrategyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StrategyRiskManagementAdapter
    extends TypeAdapter<StrategyRiskManagement> {
  @override
  final int typeId = 14;

  @override
  StrategyRiskManagement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StrategyRiskManagement(
      maxLossPerTrade: fields[0] as double?,
      maxLossPercentage: fields[1] as double?,
      maxPositionSize: fields[2] as double?,
      stopLossPercentage: fields[3] as double?,
      takeProfitPercentage: fields[4] as double?,
      maxOpenTrades: fields[5] as int?,
      riskRewardRatio: fields[6] as double?,
      useTrailingStop: fields[7] as bool,
      trailingStopPercentage: fields[8] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, StrategyRiskManagement obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.maxLossPerTrade)
      ..writeByte(1)
      ..write(obj.maxLossPercentage)
      ..writeByte(2)
      ..write(obj.maxPositionSize)
      ..writeByte(3)
      ..write(obj.stopLossPercentage)
      ..writeByte(4)
      ..write(obj.takeProfitPercentage)
      ..writeByte(5)
      ..write(obj.maxOpenTrades)
      ..writeByte(6)
      ..write(obj.riskRewardRatio)
      ..writeByte(7)
      ..write(obj.useTrailingStop)
      ..writeByte(8)
      ..write(obj.trailingStopPercentage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StrategyRiskManagementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StrategyTypeAdapter extends TypeAdapter<StrategyType> {
  @override
  final int typeId = 13;

  @override
  StrategyType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return StrategyType.scalping;
      case 1:
        return StrategyType.dayTrading;
      case 2:
        return StrategyType.swingTrading;
      case 3:
        return StrategyType.positionTrading;
      case 4:
        return StrategyType.arbitrage;
      case 5:
        return StrategyType.momentum;
      case 6:
        return StrategyType.meanReversion;
      case 7:
        return StrategyType.breakout;
      case 8:
        return StrategyType.custom;
      default:
        return StrategyType.scalping;
    }
  }

  @override
  void write(BinaryWriter writer, StrategyType obj) {
    switch (obj) {
      case StrategyType.scalping:
        writer.writeByte(0);
        break;
      case StrategyType.dayTrading:
        writer.writeByte(1);
        break;
      case StrategyType.swingTrading:
        writer.writeByte(2);
        break;
      case StrategyType.positionTrading:
        writer.writeByte(3);
        break;
      case StrategyType.arbitrage:
        writer.writeByte(4);
        break;
      case StrategyType.momentum:
        writer.writeByte(5);
        break;
      case StrategyType.meanReversion:
        writer.writeByte(6);
        break;
      case StrategyType.breakout:
        writer.writeByte(7);
        break;
      case StrategyType.custom:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StrategyTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StrategyModel _$StrategyModelFromJson(Map<String, dynamic> json) =>
    StrategyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$StrategyTypeEnumMap, json['type']),
      symbols: (json['symbols'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      parameters: json['parameters'] as Map<String, dynamic>? ?? const {},
      riskManagement: StrategyRiskManagement.fromJson(
          json['riskManagement'] as Map<String, dynamic>),
      isActive: json['isActive'] as bool? ?? true,
      color: json['color'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$StrategyModelToJson(StrategyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$StrategyTypeEnumMap[instance.type]!,
      'symbols': instance.symbols,
      'parameters': instance.parameters,
      'riskManagement': instance.riskManagement,
      'isActive': instance.isActive,
      'color': instance.color,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$StrategyTypeEnumMap = {
  StrategyType.scalping: 'scalping',
  StrategyType.dayTrading: 'dayTrading',
  StrategyType.swingTrading: 'swingTrading',
  StrategyType.positionTrading: 'positionTrading',
  StrategyType.arbitrage: 'arbitrage',
  StrategyType.momentum: 'momentum',
  StrategyType.meanReversion: 'meanReversion',
  StrategyType.breakout: 'breakout',
  StrategyType.custom: 'custom',
};

StrategyRiskManagement _$StrategyRiskManagementFromJson(
        Map<String, dynamic> json) =>
    StrategyRiskManagement(
      maxLossPerTrade: (json['maxLossPerTrade'] as num?)?.toDouble(),
      maxLossPercentage: (json['maxLossPercentage'] as num?)?.toDouble(),
      maxPositionSize: (json['maxPositionSize'] as num?)?.toDouble(),
      stopLossPercentage: (json['stopLossPercentage'] as num?)?.toDouble(),
      takeProfitPercentage: (json['takeProfitPercentage'] as num?)?.toDouble(),
      maxOpenTrades: (json['maxOpenTrades'] as num?)?.toInt(),
      riskRewardRatio: (json['riskRewardRatio'] as num?)?.toDouble(),
      useTrailingStop: json['useTrailingStop'] as bool? ?? false,
      trailingStopPercentage:
          (json['trailingStopPercentage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$StrategyRiskManagementToJson(
        StrategyRiskManagement instance) =>
    <String, dynamic>{
      'maxLossPerTrade': instance.maxLossPerTrade,
      'maxLossPercentage': instance.maxLossPercentage,
      'maxPositionSize': instance.maxPositionSize,
      'stopLossPercentage': instance.stopLossPercentage,
      'takeProfitPercentage': instance.takeProfitPercentage,
      'maxOpenTrades': instance.maxOpenTrades,
      'riskRewardRatio': instance.riskRewardRatio,
      'useTrailingStop': instance.useTrailingStop,
      'trailingStopPercentage': instance.trailingStopPercentage,
    };

StrategyPerformance _$StrategyPerformanceFromJson(Map<String, dynamic> json) =>
    StrategyPerformance(
      strategyId: json['strategyId'] as String,
      totalTrades: (json['totalTrades'] as num).toInt(),
      winningTrades: (json['winningTrades'] as num).toInt(),
      totalPnl: (json['totalPnl'] as num).toDouble(),
      winRate: (json['winRate'] as num).toDouble(),
      averageWin: (json['averageWin'] as num).toDouble(),
      averageLoss: (json['averageLoss'] as num).toDouble(),
      profitFactor: (json['profitFactor'] as num).toDouble(),
      maxDrawdown: (json['maxDrawdown'] as num).toDouble(),
      sharpeRatio: (json['sharpeRatio'] as num).toDouble(),
      calculatedAt: DateTime.parse(json['calculatedAt'] as String),
    );

Map<String, dynamic> _$StrategyPerformanceToJson(
        StrategyPerformance instance) =>
    <String, dynamic>{
      'strategyId': instance.strategyId,
      'totalTrades': instance.totalTrades,
      'winningTrades': instance.winningTrades,
      'totalPnl': instance.totalPnl,
      'winRate': instance.winRate,
      'averageWin': instance.averageWin,
      'averageLoss': instance.averageLoss,
      'profitFactor': instance.profitFactor,
      'maxDrawdown': instance.maxDrawdown,
      'sharpeRatio': instance.sharpeRatio,
      'calculatedAt': instance.calculatedAt.toIso8601String(),
    };
