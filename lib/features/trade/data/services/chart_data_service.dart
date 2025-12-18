import 'package:intl/intl.dart';
import '../../../../shared/services/api_service.dart';
import '../../domain/models/option_chain_model.dart';

/// Service for fetching chart candle data
class ChartDataService {
  static ChartDataService? _instance;
  final ApiService _apiService = ApiService.instance;

  static ChartDataService get instance {
    _instance ??= ChartDataService._();
    return _instance!;
  }

  ChartDataService._();

  /// Fetch candle data for a symbol
  Future<List<CandleData>> fetchCandleData({
    required String symbol,
    required int frequency, // in minutes
    String userId = '32', // Hardcoded for chart
    String brokerName = 'FYERS', // Hardcoded for chart
    int dateFormat = 1, // Hardcoded
  }) async {
    try {
      // Calculate date range based on frequency
      final dates = _calculateDateRange(frequency);
      
      final queryParams = {
        'userId': userId,
        'brokerName': brokerName,
        'symbol': symbol,
        'from': dates['from']!,
        'to': dates['to']!,
        'frequency': frequency.toString(),
        'dateFormat': dateFormat.toString(),
      };

      print('📊 Fetching candle data: $queryParams');

      final response = await _apiService.get<Map<String, dynamic>>(
        '/data/candle',
        queryParams: queryParams,
      );

      if (response.success && response.data != null) {
        return _parseCandleData(response.data!);
      } else {
        print('❌ Failed to fetch candle data: ${response.errorMessage}');
        return [];
      }
    } catch (e) {
      print('❌ Error fetching candle data: $e');
      return [];
    }
  }

  /// Calculate date range based on frequency
  Map<String, String> _calculateDateRange(int frequency) {
    final now = DateTime.now();
    final toDate = now;
    DateTime fromDate;

    // Calculate days based on frequency
    // More days for intraday to ensure enough data points
    int days;
    if (frequency == 1) {
      days = 5; // 1 min -> 5 days
    } else if (frequency <= 5) {
      days = 10; // 5 min -> 10 days
    } else if (frequency <= 15) {
      days = 20; // 10-15 min -> 20 days
    } else if (frequency <= 60) {
      days = 30; // 30 min - 1 hour -> 30 days
    } else {
      days = 90; // Daily/Weekly -> 90 days
    }
    
    fromDate = now.subtract(Duration(days: days));

    final formatter = DateFormat('yyyy-MM-dd');
    
    print('📅 Date range: ${formatter.format(fromDate)} to ${formatter.format(toDate)} ($days days for ${frequency}min frequency)');
    
    return {
      'from': formatter.format(fromDate),
      'to': formatter.format(toDate),
    };
  }

  /// Parse candle data from API response
  List<CandleData> _parseCandleData(Map<String, dynamic> data) {
    try {
      final List<dynamic>? candles = data['candles'] ?? data['data'] ?? data['result'];
      
      if (candles == null) {
        print('⚠️ No candles array found in response');
        return [];
      }

      final parsedCandles = <CandleData>[];
      
      for (var candle in candles) {
        try {
          CandleData candleData;
          
          // Handle both array and object formats
          if (candle is List) {
            // Array format: [timestamp, open, high, low, close, volume]
            final timestamp = candle[0] is int ? candle[0] : int.parse(candle[0].toString());
            candleData = CandleData(
              time: DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),
              open: (candle[1] as num).toDouble(),
              high: (candle[2] as num).toDouble(),
              low: (candle[3] as num).toDouble(),
              close: (candle[4] as num).toDouble(),
              volume: candle.length > 5 ? (candle[5] as num).toInt() : 0,
            );
          } else if (candle is Map) {
            // Object format: {timestamp, open, high, low, close, volume}
            final timestamp = candle['timestamp'] ?? candle['time'] ?? candle['t'];
            candleData = CandleData(
              time: DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),
              open: (candle['open'] ?? candle['o'] as num).toDouble(),
              high: (candle['high'] ?? candle['h'] as num).toDouble(),
              low: (candle['low'] ?? candle['l'] as num).toDouble(),
              close: (candle['close'] ?? candle['c'] as num).toDouble(),
              volume: (candle['volume'] ?? candle['v'] ?? 0 as num).toInt(),
            );
          } else {
            continue; // Skip unknown formats
          }
          
          parsedCandles.add(candleData);
        } catch (e) {
          print('⚠️ Skipping invalid candle: $e');
        }
      }
      
      // Sort by time in ascending order (oldest to newest)
      parsedCandles.sort((a, b) => a.time.compareTo(b.time));
      
      // Candles parsed and sorted
      return parsedCandles;
    } catch (e) {
      print('❌ Error parsing candle data: $e');
      return [];
    }
  }

  /// Update last candle with real-time data
  CandleData updateLastCandle(CandleData lastCandle, double currentPrice) {
    return CandleData(
      time: lastCandle.time,
      open: lastCandle.open,
      high: currentPrice > lastCandle.high ? currentPrice : lastCandle.high,
      low: currentPrice < lastCandle.low ? currentPrice : lastCandle.low,
      close: currentPrice,
      volume: lastCandle.volume,
    );
  }
}

