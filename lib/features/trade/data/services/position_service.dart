import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/position_model.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/services/user_config_service.dart';

class PositionService {
  static final UserConfigService _userConfig = UserConfigService();

  /// Fetch positions from the live API
  static Future<List<PositionModel>> fetchPositions() async {
    try {
      final url = Uri.parse(ApiConfig.getPositionsUrl(
        userId: _userConfig.userId,
        brokerName: _userConfig.brokerName,
      ));
      
      print('Fetching positions from: $url');
      
      final response = await http.get(
        url,
        headers: ApiConfig.defaultHeaders,
      ).timeout(ApiConfig.requestTimeout);

      print('API Response Status: ${response.statusCode}');
      print('API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        
        // Handle different response formats
        List<dynamic> jsonData;
        if (responseData is List) {
          jsonData = responseData;
        } else if (responseData is Map && responseData.containsKey('data')) {
          jsonData = responseData['data'] as List<dynamic>;
        } else if (responseData is Map && responseData.containsKey('positions')) {
          jsonData = responseData['positions'] as List<dynamic>;
        } else {
          print('Unexpected response format: $responseData');
          return [];
        }
        
        final positions = jsonData.map((json) => _parsePositionFromApi(json)).toList();
        print('Successfully parsed ${positions.length} positions');
        return positions;
      } else {
        print('Error fetching positions: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Exception fetching positions: $e');
      return [];
    }
  }

  /// Parse API response to PositionModel
  static PositionModel _parsePositionFromApi(Map<String, dynamic> json) {
    try {
      // Extract net quantity to determine position type
      final netQuantity = _parseDouble(json['netQuantity'] ?? json['quantity'] ?? 0);
      final isLong = netQuantity > 0;
      
      // Extract prices with fallback field names
      final avgPrice = _parseDouble(json['avgPrice'] ?? json['averagePrice'] ?? json['entryPrice'] ?? 0);
      final ltp = _parseDouble(json['ltp'] ?? json['lastTradedPrice'] ?? json['currentPrice'] ?? 0);
      final quantity = netQuantity.abs();
      
      // Calculate P&L if not provided
      double pnl = _parseDouble(json['pnl'] ?? json['profitLoss'] ?? json['unrealizedPnl'] ?? 0);
      if (pnl == 0 && avgPrice > 0 && ltp > 0) {
        pnl = isLong 
            ? (ltp - avgPrice) * quantity
            : (avgPrice - ltp) * quantity;
      }
      
      final pnlPercent = avgPrice != 0 ? (pnl / (avgPrice * quantity)) * 100 : 0.0;

      // Extract symbol with fallback field names
      final symbol = json['tradingSymbol'] ?? 
                    json['symbol'] ?? 
                    json['instrumentToken'] ?? 
                    json['name'] ?? 
                    'UNKNOWN';

      // Extract instrument type
      final instrument = json['instrument'] ?? 
                        json['instrumentType'] ?? 
                        json['product'] ?? 
                        'EQ';

      // Parse dates
      final createdAt = _parseDateTime(json['createdAt'] ?? json['entryTime'] ?? json['timestamp']);
      final exitedAt = _parseDateTime(json['exitedAt'] ?? json['exitTime']);

      return PositionModel(
        id: json['id']?.toString() ?? json['positionId']?.toString() ?? '',
        symbol: symbol,
        instrument: instrument,
        type: isLong ? PositionType.long : PositionType.short,
        quantity: quantity.toInt(),
        avgPrice: avgPrice,
        ltp: ltp,
        pnl: pnl,
        pnlPercent: pnlPercent,
        createdAt: createdAt,
        exitedAt: exitedAt,
        status: _parsePositionStatus(json['status'], netQuantity.toInt()),
      );
    } catch (e) {
      print('Error parsing position: $e');
      print('JSON data: $json');
      // Return a default position to prevent app crash
      return PositionModel(
        id: 'error_${DateTime.now().millisecondsSinceEpoch}',
        symbol: 'ERROR',
        instrument: 'EQ',
        type: PositionType.long,
        quantity: 0,
        avgPrice: 0.0,
        ltp: 0.0,
        pnl: 0.0,
        pnlPercent: 0.0,
        createdAt: DateTime.now(),
        status: PositionStatus.open,
      );
    }
  }

  /// Helper method to parse double values safely
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  /// Helper method to parse DateTime values safely
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  /// Parse position status from API response
  static PositionStatus _parsePositionStatus(String? status, int netQuantity) {
    if (netQuantity == 0) {
      return PositionStatus.closed;
    }
    
    switch (status?.toLowerCase()) {
      case 'open':
        return PositionStatus.open;
      case 'closed':
        return PositionStatus.closed;
      case 'partial':
        return PositionStatus.partial;
      default:
        return PositionStatus.open;
    }
  }

  /// Mock data for development/testing
  static List<PositionModel> getMockPositions() {
    final now = DateTime.now();
    return [
      PositionModel(
        id: '1',
        symbol: 'NIFTY',
        instrument: 'INDEX',
        type: PositionType.long,
        quantity: 50,
        avgPrice: 19500.0,
        ltp: 19650.0,
        pnl: 7500.0,
        pnlPercent: 0.77,
        createdAt: now.subtract(const Duration(hours: 2)),
        status: PositionStatus.open,
      ),
      PositionModel(
        id: '2',
        symbol: 'BANKNIFTY',
        instrument: 'INDEX',
        type: PositionType.short,
        quantity: 25,
        avgPrice: 44500.0,
        ltp: 44300.0,
        pnl: 5000.0,
        pnlPercent: 0.45,
        createdAt: now.subtract(const Duration(hours: 1)),
        status: PositionStatus.open,
      ),
      PositionModel(
        id: '3',
        symbol: 'RELIANCE',
        instrument: 'EQ',
        type: PositionType.long,
        quantity: 10,
        avgPrice: 2450.0,
        ltp: 2420.0,
        pnl: -300.0,
        pnlPercent: -1.22,
        createdAt: now.subtract(const Duration(days: 1)),
        status: PositionStatus.open,
      ),
      PositionModel(
        id: '4',
        symbol: 'TCS',
        instrument: 'EQ',
        type: PositionType.long,
        quantity: 5,
        avgPrice: 3200.0,
        ltp: 3250.0,
        pnl: 250.0,
        pnlPercent: 1.56,
        createdAt: now.subtract(const Duration(days: 2)),
        exitedAt: now.subtract(const Duration(hours: 1)),
        status: PositionStatus.closed,
      ),
    ];
  }

  /// Mock orders for development/testing
  static List<OrderModel> getMockOrders() {
    final now = DateTime.now();
    return [
      OrderModel(
        id: '1',
        symbol: 'NIFTY',
        instrument: 'INDEX',
        orderType: OrderType.limit,
        side: OrderSide.buy,
        quantity: 50,
        filledQuantity: 50,
        price: 19500.0,
        status: OrderStatus.complete,
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2, minutes: 5)),
      ),
      OrderModel(
        id: '2',
        symbol: 'BANKNIFTY',
        instrument: 'INDEX',
        orderType: OrderType.market,
        side: OrderSide.sell,
        quantity: 25,
        filledQuantity: 25,
        price: null,
        status: OrderStatus.complete,
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(hours: 1, minutes: 2)),
      ),
      OrderModel(
        id: '3',
        symbol: 'RELIANCE',
        instrument: 'EQ',
        orderType: OrderType.limit,
        side: OrderSide.buy,
        quantity: 10,
        filledQuantity: 0,
        price: 2400.0,
        status: OrderStatus.pending,
        createdAt: now.subtract(const Duration(minutes: 30)),
      ),
      OrderModel(
        id: '4',
        symbol: 'TCS',
        instrument: 'EQ',
        orderType: OrderType.stopLoss,
        side: OrderSide.sell,
        quantity: 5,
        filledQuantity: 5,
        price: 3200.0,
        triggerPrice: 3150.0,
        status: OrderStatus.complete,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
      OrderModel(
        id: '5',
        symbol: 'INFY',
        instrument: 'EQ',
        orderType: OrderType.limit,
        side: OrderSide.buy,
        quantity: 20,
        filledQuantity: 0,
        price: 1500.0,
        status: OrderStatus.rejected,
        rejectionReason: 'Insufficient funds',
        createdAt: now.subtract(const Duration(minutes: 15)),
      ),
    ];
  }
}
