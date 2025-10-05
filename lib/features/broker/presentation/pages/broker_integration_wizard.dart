import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/broker_models.dart';
import '../../../../shared/services/broker_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/broker_providers.dart';

class BrokerIntegrationWizard extends ConsumerStatefulWidget {
  const BrokerIntegrationWizard({super.key});

  @override
  ConsumerState<BrokerIntegrationWizard> createState() => _BrokerIntegrationWizardState();
}

class _BrokerIntegrationWizardState extends ConsumerState<BrokerIntegrationWizard> {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _vendorCodeController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _secretKeyController = TextEditingController();
  final _twoFAKeyController = TextEditingController();
  final _imeiController = TextEditingController();
  
  // Quantity controllers
  final _niftyController = TextEditingController(text: '150');
  final _sensexController = TextEditingController(text: '60');
  final _stocksController = TextEditingController(text: '10');
  final _bankniftyController = TextEditingController(text: '70');

  @override
  void dispose() {
    _pageController.dispose();
    _userIdController.dispose();
    _passwordController.dispose();
    _vendorCodeController.dispose();
    _apiKeyController.dispose();
    _secretKeyController.dispose();
    _twoFAKeyController.dispose();
    _imeiController.dispose();
    _niftyController.dispose();
    _sensexController.dispose();
    _stocksController.dispose();
    _bankniftyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final integrationState = ref.watch(brokerIntegrationProvider);
    final brokersAsync = ref.watch(brokersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Broker Integration'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildProgressIndicator(integrationState.currentStep),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildBrokerSelectionStep(),
                _buildBasicInfoStep(),
                _buildCredentialsStep(),
                _buildPreferencesStep(),
                _buildConfirmationStep(),
                _buildTestingStep(),
                _buildCompletedStep(),
              ],
            ),
          ),
          _buildNavigationButtons(integrationState),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BrokerIntegrationStep currentStep) {
    final steps = BrokerIntegrationStep.values;
    final currentIndex = steps.indexOf(currentStep);
    final progress = (currentIndex + 1) / steps.length;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.outline.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 12),
          Text(
            'Step ${currentIndex + 1} of ${steps.length}',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrokerSelectionStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Broker',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: AppTypography.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose the broker you want to integrate with',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: FutureBuilder<List<String>>(
              future: BrokerService.getAvailableBrokerNames(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                
                final brokerNames = snapshot.data ?? [];
                
                return ListView.builder(
                  itemCount: brokerNames.length,
                  itemBuilder: (context, index) {
                    final brokerName = brokerNames[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(brokerName),
                        subtitle: Text('Connect to $brokerName'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          ref.read(brokerIntegrationProvider.notifier)
                              .setSelectedBrokerName(brokerName);
                          _nextStep();
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: AppTypography.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your basic broker account details',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _userIdController,
                      decoration: const InputDecoration(
                        labelText: 'User ID',
                        hintText: 'Enter your broker user ID',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'User ID is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your broker password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _vendorCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Vendor Code (Optional)',
                        hintText: 'Enter vendor code if applicable',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCredentialsStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'API Credentials',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: AppTypography.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your API credentials for trading',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _apiKeyController,
                    decoration: const InputDecoration(
                      labelText: 'API Key',
                      hintText: 'Enter your API key',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'API Key is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _secretKeyController,
                    decoration: const InputDecoration(
                      labelText: 'Secret Key (Optional)',
                      hintText: 'Enter your secret key if required',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _twoFAKeyController,
                    decoration: const InputDecoration(
                      labelText: '2FA Key',
                      hintText: 'Enter your 2FA key',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _imeiController,
                    decoration: const InputDecoration(
                      labelText: 'IMEI',
                      hintText: 'Enter your device IMEI',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesStep() {
    final integrationState = ref.watch(brokerIntegrationProvider);
    final brokersAsync = ref.watch(brokersProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trading Preferences',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: AppTypography.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set your default trading quantities',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _niftyController,
                          decoration: const InputDecoration(
                            labelText: 'NIFTY Quantity',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _sensexController,
                          decoration: const InputDecoration(
                            labelText: 'SENSEX Quantity',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _stocksController,
                          decoration: const InputDecoration(
                            labelText: 'Stocks Quantity',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _bankniftyController,
                          decoration: const InputDecoration(
                            labelText: 'BANKNIFTY Quantity',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Default Broker',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: AppTypography.semiBold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            brokersAsync.when(
                              data: (brokers) => brokers.isEmpty 
                                  ? 'This will be your default broker (first broker)'
                                  : 'Make this your default broker?',
                              loading: () => 'Loading...',
                              error: (_, __) => 'Error loading brokers',
                            ),
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SwitchListTile(
                            title: const Text('Set as Default'),
                            value: integrationState.isDefault,
                            onChanged: (value) {
                              ref.read(brokerIntegrationProvider.notifier)
                                  .setIsDefault(value);
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationStep() {
    final integrationState = ref.watch(brokerIntegrationProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confirmation',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: AppTypography.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Review your broker integration details',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Broker', integrationState.selectedBrokerName ?? ''),
                      _buildInfoRow('User ID', _userIdController.text),
                      _buildInfoRow('API Key', _apiKeyController.text),
                      _buildInfoRow('NIFTY Quantity', _niftyController.text),
                      _buildInfoRow('SENSEX Quantity', _sensexController.text),
                      _buildInfoRow('Stocks Quantity', _stocksController.text),
                      _buildInfoRow('BANKNIFTY Quantity', _bankniftyController.text),
                      _buildInfoRow('Default Broker', integrationState.isDefault ? 'Yes' : 'No'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: AppTypography.medium,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestingStep() {
    final integrationState = ref.watch(brokerIntegrationProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (integrationState.isTestingConnection)
            const CircularProgressIndicator()
          else
            Icon(
              Icons.cloud_sync,
              size: 64,
              color: AppColors.primary,
            ),
          const SizedBox(height: 24),
          Text(
            integrationState.isTestingConnection 
                ? 'Testing Connection...'
                : 'Testing Broker Connection',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: AppTypography.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            integrationState.isTestingConnection
                ? 'Please wait while we verify your credentials'
                : 'We will test your broker connection to ensure everything is working correctly',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (integrationState.error != null) ...[
            const SizedBox(height: 16),
            Card(
              color: AppColors.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.error, color: AppColors.onErrorContainer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        integrationState.error!,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompletedStep() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            size: 64,
            color: AppColors.success,
          ),
          const SizedBox(height: 24),
          Text(
            'Integration Complete!',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: AppTypography.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your broker has been successfully integrated and is ready to use.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BrokerIntegrationState integrationState) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (integrationState.currentStep != BrokerIntegrationStep.brokerSelection)
            Expanded(
              child: OutlinedButton(
                onPressed: integrationState.isLoading ? null : _previousStep,
                child: const Text('Previous'),
              ),
            ),
          if (integrationState.currentStep != BrokerIntegrationStep.brokerSelection)
            const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: integrationState.isLoading ? null : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: integrationState.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_getNextButtonText(integrationState.currentStep)),
            ),
          ),
        ],
      ),
    );
  }

  String _getNextButtonText(BrokerIntegrationStep step) {
    switch (step) {
      case BrokerIntegrationStep.brokerSelection:
        return 'Next';
      case BrokerIntegrationStep.basicInfo:
        return 'Next';
      case BrokerIntegrationStep.credentials:
        return 'Next';
      case BrokerIntegrationStep.preferences:
        return 'Next';
      case BrokerIntegrationStep.confirmation:
        return 'Test Connection';
      case BrokerIntegrationStep.testing:
        return 'Complete';
      case BrokerIntegrationStep.completed:
        return 'Done';
    }
  }

  void _nextStep() async {
    final notifier = ref.read(brokerIntegrationProvider.notifier);
    final currentStep = ref.read(brokerIntegrationProvider).currentStep;

    switch (currentStep) {
      case BrokerIntegrationStep.basicInfo:
        if (_formKey.currentState!.validate()) {
          notifier.nextStep();
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        break;
      case BrokerIntegrationStep.confirmation:
        await _testConnection();
        break;
      case BrokerIntegrationStep.testing:
        await _completeIntegration();
        break;
      default:
        notifier.nextStep();
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
    }
  }

  void _previousStep() {
    ref.read(brokerIntegrationProvider.notifier).previousStep();
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _testConnection() async {
    final notifier = ref.read(brokerIntegrationProvider.notifier);
    
    // Create broker info from form data
    final brokerInfo = BrokerInfo(
      userId: _userIdController.text,
      password: _passwordController.text,
      vendorCode: _vendorCodeController.text,
      apiKey: _apiKeyController.text,
      secretKey: _secretKeyController.text,
      twoFAKey: _twoFAKeyController.text,
      imei: _imeiController.text,
    );
    
    notifier.setBrokerInfo(brokerInfo);
    
    // Create preferences
    final currentState = ref.read(brokerIntegrationProvider);
    final preferences = BrokerPreferences(
      quantity: BrokerQuantity(
        nifty: int.tryParse(_niftyController.text) ?? 150,
        sensex: int.tryParse(_sensexController.text) ?? 60,
        stocks: int.tryParse(_stocksController.text) ?? 10,
        banknifty: int.tryParse(_bankniftyController.text) ?? 70,
      ),
      brokerName: currentState.selectedBrokerName ?? '',
      displayName: '${currentState.selectedBrokerName}[${_userIdController.text}]',
      defaultBroker: currentState.isDefault,
    );
    
    notifier.setPreferences(preferences);
    notifier.nextStep();
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    
    // Test connection
    await notifier.testConnection();
  }

  Future<void> _completeIntegration() async {
    final notifier = ref.read(brokerIntegrationProvider.notifier);
    final integrationState = ref.read(brokerIntegrationProvider);
    
    notifier.setLoading(true);
    
    try {
      final broker = Broker(
        brokerInfo: integrationState.brokerInfo!,
        isActive: true,
        brokerName: integrationState.selectedBrokerName!,
        preferences: integrationState.preferences!,
      );
      
      await ref.read(brokersProvider.notifier).addBroker(broker);
      
      notifier.nextStep();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } catch (e) {
      notifier.setError('Failed to add broker: $e');
    } finally {
      notifier.setLoading(false);
    }
  }
}
