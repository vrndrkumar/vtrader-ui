import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import 'storage_service.dart';

/// API service for handling HTTP requests to the backend
class ApiService {
  static ApiService? _instance;
  
  /// Get the current API service instance
  static ApiService get instance {
    _instance ??= ApiService._();
    return _instance!;
  }

  ApiService._();

  /// Base URL for API requests
  String get baseUrl {
    // Use environment variable or default to production
    const String? env = String.fromEnvironment('API_BASE_URL');
    if (env != null && env.isNotEmpty) {
      return env;
    }
    
    // Default to production URL
    return 'https://apivtrader.a.pinggy.link';
  }

  /// Test URL for development
  String get testBaseUrl => 'http://localhost:3001';

  /// Get headers for API requests
  Map<String, String> get _headers {
    final token = StorageService.getString(AppConstants.authTokenKey);
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Make a POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? additionalHeaders,
    bool useTestUrl = false,
  }) async {
    try {
      final url = Uri.parse('${useTestUrl ? testBaseUrl : baseUrl}$endpoint');
      final headers = {..._headers, ...?additionalHeaders};
      
      final response = await http.post(
        url,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(AppConstants.defaultTimeout);

      return _handleResponse<T>(response);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } on HttpException catch (e) {
      return ApiResponse.error('HTTP error: ${e.message}');
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// Make a GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    Map<String, String>? additionalHeaders,
    bool useTestUrl = false,
  }) async {
    try {
      final uri = Uri.parse('${useTestUrl ? testBaseUrl : baseUrl}$endpoint');
      final url = queryParams != null 
          ? uri.replace(queryParameters: queryParams)
          : uri;
      
      final headers = {..._headers, ...?additionalHeaders};
      
      final response = await http.get(
        url,
        headers: headers,
      ).timeout(AppConstants.defaultTimeout);

      return _handleResponse<T>(response);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } on HttpException catch (e) {
      return ApiResponse.error('HTTP error: ${e.message}');
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// Make a PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? additionalHeaders,
    bool useTestUrl = false,
  }) async {
    try {
      final url = Uri.parse('${useTestUrl ? testBaseUrl : baseUrl}$endpoint');
      final headers = {..._headers, ...?additionalHeaders};
      
      final response = await http.put(
        url,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(AppConstants.defaultTimeout);

      return _handleResponse<T>(response);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } on HttpException catch (e) {
      return ApiResponse.error('HTTP error: ${e.message}');
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// Make a DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, String>? additionalHeaders,
    bool useTestUrl = false,
  }) async {
    try {
      final url = Uri.parse('${useTestUrl ? testBaseUrl : baseUrl}$endpoint');
      final headers = {..._headers, ...?additionalHeaders};
      
      final response = await http.delete(
        url,
        headers: headers,
      ).timeout(AppConstants.defaultTimeout);

      return _handleResponse<T>(response);
    } on SocketException {
      return ApiResponse.error('No internet connection');
    } on HttpException catch (e) {
      return ApiResponse.error('HTTP error: ${e.message}');
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// Handle HTTP response
  ApiResponse<T> _handleResponse<T>(http.Response response) {
    try {
      final Map<String, dynamic>? jsonData = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>?
          : null;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.success(
          data: jsonData as T?,
          statusCode: response.statusCode,
        );
      } else {
        // Handle error response
        final errorMessage = jsonData?['message'] ?? 
                           jsonData?['error'] ?? 
                           'Request failed with status ${response.statusCode}';
        return ApiResponse.error(
          errorMessage,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error(
        'Failed to parse response: $e',
        statusCode: response.statusCode,
      );
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated {
    final token = StorageService.getString(AppConstants.authTokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Clear authentication token
  Future<void> clearAuth() async {
    await StorageService.remove(AppConstants.authTokenKey);
  }
}

/// API response wrapper
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int? statusCode;

  const ApiResponse._({
    required this.success,
    this.data,
    this.error,
    this.statusCode,
  });

  factory ApiResponse.success({
    T? data,
    int? statusCode,
  }) {
    return ApiResponse._(
      success: true,
      data: data,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(
    String error, {
    int? statusCode,
  }) {
    return ApiResponse._(
      success: false,
      error: error,
      statusCode: statusCode,
    );
  }

  /// Check if response is successful
  bool get isSuccess => success;

  /// Check if response has error
  bool get hasError => !success;

  /// Get error message or empty string
  String get errorMessage => error ?? '';
}
