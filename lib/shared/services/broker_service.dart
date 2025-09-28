import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/constants/app_constants.dart';
import '../models/trade_models.dart';
import 'storage_service.dart';

/// Service for handling broker master data (similar to MasterDataService for indices)
class BrokerService {
  static BrokerService? _instance;
  
  /// Get the current service instance
  static BrokerService get instance {
    _instance ??= BrokerService._();
    return _instance!;
  }

  BrokerService._();

  static String get _baseUrl => AppConstants.baseUrl;
  static const Duration _timeout = AppConstants.defaultTimeout;
  static const String _brokerStorageKey = 'broker_master_data';

  /// Cache for broker data
  List<Broker>? _cachedBrokers;
  DateTime? _lastFetchTime;
  static const Duration _cacheExpiry = Duration(hours: 24); // Broker data changes less frequently

  /// Get cached brokers if available and not expired
  List<Broker>? get cachedBrokers {
    if (_cachedBrokers == null || _lastFetchTime == null) {
      return null;
    }
    
    if (DateTime.now().difference(_lastFetchTime!) > _cacheExpiry) {
      _cachedBrokers = null;
      _lastFetchTime = null;
      return null;
    }
    
    return _cachedBrokers;
  }

  /// Fetch brokers from API and store in local storage
  Future<List<Broker>> fetchBrokers({bool forceRefresh = false}) async {
    // Return cached data if available and not forcing refresh
    if (!forceRefresh) {
      final cached = cachedBrokers;
      if (cached != null) {
        return cached;
      }
    }

    // Try to load from local storage first
    if (!forceRefresh) {
      final storedBrokers = await _loadBrokersFromStorage();
      if (storedBrokers != null) {
        _cachedBrokers = storedBrokers;
        _lastFetchTime = DateTime.now();
        return storedBrokers;
      }
    }

    try {
      // Get auth token
      final token = await StorageService.getString(AppConstants.authTokenKey);
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Build URL for broker master
      final uri = Uri.parse('$_baseUrl${AppConstants.brokerMasterEndpoint}');

      print('Fetching broker master from: $uri');

      // Make API request
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(_timeout);

      print('Broker master API response status: ${response.statusCode}');
      print('Broker master API response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final brokerResponse = BrokerMasterResponse.fromJson(jsonData);
        
        // Cache the data
        _cachedBrokers = brokerResponse.data;
        _lastFetchTime = DateTime.now();
        
        // Store in local storage
        await _saveBrokersToStorage(brokerResponse.data);
        
        return brokerResponse.data;
      } else {
        throw Exception('Failed to fetch broker master: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching broker master: $e');
      // Return mock data if API fails
      return _getMockBrokers();
    }
  }

  /// Get broker names for dropdown (with "All Brokers" as first option)
  Future<List<String>> getBrokerNames({bool forceRefresh = false}) async {
    try {
      final brokers = await fetchBrokers(forceRefresh: forceRefresh);
      final brokerNames = brokers
          .where((broker) => broker.isActive)
          .map((broker) => broker.name)
          .toList();
      return ['All Brokers', ...brokerNames];
    } catch (e) {
      print('Error fetching broker names: $e');
      // Return default list on error
      return ['All Brokers', 'FINVASIA', 'ANGELONE', 'ZERODHA', 'DHAN', 'FYERS'];
    }
  }

  /// Get broker names synchronously from cached data
  List<String> getBrokerNamesSync() {
    final cached = cachedBrokers;
    if (cached == null) {
      return ['All Brokers', 'FINVASIA', 'ANGELONE', 'ZERODHA', 'DHAN', 'FYERS'];
    }
    
    final brokerNames = cached
        .where((broker) => broker.isActive)
        .map((broker) => broker.name)
        .toList();
    return ['All Brokers', ...brokerNames];
  }

  /// Get active brokers only
  Future<List<Broker>> getActiveBrokers({bool forceRefresh = false}) async {
    final brokers = await fetchBrokers(forceRefresh: forceRefresh);
    return brokers.where((broker) => broker.isActive).toList();
  }

  /// Get broker by name
  Broker? getBrokerByName(String name) {
    final cached = cachedBrokers;
    if (cached == null) return null;
    
    try {
      return cached.firstWhere((broker) => broker.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Get broker by ID
  Broker? getBrokerById(int id) {
    final cached = cachedBrokers;
    if (cached == null) return null;
    
    try {
      return cached.firstWhere((broker) => broker.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Clear cached broker data
  void clearCache() {
    _cachedBrokers = null;
    _lastFetchTime = null;
  }

  /// Initialize broker data (call after login)
  Future<void> initializeBrokerData() async {
    try {
      print('Initializing broker data after login...');
      await fetchBrokers(forceRefresh: true);
      print('Broker data initialized successfully');
    } catch (e) {
      print('Failed to initialize broker data: $e');
      // Don't throw error to avoid blocking login flow
    }
  }

  /// Save brokers to local storage
  Future<void> _saveBrokersToStorage(List<Broker> brokers) async {
    try {
      final brokersJson = brokers.map((broker) => broker.toJson()).toList();
      await StorageService.setString(_brokerStorageKey, json.encode(brokersJson));
      print('Brokers saved to local storage');
    } catch (e) {
      print('Error saving brokers to storage: $e');
    }
  }

  /// Load brokers from local storage
  Future<List<Broker>?> _loadBrokersFromStorage() async {
    try {
      final brokersString = await StorageService.getString(_brokerStorageKey);
      if (brokersString == null) return null;

      final brokersJson = json.decode(brokersString) as List<dynamic>;
      final brokers = brokersJson.map((json) => Broker.fromJson(json as Map<String, dynamic>)).toList();
      print('Brokers loaded from local storage: ${brokers.length} brokers');
      return brokers;
    } catch (e) {
      print('Error loading brokers from storage: $e');
      return null;
    }
  }

  /// Mock data for development/fallback
  List<Broker> _getMockBrokers() {
    return [
      const Broker(
        id: 6,
        name: 'FINVASIA',
        isActive: true,
        createdAt: '2025-09-26T11:10:35.000Z',
        updatedAt: '2025-09-26T11:10:35.000Z',
      ),
      const Broker(
        id: 7,
        name: 'ANGELONE',
        isActive: true,
        createdAt: '2025-09-26T11:10:35.000Z',
        updatedAt: '2025-09-26T11:10:35.000Z',
      ),
      const Broker(
        id: 8,
        name: 'ZERODHA',
        isActive: true,
        createdAt: '2025-09-26T11:10:35.000Z',
        updatedAt: '2025-09-26T11:10:35.000Z',
      ),
      const Broker(
        id: 9,
        name: 'DHAN',
        isActive: true,
        createdAt: '2025-09-26T11:10:35.000Z',
        updatedAt: '2025-09-26T11:10:35.000Z',
      ),
      const Broker(
        id: 10,
        name: 'FYERS',
        isActive: true,
        createdAt: '2025-09-26T11:10:35.000Z',
        updatedAt: '2025-09-26T11:10:35.000Z',
      ),
    ];
  }
}
