import 'package:flutter/material.dart';
import '../../../../shared/models/broker_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class BrokerEditDialog extends StatefulWidget {
  final Broker broker;

  const BrokerEditDialog({
    super.key,
    required this.broker,
  });

  @override
  State<BrokerEditDialog> createState() => _BrokerEditDialogState();
}

class _BrokerEditDialogState extends State<BrokerEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userIdController;
  late TextEditingController _passwordController;
  late TextEditingController _vendorCodeController;
  late TextEditingController _apiKeyController;
  late TextEditingController _secretKeyController;
  late TextEditingController _twoFAKeyController;
  late TextEditingController _imeiController;
  late TextEditingController _niftyController;
  late TextEditingController _sensexController;
  late TextEditingController _stocksController;
  late TextEditingController _bankniftyController;
  
  bool _isActive = true;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _userIdController = TextEditingController(text: widget.broker.brokerInfo.userId);
    _passwordController = TextEditingController(text: widget.broker.brokerInfo.password);
    _vendorCodeController = TextEditingController(text: widget.broker.brokerInfo.vendorCode);
    _apiKeyController = TextEditingController(text: widget.broker.brokerInfo.apiKey);
    _secretKeyController = TextEditingController(text: widget.broker.brokerInfo.secretKey);
    _twoFAKeyController = TextEditingController(text: widget.broker.brokerInfo.twoFAKey);
    _imeiController = TextEditingController(text: widget.broker.brokerInfo.imei);
    _niftyController = TextEditingController(text: widget.broker.preferences.quantity.nifty.toString());
    _sensexController = TextEditingController(text: widget.broker.preferences.quantity.sensex.toString());
    _stocksController = TextEditingController(text: widget.broker.preferences.quantity.stocks.toString());
    _bankniftyController = TextEditingController(text: widget.broker.preferences.quantity.banknifty.toString());
    
    _isActive = widget.broker.isActive;
    _isDefault = widget.broker.preferences.defaultBroker;
  }

  @override
  void dispose() {
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
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.edit,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Edit ${widget.broker.brokerName}',
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: AppTypography.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Broker Information'),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _userIdController,
                        decoration: const InputDecoration(
                          labelText: 'User ID',
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
                          labelText: 'Vendor Code',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('API Credentials'),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _apiKeyController,
                        decoration: const InputDecoration(
                          labelText: 'API Key',
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
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _twoFAKeyController,
                        decoration: const InputDecoration(
                          labelText: '2FA Key',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _imeiController,
                        decoration: const InputDecoration(
                          labelText: 'IMEI',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Trading Preferences'),
                      const SizedBox(height: 16),
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
                      _buildSectionTitle('Settings'),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Active'),
                        subtitle: const Text('Enable this broker for trading'),
                        value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      SwitchListTile(
                        title: const Text('Default Broker'),
                        subtitle: const Text('Set as default broker'),
                        value: _isDefault,
                        onChanged: (value) {
                          setState(() {
                            _isDefault = value;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveBroker,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.titleMedium.copyWith(
        fontWeight: AppTypography.semiBold,
        color: AppColors.primary,
      ),
    );
  }

  void _saveBroker() {
    if (_formKey.currentState!.validate()) {
      final updatedBroker = Broker(
        id: widget.broker.id,
        userId: widget.broker.userId,
        brokerInfo: BrokerInfo(
          userId: _userIdController.text,
          password: _passwordController.text,
          vendorCode: _vendorCodeController.text,
          apiKey: _apiKeyController.text,
          secretKey: _secretKeyController.text,
          twoFAKey: _twoFAKeyController.text,
          imei: _imeiController.text,
        ),
        isActive: _isActive,
        brokerName: widget.broker.brokerName,
        preferences: BrokerPreferences(
          quantity: BrokerQuantity(
            nifty: int.tryParse(_niftyController.text) ?? widget.broker.preferences.quantity.nifty,
            sensex: int.tryParse(_sensexController.text) ?? widget.broker.preferences.quantity.sensex,
            stocks: int.tryParse(_stocksController.text) ?? widget.broker.preferences.quantity.stocks,
            banknifty: int.tryParse(_bankniftyController.text) ?? widget.broker.preferences.quantity.banknifty,
          ),
          brokerName: widget.broker.preferences.brokerName,
          displayName: widget.broker.preferences.displayName,
          defaultBroker: _isDefault,
        ),
        createdAt: widget.broker.createdAt,
        updatedAt: widget.broker.updatedAt,
      );

      Navigator.of(context).pop(updatedBroker);
    }
  }
}
