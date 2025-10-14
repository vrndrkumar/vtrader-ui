import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resizable_widget/resizable_widget.dart';
import '../widgets/option_chain_widget.dart';
import '../widgets/chart_widget.dart';
import '../widgets/positions_orders_widget.dart';
import '../../data/services/mock_market_data_service.dart';
import '../../data/services/real_option_chain_service.dart';
import '../../domain/models/option_chain_model.dart';
import '../../domain/models/position_model.dart';
import '../../../../shared/services/storage_service.dart';
import '../../../../shared/providers/master_data_provider.dart';
import '../../../../shared/models/index_model.dart';
import '../../../../shared/widgets/websocket_status_widget.dart';
import '../../../../shared/widgets/floating_ws_test_button.dart';

class TradePage extends ConsumerStatefulWidget {
  final String? symbol;

  const TradePage({
    super.key,
    this.symbol,
  });

  @override
  ConsumerState<TradePage> createState() => _TradePageState();
}

class _TradePageState extends ConsumerState<TradePage> with TickerProviderStateMixin {
  final MockMarketDataService _marketDataService = MockMarketDataService();
  late RealOptionChainService _realOptionChainService;
  
  String _selectedIndex = 'NIFTY';
  String? _selectedExpiry;
  OptionChainModel? _optionChain;
  List<CandleData> _candleData = [];
  List<PositionModel> _positions = [];
  List<OrderModel> _orders = [];
  
  Timer? _refreshTimer;
  bool _isLoading = true;
  StreamSubscription<OptionChainModel?>? _optionChainSubscription;

  // Panel size persistence keys
  static const String _horizontalRatioKey = 'trade_page_horizontal_ratio';
  static const String _verticalRatioKey = 'trade_page_vertical_ratio';
  
  double _horizontalRatio = 0.4; // Left panel width ratio (Option Chain)
  double _verticalRatio = 0.7; // Top right panel height ratio (Chart vs Positions)

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.symbol ?? 'NIFTY';
    _realOptionChainService = RealOptionChainService.instance;
    
    _loadPanelSizes();
    _initializeWebSocket();
    _loadInitialData();
    _startAutoRefresh();

    // Listen to master data changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeFromMasterData();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _optionChainSubscription?.cancel();
    _marketDataService.stopPriceUpdates();
    _realOptionChainService.dispose();
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
      
      // Generate mock data for non-option chain widgets (candles, positions, orders)
      final candleData = _marketDataService.generateCandleData(_selectedIndex);
      final positions = _marketDataService.generateMockPositions();
      final orders = _marketDataService.generateMockOrders();

      if (mounted) {
        print('Data loaded for $_selectedIndex: ${candleData.length} candles');
        setState(() {
          // Option chain will come from WebSocket, don't use mock data
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
      print('Index changing from $_selectedIndex to $newIndex');
      
      // Unsubscribe from previous WebSocket channel
      _realOptionChainService.unsubscribe();
      
      setState(() {
        _selectedIndex = newIndex;
        _selectedExpiry = null; // Reset expiry when index changes
        _isLoading = true;
        // Clear existing data to force complete rebuild
        _optionChain = null;
        _candleData = [];
        _positions = [];
        _orders = [];
      });
      _loadInitialData();
    }
  }

  void _onIndexModelChanged(IndexModel? indexModel) {
    if (indexModel != null) {
      _onIndexChanged(indexModel.symbolCode);
    }
  }

  void _onExpiryChanged(String? expiry) {
    setState(() {
      _selectedExpiry = expiry;
    });
    
    // Subscribe to WebSocket for new expiry
    if (expiry != null && _selectedIndex.isNotEmpty) {
      // Convert dropdown format to API format for subscription
      final apiExpiry = _convertDropdownToApiExpiry(expiry);
      _subscribeToOptionChain(_selectedIndex, apiExpiry);
    }
  }

  void _initializeFromMasterData() {
    final masterDataState = ref.read(masterDataStateProvider);
    if (masterDataState.hasData) {
      // Set default index if not already set
      final selectedIndex = ref.read(selectedIndexProvider);
      if (selectedIndex == null) {
        final defaultIndex = masterDataState.indices.first;
        ref.read(selectedIndexProvider.notifier).state = defaultIndex;
        _onIndexChanged(defaultIndex.symbolCode);
        
        // Subscribe to WebSocket with first expiry after index is set
        final expiries = defaultIndex.formattedExpiryDates;
        debugPrint('📅 Available expiries: $expiries');
        if (expiries.isNotEmpty) {
          final apiExpiry = expiries.first; // e.g., "14OCT25"
          final dropdownExpiry = _convertApiExpiryToDropdown(apiExpiry); // e.g., "14/10/2025"
          
          debugPrint('📅 Setting expiry: API=$apiExpiry, Dropdown=$dropdownExpiry');
          
          setState(() {
            _selectedExpiry = dropdownExpiry;
          });
          ref.read(selectedExpiryProvider.notifier).state = dropdownExpiry;
          
          WidgetsBinding.instance.addPostFrameCallback((_) {
            debugPrint('📡 Subscribing to: ${defaultIndex.symbolCode} - $apiExpiry');
            _subscribeToOptionChain(defaultIndex.symbolCode, apiExpiry);
          });
        } else {
          debugPrint('⚠️ No expiries available for ${defaultIndex.symbolCode}');
        }
      } else {
        // Subscribe to WebSocket for currently selected index/expiry
        final expiries = selectedIndex.formattedExpiryDates;
        debugPrint('📅 Index already selected: ${selectedIndex.symbolCode}, expiries: $expiries');
        
        if (expiries.isNotEmpty) {
          // Use first expiry if none selected
          final dropdownExpiry = _selectedExpiry ?? _convertApiExpiryToDropdown(expiries.first);
          final apiExpiry = _convertDropdownToApiExpiry(dropdownExpiry);
          
          debugPrint('📅 Using expiry: Dropdown=$dropdownExpiry, API=$apiExpiry');
          
          if (_selectedExpiry == null) {
            setState(() {
              _selectedExpiry = dropdownExpiry;
            });
            ref.read(selectedExpiryProvider.notifier).state = dropdownExpiry;
          }
          
          WidgetsBinding.instance.addPostFrameCallback((_) {
            debugPrint('📡 Subscribing to: ${selectedIndex.symbolCode} - $apiExpiry');
            _subscribeToOptionChain(selectedIndex.symbolCode, apiExpiry);
          });
        } else {
          debugPrint('⚠️ No expiries available for ${selectedIndex.symbolCode}');
        }
      }
    }
  }
  
  /// Convert API expiry format to dropdown format
  /// Example: "14OCT25" -> "14/10/2025"
  String _convertApiExpiryToDropdown(String apiExpiry) {
    try {
      final day = apiExpiry.substring(0, 2);
      final monthStr = apiExpiry.substring(2, 5);
      final year = '20${apiExpiry.substring(5, 7)}';

      const monthMap = {
        'JAN': '01', 'FEB': '02', 'MAR': '03', 'APR': '04', 'MAY': '05', 'JUN': '06',
        'JUL': '07', 'AUG': '08', 'SEP': '09', 'OCT': '10', 'NOV': '11', 'DEC': '12',
      };

      final month = monthMap[monthStr] ?? '01';
      return '$day/$month/$year';
    } catch (e) {
      return apiExpiry;
    }
  }
  
  /// Convert dropdown expiry format to API format
  /// Example: "14/10/2025" -> "14OCT25"
  String _convertDropdownToApiExpiry(String dropdownExpiry) {
    try {
      final parts = dropdownExpiry.split('/');
      if (parts.length == 3) {
        final day = parts[0].padLeft(2, '0');
        final month = int.parse(parts[1]);
        final year = parts[2].substring(2); // Last 2 digits

        const months = [
          '', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
          'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
        ];

        return '$day${months[month]}$year';
      }
      return dropdownExpiry;
    } catch (e) {
      return dropdownExpiry;
    }
  }

  /// Initialize WebSocket service and listen to real-time option chain data
  Future<void> _initializeWebSocket() async {
    try {
      debugPrint('🚀 TradePage: Initializing WebSocket service...');
      
      // Initialize the real option chain service
      await _realOptionChainService.initialize();
      
      // Listen to real-time option chain updates
      _optionChainSubscription = _realOptionChainService.optionChainStream.listen(
        (optionChain) {
          if (optionChain != null && mounted) {
            debugPrint('📊 TradePage: Received option chain with ${optionChain.strikes.length} strikes');
            setState(() {
              _optionChain = optionChain;
            });
          }
        },
        onError: (error) {
          debugPrint('❌ TradePage: Error in option chain stream: $error');
        },
      );
      
      debugPrint('✅ TradePage: WebSocket service initialized');
    } catch (e) {
      debugPrint('❌ TradePage: Failed to initialize WebSocket: $e');
    }
  }

  /// Subscribe to option chain WebSocket for specific index and expiry
  void _subscribeToOptionChain(String index, String expiry) {
    debugPrint('📡 TradePage: Subscribing to $index - $expiry');
    _realOptionChainService.subscribeToOptionChain(index, expiry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey('trade_page_$_selectedIndex'),
      body: Stack(
        children: [
          Column(
            children: [
              // WebSocket test panel - ALWAYS visible
              const WebSocketStatusWidget(),
              
              // Top controls (Index + Expiry dropdowns) - ALWAYS visible
              _buildTopControls(context),
              
              // Main content area - show spinner ONLY for option chain data
              Expanded(
                child: _buildMainLayout(context),
              ),
            ],
          ),
          
          // Floating WebSocket Test Button - ALWAYS VISIBLE
          const FloatingWSTestButton(),
        ],
      ),
    );
  }

  Widget _buildTopControls(BuildContext context) {
    final theme = Theme.of(context);
    final masterDataState = ref.watch(masterDataStateProvider);
    final selectedIndex = ref.watch(selectedIndexProvider);

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
                value: selectedIndex?.symbolCode ?? _selectedIndex,
                onChanged: masterDataState.isLoading ? null : (value) {
                  if (value != null) {
                    // Schedule state update for after build to avoid LayoutBuilder error
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        // Find the index model and update state
                        final indexModel = masterDataState.indices.firstWhere(
                          (index) => index.symbolCode == value,
                          orElse: () => masterDataState.indices.first,
                        );
                        ref.read(selectedIndexProvider.notifier).state = indexModel;
                        _onIndexChanged(value);
                      }
                    });
                  }
                },
                hint: masterDataState.isLoading
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Loading...',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      )
                    : null,
                items: () {
                  // Remove duplicates by using a Map keyed by symbolCode
                  final uniqueIndices = <String, IndexModel>{};
                  for (final index in masterDataState.indices) {
                    uniqueIndices[index.symbolCode] = index;
                  }
                  
                  return uniqueIndices.values.map((index) {
                    return DropdownMenuItem<String>(
                      value: index.symbolCode,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              index.symbolName,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${index.exchange}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList();
                }(),
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
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh Data',
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
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text('Waiting for option chain data...'),
                            const SizedBox(height: 8),
                            Text(
                              'Index: $_selectedIndex | Expiry: ${_selectedExpiry ?? "Not set"}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Check test widget at bottom-right →',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
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
        key: ValueKey('desktop_layout_$_selectedIndex'),
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
                  key: ValueKey('option_chain_$_selectedIndex'),
                  optionChain: _optionChain!,
                  onRefresh: _refreshData,
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      const Text(
                        'Waiting for option chain data...',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Index: $_selectedIndex',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Expiry: ${_selectedExpiry ?? "⚠️ NOT SET - Please select expiry"}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _selectedExpiry == null ? Colors.red : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '👉 Check test widget at bottom-right corner',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '📊 WebSocket Status Panel at top',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
          
          // Right Panel - Chart and Positions/Orders (Vertical split)
          ResizableWidget(
            key: ValueKey('right_panel_$_selectedIndex'),
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
                key: ValueKey('chart_$_selectedIndex'),
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