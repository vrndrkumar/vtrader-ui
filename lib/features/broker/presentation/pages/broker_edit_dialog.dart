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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 768;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: isMobile ? screenWidth * 0.95 : screenWidth * 0.7,
        height: isMobile ? screenHeight * 0.9 : screenHeight * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 20 : 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAccountSection(),
                      const SizedBox(height: 32),
                      _buildCredentialsSection(),
                      const SizedBox(height: 32),
                      _buildPreferencesSection(isMobile),
                      const SizedBox(height: 32),
                      _buildSettingsSection(),
                    ],
                  ),
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.account_balance,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit ${widget.broker.brokerName}',
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: AppTypography.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Update broker configuration and preferences',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return _buildSection(
      title: 'Account Details',
      icon: Icons.person,
      children: [
        _buildModernTextField(
          controller: _userIdController,
          label: 'User ID',
          icon: Icons.badge,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'User ID is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildModernTextField(
          controller: _passwordController,
          label: 'Password',
          icon: Icons.lock,
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildModernTextField(
          controller: _vendorCodeController,
          label: 'Vendor Code',
          icon: Icons.code,
          hintText: 'Optional vendor code',
        ),
      ],
    );
  }

  Widget _buildCredentialsSection() {
    return _buildSection(
      title: 'API Credentials',
      icon: Icons.security,
      children: [
        _buildModernTextField(
          controller: _apiKeyController,
          label: 'API Key',
          icon: Icons.vpn_key,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'API Key is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildModernTextField(
          controller: _secretKeyController,
          label: 'Secret Key',
          icon: Icons.key,
          obscureText: true,
          hintText: 'Optional secret key',
        ),
        const SizedBox(height: 16),
        _buildModernTextField(
          controller: _twoFAKeyController,
          label: '2FA Key',
          icon: Icons.security,
          hintText: 'Two-factor authentication key',
        ),
        const SizedBox(height: 16),
        _buildModernTextField(
          controller: _imeiController,
          label: 'IMEI',
          icon: Icons.phone_android,
          hintText: 'Device IMEI number',
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(bool isMobile) {
    return _buildSection(
      title: 'Trading Preferences',
      icon: Icons.trending_up,
      children: [
        if (isMobile) ...[
          _buildModernTextField(
            controller: _niftyController,
            label: 'NIFTY Quantity',
            icon: Icons.show_chart,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildModernTextField(
            controller: _sensexController,
            label: 'SENSEX Quantity',
            icon: Icons.show_chart,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildModernTextField(
            controller: _stocksController,
            label: 'Stocks Quantity',
            icon: Icons.show_chart,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildModernTextField(
            controller: _bankniftyController,
            label: 'BANKNIFTY Quantity',
            icon: Icons.show_chart,
            keyboardType: TextInputType.number,
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: _buildModernTextField(
                  controller: _niftyController,
                  label: 'NIFTY Quantity',
                  icon: Icons.show_chart,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildModernTextField(
                  controller: _sensexController,
                  label: 'SENSEX Quantity',
                  icon: Icons.show_chart,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildModernTextField(
                  controller: _stocksController,
                  label: 'Stocks Quantity',
                  icon: Icons.show_chart,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildModernTextField(
                  controller: _bankniftyController,
                  label: 'BANKNIFTY Quantity',
                  icon: Icons.show_chart,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSettingsSection() {
    return _buildSection(
      title: 'Settings',
      icon: Icons.settings,
      children: [
        _buildModernSwitchTile(
          title: 'Active',
          subtitle: 'Enable this broker for trading',
          value: _isActive,
          icon: Icons.power_settings_new,
          onChanged: (value) => setState(() => _isActive = value),
        ),
        const SizedBox(height: 16),
        _buildModernSwitchTile(
          title: 'Default Broker',
          subtitle: 'Set as default broker',
          value: _isDefault,
          icon: Icons.star,
          onChanged: (value) => setState(() => _isDefault = value),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: AppTypography.semiBold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hintText,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: AppTypography.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildModernSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: AppTypography.medium,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
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
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text('Save Changes'),
            ),
          ),
        ],
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
