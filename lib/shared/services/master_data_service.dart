import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/index_model.dart';
import '../../core/config/api_config.dart';

/// Service for fetching and managing master data
class MasterDataService {
  static MasterDataService? _instance;
  
  /// Get the current service instance
  static MasterDataService get instance {
    _instance ??= MasterDataService._();
    return _instance!;
  }

  MasterDataService._();

  /// Cache for indices data
  List<IndexModel>? _cachedIndices;
  DateTime? _lastFetchTime;
  static const Duration _cacheExpiry = Duration(minutes: 30);

  /// Get cached indices if available and not expired
  List<IndexModel>? get cachedIndices {
    if (_cachedIndices == null || _lastFetchTime == null) {
      return null;
    }
    
    if (DateTime.now().difference(_lastFetchTime!) > _cacheExpiry) {
      _cachedIndices = null;
      _lastFetchTime = null;
      return null;
    }
    
    return _cachedIndices;
  }

  /// Fetch indices from API
  Future<List<IndexModel>> fetchIndices({bool forceRefresh = false}) async {
    // Return cached data if available and not forcing refresh
    if (!forceRefresh) {
      final cached = cachedIndices;
      if (cached != null) {
        return cached;
      }
    }

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.getIndicesUrl(useTestUrl: true)), // Use test URL for now
        headers: ApiConfig.defaultHeaders,
      ).timeout(ApiConfig.requestTimeout);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final masterDataResponse = MasterDataResponse.fromJson(jsonData);
        
        // Cache the data
        _cachedIndices = masterDataResponse.indices;
        _lastFetchTime = DateTime.now();
        
        return masterDataResponse.indices;
      } else {
        throw Exception('Failed to fetch indices: ${response.statusCode}');
      }
    } catch (e) {
      // If API fails, return mock data for development
      print('API Error: $e');
      return _getMockIndices();
    }
  }

  /// Get index by symbol code
  IndexModel? getIndexBySymbolCode(String symbolCode) {
    final indices = cachedIndices;
    if (indices == null) return null;
    
    try {
      return indices.firstWhere((index) => index.symbolCode == symbolCode);
    } catch (e) {
      return null;
    }
  }

  /// Get index by ID
  IndexModel? getIndexById(int id) {
    final indices = cachedIndices;
    if (indices == null) return null;
    
    try {
      return indices.firstWhere((index) => index.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Clear cache
  void clearCache() {
    _cachedIndices = null;
    _lastFetchTime = null;
  }

  /// Mock data for development/fallback
  List<IndexModel> _getMockIndices() {
    return [
      IndexModel(
        id: 5,
        exchange: 'NSE',
        symbolCode: 'NIFTY',
        symbolName: 'Nifty 50',
        tokenId: 26000,
        lot: 75,
        strikeDifference: 50,
        expiryDays: '23SEP25,30SEP25',
        createdAt: DateTime.parse('2023-01-21T13:22:39.000Z'),
        updatedAt: DateTime.parse('2023-01-21T13:22:39.000Z'),
      ),
      IndexModel(
        id: 6,
        exchange: 'NSE',
        symbolCode: 'BANKNIFTY',
        symbolName: 'Nifty Bank',
        tokenId: 26009,
        lot: 35,
        strikeDifference: 100,
        expiryDays: '30SEP25',
        createdAt: DateTime.parse('2023-01-21T07:52:39.000Z'),
        updatedAt: DateTime.parse('2023-01-21T07:52:39.000Z'),
      ),
      IndexModel(
        id: 8,
        exchange: 'NSE',
        symbolCode: 'FINNIFTY',
        symbolName: 'Nifty Fin Service',
        tokenId: 26037,
        lot: 25,
        strikeDifference: 50,
        expiryDays: '30SEP25',
        createdAt: DateTime.parse('2023-01-21T07:52:39.000Z'),
        updatedAt: DateTime.parse('2023-01-21T07:52:39.000Z'),
      ),
      IndexModel(
        id: 9,
        exchange: 'BSE',
        symbolCode: 'BANKEX',
        symbolName: 'BANKEX',
        tokenId: 12,
        lot: 15,
        strikeDifference: 100,
        expiryDays: '25SEP25',
        createdAt: DateTime.parse('2023-01-21T07:52:39.000Z'),
        updatedAt: DateTime.parse('2023-01-21T07:52:39.000Z'),
      ),
      IndexModel(
        id: 10,
        exchange: 'BSE',
        symbolCode: 'SENSEX',
        symbolName: 'SENSEX',
        tokenId: 1,
        lot: 20,
        strikeDifference: 100,
        expiryDays: '25SEP25',
        createdAt: DateTime.parse('2023-01-21T07:52:39.000Z'),
        updatedAt: DateTime.parse('2023-01-21T07:52:39.000Z'),
      ),
    ];
  }
}
