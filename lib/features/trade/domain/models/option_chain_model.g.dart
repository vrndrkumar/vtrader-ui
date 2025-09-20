// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'option_chain_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OptionChainModel _$OptionChainModelFromJson(Map<String, dynamic> json) =>
    OptionChainModel(
      underlying: json['underlying'] as String,
      underlyingPrice: (json['underlyingPrice'] as num).toDouble(),
      expiry: DateTime.parse(json['expiry'] as String),
      strikes: (json['strikes'] as List<dynamic>)
          .map((e) => StrikePriceData.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$OptionChainModelToJson(OptionChainModel instance) =>
    <String, dynamic>{
      'underlying': instance.underlying,
      'underlyingPrice': instance.underlyingPrice,
      'expiry': instance.expiry.toIso8601String(),
      'strikes': instance.strikes,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

StrikePriceData _$StrikePriceDataFromJson(Map<String, dynamic> json) =>
    StrikePriceData(
      strikePrice: (json['strikePrice'] as num).toDouble(),
      call: json['call'] == null
          ? null
          : OptionData.fromJson(json['call'] as Map<String, dynamic>),
      put: json['put'] == null
          ? null
          : OptionData.fromJson(json['put'] as Map<String, dynamic>),
      isAtm: json['isAtm'] as bool? ?? false,
      isItm: json['isItm'] as bool? ?? false,
    );

Map<String, dynamic> _$StrikePriceDataToJson(StrikePriceData instance) =>
    <String, dynamic>{
      'strikePrice': instance.strikePrice,
      'call': instance.call,
      'put': instance.put,
      'isAtm': instance.isAtm,
      'isItm': instance.isItm,
    };

OptionData _$OptionDataFromJson(Map<String, dynamic> json) => OptionData(
      ltp: (json['ltp'] as num).toDouble(),
      bid: (json['bid'] as num).toDouble(),
      ask: (json['ask'] as num).toDouble(),
      volume: (json['volume'] as num).toInt(),
      openInterest: (json['openInterest'] as num).toInt(),
      change: (json['change'] as num).toDouble(),
      changePercent: (json['changePercent'] as num).toDouble(),
      iv: (json['iv'] as num).toDouble(),
      delta: (json['delta'] as num).toDouble(),
      gamma: (json['gamma'] as num).toDouble(),
      theta: (json['theta'] as num).toDouble(),
      vega: (json['vega'] as num).toDouble(),
    );

Map<String, dynamic> _$OptionDataToJson(OptionData instance) =>
    <String, dynamic>{
      'ltp': instance.ltp,
      'bid': instance.bid,
      'ask': instance.ask,
      'volume': instance.volume,
      'openInterest': instance.openInterest,
      'change': instance.change,
      'changePercent': instance.changePercent,
      'iv': instance.iv,
      'delta': instance.delta,
      'gamma': instance.gamma,
      'theta': instance.theta,
      'vega': instance.vega,
    };

MarketIndex _$MarketIndexFromJson(Map<String, dynamic> json) => MarketIndex(
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      ltp: (json['ltp'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      changePercent: (json['changePercent'] as num).toDouble(),
      isActive: json['isActive'] as bool? ?? false,
    );

Map<String, dynamic> _$MarketIndexToJson(MarketIndex instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'name': instance.name,
      'ltp': instance.ltp,
      'change': instance.change,
      'changePercent': instance.changePercent,
      'isActive': instance.isActive,
    };

CandleData _$CandleDataFromJson(Map<String, dynamic> json) => CandleData(
      time: DateTime.parse(json['time'] as String),
      open: (json['open'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      close: (json['close'] as num).toDouble(),
      volume: (json['volume'] as num).toInt(),
    );

Map<String, dynamic> _$CandleDataToJson(CandleData instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'open': instance.open,
      'high': instance.high,
      'low': instance.low,
      'close': instance.close,
      'volume': instance.volume,
    };
