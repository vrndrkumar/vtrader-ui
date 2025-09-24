import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/services/storage_service.dart';
import '../../shared/models/api_models.dart';

/// Broker selection service for managing broker switching
class BrokerSelectionService extends StateNotifier<String?> {
  BrokerSelectionService() : super(null) {
    _loadDefaultBroker();
  }

  /// Load the default broker from user preferences
  void _loadDefaultBroker() {
    final brokerPrefsData = StorageService.getString(AppConstants.brokerPreferencesKey);
    if (brokerPrefsData != null) {
      try {
        final brokerPrefs = jsonDecode(brokerPrefsData) as List;
        final defaultBroker = brokerPrefs.firstWhere(
          (broker) => broker['default'] == true,
          orElse: () => brokerPrefs.first,
        );
        state = defaultBroker['brokerName'] ?? 'FINVASIA';
      } catch (e) {
        print('Error loading default broker: $e');
        state = 'FINVASIA'; // Fallback
      }
    } else {
      state = 'FINVASIA'; // Fallback
    }
  }

  /// Get all available brokers from user preferences
  List<BrokerPreferences> getAvailableBrokers() {
    final brokerPrefsData = StorageService.getString(AppConstants.brokerPreferencesKey);
    if (brokerPrefsData != null) {
      try {
        final brokerPrefs = jsonDecode(brokerPrefsData) as List;
        return brokerPrefs.map((json) => BrokerPreferences.fromJson(json)).toList();
      } catch (e) {
        print('Error parsing broker preferences: $e');
      }
    }
    return [];
  }

  /// Switch to a different broker
  void switchBroker(String brokerName) {
    state = brokerName;
  }

  /// Get current selected broker
  String? get currentBroker => state;

  /// Get broker display name
  String getCurrentBrokerDisplayName() {
    final brokers = getAvailableBrokers();
    final current = state;
    if (current != null) {
      try {
        final broker = brokers.firstWhere((b) => b.brokerName == current);
        return broker.displayName;
      } catch (e) {
        return current;
      }
    }
    return 'FINVASIA';
  }
}

/// Provider for broker selection service
final brokerSelectionProvider = StateNotifierProvider<BrokerSelectionService, String?>(
  (ref) => BrokerSelectionService(),
);
