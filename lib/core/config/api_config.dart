class ApiConfig {
  // Base API URL
  static const String baseUrl = 'https://apivtrader.a.pinggy.link';
  
  // API Endpoints
  static const String positionsEndpoint = '/trade/positions';
  static const String ordersEndpoint = '/trade/orders';
  static const String marketDataEndpoint = '/market/data';
  static const String indicesEndpoint = '/trade/indices';
  
  // Default User Configuration (Hardcoded for now)
  static const String defaultUserId = '31';
  static const String defaultBrokerName = 'FINVASIA';
  
  // API Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Request Timeout
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Helper methods
  static String getPositionsUrl({String? userId, String? brokerName}) {
    final uid = userId ?? defaultUserId;
    final broker = brokerName ?? defaultBrokerName;
    return '$baseUrl$positionsEndpoint?userId=$uid&brokerName=$broker';
  }
  
  static String getOrdersUrl({String? userId, String? brokerName}) {
    final uid = userId ?? defaultUserId;
    final broker = brokerName ?? defaultBrokerName;
    return '$baseUrl$ordersEndpoint?userId=$uid&brokerName=$broker';
  }
  
  static String getMarketDataUrl(String symbol) {
    return '$baseUrl$marketDataEndpoint?symbol=$symbol';
  }
  
  static String getIndicesUrl() {
    return '$baseUrl$indicesEndpoint';
  }
}
