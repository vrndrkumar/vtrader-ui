import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'index_model.g.dart';

/// Index model representing market index data
@JsonSerializable()
class IndexModel extends Equatable {
  final int id;
  final String exchange;
  final String symbolCode;
  final String symbolName;
  final int tokenId;
  final int lot;
  final int strikeDifference;
  final String expiryDays;
  final DateTime createdAt;
  final DateTime updatedAt;

  const IndexModel({
    required this.id,
    required this.exchange,
    required this.symbolCode,
    required this.symbolName,
    required this.tokenId,
    required this.lot,
    required this.strikeDifference,
    required this.expiryDays,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get list of expiry dates as DateTime objects
  List<DateTime> get expiryDates {
    if (expiryDays.isEmpty) return [];
    
    return expiryDays.split(',').map((dateStr) {
      try {
        // Parse format like "23SEP25" to DateTime
        final day = int.parse(dateStr.substring(0, 2));
        final monthStr = dateStr.substring(2, 5);
        final year = 2000 + int.parse(dateStr.substring(5, 7));
        
        final monthMap = {
          'JAN': 1, 'FEB': 2, 'MAR': 3, 'APR': 4, 'MAY': 5, 'JUN': 6,
          'JUL': 7, 'AUG': 8, 'SEP': 9, 'OCT': 10, 'NOV': 11, 'DEC': 12,
        };
        
        final month = monthMap[monthStr] ?? 1;
        return DateTime(year, month, day);
      } catch (e) {
        return DateTime.now();
      }
    }).toList()..sort();
  }

  /// Get formatted expiry dates for display
  List<String> get formattedExpiryDates {
    return expiryDates.map((date) {
      return '${date.day.toString().padLeft(2, '0')}${_getMonthAbbr(date.month)}${date.year.toString().substring(2)}';
    }).toList();
  }

  String _getMonthAbbr(int month) {
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
                   'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return months[month - 1];
  }

  /// Factory constructor from JSON
  factory IndexModel.fromJson(Map<String, dynamic> json) =>
      _$IndexModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$IndexModelToJson(this);

  /// Create a copy with updated fields
  IndexModel copyWith({
    int? id,
    String? exchange,
    String? symbolCode,
    String? symbolName,
    int? tokenId,
    int? lot,
    int? strikeDifference,
    String? expiryDays,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return IndexModel(
      id: id ?? this.id,
      exchange: exchange ?? this.exchange,
      symbolCode: symbolCode ?? this.symbolCode,
      symbolName: symbolName ?? this.symbolName,
      tokenId: tokenId ?? this.tokenId,
      lot: lot ?? this.lot,
      strikeDifference: strikeDifference ?? this.strikeDifference,
      expiryDays: expiryDays ?? this.expiryDays,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        exchange,
        symbolCode,
        symbolName,
        tokenId,
        lot,
        strikeDifference,
        expiryDays,
        createdAt,
        updatedAt,
      ];
}

/// Master data response model
@JsonSerializable()
class MasterDataResponse extends Equatable {
  final List<IndexModel> indices;

  const MasterDataResponse({
    required this.indices,
  });

  /// Factory constructor from JSON
  factory MasterDataResponse.fromJson(Map<String, dynamic> json) =>
      _$MasterDataResponseFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$MasterDataResponseToJson(this);

  @override
  List<Object?> get props => [indices];
}
