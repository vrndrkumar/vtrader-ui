// This is a generated file - do not edit.
//
// Generated from protos/option_chain.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use optionDataDescriptor instead')
const OptionData$json = {
  '1': 'OptionData',
  '2': [
    {'1': 'symbol', '3': 1, '4': 1, '5': 9, '10': 'symbol'},
    {'1': 'ask', '3': 2, '4': 1, '5': 1, '10': 'ask'},
    {'1': 'bid', '3': 3, '4': 1, '5': 1, '10': 'bid'},
    {'1': 'ltp', '3': 4, '4': 1, '5': 1, '10': 'ltp'},
    {'1': 'ltpch', '3': 5, '4': 1, '5': 1, '10': 'ltpch'},
    {'1': 'ltpchp', '3': 6, '4': 1, '5': 1, '10': 'ltpchp'},
    {'1': 'optionType', '3': 7, '4': 1, '5': 9, '10': 'optionType'},
    {'1': 'strikePrice', '3': 8, '4': 1, '5': 1, '10': 'strikePrice'},
    {'1': 'oi', '3': 9, '4': 1, '5': 1, '10': 'oi'},
    {'1': 'oich', '3': 10, '4': 1, '5': 1, '10': 'oich'},
    {'1': 'oichp', '3': 11, '4': 1, '5': 1, '10': 'oichp'},
    {'1': 'volume', '3': 12, '4': 1, '5': 1, '10': 'volume'},
    {'1': 'fp', '3': 13, '4': 1, '5': 1, '10': 'fp'},
    {'1': 'fpch', '3': 14, '4': 1, '5': 1, '10': 'fpch'},
    {'1': 'fpchp', '3': 15, '4': 1, '5': 1, '10': 'fpchp'},
  ],
};

/// Descriptor for `OptionData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List optionDataDescriptor = $convert.base64Decode(
    'CgpPcHRpb25EYXRhEhYKBnN5bWJvbBgBIAEoCVIGc3ltYm9sEhAKA2FzaxgCIAEoAVIDYXNrEh'
    'AKA2JpZBgDIAEoAVIDYmlkEhAKA2x0cBgEIAEoAVIDbHRwEhQKBWx0cGNoGAUgASgBUgVsdHBj'
    'aBIWCgZsdHBjaHAYBiABKAFSBmx0cGNocBIeCgpvcHRpb25UeXBlGAcgASgJUgpvcHRpb25UeX'
    'BlEiAKC3N0cmlrZVByaWNlGAggASgBUgtzdHJpa2VQcmljZRIOCgJvaRgJIAEoAVICb2kSEgoE'
    'b2ljaBgKIAEoAVIEb2ljaBIUCgVvaWNocBgLIAEoAVIFb2ljaHASFgoGdm9sdW1lGAwgASgBUg'
    'Z2b2x1bWUSDgoCZnAYDSABKAFSAmZwEhIKBGZwY2gYDiABKAFSBGZwY2gSFAoFZnBjaHAYDyAB'
    'KAFSBWZwY2hw');

@$core.Deprecated('Use optionChainDescriptor instead')
const OptionChain$json = {
  '1': 'OptionChain',
  '2': [
    {
      '1': 'options',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.OptionData',
      '10': 'options'
    },
  ],
};

/// Descriptor for `OptionChain`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List optionChainDescriptor = $convert.base64Decode(
    'CgtPcHRpb25DaGFpbhIlCgdvcHRpb25zGAEgAygLMgsuT3B0aW9uRGF0YVIHb3B0aW9ucw==');
