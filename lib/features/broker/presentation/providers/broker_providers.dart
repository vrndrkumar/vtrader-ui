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
      rethrow; // Re-throw to let the UI handle the error
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
      rethrow; // Re-throw to let the UI handle the error
    }
  }

  Future<void> setDefaultBroker(int brokerId) async {
    try {
      print('=== SET DEFAULT BROKER START ===');
      print('User clicked: Set broker $brokerId as default');
      
      // Get all brokers
      final allBrokers = state.value ?? [];
      print('Total brokers: ${allBrokers.length}');
      
      // Step 1: Find if any broker currently has default = true
      Broker? currentDefaultBroker;
      for (final broker in allBrokers) {
        print('Checking Broker ${broker.id} (${broker.brokerName}): default = ${broker.preferences.defaultBroker}');
        if (broker.preferences.defaultBroker == true) {
          currentDefaultBroker = broker;
          print('Found current default broker: ID ${broker.id}');
          break;
        }
      }
      
      // Step 2: If a default broker exists, disable it first
      if (currentDefaultBroker != null && currentDefaultBroker.id != brokerId) {
        print('Step 1: Disabling current default broker ${currentDefaultBroker.id}...');
        
        // Create broker object with default = false
        final disabledBroker = Broker(
          id: currentDefaultBroker.id,
          userId: currentDefaultBroker.userId,
          brokerInfo: currentDefaultBroker.brokerInfo,
          isActive: currentDefaultBroker.isActive,
          brokerName: currentDefaultBroker.brokerName,
          preferences: BrokerPreferences(
            quantity: currentDefaultBroker.preferences.quantity,
            brokerName: currentDefaultBroker.preferences.brokerName,
            displayName: currentDefaultBroker.preferences.displayName,
            defaultBroker: false, // Set to FALSE
          ),
          createdAt: currentDefaultBroker.createdAt,
          updatedAt: currentDefaultBroker.updatedAt,
        );
        
        // Call UPDATE API for current default broker with default = false
        print('Calling UPDATE API: PUT /broker/${currentDefaultBroker.id} with default=false');
        await BrokerService.updateBroker(currentDefaultBroker.id!, disabledBroker);
        print('✓ Successfully disabled broker ${currentDefaultBroker.id}');
      } else if (currentDefaultBroker != null && currentDefaultBroker.id == brokerId) {
        print('Broker $brokerId is already default. No action needed.');
        return;
      } else {
        print('No default broker exists. Will set broker $brokerId directly.');
      }
      
      // Step 3: Now set the requested broker to default = true
      print('Step 2: Setting broker $brokerId as default...');
      
      // Find the target broker
      final targetBroker = allBrokers.firstWhere((b) => b.id == brokerId);
      
      // Create broker object with default = true
      final enabledBroker = Broker(
        id: targetBroker.id,
        userId: targetBroker.userId,
        brokerInfo: targetBroker.brokerInfo,
        isActive: targetBroker.isActive,
        brokerName: targetBroker.brokerName,
        preferences: BrokerPreferences(
          quantity: targetBroker.preferences.quantity,
          brokerName: targetBroker.preferences.brokerName,
          displayName: targetBroker.preferences.displayName,
          defaultBroker: true, // Set to TRUE
        ),
        createdAt: targetBroker.createdAt,
        updatedAt: targetBroker.updatedAt,
      );
      
      // Call UPDATE API for requested broker with default = true
      print('Calling UPDATE API: PUT /broker/$brokerId with default=true');
      await BrokerService.updateBroker(brokerId, enabledBroker);
      print('✓ Successfully enabled broker $brokerId as default');
      
      // Step 4: Refresh broker list
      print('Step 3: Refreshing broker list...');
      await loadBrokers();
      
      print('=== SET DEFAULT BROKER COMPLETE ===');
      
    } catch (error, stackTrace) {
      print('ERROR in setDefaultBroker: $error');
      state = AsyncValue.error(error, stackTrace);
      rethrow;
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
