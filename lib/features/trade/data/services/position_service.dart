import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/position_model.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/services/user_config_service.dart';
import '../../../../shared/services/auth_service.dart';
import '../../../../shared/services/storage_service.dart';
import '../../../../core/constants/app_constants.dart';

class PositionService {
  static final UserConfigService _userConfig = UserConfigService();

  /// Fetch positions from the live API
  static Future<List<PositionModel>> fetchPositions({String? brokerName}) async {
    try {
      // Get actual user ID from auth service
      final currentUser = AuthService.instance.currentUser;
      final userId = currentUser?.id ?? '31'; // Fallback for testing
      
      // Get broker name from parameter or default broker from preferences
      String selectedBroker = brokerName ?? 'FINVASIA';
      
      // Try to get default broker from user preferences
      if (brokerName == null) {
        final brokerPrefsData = StorageService.getString(AppConstants.brokerPreferencesKey);
        if (brokerPrefsData != null) {
          try {
            final brokerPrefs = jsonDecode(brokerPrefsData) as List;
            final defaultBroker = brokerPrefs.firstWhere(
              (broker) => broker['default'] == true,
              orElse: () => brokerPrefs.first,
            );
            selectedBroker = defaultBroker['brokerName'] ?? 'FINVASIA';
          } catch (e) {
            print('Error parsing broker preferences: $e');
          }
        }
      }
      
      final url = Uri.parse(ApiConfig.getPositionsUrl(
        userId: userId,
        brokerName: selectedBroker,
      ));
      
      print('Fetching positions from: $url');
      print('User ID: $userId, Broker: $selectedBroker');
      
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
      final quantity = netQuantity.abs();

      // Extract prices with updated fallbacks
      final avgPrice = _parseDouble(json['netAvgPrice'] ?? json['avgPrice'] ?? json['averagePrice'] ?? json['entryPrice'] ?? 0);
      final ltp = _parseDouble(json['ltp'] ?? json['lastTradedPrice'] ?? json['currentPrice'] ?? 0);

      // Extract PNL with typo fallbacks
      final realisedPnl = _parseDouble(json['realiasedPNL'] ?? json['realisedPNL'] ?? json['realizedPnl'] ?? 0);
      final unrealisedPnl = _parseDouble(json['unrealiasedMTM'] ?? json['unrealisedMTM'] ?? json['unrealizedPnl'] ?? json['unrealizedMTM'] ?? 0);

      // Use appropriate PNL based on whether position is open or closed
      double pnl = netQuantity == 0 ? realisedPnl : unrealisedPnl;

      // Fallback calculation if PNL is zero
      if (pnl == 0 && avgPrice > 0 && ltp > 0 && quantity > 0) {
        pnl = isLong 
            ? (ltp - avgPrice) * quantity
            : (avgPrice - ltp) * quantity;
      }

      final pnlPercent = (avgPrice > 0 && quantity > 0) 
          ? (pnl / (avgPrice * quantity)) * 100 
          : 0.0;

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

      // New fields
      final dayBuyAvgPrice = _parseDouble(json['dayBuyAvgPrice'] ?? 0);
      final daySellAvgPrice = _parseDouble(json['daySellAvgPrice'] ?? 0);

      // Parse dates
      final createdAt = _parseDateTime(json['createdAt'] ?? json['entryTime'] ?? json['timestamp']);
      final exitedAt = _parseNullableDateTime(json['exitedAt'] ?? json['exitTime']);

      final position = PositionModel(
        id: json['id']?.toString() ?? json['positionId']?.toString() ?? '',
        symbol: symbol,
        quantity: quantity.toInt(),
        avgPrice: avgPrice,
        ltp: ltp,
        pnl: pnl,
        pnlPercent: pnlPercent,
        isLong: isLong,
        instrument: instrument,
        createdAt: createdAt,
        exitedAt: exitedAt,
        dayBuyAvgPrice: dayBuyAvgPrice,
        daySellAvgPrice: daySellAvgPrice,
        realisedPnl: realisedPnl,
        unrealisedMtm: unrealisedPnl,
      );
      
      print('Parsed position: $symbol - dayBuy: $dayBuyAvgPrice, daySell: $daySellAvgPrice, realised: $realisedPnl, unrealised: $unrealisedPnl');
      return position;
    } catch (e) {
      print('Error parsing position: $e - JSON: $json');
      return PositionModel(
        id: '',
        symbol: json['tradingSymbol'] ?? 'UNKNOWN',
        quantity: 0,
        avgPrice: 0,
        ltp: 0,
        pnl: 0,
        pnlPercent: 0,
        isLong: true,
        instrument: 'EQ',
        createdAt: DateTime.now(),
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

  /// Helper to parse nullable DateTime (returns null if value is missing/invalid)
  static DateTime? _parseNullableDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
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
        isLong: true,
        quantity: 50,
        avgPrice: 19500.0,
        ltp: 19650.0,
        pnl: 7500.0,
        pnlPercent: 0.77,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      PositionModel(
        id: '2',
        symbol: 'BANKNIFTY',
        instrument: 'INDEX',
        isLong: false,
        quantity: 25,
        avgPrice: 44500.0,
        ltp: 44300.0,
        pnl: 5000.0,
        pnlPercent: 0.45,
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
      PositionModel(
        id: '3',
        symbol: 'RELIANCE',
        instrument: 'EQ',
        isLong: true,
        quantity: 10,
        avgPrice: 2450.0,
        ltp: 2420.0,
        pnl: -300.0,
        pnlPercent: -1.22,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      PositionModel(
        id: '4',
        symbol: 'TCS',
        instrument: 'EQ',
        isLong: true,
        quantity: 5,
        avgPrice: 3200.0,
        ltp: 3250.0,
        pnl: 250.0,
        pnlPercent: 1.56,
        createdAt: now.subtract(const Duration(days: 2)),
        exitedAt: now.subtract(const Duration(hours: 1)),
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
