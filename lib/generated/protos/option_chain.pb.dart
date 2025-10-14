// This is a generated file - do not edit.
//
// Generated from protos/option_chain.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class OptionData extends $pb.GeneratedMessage {
  factory OptionData({
    $core.String? symbol,
    $core.double? ask,
    $core.double? bid,
    $core.double? ltp,
    $core.double? ltpch,
    $core.double? ltpchp,
    $core.String? optionType,
    $core.double? strikePrice,
    $core.double? oi,
    $core.double? oich,
    $core.double? oichp,
    $core.double? volume,
    $core.double? fp,
    $core.double? fpch,
    $core.double? fpchp,
  }) {
    final result = create();
    if (symbol != null) result.symbol = symbol;
    if (ask != null) result.ask = ask;
    if (bid != null) result.bid = bid;
    if (ltp != null) result.ltp = ltp;
    if (ltpch != null) result.ltpch = ltpch;
    if (ltpchp != null) result.ltpchp = ltpchp;
    if (optionType != null) result.optionType = optionType;
    if (strikePrice != null) result.strikePrice = strikePrice;
    if (oi != null) result.oi = oi;
    if (oich != null) result.oich = oich;
    if (oichp != null) result.oichp = oichp;
    if (volume != null) result.volume = volume;
    if (fp != null) result.fp = fp;
    if (fpch != null) result.fpch = fpch;
    if (fpchp != null) result.fpchp = fpchp;
    return result;
  }

  OptionData._();

  factory OptionData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OptionData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OptionData',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'symbol')
    ..aD(2, _omitFieldNames ? '' : 'ask')
    ..aD(3, _omitFieldNames ? '' : 'bid')
    ..aD(4, _omitFieldNames ? '' : 'ltp')
    ..aD(5, _omitFieldNames ? '' : 'ltpch')
    ..aD(6, _omitFieldNames ? '' : 'ltpchp')
    ..aOS(7, _omitFieldNames ? '' : 'optionType', protoName: 'optionType')
    ..aD(8, _omitFieldNames ? '' : 'strikePrice', protoName: 'strikePrice')
    ..aD(9, _omitFieldNames ? '' : 'oi')
    ..aD(10, _omitFieldNames ? '' : 'oich')
    ..aD(11, _omitFieldNames ? '' : 'oichp')
    ..aD(12, _omitFieldNames ? '' : 'volume')
    ..aD(13, _omitFieldNames ? '' : 'fp')
    ..aD(14, _omitFieldNames ? '' : 'fpch')
    ..aD(15, _omitFieldNames ? '' : 'fpchp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OptionData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OptionData copyWith(void Function(OptionData) updates) =>
      super.copyWith((message) => updates(message as OptionData)) as OptionData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OptionData create() => OptionData._();
  @$core.override
  OptionData createEmptyInstance() => create();
  static $pb.PbList<OptionData> createRepeated() => $pb.PbList<OptionData>();
  @$core.pragma('dart2js:noInline')
  static OptionData getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OptionData>(create);
  static OptionData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get symbol => $_getSZ(0);
  @$pb.TagNumber(1)
  set symbol($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get ask => $_getN(1);
  @$pb.TagNumber(2)
  set ask($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAsk() => $_has(1);
  @$pb.TagNumber(2)
  void clearAsk() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get bid => $_getN(2);
  @$pb.TagNumber(3)
  set bid($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBid() => $_has(2);
  @$pb.TagNumber(3)
  void clearBid() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get ltp => $_getN(3);
  @$pb.TagNumber(4)
  set ltp($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLtp() => $_has(3);
  @$pb.TagNumber(4)
  void clearLtp() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get ltpch => $_getN(4);
  @$pb.TagNumber(5)
  set ltpch($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLtpch() => $_has(4);
  @$pb.TagNumber(5)
  void clearLtpch() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get ltpchp => $_getN(5);
  @$pb.TagNumber(6)
  set ltpchp($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLtpchp() => $_has(5);
  @$pb.TagNumber(6)
  void clearLtpchp() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get optionType => $_getSZ(6);
  @$pb.TagNumber(7)
  set optionType($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOptionType() => $_has(6);
  @$pb.TagNumber(7)
  void clearOptionType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get strikePrice => $_getN(7);
  @$pb.TagNumber(8)
  set strikePrice($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasStrikePrice() => $_has(7);
  @$pb.TagNumber(8)
  void clearStrikePrice() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get oi => $_getN(8);
  @$pb.TagNumber(9)
  set oi($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOi() => $_has(8);
  @$pb.TagNumber(9)
  void clearOi() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get oich => $_getN(9);
  @$pb.TagNumber(10)
  set oich($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasOich() => $_has(9);
  @$pb.TagNumber(10)
  void clearOich() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get oichp => $_getN(10);
  @$pb.TagNumber(11)
  set oichp($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOichp() => $_has(10);
  @$pb.TagNumber(11)
  void clearOichp() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get volume => $_getN(11);
  @$pb.TagNumber(12)
  set volume($core.double value) => $_setDouble(11, value);
  @$pb.TagNumber(12)
  $core.bool hasVolume() => $_has(11);
  @$pb.TagNumber(12)
  void clearVolume() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get fp => $_getN(12);
  @$pb.TagNumber(13)
  set fp($core.double value) => $_setDouble(12, value);
  @$pb.TagNumber(13)
  $core.bool hasFp() => $_has(12);
  @$pb.TagNumber(13)
  void clearFp() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.double get fpch => $_getN(13);
  @$pb.TagNumber(14)
  set fpch($core.double value) => $_setDouble(13, value);
  @$pb.TagNumber(14)
  $core.bool hasFpch() => $_has(13);
  @$pb.TagNumber(14)
  void clearFpch() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.double get fpchp => $_getN(14);
  @$pb.TagNumber(15)
  set fpchp($core.double value) => $_setDouble(14, value);
  @$pb.TagNumber(15)
  $core.bool hasFpchp() => $_has(14);
  @$pb.TagNumber(15)
  void clearFpchp() => $_clearField(15);
}

class OptionChain extends $pb.GeneratedMessage {
  factory OptionChain({
    $core.Iterable<OptionData>? options,
  }) {
    final result = create();
    if (options != null) result.options.addAll(options);
    return result;
  }

  OptionChain._();

  factory OptionChain.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OptionChain.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OptionChain',
      createEmptyInstance: create)
    ..pPM<OptionData>(1, _omitFieldNames ? '' : 'options',
        subBuilder: OptionData.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OptionChain clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OptionChain copyWith(void Function(OptionChain) updates) =>
      super.copyWith((message) => updates(message as OptionChain))
          as OptionChain;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OptionChain create() => OptionChain._();
  @$core.override
  OptionChain createEmptyInstance() => create();
  static $pb.PbList<OptionChain> createRepeated() => $pb.PbList<OptionChain>();
  @$core.pragma('dart2js:noInline')
  static OptionChain getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OptionChain>(create);
  static OptionChain? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<OptionData> get options => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
