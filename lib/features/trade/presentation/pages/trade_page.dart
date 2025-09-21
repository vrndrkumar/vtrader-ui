import 'dart:async';
import 'package:flutter/material.dart';
import 'package:resizable_widget/resizable_widget.dart';
import '../widgets/option_chain_widget.dart';
import '../widgets/chart_widget.dart';
import '../widgets/positions_orders_widget.dart';
import '../../data/services/mock_market_data_service.dart';
import '../../domain/models/option_chain_model.dart';
import '../../domain/models/position_model.dart';
import '../../../../shared/services/storage_service.dart';

class TradePage extends StatefulWidget {
  final String? symbol;

  const TradePage({
    super.key,
    this.symbol,
  });

  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> with TickerProviderStateMixin {
  final MockMarketDataService _marketDataService = MockMarketDataService();
  
  String _selectedIndex = 'NIFTY';
  OptionChainModel? _optionChain;
  List<CandleData> _candleData = [];
  List<PositionModel> _positions = [];
  List<OrderModel> _orders = [];
  
  Timer? _refreshTimer;
  bool _isLoading = true;

  // Panel size persistence keys
  static const String _horizontalRatioKey = 'trade_page_horizontal_ratio';
  static const String _verticalRatioKey = 'trade_page_vertical_ratio';
  
  double _horizontalRatio = 0.4; // Left panel width ratio (Option Chain)
  double _verticalRatio = 0.7; // Top right panel height ratio (Chart vs Positions)

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.symbol ?? 'NIFTY';
    _loadPanelSizes();
    _loadInitialData();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _marketDataService.stopPriceUpdates();
    super.dispose();
  }

  void _loadPanelSizes() {
    final horizontalRatio = StorageService.getDouble(_horizontalRatioKey);
    final verticalRatio = StorageService.getDouble(_verticalRatioKey);
    
    if (horizontalRatio != null) {
      _horizontalRatio = horizontalRatio;
    }
    if (verticalRatio != null) {
      _verticalRatio = verticalRatio;
    }
  }

  void _savePanelSizes() {
    StorageService.setDouble(_horizontalRatioKey, _horizontalRatio);
    StorageService.setDouble(_verticalRatioKey, _verticalRatio);
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Stop previous updates and set new active index
      _marketDataService.stopPriceUpdates();
      _marketDataService.setActiveIndex(_selectedIndex);
      _marketDataService.startPriceUpdates();
      
      // Generate fresh data for the selected index
      final optionChain = _marketDataService.generateOptionChain(_selectedIndex);
      final candleData = _marketDataService.generateCandleData(_selectedIndex);
      final positions = _marketDataService.generateMockPositions();
      final orders = _marketDataService.generateMockOrders();

      if (mounted) {
        setState(() {
          _optionChain = optionChain;
          _candleData = candleData;
          _positions = positions;
          _orders = orders;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data for $_selectedIndex: $e')),
        );
      }
    }
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        _refreshData();
      }
    });
  }

  Future<void> _refreshData() async {
    try {
      final optionChain = _marketDataService.generateOptionChain(_selectedIndex);
      final candleData = _marketDataService.generateCandleData(_selectedIndex);
      final positions = _marketDataService.generateMockPositions();
      final orders = _marketDataService.generateMockOrders();

      if (mounted) {
        setState(() {
          _optionChain = optionChain;
          _candleData = candleData;
          _positions = positions;
          _orders = orders;
        });
      }
    } catch (e) {
      // Silently handle refresh errors
    }
  }

  void _onIndexChanged(String newIndex) {
    if (newIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = newIndex;
        _isLoading = true;
      });
      _loadInitialData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTopControls(context),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildMainLayout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTopControls(BuildContext context) {
    final theme = Theme.of(context);
    final indices = _marketDataService.getIndices();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Trade Terminal',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 32),
          Text(
            'Index:',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: theme.dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedIndex,
                onChanged: (value) {
                  if (value != null) {
                    _onIndexChanged(value);
                  }
                },
                items: indices.map((index) {
                  final isPositive = index.change >= 0;
                  return DropdownMenuItem<String>(
                    value: index.symbol,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            index.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '₹${index.ltp.toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${isPositive ? '+' : ''}${index.changePercent.toStringAsFixed(2)}%)',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isPositive ? Colors.green : Colors.red,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const Spacer(),
          Text(
            'Last Updated: ${DateTime.now().toString().substring(11, 19)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainLayout(BuildContext context) {
    // Check screen size for responsive layout
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 1024; // Desktop breakpoint
        
        if (isMobile) {
          return _buildMobileLayout(context);
        } else {
          return _buildDesktopLayout(context);
        }
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Option Chain', icon: Icon(Icons.table_chart)),
              Tab(text: 'Chart', icon: Icon(Icons.show_chart)),
              Tab(text: 'Positions', icon: Icon(Icons.account_balance_wallet)),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _optionChain != null
                    ? OptionChainWidget(
                        optionChain: _optionChain!,
                        onRefresh: _refreshData,
                      )
                    : const Center(child: CircularProgressIndicator()),
                ChartWidget(
                  candleData: _candleData,
                  symbol: _selectedIndex,
                  onRefresh: _refreshData,
                ),
                PositionsOrdersWidget(
                  positions: _positions,
                  orders: _orders,
                  onRefresh: _refreshData,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ResizableWidget(
        isHorizontalSeparator: false, // Vertical split: Left | Right
        separatorColor: Theme.of(context).dividerColor,
        separatorSize: 4,
        percentages: [_horizontalRatio, 1 - _horizontalRatio],
        onResized: (info) {
          if (info.isNotEmpty) {
            setState(() {
              _horizontalRatio = info[0].percentage;
            });
            _savePanelSizes();
          }
        },
        children: [
          // Left Panel - Option Chain (full height)
          _optionChain != null
              ? OptionChainWidget(
                  optionChain: _optionChain!,
                  onRefresh: _refreshData,
                )
              : const Center(child: CircularProgressIndicator()),
          
          // Right Panel - Chart and Positions/Orders (Vertical split)
          ResizableWidget(
            isHorizontalSeparator: true, // Horizontal split: Top / Bottom
            separatorColor: Theme.of(context).dividerColor,
            separatorSize: 4,
            percentages: [_verticalRatio, 1 - _verticalRatio],
            onResized: (info) {
              if (info.isNotEmpty) {
                setState(() {
                  _verticalRatio = info[0].percentage;
                });
                _savePanelSizes();
              }
            },
            children: [
              // Top Right - Chart
              ChartWidget(
                candleData: _candleData,
                symbol: _selectedIndex,
                onRefresh: _refreshData,
              ),
              
              // Bottom Right - Positions/Orders
              PositionsOrdersWidget(
                positions: _positions,
                orders: _orders,
                onRefresh: _refreshData,
              ),
            ],
          ),
        ],
      ),
    );
  }
}