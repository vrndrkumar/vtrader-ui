import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/index_model.dart';
import '../services/master_data_service.dart';

/// Provider for master data service
final masterDataServiceProvider = Provider<MasterDataService>((ref) {
  return MasterDataService.instance;
});

/// Provider for indices data
final indicesProvider = FutureProvider<List<IndexModel>>((ref) async {
  final service = ref.read(masterDataServiceProvider);
  return await service.fetchIndices();
});

/// Provider for selected index
final selectedIndexProvider = StateProvider<IndexModel?>((ref) {
  return null;
});

/// Provider for selected expiry
final selectedExpiryProvider = StateProvider<String?>((ref) {
  return null;
});

/// Provider to get available expiries for selected index
final availableExpiriesProvider = Provider<List<String>>((ref) {
  final selectedIndex = ref.watch(selectedIndexProvider);
  if (selectedIndex == null) return [];
  
  return selectedIndex.formattedExpiryDates;
});

/// Provider to get index by symbol code
final indexBySymbolCodeProvider = Provider.family<IndexModel?, String>((ref, symbolCode) {
  final indicesAsync = ref.watch(indicesProvider);
  return indicesAsync.when(
    data: (indices) {
      try {
        return indices.firstWhere((index) => index.symbolCode == symbolCode);
      } catch (e) {
        return null;
      }
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Provider to refresh indices data
final refreshIndicesProvider = Provider<void Function()>((ref) {
  return () {
    ref.invalidate(indicesProvider);
  };
});

/// Provider for master data state (loading, error, data)
final masterDataStateProvider = Provider<MasterDataState>((ref) {
  final indicesAsync = ref.watch(indicesProvider);
  
  return indicesAsync.when(
    data: (indices) => MasterDataState(
      isLoading: false,
      error: null,
      indices: indices,
    ),
    loading: () => MasterDataState(
      isLoading: true,
      error: null,
      indices: [],
    ),
    error: (error, stackTrace) => MasterDataState(
      isLoading: false,
      error: error.toString(),
      indices: [],
    ),
  );
});

/// State class for master data
class MasterDataState {
  final bool isLoading;
  final String? error;
  final List<IndexModel> indices;

  const MasterDataState({
    required this.isLoading,
    required this.error,
    required this.indices,
  });

  bool get hasError => error != null;
  bool get hasData => indices.isNotEmpty;
  bool get isEmpty => indices.isEmpty && !isLoading && !hasError;
}
