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
        print('Tags JSON data: $jsonData');
        
        final tagsResponse = TagsResponse.fromJson(jsonData);
        print('Tags parsed successfully. Count: ${tagsResponse.data.length}');
        
        // Extract group names from tags and add "All Groups" option
        final groupNames = ['All Groups'] + tagsResponse.data.map((tag) => tag.name).toList();
        print('Final group names: $groupNames');
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

  /// Get available tags for management
  static Future<List<Tag>> getAvailableTags() async {
    try {
      // Get auth token
      final token = await StorageService.getString(AppConstants.authTokenKey);
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Build URL for tags
      final uri = Uri.parse('$_baseUrl${AppConstants.tagsEndpoint}');

      print('Fetching available tags from: $uri');

      // Make API request
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(_timeout);

      print('Available tags API response status: ${response.statusCode}');
      print('Available tags API response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final tagsResponse = TagsResponse.fromJson(jsonData);
        return tagsResponse.data;
      } else {
        throw Exception('Failed to fetch tags: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching available tags: $e');
      rethrow;
    }
  }

  /// Create a new tag
  static Future<Tag> createTag({
    required String name,
    required bool applyToTrade,
    required String tradeId,
  }) async {
    try {
      // Get auth token
      final token = await StorageService.getString(AppConstants.authTokenKey);
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Build URL for creating tags
      final uri = Uri.parse('$_baseUrl${AppConstants.tagsEndpoint}');

      print('Creating tag: $name');

      // Prepare request body
      final requestBody = {
        'name': name,
        'applyToTrade': applyToTrade,
        'tradeId': tradeId,
      };

      // Make API request
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      ).timeout(_timeout);

      print('Create tag API response status: ${response.statusCode}');
      print('Create tag API response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return Tag.fromJson(jsonData['data'] ?? jsonData);
      } else {
        throw Exception('Failed to create tag: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error creating tag: $e');
      rethrow;
    }
  }

  /// Apply tag to trade (all orders in the trade)
  static Future<void> applyTagToTrade({
    required int tagId,
    required String tradeId,
  }) async {
    try {
      // Get auth token
      final token = await StorageService.getString(AppConstants.authTokenKey);
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Build URL for applying tag to trade
      final uri = Uri.parse('$_baseUrl/trades/$tradeId/tags');

      print('Applying tag $tagId to trade: $tradeId');

      // Prepare request body
      final requestBody = {
        'tagId': tagId,
      };

      // Make API request
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      ).timeout(_timeout);

      print('Apply tag to trade API response status: ${response.statusCode}');
      print('Apply tag to trade API response body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to apply tag to trade: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error applying tag to trade: $e');
      rethrow;
    }
  }

  /// Apply tag to individual order
  static Future<void> applyTagToOrder({
    required int tagId,
    required int orderId,
  }) async {
    try {
      // Get auth token
      final token = await StorageService.getString(AppConstants.authTokenKey);
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Build URL for applying tag to order
      final uri = Uri.parse('$_baseUrl/orders/$orderId/tags');

      print('Applying tag $tagId to order: $orderId');

      // Prepare request body
      final requestBody = {
        'tagId': tagId,
      };

      // Make API request
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      ).timeout(_timeout);

      print('Apply tag to order API response status: ${response.statusCode}');
      print('Apply tag to order API response body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to apply tag to order: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error applying tag to order: $e');
      rethrow;
    }
  }
}
