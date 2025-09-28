import '../constants/app_constants.dart';
import '../../shared/services/api_service.dart';

class ApiConfig {
  // API Endpoints
  static const String positionsEndpoint = '/trade/positions';
  static const String ordersEndpoint = '/trade/orders';
  static const String marketDataEndpoint = '/market/data';
  static const String indicesEndpoint = '/trade/indices';
  
  // API Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Request Timeout
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Helper methods
  static String getPositionsUrl({String? userId, String? brokerName, bool useTestUrl = true}) {
    final baseUrl = useTestUrl ? AppConstants.devBaseUrl : AppConstants.prodBaseUrl;
    final uid = userId ?? '31'; // Fallback for testing
    final broker = brokerName ?? 'FINVASIA'; // Fallback for testing
    return '$baseUrl$positionsEndpoint?userId=$uid&brokerName=$broker';
  }
  
  static String getOrdersUrl({String? userId, String? brokerName, bool useTestUrl = true}) {
    final baseUrl = useTestUrl ? AppConstants.devBaseUrl : AppConstants.prodBaseUrl;
    final uid = userId ?? '31'; // Fallback for testing
    final broker = brokerName ?? 'FINVASIA'; // Fallback for testing
    return '$baseUrl$ordersEndpoint?userId=$uid&brokerName=$broker';
  }
  
  static String getMarketDataUrl(String symbol, {bool useTestUrl = true}) {
    final baseUrl = useTestUrl ? AppConstants.devBaseUrl : AppConstants.prodBaseUrl;
    return '$baseUrl$marketDataEndpoint?symbol=$symbol';
  }
  
  static String getIndicesUrl({bool useTestUrl = true}) {
    final baseUrl = useTestUrl ? AppConstants.devBaseUrl : AppConstants.prodBaseUrl;
    return '$baseUrl$indicesEndpoint';
  }
}
