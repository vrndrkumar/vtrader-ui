import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/constants/app_constants.dart';
import '../models/trade_models.dart';
import 'broker_service.dart';
import 'storage_service.dart';

/// Service for handling trades API operations
class TradesService {
  static String get _baseUrl => AppConstants.baseUrl;
  static const Duration _timeout = AppConstants.defaultTimeout;

  /// Get trades with optional filters
  static Future<TradesResponse> getTrades({
    TradeFilters? filters,
  }) async {
    try {
      // Get auth token
      final token = await StorageService.getString(AppConstants.authTokenKey);
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Build URL with query parameters
      final uri = Uri.parse('$_baseUrl${AppConstants.tradesEndpoint}');
      final queryParams = filters?.toQueryParams() ?? <String, String>{};
      final finalUri = uri.replace(queryParameters: queryParams.isEmpty ? null : queryParams);

      print('Fetching trades from: $finalUri');

      // Make API request
      final response = await http.get(
        finalUri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(_timeout);

      print('Trades API response status: ${response.statusCode}');
      print('Trades API response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return TradesResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to fetch trades: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching trades: $e');
      rethrow;
    }
  }

  /// Get trade orders (for when user clicks on a specific trade)
  static Future<OrdersResponse> getTradeOrders(String tradeId) async {
    try {
      // Get auth token
      final token = await StorageService.getString(AppConstants.authTokenKey);
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Build URL for trade orders with query parameter
      final uri = Uri.parse('$_baseUrl/trades/orders?tradeId=$tradeId');

      print('Fetching trade orders from: $uri');

      // Make API request
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(_timeout);

      print('Trade orders API response status: ${response.statusCode}');
      print('Trade orders API response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return OrdersResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to fetch trade orders: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching trade orders: $e');
      rethrow;
    }
  }

  /// Get available group names for filtering
  static Future<List<String>> getGroupNames() async {
    try {
      // Get auth token
      final token = await StorageService.getString(AppConstants.authTokenKey);
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Build URL for tags/group names
      final uri = Uri.parse('$_baseUrl${AppConstants.tagsEndpoint}');

      print('Fetching group names from: $uri');

      // Make API request
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(_timeout);

      print('Tags API response status: ${response.statusCode}');
      print('Tags API response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final tagsResponse = TagsResponse.fromJson(jsonData);
        
        // Extract group names from tags and add "All Groups" option
        final groupNames = ['All Groups'] + tagsResponse.data.map((tag) => tag.name).toList();
        return groupNames;
      } else {
        // Return default list if endpoint doesn't exist
        return ['All Groups'];
      }
    } catch (e) {
      print('Error fetching group names: $e');
      // Return default list on error
      return ['All Groups'];
    }
  }

  /// Get available broker names for filtering
  static Future<List<String>> getBrokerNames() async {
    return await BrokerService.instance.getBrokerNames();
  }
}
