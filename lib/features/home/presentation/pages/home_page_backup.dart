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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 100),
      child: Column(
        children: [
          Text(
            'Everything You Need to Trade Like a Pro',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.lightOnBackground,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Text(
              'Comprehensive tools and analytics to help you identify patterns, improve consistency, and maximize your trading performance.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.lightOnSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 80),
          _buildDetailedFeatureCard(
            context,
            Icons.book_rounded,
            'Advanced Trade Journaling',
            'Comprehensive Trade Documentation & Analysis',
            'Transform your trading with our intelligent journaling system that goes far beyond simple trade logging. Automatically sync trades from 15+ major brokers including Interactive Brokers, TD Ameritrade, E*TRADE, and Charles Schwab, or manually log every detail with our intuitive interface. Add rich context with detailed notes, screenshots, market conditions, emotional states, and trade rationale. Our AI-powered analysis engine examines your entries to identify patterns in your behavior, helping you understand what drives your best and worst trades. Tag trades by strategy, setup, or market conditions for easy filtering and analysis. Group related trades to track the performance of specific approaches over time. Export comprehensive reports for tax purposes or performance reviews with professional traders.',
            [
              'Auto-sync from 15+ major brokers',
              'Rich media attachments & screenshots',
              'AI pattern recognition & insights',
              'Custom tagging & categorization system',
              'Strategy performance tracking over time',
              'Professional reporting & tax exports',
            ],
            true,
          ),
          const SizedBox(height: 60),
          _buildDetailedFeatureCard(
            context,
            Icons.account_tree_rounded,
            'Multi-Broker Integration',
            'Unified Trading Across All Your Accounts',
            'Revolutionize your trading workflow with our comprehensive multi-broker integration platform. Manage multiple broker accounts from a single, powerful interface without the hassle of switching between different platforms. Connect to leading brokers including Interactive Brokers, TD Ameritrade, E*TRADE, Charles Schwab, Fidelity, and more through secure API connections. Execute trades simultaneously across multiple accounts with our advanced one-click trading system that ensures optimal execution timing. Monitor positions, orders, and P&L in real-time across all your accounts with unified dashboards. Our secure API connections ensure your data is always protected while providing instant access to your trading information. Perfect for traders who want to diversify across brokers, manage multiple strategies, or consolidate their trading operations.',
            [
              '15+ major broker integrations',
              'One-click multi-account trading',
              'Real-time position & order monitoring',
              'Bank-grade secure API connections',
              'Unified P&L tracking across accounts',
              'Advanced order management tools',
            ],
            false,
          ),
          const SizedBox(height: 60),
          _buildDetailedFeatureCard(
            context,
            Icons.analytics_rounded,
            'Professional Analytics Suite',
            'Data-Driven Insights for Better Decisions',
            'Unlock the power of your trading data with our comprehensive analytics engine designed by professional traders for professional traders. Track key performance metrics including win rate, profit factor, Sharpe ratio, maximum drawdown, and risk-adjusted returns. Analyze performance across different timeframes, instruments, and market conditions with our advanced filtering system. Our interactive heat maps reveal your most and least profitable trading hours, days, and setups, helping you optimize your trading schedule. Advanced risk metrics help you understand your risk-adjusted returns and identify areas for improvement. Generate detailed reports for tax purposes, performance reviews, or sharing with mentors. Our Monte Carlo simulations help you understand potential outcomes and plan for various market scenarios.',
            [
              'Advanced performance metrics & KPIs',
              'Risk-adjusted analytics & Sharpe ratios',
              'Interactive heat maps & visualizations',
              'Custom reporting & export tools',
              'Tax-ready exports & documentation',
              'Monte Carlo simulation & forecasting',
            ],
            true,
          ),
          const SizedBox(height: 60),
          _buildDetailedFeatureCard(
            context,
            Icons.calculate_rounded,
            'Smart Money Management',
            'Protect Your Capital with Advanced Risk Tools',
            'Professional-grade risk management tools to protect and grow your capital with precision and discipline. Our dynamic position sizing calculator considers your account size, risk tolerance, trade setup, and market volatility to recommend optimal position sizes for every trade. Set daily, weekly, and monthly risk limits with automatic alerts when you approach them, ensuring you never risk more than you can afford to lose. Track your risk-reward ratios and ensure every trade meets your criteria before execution with our pre-trade validation system. Our Monte Carlo simulations help you understand potential outcomes and plan for various market scenarios. Advanced portfolio analytics help you understand correlation between positions and optimize your overall risk exposure.',
            [
              'Dynamic position sizing calculator',
              'Multi-timeframe risk limits & alerts',
              'R-multiple tracking & analysis',
              'Monte Carlo simulations & forecasting',
              'Real-time risk monitoring & alerts',
              'Portfolio correlation & optimization',
            ],
            false,
          ),
          const SizedBox(height: 60),
          _buildDetailedFeatureCard(
            context,
            Icons.group_work_rounded,
            'Strategy Development & Backtesting',
            'Build, Test, and Refine Your Trading Edge',
            'Develop and validate your trading strategies with our comprehensive backtesting engine powered by years of historical market data. Import historical data for any instrument and test your strategies across different market conditions including bull markets, bear markets, and sideways markets. Our visual strategy builder allows you to define entry and exit rules, risk parameters, and position sizing logic with an intuitive drag-and-drop interface. Analyze strategy performance with detailed metrics including win rate, profit factor, maximum drawdown, and risk-adjusted returns. Compare multiple strategies side-by-side to identify your most profitable approaches. Forward-test new strategies with paper trading integration before risking real capital. Our optimization tools help you fine-tune parameters for maximum performance.',
            [
              'Historical data backtesting engine',
              'Visual strategy builder & editor',
              'Performance optimization & tuning',
              'Strategy comparison & analysis tools',
              'Paper trading integration & testing',
              'Advanced parameter optimization',
            ],
            true,
          ),
        ],
      ),
    );
  }









  Widget _buildDetailedFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    String description,
    List<String> features,
    bool imageOnLeft,
  ) {
    final cardContent = Row(
      children: [
        if (imageOnLeft) _buildFeatureImage(context, icon),
        if (imageOnLeft) const SizedBox(width: 80),
        Expanded(
          child: _buildFeatureContent(context, title, subtitle, description, features),
        ),
        if (!imageOnLeft) const SizedBox(width: 80),
        if (!imageOnLeft) _buildFeatureImage(context, icon),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: cardContent,
    );
  }

  Widget _buildFeatureImage(BuildContext context, IconData icon) {
    return Container(
      width: 300,
      height: 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 60,
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureContent(
    BuildContext context,
    String title,
    String subtitle,
    String description,
    List<String> features,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.lightOnBackground,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.lightOnSurfaceVariant,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),
        ...features.map((feature) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  feature,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 100),
      color: AppColors.primary.withOpacity(0.02),
      child: Column(
        children: [
          Text(
            'Trusted by Professional Traders Worldwide',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.lightOnBackground,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 80),
          Row(
            children: testimonials.map((testimonial) => 
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildTestimonialCard(context, testimonial),
                ),
              ),
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(BuildContext context, Map<String, dynamic> testimonial) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(5, (index) => Icon(
              Icons.star_rounded,
              color: index < testimonial['rating'] ? AppColors.warning : Colors.grey[300],
              size: 20,
            )),
          ),
          const SizedBox(height: 24),
          Text(
            testimonial['text'],
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    testimonial['avatar'],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial['name'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      testimonial['role'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.lightOnSurfaceVariant,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 100),
      child: Column(
        children: [
          Text(
            'Simple, Transparent Pricing',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.lightOnBackground,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Start free, upgrade when you\'re ready. No hidden fees.',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.lightOnSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 80),
          Row(
            children: [
              Expanded(
                child: _buildPricingCard(
                  context,
                  'Starter',
                  'Free',
                  'Perfect for new traders',
                  [
                    'Up to 100 trades/month',
                    'Basic analytics',
                    '2 broker connections',
                    'Email support',
                  ],
                  false,
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: _buildPricingCard(
                  context,
                  'Professional',
                  '\$29/month',
                  'For serious traders',
                  [
                    'Unlimited trades',
                    'Advanced analytics',
                    'All broker integrations',
                    'Priority support',
                    'Custom reports',
                    'API access',
                  ],
                  true,
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: _buildPricingCard(
                  context,
                  'Enterprise',
                  'Custom',
                  'For trading firms',
                  [
                    'Multi-user accounts',
                    'White-label solution',
                    'Custom integrations',
                    'Dedicated support',
                    'Advanced security',
                  ],
                  false,
                ),
              ),
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
  ) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isPopular ? Border.all(color: AppColors.primary, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isPopular ? 0.12 : 0.08),
            blurRadius: isPopular ? 32 : 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Most Popular',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (isPopular) const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.lightOnSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          ...features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    feature,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/register'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isPopular ? AppColors.primary : Colors.grey[100],
                foregroundColor: isPopular ? Colors.white : AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                title == 'Enterprise' ? 'Contact Sales' : 'Get Started',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
      color: AppColors.lightOnBackground,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.primaryLight],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.trending_up_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'VTrader',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Professional trading platform trusted by thousands of traders worldwide. Transform your trading with advanced analytics and multi-broker integration.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        _buildSocialButton(context, Icons.facebook_rounded),
                        const SizedBox(width: 16),
                        _buildSocialButton(context, Icons.link_rounded),
                        const SizedBox(width: 16),
                        _buildSocialButton(context, Icons.email_rounded),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 80),
              Expanded(
                child: _buildFooterColumn(context, 'Product', [
                  'Features',
                  'Pricing',
                  'Integrations',
                  'API Docs',
                  'Changelog',
                ]),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: _buildFooterColumn(context, 'Company', [
                  'About Us',
                  'Careers',
                  'Press Kit',
                  'Contact',
                  'Blog',
                ]),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: _buildFooterColumn(context, 'Support', [
                  'Help Center',
                  'Community',
                  'Tutorials',
                  'Status Page',
                  'Bug Reports',
                ]),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: _buildFooterColumn(context, 'Legal', [
                  'Privacy Policy',
                  'Terms of Service',
                  'Cookie Policy',
                  'GDPR',
                  'Security',
                ]),
              ),
            ],
          ),
          const SizedBox(height: 60),
          const Divider(color: Colors.white24),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2024 VTrader. All rights reserved.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              Row(
                children: [
                  Text(
                    'Made with ❤️ for traders',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: Colors.white.withOpacity(0.8),
        size: 20,
      ),
    );
  }

  Widget _buildFooterColumn(BuildContext context, String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        ...links.map((link) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            link,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        )),
      ],
    );
  }
}
