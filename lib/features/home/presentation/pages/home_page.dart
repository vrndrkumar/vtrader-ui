import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildNavigation(context),
            _buildHeroSection(context),
            _buildStatsSection(context),
            _buildFeaturesSection(context),
            _buildTestimonialsSection(context),
            _buildPricingSection(context),
            _buildCallToActionSection(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VTrader',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Professional Trading Platform',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: () => context.push('/login'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => context.push('/register'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.rocket_launch_rounded, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Get Started Free',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 100),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.05),
            AppColors.secondary.withOpacity(0.03),
            Colors.white,
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.success.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_rounded,
                  color: AppColors.success,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Trusted by 10,000+ Professional Traders',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Master Your Trading Edge with\nProfessional-Grade Analytics',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.lightOnBackground,
              height: 1.2,
              letterSpacing: -1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              'Transform your trading performance with comprehensive journaling, multi-broker integration, and AI-powered analytics. Join thousands of traders who\'ve already improved their consistency and profitability.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.lightOnSurfaceVariant,
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => context.push('/register'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.rocket_launch_rounded, size: 20),
                    SizedBox(width: 12),
                    Text(
                      'Start Free Trial',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              OutlinedButton(
                onPressed: () => context.push('/login'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary, width: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.login_rounded, size: 20),
                    SizedBox(width: 12),
                    Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.success,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'No credit card required',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.lightOnSurfaceVariant,
                ),
              ),
              const SizedBox(width: 24),
              Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.success,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                '14-day free trial',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.lightOnSurfaceVariant,
                ),
              ),
              const SizedBox(width: 24),
              Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.success,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Cancel anytime',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.lightOnSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final stats = [
      {'number': '10,000+', 'label': 'Active Traders'},
      {'number': '2.5M+', 'label': 'Trades Analyzed'},
      {'number': '15+', 'label': 'Supported Brokers'},
      {'number': '98%', 'label': 'Satisfaction Rate'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
      color: AppColors.primary.withOpacity(0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stats.map((stat) => _buildStatItem(context, stat)).toList(),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, Map<String, String> stat) {
    return Column(
      children: [
        Text(
          stat['number']!,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          stat['label']!,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.lightOnSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }


  Widget _buildFeaturesSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 768;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;
    
    // Determine columns based on screen size
    int columns;
    if (isMobile) {
      columns = 1;
    } else if (isTablet) {
      columns = 2;
    } else {
      columns = 3; // Desktop: 3 columns
    }
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        children: [
          Text(
            'Everything You Need to Trade Like a Pro',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.lightOnBackground,
              letterSpacing: -0.5,
              fontSize: isMobile ? 24 : 32,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 600,
            ),
            child: Text(
              'Comprehensive tools and analytics to help you identify patterns, improve consistency, and maximize your trading performance.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.lightOnSurfaceVariant,
                height: 1.5,
                fontSize: isMobile ? 14 : 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: isMobile ? 40 : 80),
          
          // Grid layout for features
          LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: isMobile ? 16 : 24,
                  mainAxisSpacing: isMobile ? 16 : 24,
                  childAspectRatio: isMobile ? 0.8 : 0.9, // Taller cards to accommodate metrics
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return _buildFeatureGridCard(context, index);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGridCard(BuildContext context, int index) {
    final features = [
      {
        'icon': Icons.book_rounded,
        'title': 'Trade Journaling',
        'description': 'Intelligent trade logging with AI analysis.',
        'color': AppColors.primary,
        'detailedDescription': 'Transform your trading with our intelligent journaling system that goes far beyond simple trade logging. Automatically sync trades from 15+ major brokers including Interactive Brokers, TD Ameritrade, E*TRADE, and Charles Schwab, or manually log every detail with our intuitive interface. Add rich context with detailed notes, screenshots, market conditions, emotional states, and trade rationale. Our AI-powered analysis engine examines your entries to identify patterns in your behavior, helping you understand what drives your best and worst trades. Tag trades by strategy, setup, or market conditions for easy filtering and analysis. Group related trades to track the performance of specific approaches over time. Export comprehensive reports for tax purposes or performance reviews with professional traders.',
        'metrics': {
          'winRate': 68.5,
          'totalTrades': 1247,
          'avgReturn': 2.3,
          'profitFactor': 1.85,
        },
        'hoverMetrics': {
          'bestTrade': '₹45,230',
          'worstTrade': '₹12,450',
          'streak': '8 wins',
          'monthlyReturn': '+12.4%',
        }
      },
      {
        'icon': Icons.account_tree_rounded,
        'title': 'Multi-Broker',
        'description': 'Manage all your broker accounts from one interface.',
        'color': AppColors.secondary,
        'detailedDescription': 'Connect and manage multiple broker accounts from one powerful interface. Our multi-broker integration supports 15+ major brokers including Interactive Brokers, TD Ameritrade, E*TRADE, Charles Schwab, Fidelity, and more. Execute trades simultaneously across different brokers, monitor positions in real-time, and track unified P&L across all your accounts. The platform provides secure API connections with bank-level encryption, ensuring your trading data remains protected. Set up custom alerts for position changes, margin calls, or profit targets across all connected accounts. The unified dashboard gives you a complete view of your trading portfolio, making it easier to manage risk and optimize your trading strategy across multiple brokers.',
        'metrics': {
          'connectedBrokers': 3,
          'totalAccounts': 7,
          'unifiedPnl': 156780,
          'activePositions': 23,
        },
        'hoverMetrics': {
          'todayPnl': '+₹8,450',
          'marginUsed': '₹2.1L',
          'availableCash': '₹5.8L',
          'lastSync': '2 min ago',
        }
      },
      {
        'icon': Icons.analytics_rounded,
        'title': 'Analytics Suite',
        'description': 'Comprehensive performance metrics and analytics.',
        'color': AppColors.success,
        'detailedDescription': 'Unlock the power of your trading data with comprehensive analytics and insights. Track key performance metrics including win rate, average R-multiple, profit factor, maximum drawdown, and Sharpe ratio. Analyze patterns with interactive heat maps showing your performance by day of week, time of day, market conditions, and trading strategies. Generate detailed reports with Monte Carlo simulations to understand the probability distribution of your trading outcomes. Use advanced charting tools to visualize your equity curve, drawdown periods, and trade distribution. The analytics engine identifies your strengths and weaknesses, helping you focus on what works and eliminate what doesn\'t. Export professional reports for performance reviews or share insights with trading mentors.',
        'metrics': {
          'sharpeRatio': 1.42,
          'maxDrawdown': 8.3,
          'avgRMultiple': 1.8,
          'monthlyReturn': 15.2,
        },
        'hoverMetrics': {
          'volatility': '12.4%',
          'beta': 0.85,
          'alpha': '+2.1%',
          'correlation': '0.73',
        }
      },
      {
        'icon': Icons.calculate_rounded,
        'title': 'Risk Management',
        'description': 'Advanced position sizing and risk control tools.',
        'color': AppColors.warning,
        'detailedDescription': 'Protect your capital with advanced risk management tools designed for professional traders. Implement dynamic position sizing based on account size, volatility, and market conditions. Set up automated risk limits with real-time alerts for position size, daily loss limits, and maximum drawdown thresholds. Track R-multiples for every trade to ensure consistent risk-reward ratios. Use portfolio optimization tools to balance risk across different strategies and markets. The platform calculates optimal position sizes using Kelly Criterion, Fixed Fractional, and Volatility-based methods. Set up automated stop-losses and take-profits based on your risk parameters. Monitor correlation between positions to avoid over-concentration in similar trades. Advanced risk analytics help you understand your risk-adjusted returns and optimize your trading approach.',
        'metrics': {
          'riskPerTrade': 1.5,
          'dailyLimit': 3.0,
          'positionSize': 2.8,
          'riskReward': 1.85,
        },
        'hoverMetrics': {
          'var95': '₹12,450',
          'exposure': '₹3.2L',
          'hedgeRatio': '0.65',
          'stopLoss': '₹8,900',
        }
      },
      {
        'icon': Icons.group_work_rounded,
        'title': 'Strategy Testing',
        'description': 'Backtest and optimize your trading strategies.',
        'color': AppColors.error,
        'detailedDescription': 'Build, test, and refine your trading strategies with confidence using our comprehensive backtesting engine. Test your strategies against years of historical data with realistic slippage and commission costs. Use our visual strategy builder to create complex trading rules with drag-and-drop simplicity. Optimize strategy parameters using genetic algorithms and walk-forward analysis to ensure robustness. Paper trade your strategies in real-time to validate performance before risking real capital. The platform supports multiple asset classes including stocks, options, futures, forex, and cryptocurrencies. Advanced features include Monte Carlo analysis, scenario testing, and stress testing under extreme market conditions. Export strategy results and share them with the trading community. Integrate with live trading systems for seamless strategy deployment.',
        'metrics': {
          'backtestsRun': 47,
          'winRate': 72.1,
          'profitFactor': 2.1,
          'maxDrawdown': 6.8,
        },
        'hoverMetrics': {
          'bestStrategy': 'Momentum Breakout',
          'avgTrade': '₹1,250',
          'consecutiveWins': '12',
          'lastBacktest': '2 hours ago',
        }
      },
      {
        'icon': Icons.trending_up_rounded,
        'title': 'Performance',
        'description': 'Track and improve your trading performance over time.',
        'color': AppColors.primary,
        'detailedDescription': 'Monitor and improve your trading performance with comprehensive tracking and analysis tools. Track your progress over time with detailed performance metrics including monthly returns, annualized returns, and risk-adjusted performance measures. Set up performance goals and track your progress toward achieving them. Use performance attribution analysis to understand which strategies, markets, or time periods contribute most to your success. Monitor your trading psychology with mood tracking and emotional state analysis. The platform provides personalized recommendations based on your trading patterns and performance history. Compare your performance against market benchmarks and other traders in the community. Use advanced performance analytics to identify areas for improvement and optimize your trading approach for maximum profitability.',
        'metrics': {
          'ytdReturn': 24.8,
          'monthlyReturn': 3.2,
          'annualizedReturn': 28.5,
          'benchmarkBeat': 4.2,
        },
        'hoverMetrics': {
          'bestMonth': '+8.4%',
          'worstMonth': '-2.1%',
          'consistency': '85%',
          'ranking': 'Top 15%',
        }
      },
    ];
    
    final feature = features[index];
    final isMobile = MediaQuery.of(context).size.width <= 768;
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) {
        // Add hover effect if needed
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: isMobile ? 6 : 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
            onTap: () {
              _showFeaturePopup(context, feature);
            },
            child: Container(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with icon and title
                  Row(
                    children: [
                      Container(
                        width: isMobile ? 32 : 40,
                        height: isMobile ? 32 : 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              feature['color'] as Color,
                              (feature['color'] as Color).withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                        ),
                        child: Icon(
                          feature['icon'] as IconData,
                          color: Colors.white,
                          size: isMobile ? 18 : 22,
                        ),
                      ),
                      SizedBox(width: isMobile ? 12 : 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feature['title'] as String,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.lightOnBackground,
                                fontSize: isMobile ? 14 : 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              feature['description'] as String,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.lightOnSurfaceVariant,
                                fontSize: isMobile ? 11 : 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: isMobile ? 16 : 20),
                  
                  // Feature-specific content section
                  _buildFeatureSpecificContent(context, feature, isMobile),
                  
                  SizedBox(height: isMobile ? 12 : 16),
                  
                  // Learn More Button
                  Container(
                    width: double.infinity,
                    height: isMobile ? 36 : 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          feature['color'] as Color,
                          (feature['color'] as Color).withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                        onTap: () {
                          _showFeaturePopup(context, feature);
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Learn More',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: isMobile ? 12 : 14,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: isMobile ? 16 : 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureSpecificContent(BuildContext context, Map<String, dynamic> feature, bool isMobile) {
    final title = feature['title'] as String;
    
    switch (title) {
      case 'Trade Journaling':
        return _buildTradeJournalingContent(context, isMobile);
      case 'Multi-Broker':
        return _buildMultiBrokerContent(context, isMobile);
      case 'Analytics Suite':
        return _buildAnalyticsContent(context, isMobile);
      case 'Risk Management':
        return _buildRiskManagementContent(context, isMobile);
      case 'Strategy Testing':
        return _buildStrategyTestingContent(context, isMobile);
      case 'Performance':
        return _buildPerformanceContent(context, isMobile);
      default:
        return Container();
    }
  }

  // Trade Journaling - Show journal entries and tags
  Widget _buildTradeJournalingContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recent journal entries
        Container(
          padding: EdgeInsets.all(isMobile ? 8 : 12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.edit_note, size: isMobile ? 16 : 18, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Recent Entries',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
                      fontSize: isMobile ? 10 : 11,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _buildJournalEntry('NIFTY 50 Breakout', 'Bullish', '+₹2,450', Colors.green, isMobile),
              SizedBox(height: 4),
              _buildJournalEntry('BANKNIFTY Scalp', 'Neutral', '-₹850', Colors.red, isMobile),
              SizedBox(height: 4),
              _buildJournalEntry('RELIANCE Swing', 'Bullish', '+₹3,200', Colors.green, isMobile),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 8 : 12),
        // Tags and stats
        Row(
          children: [
            Expanded(
              child: _buildStatCard('Total Entries', '247', Colors.blue, isMobile),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildStatCard('This Week', '12', Colors.green, isMobile),
            ),
          ],
        ),
      ],
    );
  }

  // Multi-Broker - Show connected brokers
  Widget _buildMultiBrokerContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Connected brokers
        Container(
          padding: EdgeInsets.all(isMobile ? 8 : 12),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.purple.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.account_tree, size: isMobile ? 16 : 18, color: Colors.purple),
                  SizedBox(width: 8),
                  Text(
                    'Connected Brokers',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.purple[700],
                      fontSize: isMobile ? 10 : 11,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _buildBrokerConnection('FINVASIA', 'Active', '₹1.2L', Colors.green, isMobile),
              SizedBox(height: 4),
              _buildBrokerConnection('ZERODHA', 'Active', '₹85K', Colors.green, isMobile),
              SizedBox(height: 4),
              _buildBrokerConnection('ANGEL ONE', 'Syncing', '₹45K', Colors.orange, isMobile),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 8 : 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard('Total P&L', '₹1.85L', Colors.green, isMobile),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildStatCard('Active Pos', '23', Colors.purple, isMobile),
            ),
          ],
        ),
      ],
    );
  }

  // Analytics Suite - Show charts and metrics
  Widget _buildAnalyticsContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Performance chart representation
        Container(
          height: isMobile ? 60 : 80,
          padding: EdgeInsets.all(isMobile ? 8 : 12),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.trending_up, size: isMobile ? 16 : 18, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    'Performance Overview',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                      fontSize: isMobile ? 10 : 11,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Simple chart representation
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: isMobile ? 20 : 30,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(12, (index) {
                          final heights = [0.3, 0.6, 0.4, 0.8, 0.5, 0.9, 0.7, 0.6, 0.8, 0.4, 0.7, 0.9];
                          return Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 1),
                              height: (isMobile ? 20 : 30) * heights[index],
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 8 : 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard('Win Rate', '72.4%', Colors.green, isMobile),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildStatCard('Sharpe', '1.85', Colors.blue, isMobile),
            ),
          ],
        ),
      ],
    );
  }

  // Risk Management - Show risk indicators
  Widget _buildRiskManagementContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Risk gauge representation
        Container(
          padding: EdgeInsets.all(isMobile ? 8 : 12),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.security, size: isMobile ? 16 : 18, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(
                    'Risk Monitor',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.orange[700],
                      fontSize: isMobile ? 10 : 11,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Risk progress bars
              _buildRiskBar('Daily Risk', 0.45, Colors.green, isMobile),
              SizedBox(height: 4),
              _buildRiskBar('Position Size', 0.65, Colors.orange, isMobile),
              SizedBox(height: 4),
              _buildRiskBar('Portfolio Risk', 0.25, Colors.green, isMobile),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 8 : 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard('Max Risk', '2.5%', Colors.orange, isMobile),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildStatCard('VaR 95%', '₹12K', Colors.red, isMobile),
            ),
          ],
        ),
      ],
    );
  }

  // Strategy Testing - Show backtest results
  Widget _buildStrategyTestingContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strategy performance
        Container(
          padding: EdgeInsets.all(isMobile ? 8 : 12),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.psychology, size: isMobile ? 16 : 18, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Active Strategies',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.red[700],
                      fontSize: isMobile ? 10 : 11,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _buildStrategyResult('Momentum Breakout', '78% Win', '+₹45K', Colors.green, isMobile),
              SizedBox(height: 4),
              _buildStrategyResult('Mean Reversion', '65% Win', '+₹28K', Colors.green, isMobile),
              SizedBox(height: 4),
              _buildStrategyResult('Scalping Bot', '45% Win', '-₹5K', Colors.red, isMobile),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 8 : 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard('Backtests', '47', Colors.red, isMobile),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildStatCard('Best Strat', '78%', Colors.green, isMobile),
            ),
          ],
        ),
      ],
    );
  }

  // Performance - Show equity curve
  Widget _buildPerformanceContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Equity curve
        Container(
          height: isMobile ? 60 : 80,
          padding: EdgeInsets.all(isMobile ? 8 : 12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.show_chart, size: isMobile ? 16 : 18, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Equity Curve',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
                      fontSize: isMobile ? 10 : 11,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Equity curve representation
              Expanded(
                child: CustomPaint(
                  size: Size(double.infinity, isMobile ? 20 : 30),
                  painter: EquityCurvePainter(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 8 : 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard('YTD Return', '+24.8%', Colors.green, isMobile),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildStatCard('Max DD', '-8.2%', Colors.red, isMobile),
            ),
          ],
        ),
      ],
    );
  }

  // Helper widgets
  Widget _buildJournalEntry(String trade, String sentiment, String pnl, Color pnlColor, bool isMobile) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: sentiment == 'Bullish' ? Colors.green : sentiment == 'Bearish' ? Colors.red : Colors.orange,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            trade,
            style: TextStyle(fontSize: isMobile ? 9 : 10, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          pnl,
          style: TextStyle(
            fontSize: isMobile ? 9 : 10,
            fontWeight: FontWeight.w600,
            color: pnlColor,
          ),
        ),
      ],
    );
  }

  Widget _buildBrokerConnection(String broker, String status, String balance, Color statusColor, bool isMobile) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            broker,
            style: TextStyle(fontSize: isMobile ? 9 : 10, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          balance,
          style: TextStyle(
            fontSize: isMobile ? 9 : 10,
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildRiskBar(String label, double value, Color color, bool isMobile) {
    return Row(
      children: [
        SizedBox(
          width: isMobile ? 60 : 80,
          child: Text(
            label,
            style: TextStyle(fontSize: isMobile ? 8 : 9),
          ),
        ),
        Expanded(
          child: Container(
            height: isMobile ? 4 : 6,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(
          '${(value * 100).toInt()}%',
          style: TextStyle(
            fontSize: isMobile ? 8 : 9,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildStrategyResult(String strategy, String winRate, String pnl, Color pnlColor, bool isMobile) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: pnlColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            strategy,
            style: TextStyle(fontSize: isMobile ? 9 : 10, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          pnl,
          style: TextStyle(
            fontSize: isMobile ? 9 : 10,
            fontWeight: FontWeight.w600,
            color: pnlColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 6 : 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 8 : 9,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: isMobile ? 11 : 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

}

// Custom painter for equity curve
class EquityCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.1, size.height * 0.7),
      Offset(size.width * 0.2, size.height * 0.6),
      Offset(size.width * 0.3, size.height * 0.5),
      Offset(size.width * 0.4, size.height * 0.4),
      Offset(size.width * 0.5, size.height * 0.3),
      Offset(size.width * 0.6, size.height * 0.35),
      Offset(size.width * 0.7, size.height * 0.25),
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width * 0.9, size.height * 0.15),
      Offset(size.width, size.height * 0.1),
    ];

    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    // Fill area under curve
    final fillPaint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

  void _showFeaturePopup(BuildContext context, Map<String, dynamic> feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            feature['color'] as Color,
                            (feature['color'] as Color).withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        feature['icon'] as IconData,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        feature['title'] as String,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightOnBackground,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      feature['detailedDescription'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.lightOnSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Action Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Add navigation to feature page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: feature['color'] as Color,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Explore ${feature['title']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }












  Widget _buildTestimonialsSection(BuildContext context) {
    final testimonials = [
      {
        'name': 'Sarah Chen',
        'role': 'Day Trader',
        'avatar': '👩‍💼',
        'rating': 5,
        'text': 'VTrader transformed my trading completely. The analytics helped me identify that I was overtrading on Fridays and my win rate improved by 23% after adjusting my strategy.',
      },
      {
        'name': 'Michael Rodriguez',
        'role': 'Swing Trader',
        'avatar': '👨‍💻',
        'rating': 5,
        'text': 'The multi-broker integration is a game-changer. I can manage my IB and TD accounts from one place, and the unified P&L tracking gives me a clear picture of my performance.',
      },
      {
        'name': 'David Kim',
        'role': 'Options Trader',
        'avatar': '👨‍🎓',
        'rating': 5,
        'text': 'The risk management tools saved me from several large losses. The position sizing calculator and daily limits keep me disciplined and consistent with my trading plan.',
      },
    ];

    final isMobile = MediaQuery.of(context).size.width <= 768;
    final isTablet = MediaQuery.of(context).size.width > 768 && MediaQuery.of(context).size.width <= 1024;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: isMobile ? 60 : 100,
      ),
      color: AppColors.primary.withOpacity(0.02),
      child: Column(
        children: [
          Text(
            'Trusted by Professional Traders Worldwide',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.lightOnBackground,
              letterSpacing: -0.5,
              fontSize: isMobile ? 20 : 28,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 40 : 80),
          
          // Responsive testimonials layout
          if (isMobile)
            // Mobile: Single column
            Column(
              children: testimonials.map((testimonial) => 
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: _buildTestimonialCard(context, testimonial, isMobile),
                ),
              ).toList(),
            )
          else if (isTablet)
            // Tablet: 2 columns
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildTestimonialCard(context, testimonials[0], isMobile),
                      const SizedBox(height: 20),
                      _buildTestimonialCard(context, testimonials[1], isMobile),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildTestimonialCard(context, testimonials[2], isMobile),
                ),
              ],
            )
          else
            // Desktop: 3 columns
            Row(
              children: testimonials.map((testimonial) => 
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: _buildTestimonialCard(context, testimonial, isMobile),
                  ),
                ),
              ).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(BuildContext context, Map<String, dynamic> testimonial, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: isMobile ? 12 : 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Star rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) => Icon(
              Icons.star_rounded,
              color: index < testimonial['rating'] ? AppColors.warning : Colors.grey[300],
              size: isMobile ? 16 : 18,
            )),
          ),
          
          SizedBox(height: isMobile ? 16 : 20),
          
          // Testimonial text
          Text(
            testimonial['text'],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.5,
              fontSize: isMobile ? 13 : 14,
              fontStyle: FontStyle.italic,
              color: AppColors.lightOnSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: isMobile ? 20 : 24),
          
          // User info
          Row(
            children: [
              Container(
                width: isMobile ? 40 : 48,
                height: isMobile ? 40 : 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
                ),
                child: Center(
                  child: Text(
                    testimonial['avatar'],
                    style: TextStyle(fontSize: isMobile ? 16 : 20),
                  ),
                ),
              ),
              SizedBox(width: isMobile ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial['name'],
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 13 : 14,
                      ),
                    ),
                    Text(
                      testimonial['role'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.lightOnSurfaceVariant,
                        fontSize: isMobile ? 11 : 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 768;
    final isTablet = MediaQuery.of(context).size.width > 768 && MediaQuery.of(context).size.width <= 1024;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        children: [
          Text(
            'Choose Your Trading Plan',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.lightOnBackground,
              letterSpacing: -0.5,
              fontSize: isMobile ? 24 : 32,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 600,
            ),
            child: Text(
              'Start free and upgrade as your trading grows. All plans include our core features with no hidden fees.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.lightOnSurfaceVariant,
                height: 1.5,
                fontSize: isMobile ? 14 : 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: isMobile ? 40 : 80),
          
          // Responsive pricing cards
          if (isMobile)
            // Mobile: Single column
            Column(
              children: [
                _buildPricingCard(context, 'Starter', 'Free', 'Perfect for new traders', [
                  'Up to 100 trades/month',
                  'Basic analytics dashboard',
                  '2 broker connections',
                  'Email support',
                  'Mobile app access',
                ], false, isMobile),
                const SizedBox(height: 20),
                _buildPricingCard(context, 'Professional', '\$29/month', 'For serious traders', [
                  'Unlimited trades',
                  'Advanced analytics & reports',
                  'All broker integrations',
                  'AI pattern recognition',
                  'Priority support',
                  'Custom strategies',
                  'API access',
                ], true, isMobile),
                const SizedBox(height: 20),
                _buildPricingCard(context, 'Enterprise', 'Custom', 'For trading firms', [
                  'Everything in Professional',
                  'Multi-user accounts',
                  'White-label solution',
                  'Custom integrations',
                  'Dedicated account manager',
                  'Advanced security',
                  'Custom reporting',
                ], false, isMobile),
              ],
            )
          else if (isTablet)
            // Tablet: 2 columns
            Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildPricingCard(context, 'Starter', 'Free', 'Perfect for new traders', [
                      'Up to 100 trades/month',
                      'Basic analytics dashboard',
                      '2 broker connections',
                      'Email support',
                    ], false, isMobile)),
                    const SizedBox(width: 20),
                    Expanded(child: _buildPricingCard(context, 'Professional', '\$29/month', 'For serious traders', [
                      'Unlimited trades',
                      'Advanced analytics & reports',
                      'All broker integrations',
                      'AI pattern recognition',
                      'Priority support',
                    ], true, isMobile)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: _buildPricingCard(context, 'Enterprise', 'Custom', 'For trading firms', [
                    'Everything in Professional',
                    'Multi-user accounts',
                    'White-label solution',
                    'Custom integrations',
                    'Dedicated account manager',
                  ], false, isMobile),
                ),
              ],
            )
          else
            // Desktop: 3 columns
            Row(
              children: [
                Expanded(child: _buildPricingCard(context, 'Starter', 'Free', 'Perfect for new traders', [
                  'Up to 100 trades/month',
                  'Basic analytics dashboard',
                  '2 broker connections',
                  'Email support',
                  'Mobile app access',
                ], false, isMobile)),
                const SizedBox(width: 24),
                Expanded(child: _buildPricingCard(context, 'Professional', '\$29/month', 'For serious traders', [
                  'Unlimited trades',
                  'Advanced analytics & reports',
                  'All broker integrations',
                  'AI pattern recognition',
                  'Priority support',
                  'Custom strategies',
                  'API access',
                ], true, isMobile)),
                const SizedBox(width: 24),
                Expanded(child: _buildPricingCard(context, 'Enterprise', 'Custom', 'For trading firms', [
                  'Everything in Professional',
                  'Multi-user accounts',
                  'White-label solution',
                  'Custom integrations',
                  'Dedicated account manager',
                  'Advanced security',
                  'Custom reporting',
                ], false, isMobile)),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPricingCard(
    BuildContext context,
    String title,
    String price,
    String description,
    List<String> features,
    bool isPopular,
    bool isMobile,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        border: isPopular ? Border.all(color: AppColors.success, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: isMobile ? 16 : 24,
            offset: const Offset(0, 8),
          ),
          if (isPopular)
            BoxShadow(
              color: AppColors.success.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        children: [
          // Popular badge
          if (isPopular)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMobile ? 16 : 20),
                  topRight: Radius.circular(isMobile ? 16 : 20),
                ),
              ),
              child: Text(
                'Most Popular',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 11 : 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          
          Padding(
            padding: EdgeInsets.all(isMobile ? 20 : 24),
            child: Column(
              children: [
                // Plan title
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 18 : 20,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Price
                Text(
                  price,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: isMobile ? 28 : 36,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Description
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.lightOnSurfaceVariant,
                    fontSize: isMobile ? 13 : 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: isMobile ? 24 : 32),
                
                // Features list
                Column(
                  children: features.map((feature) => 
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: isMobile ? 20 : 24,
                            height: isMobile ? 20 : 24,
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              color: AppColors.success,
                              size: isMobile ? 14 : 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: isMobile ? 13 : 14,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).toList(),
                ),
                
                SizedBox(height: isMobile ? 24 : 32),
                
                // CTA Button
                SizedBox(
                  width: double.infinity,
                  height: isMobile ? 44 : 48,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add navigation logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPopular ? AppColors.success : AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                      ),
                    ),
                    child: Text(
                      title == 'Starter' ? 'Get Started' : 
                      title == 'Professional' ? 'Start Free Trial' : 
                      'Contact Sales',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: isMobile ? 14 : 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallToActionSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 100),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Ready to Transform Your Trading?',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'Join thousands of traders who have already improved their performance with VTrader. Start your free trial today and see the difference professional-grade tools can make.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white.withOpacity(0.9),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => context.push('/register'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.rocket_launch_rounded, size: 20),
                    SizedBox(width: 12),
                    Text(
                      'Start Free Trial',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_circle_outline_rounded, size: 20),
                    SizedBox(width: 12),
                    Text(
                      'Watch Demo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 768;
    final isTablet = MediaQuery.of(context).size.width > 768 && MediaQuery.of(context).size.width <= 1024;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1a1a2e),
            const Color(0xFF16213e),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 32,
              vertical: isMobile ? 60 : 80,
            ),
            child: Column(
              children: [
                // Main footer content
                if (isMobile)
                  _buildMobileFooterLayout(context)
                else if (isTablet)
                  _buildTabletFooterLayout(context)
                else
                  _buildDesktopFooterLayout(context),
                
                SizedBox(height: isMobile ? 40 : 60),
                
                // Divider
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: isMobile ? 24 : 32),
                
                // Bottom section
                if (isMobile)
                  Column(
                    children: [
                      Text(
                        '© 2024 VTrader. All rights reserved.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Made with ❤️ for professional traders',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '© 2024 VTrader. All rights reserved.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      Text(
                        'Made with ❤️ for professional traders',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFooterLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand section
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo and brand
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.trending_up_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'VTrader Pro',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Description
              Container(
                constraints: const BoxConstraints(maxWidth: 300),
                child: Text(
                  'The ultimate trading companion for professional traders. Advanced analytics, multi-broker integration, and intelligent insights to maximize your trading performance.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    height: 1.6,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Social media
              Row(
                children: [
                  _buildModernSocialButton(context, Icons.email_rounded, 'Email'),
                  const SizedBox(width: 12),
                  _buildModernSocialButton(context, Icons.phone_rounded, 'Phone'),
                  const SizedBox(width: 12),
                  _buildModernSocialButton(context, Icons.language_rounded, 'Website'),
                  const SizedBox(width: 12),
                  _buildModernSocialButton(context, Icons.support_agent_rounded, 'Support'),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(width: 60),
        
        // Navigation columns
        Expanded(
          child: _buildModernFooterColumn(context, 'Platform', [
            'Trade Journal',
            'Multi-Broker',
            'Analytics Suite',
            'Risk Management',
            'Strategy Testing',
            'Mobile App',
          ]),
        ),
        
        const SizedBox(width: 40),
        
        Expanded(
          child: _buildModernFooterColumn(context, 'Resources', [
            'Getting Started',
            'Documentation',
            'API Reference',
            'Video Tutorials',
            'Trading Guides',
            'Market Insights',
          ]),
        ),
        
        const SizedBox(width: 40),
        
        Expanded(
          child: _buildModernFooterColumn(context, 'Support', [
            'Help Center',
            'Live Chat',
            'Community Forum',
            'Contact Sales',
            'Feature Requests',
            'Status Page',
          ]),
        ),
        
        const SizedBox(width: 40),
        
        Expanded(
          child: _buildModernFooterColumn(context, 'Company', [
            'About Us',
            'Careers',
            'Press Kit',
            'Privacy Policy',
            'Terms of Service',
            'Security',
          ]),
        ),
      ],
    );
  }

  Widget _buildTabletFooterLayout(BuildContext context) {
    return Column(
      children: [
        // Brand section
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.trending_up_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'VTrader Pro',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        Text(
          'The ultimate trading companion for professional traders with advanced analytics and multi-broker integration.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.8),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 32),
        
        // Social media
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildModernSocialButton(context, Icons.email_rounded, 'Email'),
            const SizedBox(width: 12),
            _buildModernSocialButton(context, Icons.phone_rounded, 'Phone'),
            const SizedBox(width: 12),
            _buildModernSocialButton(context, Icons.language_rounded, 'Website'),
            const SizedBox(width: 12),
            _buildModernSocialButton(context, Icons.support_agent_rounded, 'Support'),
          ],
        ),
        
        const SizedBox(height: 40),
        
        // Navigation in 2x2 grid
        Row(
          children: [
            Expanded(
              child: _buildModernFooterColumn(context, 'Platform', [
                'Trade Journal',
                'Multi-Broker',
                'Analytics Suite',
                'Risk Management',
              ]),
            ),
            const SizedBox(width: 40),
            Expanded(
              child: _buildModernFooterColumn(context, 'Resources', [
                'Getting Started',
                'Documentation',
                'API Reference',
                'Video Tutorials',
              ]),
            ),
          ],
        ),
        
        const SizedBox(height: 32),
        
        Row(
          children: [
            Expanded(
              child: _buildModernFooterColumn(context, 'Support', [
                'Help Center',
                'Live Chat',
                'Community Forum',
                'Contact Sales',
              ]),
            ),
            const SizedBox(width: 40),
            Expanded(
              child: _buildModernFooterColumn(context, 'Company', [
                'About Us',
                'Careers',
                'Privacy Policy',
                'Terms of Service',
              ]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileFooterLayout(BuildContext context) {
    return Column(
      children: [
        // Brand section
        Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.trending_up_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'VTrader Pro',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'The ultimate trading companion for professional traders with advanced analytics and multi-broker integration.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.8),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        
        const SizedBox(height: 32),
        
        // Social media
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildModernSocialButton(context, Icons.email_rounded, 'Email'),
            const SizedBox(width: 12),
            _buildModernSocialButton(context, Icons.phone_rounded, 'Phone'),
            const SizedBox(width: 12),
            _buildModernSocialButton(context, Icons.language_rounded, 'Website'),
            const SizedBox(width: 12),
            _buildModernSocialButton(context, Icons.support_agent_rounded, 'Support'),
          ],
        ),
        
        const SizedBox(height: 40),
        
        // Navigation columns
        _buildModernFooterColumn(context, 'Platform', [
          'Trade Journal',
          'Multi-Broker',
          'Analytics Suite',
          'Risk Management',
        ]),
        
        const SizedBox(height: 24),
        
        _buildModernFooterColumn(context, 'Resources', [
          'Getting Started',
          'Documentation',
          'Video Tutorials',
          'Trading Guides',
        ]),
        
        const SizedBox(height: 24),
        
        _buildModernFooterColumn(context, 'Support', [
          'Help Center',
          'Live Chat',
          'Community Forum',
          'Contact Sales',
        ]),
        
        const SizedBox(height: 24),
        
        _buildModernFooterColumn(context, 'Company', [
          'About Us',
          'Privacy Policy',
          'Terms of Service',
          'Contact',
        ]),
      ],
    );
  }

  Widget _buildModernSocialButton(BuildContext context, IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // Add social media navigation
            },
            child: Icon(
              icon,
              color: Colors.white.withOpacity(0.8),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernFooterColumn(BuildContext context, String title, List<String> links) {
    final isMobile = MediaQuery.of(context).size.width <= 768;
    
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: isMobile ? 16 : 18,
          ),
        ),
        
        SizedBox(height: isMobile ? 16 : 20),
        
        ...links.map((link) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: () {
                // Add navigation logic
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  link,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: isMobile ? 14 : 15,
                  ),
                  textAlign: isMobile ? TextAlign.center : TextAlign.start,
                ),
              ),
            ),
          ),
        )),
      ],
    );
  }
