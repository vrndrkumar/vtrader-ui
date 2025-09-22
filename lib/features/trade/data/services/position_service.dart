import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/position_model.dart';

class PositionService {
  static const String _baseUrl = 'https://apivtrader.a.pinggy.link';
  static const String _userId = '31';
  static const String _brokerName = 'FINVASIA';

  /// Fetch positions from the live API
  static Future<List<PositionModel>> fetchPositions() async {
    try {
      final url = Uri.parse('$_baseUrl/trade/positions?userId=$_userId&brokerName=$_brokerName');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => _parsePositionFromApi(json)).toList();
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
    // Extract net quantity to determine position type
    final netQuantity = json['netQuantity'] ?? 0;
    final isLong = netQuantity > 0;
    
    // Calculate P&L if not provided
    final avgPrice = (json['avgPrice'] ?? 0.0).toDouble();
    final ltp = (json['ltp'] ?? 0.0).toDouble();
    final quantity = (json['netQuantity'] ?? 0).abs();
    
    final pnl = isLong 
        ? (ltp - avgPrice) * quantity
        : (avgPrice - ltp) * quantity;
    
    final pnlPercent = avgPrice != 0 ? (pnl / (avgPrice * quantity)) * 100 : 0.0;

    return PositionModel(
      id: json['id']?.toString() ?? '',
      symbol: json['tradingSymbol'] ?? json['symbol'] ?? '',
      instrument: json['instrument'] ?? 'EQ',
      type: isLong ? PositionType.long : PositionType.short,
      quantity: quantity,
      avgPrice: avgPrice,
      ltp: ltp,
      pnl: pnl,
      pnlPercent: pnlPercent,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      exitedAt: json['exitedAt'] != null ? DateTime.tryParse(json['exitedAt']) : null,
      status: _parsePositionStatus(json['status'], netQuantity),
    );
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
