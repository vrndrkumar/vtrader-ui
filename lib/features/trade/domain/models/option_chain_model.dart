import 'package:json_annotation/json_annotation.dart';

part 'option_chain_model.g.dart';

@JsonSerializable()
class OptionChainModel {
  final String underlying;
  final double underlyingPrice;
  final DateTime expiry;
  final List<StrikePriceData> strikes;
  final DateTime lastUpdated;

  const OptionChainModel({
    required this.underlying,
    required this.underlyingPrice,
    required this.expiry,
    required this.strikes,
    required this.lastUpdated,
  });

  factory OptionChainModel.fromJson(Map<String, dynamic> json) =>
      _$OptionChainModelFromJson(json);

  Map<String, dynamic> toJson() => _$OptionChainModelToJson(this);
}

@JsonSerializable()
class StrikePriceData {
  final double strikePrice;
  final OptionData? call;
  final OptionData? put;
  final bool isAtm; // At The Money
  final bool isItm; // In The Money

  const StrikePriceData({
    required this.strikePrice,
    this.call,
    this.put,
    this.isAtm = false,
    this.isItm = false,
  });

  factory StrikePriceData.fromJson(Map<String, dynamic> json) =>
      _$StrikePriceDataFromJson(json);

  Map<String, dynamic> toJson() => _$StrikePriceDataToJson(this);
}

@JsonSerializable()
class OptionData {
  final double ltp; // Last Traded Price
  final double bid;
  final double ask;
  final int volume;
  final int openInterest;
  final double change;
  final double changePercent;
  final double iv; // Implied Volatility
  final double delta;
  final double gamma;
  final double theta;
  final double vega;

  const OptionData({
    required this.ltp,
    required this.bid,
    required this.ask,
    required this.volume,
    required this.openInterest,
    required this.change,
    required this.changePercent,
    required this.iv,
    required this.delta,
    required this.gamma,
    required this.theta,
    required this.vega,
  });

  factory OptionData.fromJson(Map<String, dynamic> json) =>
      _$OptionDataFromJson(json);

  Map<String, dynamic> toJson() => _$OptionDataToJson(this);
}

@JsonSerializable()
class MarketIndex {
  final String symbol;
  final String name;
  final double ltp;
  final double change;
  final double changePercent;
  final bool isActive;

  const MarketIndex({
    required this.symbol,
    required this.name,
    required this.ltp,
    required this.change,
    required this.changePercent,
    this.isActive = false,
  });

  factory MarketIndex.fromJson(Map<String, dynamic> json) =>
      _$MarketIndexFromJson(json);

  Map<String, dynamic> toJson() => _$MarketIndexToJson(this);
}

@JsonSerializable()
class CandleData {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;
  final int volume;

  const CandleData({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory CandleData.fromJson(Map<String, dynamic> json) =>
      _$CandleDataFromJson(json);

  Map<String, dynamic> toJson() => _$CandleDataToJson(this);
}
