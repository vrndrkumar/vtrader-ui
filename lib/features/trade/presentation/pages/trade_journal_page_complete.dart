import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/models/trade_models.dart';
import '../../../../shared/services/trades_service.dart';
import '../../../../shared/widgets/app_button.dart';
import '../widgets/trade_card.dart';
import '../widgets/trade_details_dialog.dart';

/// Trade Journal Page with filters and responsive design
class TradeJournalPage extends ConsumerStatefulWidget {
  const TradeJournalPage({super.key});

  @override
  ConsumerState<TradeJournalPage> createState() => _TradeJournalPageState();
}

class _TradeJournalPageState extends ConsumerState<TradeJournalPage> {
  // State variables
  List<Trade> _trades = [];
  bool _isLoading = false;
  String? _error;
  
  // Filter state
  TradeFilters _filters = const TradeFilters();
  List<String> _availableGroups = [];
  List<String> _availableBrokers = [];
  
  // Controllers
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  String? _selectedGroup;
  String? _selectedBroker;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadTrades(),
      _loadFilterOptions(),
    ]);
  }

  Future<void> _loadTrades() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await TradesService.getTrades(filters: _filters);
      setState(() {
        _trades = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadFilterOptions() async {
    try {
      final results = await Future.wait([
        TradesService.getGroupNames(),
        TradesService.getBrokerNames(),
      ]);
      
      setState(() {
        _availableGroups = results[0];
        _availableBrokers = results[1];
      });
    } catch (e) {
      print('Error loading filter options: $e');
    }
  }

  void _applyFilters() {
    setState(() {
      _filters = TradeFilters(
        fromDate: _filters.fromDate,
        toDate: _filters.toDate,
        groupName: _selectedGroup,
        brokerName: _selectedBroker,
      );
    });
    _loadTrades();
  }

  void _clearFilters() {
    setState(() {
      _filters = const TradeFilters();
      _selectedGroup = null;
      _selectedBroker = null;
      _fromDateController.clear();
      _toDateController.clear();
    });
    _loadTrades();
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {
        if (isFromDate) {
          _fromDateController.text = formattedDate;
          _filters = _filters.copyWith(fromDate: picked);
        } else {
          _toDateController.text = formattedDate;
          _filters = _filters.copyWith(toDate: picked);
        }
      });
    }
  }

  void _showTradeDetails(Trade trade) {
    showDialog(
      context: context,
      builder: (context) => TradeDetailsDialog(trade: trade),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return Scaffold(
      body: Column(
        children: [
          // Header and Filters
          _buildHeader(context, isMobile),
          _buildFilters(context, isMobile),
          
          // Content
          Expanded(
            child: _buildContent(context, isMobile, isTablet),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trade Journal',
                  style: AppTypography.headlineMedium.copyWith(
                    fontWeight: AppTypography.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Track and analyze your trading performance',
                  style: AppTypography.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile) ...[
            const SizedBox(width: 16),
            _buildSummaryStats(),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryStats() {
    final totalTrades = _trades.length;
    final openTrades = _trades.where((t) => t.tradeStatus == TradeStatus.open).length;
    final totalPnl = _trades.fold<double>(0, (sum, trade) => sum + trade.pnlValue);
    final winRate = totalTrades > 0 
        ? (_trades.where((t) => t.isProfitable).length / totalTrades * 100)
        : 0.0;

    return Row(
      children: [
        _buildStatChip('Total', totalTrades.toString(), AppColors.primary),
        const SizedBox(width: 8),
        _buildStatChip('Open', openTrades.toString(), AppColors.warning),
        const SizedBox(width: 8),
        _buildStatChip(
          'P&L', 
          '₹${totalPnl.toStringAsFixed(0)}',
          totalPnl >= 0 ? AppColors.success : AppColors.error,
        ),
        const SizedBox(width: 8),
        _buildStatChip('Win Rate', '${winRate.toStringAsFixed(1)}%', AppColors.secondary),
      ],
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTypography.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          if (isMobile) ...[
            // Mobile layout - stacked filters
            _buildDateFilters(context, isMobile),
            const SizedBox(height: 16),
            _buildDropdownFilters(context, isMobile),
            const SizedBox(height: 16),
            _buildFilterActions(context, isMobile),
          ] else ...[
            // Desktop/Tablet layout - horizontal filters
            Row(
              children: [
                Expanded(child: _buildDateFilters(context, isMobile)),
                const SizedBox(width: 16),
                Expanded(child: _buildDropdownFilters(context, isMobile)),
                const SizedBox(width: 16),
                _buildFilterActions(context, isMobile),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateFilters(BuildContext context, bool isMobile) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _fromDateController,
            decoration: const InputDecoration(
              labelText: 'From Date',
              hintText: 'Select start date',
              prefixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () => _selectDate(context, true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: _toDateController,
            decoration: const InputDecoration(
              labelText: 'To Date',
              hintText: 'Select end date',
              prefixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () => _selectDate(context, false),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownFilters(BuildContext context, bool isMobile) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedGroup,
            decoration: const InputDecoration(
              labelText: 'Group',
              hintText: 'Select group',
              prefixIcon: Icon(Icons.group),
            ),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('All Groups'),
              ),
              ..._availableGroups.map((group) => DropdownMenuItem<String>(
                value: group,
                child: Text(group),
              )),
            ],
            onChanged: (value) {
              setState(() {
                _selectedGroup = value;
              });
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedBroker,
            decoration: const InputDecoration(
              labelText: 'Broker',
              hintText: 'Select broker',
              prefixIcon: Icon(Icons.account_balance),
            ),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('All Brokers'),
              ),
              ..._availableBrokers.map((broker) => DropdownMenuItem<String>(
                value: broker,
                child: Text(broker),
              )),
            ],
            onChanged: (value) {
              setState(() {
                _selectedBroker = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterActions(BuildContext context, bool isMobile) {
    return Row(
      mainAxisSize: isMobile ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (isMobile) const Spacer(),
        AppButton(
          text: 'Apply',
          onPressed: _applyFilters,
          variant: AppButtonVariant.primary,
          size: AppButtonSize.medium,
        ),
        const SizedBox(width: 8),
        AppButton(
          text: 'Clear',
          onPressed: _clearFilters,
          variant: AppButtonVariant.outlined,
          size: AppButtonSize.medium,
        ),
        if (isMobile) const Spacer(),
      ],
    );
  }

  Widget _buildContent(BuildContext context, bool isMobile, bool isTablet) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading trades',
              style: AppTypography.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: AppTypography.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AppButton(
              text: 'Retry',
              onPressed: _loadTrades,
              variant: AppButtonVariant.primary,
            ),
          ],
        ),
      );
    }

    if (_trades.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No trades found',
              style: AppTypography.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _filters.hasFilters 
                  ? 'Try adjusting your filters'
                  : 'Start trading to see your journal',
              style: AppTypography.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTrades,
      child: ListView.builder(
        padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
        itemCount: _trades.length,
        itemBuilder: (context, index) {
          final trade = _trades[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TradeCard(
              trade: trade,
              isMobile: isMobile,
              onTap: () => _showTradeDetails(trade),
            ),
          );
        },
      ),
    );
  }
}
