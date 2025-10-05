import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/broker_models.dart';
import '../../../../shared/services/broker_service.dart';

/// Provider for brokers list
final brokersProvider = StateNotifierProvider<BrokersNotifier, AsyncValue<List<Broker>>>((ref) {
  return BrokersNotifier();
});

/// Provider for broker integration state
final brokerIntegrationProvider = StateNotifierProvider<BrokerIntegrationNotifier, BrokerIntegrationState>((ref) {
  return BrokerIntegrationNotifier();
});

/// Provider for current default broker
final defaultBrokerProvider = Provider<Broker?>((ref) {
  final brokersAsync = ref.watch(brokersProvider);
  return brokersAsync.when(
    data: (brokers) => brokers.where((broker) => broker.preferences.defaultBroker).firstOrNull,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Brokers state notifier
class BrokersNotifier extends StateNotifier<AsyncValue<List<Broker>>> {
  BrokersNotifier() : super(const AsyncValue.loading()) {
    loadBrokers();
  }

  Future<void> loadBrokers() async {
    try {
      state = const AsyncValue.loading();
      final brokers = await BrokerService.getBrokers();
      state = AsyncValue.data(brokers.data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addBroker(Broker broker) async {
    try {
      final newBroker = await BrokerService.addBroker(broker);
      state.whenData((brokers) {
        state = AsyncValue.data([...brokers, newBroker]);
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateBroker(int brokerId, Broker broker) async {
    try {
      print('Provider: Updating broker $brokerId');
      final updatedBroker = await BrokerService.updateBroker(brokerId, broker);
      print('Provider: Received updated broker from API: ${updatedBroker.preferences.quantity.nifty}');
      
      // Force a complete refresh by reloading all brokers from API
      await loadBrokers();
      print('Provider: Complete refresh completed');
    } catch (error, stackTrace) {
      print('Provider: Error updating broker: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteBroker(int brokerId) async {
    try {
      await BrokerService.deleteBroker(brokerId);
      
      // Update the state by removing the deleted broker
      state = state.whenData((brokers) {
        return brokers.where((b) => b.id != brokerId).toList();
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> setDefaultBroker(int brokerId) async {
    try {
      state.whenData((brokers) async {
        // Update all brokers to set defaultBroker to false
        final updatedBrokers = brokers.map((broker) {
          final updatedPreferences = BrokerPreferences(
            quantity: broker.preferences.quantity,
            brokerName: broker.preferences.brokerName,
            displayName: broker.preferences.displayName,
            defaultBroker: broker.id == brokerId,
          );
          return Broker(
            id: broker.id,
            userId: broker.userId,
            brokerInfo: broker.brokerInfo,
            isActive: broker.isActive,
            brokerName: broker.brokerName,
            preferences: updatedPreferences,
            createdAt: broker.createdAt,
            updatedAt: broker.updatedAt,
          );
        }).toList();

        // Update each broker
        for (final broker in updatedBrokers) {
          if (broker.id != null) {
            await BrokerService.updateBroker(broker.id!, broker);
          }
        }

        state = AsyncValue.data(updatedBrokers);
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Broker integration state notifier
class BrokerIntegrationNotifier extends StateNotifier<BrokerIntegrationState> {
  BrokerIntegrationNotifier() : super(const BrokerIntegrationState());

  void reset() {
    state = const BrokerIntegrationState();
  }

  void setCurrentStep(BrokerIntegrationStep step) {
    state = state.copyWith(currentStep: step);
  }

  void setSelectedBrokerName(String brokerName) {
    state = state.copyWith(selectedBrokerName: brokerName);
  }

  void setBrokerInfo(BrokerInfo brokerInfo) {
    state = state.copyWith(brokerInfo: brokerInfo);
  }

  void setPreferences(BrokerPreferences preferences) {
    state = state.copyWith(preferences: preferences);
  }

  void setIsDefault(bool isDefault) {
    state = state.copyWith(isDefault: isDefault);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void setTestingConnection(bool isTesting) {
    state = state.copyWith(isTestingConnection: isTesting);
  }

  void nextStep() {
    final steps = BrokerIntegrationStep.values;
    final currentIndex = steps.indexOf(state.currentStep);
    if (currentIndex < steps.length - 1) {
      state = state.copyWith(currentStep: steps[currentIndex + 1]);
    }
  }

  void previousStep() {
    final steps = BrokerIntegrationStep.values;
    final currentIndex = steps.indexOf(state.currentStep);
    if (currentIndex > 0) {
      state = state.copyWith(currentStep: steps[currentIndex - 1]);
    }
  }

  Future<bool> testConnection() async {
    if (state.brokerInfo == null) return false;
    
    setTestingConnection(true);
    setError(null);
    
    try {
      final broker = Broker(
        brokerInfo: state.brokerInfo!,
        isActive: true,
        brokerName: state.selectedBrokerName ?? '',
        preferences: state.preferences ?? BrokerPreferences(
          quantity: const BrokerQuantity(nifty: 150, sensex: 60, stocks: 10, banknifty: 70),
          brokerName: state.selectedBrokerName ?? '',
          displayName: '${state.selectedBrokerName}[User]',
          defaultBroker: false,
        ),
      );
      
      final success = await BrokerService.testBrokerConnection(broker);
      
      if (success) {
        setCurrentStep(BrokerIntegrationStep.completed);
      } else {
        setError('Connection test failed. Please check your credentials.');
      }
      
      return success;
    } catch (e) {
      setError('Connection test failed: $e');
      return false;
    } finally {
      setTestingConnection(false);
    }
  }
}
