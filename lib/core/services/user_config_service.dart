import 'package:shared_preferences/shared_preferences.dart';

class UserConfigService {
  static const String _userIdKey = 'user_id';
  static const String _brokerNameKey = 'broker_name';
  static const String _useLiveDataKey = 'use_live_data';
  
  // Singleton instance
  static final UserConfigService _instance = UserConfigService._internal();
  factory UserConfigService() => _instance;
  UserConfigService._internal();
  
  // Current configuration
  String _userId = '31';
  String _brokerName = 'FINVASIA';
  bool _useLiveData = false;
  
  // Getters
  String get userId => _userId;
  String get brokerName => _brokerName;
  bool get useLiveData => _useLiveData;
  
  // Initialize configuration
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    
    _userId = prefs.getString(_userIdKey) ?? '31';
    _brokerName = prefs.getString(_brokerNameKey) ?? 'FINVASIA';
    _useLiveData = prefs.getBool(_useLiveDataKey) ?? false;
  }
  
  // Update user ID
  Future<void> updateUserId(String userId) async {
    _userId = userId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }
  
  // Update broker name
  Future<void> updateBrokerName(String brokerName) async {
    _brokerName = brokerName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_brokerNameKey, brokerName);
  }
  
  // Toggle live data usage
  Future<void> toggleLiveData(bool useLiveData) async {
    _useLiveData = useLiveData;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_useLiveDataKey, useLiveData);
  }
  
  // Reset to defaults
  Future<void> resetToDefaults() async {
    _userId = '31';
    _brokerName = 'FINVASIA';
    _useLiveData = false;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_brokerNameKey);
    await prefs.remove(_useLiveDataKey);
  }
  
  // Get configuration summary
  Map<String, dynamic> getConfigSummary() {
    return {
      'userId': _userId,
      'brokerName': _brokerName,
      'useLiveData': _useLiveData,
      'baseUrl': 'https://apivtrader.a.pinggy.link',
    };
  }
}
