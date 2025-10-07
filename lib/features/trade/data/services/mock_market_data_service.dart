import 'dart:async';
import 'dart:math' as math;

import '../../../trade/domain/models/option_chain_model.dart';
import '../../../trade/domain/models/position_model.dart';

class MockMarketDataService {
  static final MockMarketDataService _instance = MockMarketDataService._internal();
  factory MockMarketDataService() => _instance;
  MockMarketDataService._internal();

  final math.Random _random = math.Random();
  Timer? _priceUpdateTimer;

  // Mock indices
  final List<MarketIndex> _indices = [
    MarketIndex(
      symbol: 'NIFTY',
      name: 'NIFTY 50',
      ltp: 25327.05,
      change: -45.35,
      changePercent: -0.18,
      isActive: true,
    ),
    MarketIndex(
      symbol: 'BANKNIFTY',
      name: 'BANK NIFTY',
      ltp: 54250.30,
      change: 125.80,
      changePercent: 0.23,
    ),
    MarketIndex(
      symbol: 'FINNIFTY',
      name: 'FIN NIFTY',
      ltp: 23450.75,
      change: -89.25,
      changePercent: -0.38,
    ),
  ];

  List<MarketIndex> getIndices() => _indices;

  MarketIndex getActiveIndex() => _indices.firstWhere((index) => index.isActive);

  void setActiveIndex(String symbol) {
    for (int i = 0; i < _indices.length; i++) {
      _indices[i] = MarketIndex(
        symbol: _indices[i].symbol,
        name: _indices[i].name,
        ltp: _indices[i].ltp,
        change: _indices[i].change,
        changePercent: _indices[i].changePercent,
        isActive: _indices[i].symbol == symbol,
      );
    }
  }

  OptionChainModel generateOptionChain(String symbol) {
    final activeIndex = _indices.firstWhere((index) => index.symbol == symbol);
    final underlyingPrice = activeIndex.ltp;
    
    // Generate strikes around current price
    final atmStrike = (underlyingPrice / 50).round() * 50;
    final strikes = <StrikePriceData>[];
    
    for (int i = -20; i <= 20; i++) {
      final strike = atmStrike + (i * 50);
      final isAtm = strike == atmStrike;
      final isItmCall = strike < underlyingPrice;
      final isItmPut = strike > underlyingPrice;
      
      strikes.add(StrikePriceData(
        strikePrice: strike.toDouble(),
        isAtm: isAtm,
        isItm: isItmCall || isItmPut,
        call: _generateOptionData(strike.toDouble(), underlyingPrice, true),
        put: _generateOptionData(strike.toDouble(), underlyingPrice, false),
      ));
    }
    
    return OptionChainModel(
      underlying: symbol,
      underlyingPrice: underlyingPrice,
      expiry: DateTime.now().add(const Duration(days: 7)), // Weekly expiry
      strikes: strikes,
      lastUpdated: DateTime.now(),
    );
  }

  OptionData _generateOptionData(double strike, double underlying, bool isCall) {
    final moneyness = isCall ? (underlying - strike) : (strike - underlying);
    final basePrice = math.max(moneyness, 0) + _random.nextDouble() * 50;
    
    return OptionData(
      ltp: double.parse(basePrice.toStringAsFixed(2)),
      bid: double.parse((basePrice - 0.5).toStringAsFixed(2)),
      ask: double.parse((basePrice + 0.5).toStringAsFixed(2)),
      volume: _random.nextInt(10000) + 1000,
      openInterest: _random.nextInt(50000) + 5000,
      change: (_random.nextDouble() - 0.5) * 20,
      changePercent: (_random.nextDouble() - 0.5) * 10,
      iv: 15.0 + _random.nextDouble() * 20,
      delta: isCall ? 0.3 + _random.nextDouble() * 0.4 : -0.7 + _random.nextDouble() * 0.4,
      gamma: _random.nextDouble() * 0.01,
      theta: -_random.nextDouble() * 5,
      vega: _random.nextDouble() * 10,
    );
  }

  List<CandleData> generateCandleData(String symbol, {int days = 30}) {
    final candles = <CandleData>[];
    final activeIndex = _indices.firstWhere((index) => index.symbol == symbol);
    double currentPrice = activeIndex.ltp;
    
    for (int i = days; i >= 0; i--) {
      final time = DateTime.now().subtract(Duration(days: i));
      final open = currentPrice;
      final change = (_random.nextDouble() - 0.5) * 200;
      final close = open + change;
      final high = math.max(open, close) + _random.nextDouble() * 50;
      final low = math.min(open, close) - _random.nextDouble() * 50;
      
      candles.add(CandleData(
        time: time,
        open: double.parse(open.toStringAsFixed(2)),
        high: double.parse(high.toStringAsFixed(2)),
        low: double.parse(low.toStringAsFixed(2)),
        close: double.parse(close.toStringAsFixed(2)),
        volume: _random.nextInt(1000000) + 100000,
      ));
      
      currentPrice = close;
    }
    
    return candles;
  }

  List<PositionModel> generateMockPositions() {
    return [
      PositionModel(
        id: 'pos_1',
        symbol: 'NIFTY25400CE',
        instrument: 'CE',
        isLong: true,
        quantity: 50,
        avgPrice: 125.50,
        ltp: 142.30,
        pnl: 840.00,
        pnlPercent: 13.38,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      PositionModel(
        id: 'pos_2',
        symbol: 'NIFTY25300PE',
        instrument: 'PE',
        isLong: false,
        quantity: 25,
        avgPrice: 89.75,
        ltp: 67.20,
        pnl: 563.75,
        pnlPercent: 25.12,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      PositionModel(
        id: 'pos_3',
        symbol: 'BANKNIFTY54500CE',
        instrument: 'CE',
        isLong: true,
        quantity: 15,
        avgPrice: 234.80,
        ltp: 198.50,
        pnl: -544.50,
        pnlPercent: -15.46,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];
  }

  List<OrderModel> generateMockOrders() {
    return [
      OrderModel(
        id: 'ord_1',
        symbol: 'NIFTY25350CE',
        instrument: 'CE',
        orderType: OrderType.limit,
        side: OrderSide.buy,
        quantity: 25,
        filledQuantity: 25,
        price: 156.75,
        status: OrderStatus.complete,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 28)),
      ),
      OrderModel(
        id: 'ord_2',
        symbol: 'BANKNIFTY54000PE',
        instrument: 'PE',
        orderType: OrderType.limit,
        side: OrderSide.sell,
        quantity: 50,
        filledQuantity: 0,
        price: 245.50,
        status: OrderStatus.open,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      OrderModel(
        id: 'ord_3',
        symbol: 'FINNIFTY23500CE',
        instrument: 'CE',
        orderType: OrderType.market,
        side: OrderSide.buy,
        quantity: 40,
        status: OrderStatus.rejected,
        rejectionReason: 'Insufficient margin',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
    ];
  }

  void startPriceUpdates() {
    _priceUpdateTimer?.cancel();
    _priceUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Simulate price updates
      for (int i = 0; i < _indices.length; i++) {
        final change = (_random.nextDouble() - 0.5) * 10;
        final newLtp = _indices[i].ltp + change;
        final newChange = _indices[i].change + change;
        final newChangePercent = (newChange / newLtp) * 100;
        
        _indices[i] = MarketIndex(
          symbol: _indices[i].symbol,
          name: _indices[i].name,
          ltp: double.parse(newLtp.toStringAsFixed(2)),
          change: double.parse(newChange.toStringAsFixed(2)),
          changePercent: double.parse(newChangePercent.toStringAsFixed(2)),
          isActive: _indices[i].isActive,
        );
      }
    });
  }

  void stopPriceUpdates() {
    _priceUpdateTimer?.cancel();
    _priceUpdateTimer = null;
  }

  void dispose() {
    stopPriceUpdates();
  }
}
