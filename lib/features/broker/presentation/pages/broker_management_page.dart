import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/broker_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/broker_providers.dart';
import 'broker_integration_wizard.dart';
import 'broker_edit_dialog.dart';

class BrokerManagementPage extends ConsumerStatefulWidget {
  const BrokerManagementPage({super.key});

  @override
  ConsumerState<BrokerManagementPage> createState() => _BrokerManagementPageState();
}

class _BrokerManagementPageState extends ConsumerState<BrokerManagementPage> {
  @override
  Widget build(BuildContext context) {
    final brokersAsync = ref.watch(brokersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Broker Management'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(brokersProvider.notifier).loadBrokers();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: brokersAsync.when(
              data: (brokers) => _buildBrokersList(brokers),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => _buildErrorWidget(error),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewBroker,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Broker'),
      ),
    );
  }

  Widget _buildHeader() {
    final brokersAsync = ref.watch(brokersProvider);
    final defaultBroker = ref.watch(defaultBrokerProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance,
                color: AppColors.primary,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Broker Management',
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: AppTypography.bold,
                        color: AppColors.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      brokersAsync.when(
                        data: (brokers) => '${brokers.length} broker${brokers.length != 1 ? 's' : ''} configured',
                        loading: () => 'Loading...',
                        error: (_, __) => 'Error loading brokers',
                      ),
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.onPrimaryContainer.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (defaultBroker != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Default: ${defaultBroker.brokerName}',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: AppTypography.medium,
                      color: AppColors.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBrokersList(List<Broker> brokers) {
    if (brokers.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: brokers.length,
      itemBuilder: (context, index) {
        final broker = brokers[index];
        return _buildBrokerCard(broker);
      },
    );
  }

  Widget _buildBrokerCard(Broker broker) {
    // Debug logging
    print('Building broker card: ID=${broker.id}, Name=${broker.brokerName}, Default=${broker.preferences.defaultBroker}');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            broker.brokerName,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: AppTypography.semiBold,
                            ),
                          ),
                          if (broker.preferences.defaultBroker) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'DEFAULT',
                                style: AppTypography.labelSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: AppTypography.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'User ID: ${broker.brokerInfo.userId}',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleBrokerAction(value, broker),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    if (!broker.preferences.defaultBroker)
                      const PopupMenuItem(
                        value: 'set_default',
                        child: Row(
                          children: [
                            Icon(Icons.star),
                            SizedBox(width: 8),
                            Text('Set as Default'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  child: const Icon(Icons.more_vert),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildBrokerStatus(broker),
            const SizedBox(height: 12),
            _buildQuantityInfo(broker.preferences.quantity),
          ],
        ),
      ),
    );
  }

  Widget _buildBrokerStatus(Broker broker) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: broker.isActive ? AppColors.success : AppColors.error,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          broker.isActive ? 'Active' : 'Inactive',
          style: AppTypography.bodyMedium.copyWith(
            color: broker.isActive ? AppColors.success : AppColors.error,
            fontWeight: AppTypography.medium,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityInfo(BrokerQuantity quantity) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildQuantityChip('NIFTY', quantity.nifty),
        _buildQuantityChip('SENSEX', quantity.sensex),
        _buildQuantityChip('Stocks', quantity.stocks),
        _buildQuantityChip('BANKNIFTY', quantity.banknifty),
      ],
    );
  }

  Widget _buildQuantityChip(String label, int quantity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label: $quantity',
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_outlined,
              size: 64,
              color: AppColors.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Brokers Configured',
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: AppTypography.bold,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first broker to start trading',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _addNewBroker,
              icon: const Icon(Icons.add),
              label: const Text('Add Broker'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading Brokers',
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: AppTypography.bold,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(brokersProvider.notifier).loadBrokers();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewBroker() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BrokerIntegrationWizard(),
      ),
    ).then((_) {
      // Refresh brokers list when returning from wizard
      ref.read(brokersProvider.notifier).loadBrokers();
    });
  }

  void _handleBrokerAction(String action, Broker broker) async {
    print('=== _handleBrokerAction CALLED ===');
    print('Action: $action, Broker: ${broker.brokerName} (ID: ${broker.id})');
    
    switch (action) {
      case 'edit':
        print('Calling _editBroker...');
        await _editBroker(broker);
        break;
      case 'set_default':
        print('Calling _setDefaultBroker...');
        await _setDefaultBroker(broker);
        break;
      case 'delete':
        print('Calling _deleteBroker...');
        await _deleteBroker(broker);
        break;
      default:
        print('Unknown action: $action');
    }
  }

  Future<void> _editBroker(Broker broker) async {
    final result = await showDialog<Broker>(
      context: context,
      builder: (context) => BrokerEditDialog(broker: broker),
    );

    if (result != null && broker.id != null) {
      try {
        await ref.read(brokersProvider.notifier).updateBroker(broker.id!, result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Broker updated successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating broker: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _setDefaultBroker(Broker broker) async {
    print('=== _setDefaultBroker UI METHOD CALLED ===');
    print('Broker ID: ${broker.id}, Name: ${broker.brokerName}');
    
    if (broker.id == null) return;

    try {
      print('Calling setDefaultBroker provider method...');
      await ref.read(brokersProvider.notifier).setDefaultBroker(broker.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${broker.brokerName} set as default broker'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error setting default broker: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _deleteBroker(Broker broker) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Broker'),
        content: Text('Are you sure you want to delete ${broker.brokerName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && broker.id != null) {
      try {
        await ref.read(brokersProvider.notifier).deleteBroker(broker.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${broker.brokerName} deleted successfully'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting broker: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}
