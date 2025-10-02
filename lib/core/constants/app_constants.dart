/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'VTrader';
  static const String appVersion = '1.0.0';
  static const String domain = 'vtrader.in';
  
  // API Configuration
  static const String baseUrl = 'https://apivtrader.a.pinggy.link';
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration retryDelay = Duration(seconds: 2);
  static const int maxRetries = 3;
  
  // API Endpoints
  static const String loginEndpoint = '/users/api/login';
  static const String logoutEndpoint = '/users/api/logout';
  static const String refreshTokenEndpoint = '/users/api/refresh';
  static const String userProfileEndpoint = '/users/api/profile';
  static const String registrationEndpoint = '/users/register';
  static const String tradesEndpoint = '/trades';
  static const String brokerMasterEndpoint = '/broker-mstr';
  static const String tagsEndpoint = '/tags';
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String userPreferencesKey = 'user_preferences';
  static const String brokerPreferencesKey = 'broker_preferences';
  static const String themeModeKey = 'theme_mode';
  static const String onboardingKey = 'onboarding_complete';
  
  // Hive Box Names
  static const String authBox = 'auth_box';
  static const String tradesBox = 'trades_box';
  static const String brokersBox = 'brokers_box';
  static const String settingsBox = 'settings_box';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Responsive Breakpoints
  static const double mobileBreakpoint = 450;
  static const double tabletBreakpoint = 800;
  static const double desktopBreakpoint = 1200;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 8.0;
  static const double largeRadius = 16.0;
  
  // Chart Constants
  static const double chartMinHeight = 300.0;
  static const double chartDefaultHeight = 400.0;
  static const int chartCandleLimit = 1000;
  
  // Trade Constants
  static const List<String> tradeStatuses = ['Open', 'Closed', 'Cancelled'];
  static const List<String> tradeTypes = ['Long', 'Short'];
  static const List<String> orderTypes = ['Market', 'Limit', 'Stop', 'Stop Limit'];
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxTradeNoteLength = 500;
  static const int maxStrategyNameLength = 50;
}

