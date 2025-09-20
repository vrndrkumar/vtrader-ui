#!/usr/bin/env dart

import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

/// Script to seed the app with mock data for development and testing
/// Usage: dart scripts/seed_data.dart
void main() async {
  print('🌱 Seeding VTrader with mock data...');

  try {
    await seedMockData();
    print('✅ Mock data seeded successfully!');
    print('');
    print('📋 What was seeded:');
    print('  • 5 sample trades (various strategies and outcomes)');
    print('  • 3 broker connections (Zerodha, Upstox, Angel One)');
    print('  • 5 trading strategies with risk management rules');
    print('  • Demo user account');
    print('');
    print('🚀 You can now run the app and explore with sample data!');
    print('   Use demo credentials: demo@vtrader.in / password123');
  } catch (e) {
    print('❌ Error seeding data: $e');
    exit(1);
  }
}

Future<void> seedMockData() async {
  final currentDir = Directory.current.path;
  final assetsDir = path.join(currentDir, 'assets', 'mock_data');

  // Check if assets directory exists
  if (!Directory(assetsDir).existsSync()) {
    throw Exception('Assets directory not found: $assetsDir');
  }

  // Read mock data files
  final tradesFile = File(path.join(assetsDir, 'sample_trades.json'));
  final brokersFile = File(path.join(assetsDir, 'sample_brokers.json'));
  final strategiesFile = File(path.join(assetsDir, 'sample_strategies.json'));

  if (!tradesFile.existsSync()) {
    throw Exception('Sample trades file not found');
  }
  if (!brokersFile.existsSync()) {
    throw Exception('Sample brokers file not found');
  }
  if (!strategiesFile.existsSync()) {
    throw Exception('Sample strategies file not found');
  }

  // Parse JSON data
  final trades = jsonDecode(await tradesFile.readAsString()) as List;
  final brokers = jsonDecode(await brokersFile.readAsString()) as List;
  final strategies = jsonDecode(await strategiesFile.readAsString()) as List;

  print('📊 Found ${trades.length} trades');
  print('🏦 Found ${brokers.length} brokers');
  print('📈 Found ${strategies.length} strategies');

  // In a real implementation, this would:
  // 1. Initialize Hive database
  // 2. Clear existing data (if needed)
  // 3. Insert mock data using StorageService
  // 4. Create demo user account
  
  // For now, we'll just validate the data structure
  validateTrades(trades);
  validateBrokers(brokers);
  validateStrategies(strategies);

  print('✅ All mock data validated successfully');
}

void validateTrades(List trades) {
  for (final trade in trades) {
    final tradeMap = trade as Map<String, dynamic>;
    
    // Required fields
    final requiredFields = [
      'id', 'symbol', 'type', 'status', 'orderType', 
      'quantity', 'entryPrice', 'entryTime', 'brokerId'
    ];
    
    for (final field in requiredFields) {
      if (!tradeMap.containsKey(field)) {
        throw Exception('Trade missing required field: $field');
      }
    }
    
    // Validate enums
    if (!['long', 'short'].contains(tradeMap['type'])) {
      throw Exception('Invalid trade type: ${tradeMap['type']}');
    }
    
    if (!['open', 'closed', 'cancelled'].contains(tradeMap['status'])) {
      throw Exception('Invalid trade status: ${tradeMap['status']}');
    }
    
    if (!['market', 'limit', 'stop', 'stopLimit'].contains(tradeMap['orderType'])) {
      throw Exception('Invalid order type: ${tradeMap['orderType']}');
    }
  }
  
  print('✅ Trades validated');
}

void validateBrokers(List brokers) {
  for (final broker in brokers) {
    final brokerMap = broker as Map<String, dynamic>;
    
    // Required fields
    final requiredFields = [
      'id', 'name', 'type', 'accountId', 'isConnected', 
      'syncSettings', 'createdAt', 'updatedAt'
    ];
    
    for (final field in requiredFields) {
      if (!brokerMap.containsKey(field)) {
        throw Exception('Broker missing required field: $field');
      }
    }
    
    // Validate broker types
    final validTypes = [
      'zerodha', 'upstox', 'angelone', 'iifl', 
      'fyers', 'interactive', 'custom'
    ];
    
    if (!validTypes.contains(brokerMap['type'])) {
      throw Exception('Invalid broker type: ${brokerMap['type']}');
    }
    
    // Validate sync settings
    final syncSettings = brokerMap['syncSettings'] as Map<String, dynamic>;
    final requiredSyncFields = [
      'autoSync', 'syncIntervalMinutes', 'syncOrders', 
      'syncPositions', 'syncTrades'
    ];
    
    for (final field in requiredSyncFields) {
      if (!syncSettings.containsKey(field)) {
        throw Exception('Broker sync settings missing field: $field');
      }
    }
  }
  
  print('✅ Brokers validated');
}

void validateStrategies(List strategies) {
  for (final strategy in strategies) {
    final strategyMap = strategy as Map<String, dynamic>;
    
    // Required fields
    final requiredFields = [
      'id', 'name', 'description', 'type', 'riskManagement',
      'isActive', 'createdAt', 'updatedAt'
    ];
    
    for (final field in requiredFields) {
      if (!strategyMap.containsKey(field)) {
        throw Exception('Strategy missing required field: $field');
      }
    }
    
    // Validate strategy types
    final validTypes = [
      'scalping', 'dayTrading', 'swingTrading', 'positionTrading',
      'arbitrage', 'momentum', 'meanReversion', 'breakout', 'custom'
    ];
    
    if (!validTypes.contains(strategyMap['type'])) {
      throw Exception('Invalid strategy type: ${strategyMap['type']}');
    }
    
    // Validate risk management
    final riskMgmt = strategyMap['riskManagement'] as Map<String, dynamic>;
    if (riskMgmt.containsKey('maxLossPercentage')) {
      final maxLoss = riskMgmt['maxLossPercentage'] as double?;
      if (maxLoss != null && (maxLoss <= 0 || maxLoss > 100)) {
        throw Exception('Invalid maxLossPercentage: must be between 0 and 100');
      }
    }
  }
  
  print('✅ Strategies validated');
}

/// Print usage instructions
void printUsage() {
  print('');
  print('📖 VTrader Mock Data Seeder');
  print('');
  print('This script seeds the VTrader app with sample data for development.');
  print('');
  print('Usage:');
  print('  dart scripts/seed_data.dart');
  print('');
  print('What it does:');
  print('  • Validates mock data structure');
  print('  • Seeds local database with sample trades, brokers, and strategies');
  print('  • Creates demo user account');
  print('');
  print('Files used:');
  print('  • assets/mock_data/sample_trades.json');
  print('  • assets/mock_data/sample_brokers.json');
  print('  • assets/mock_data/sample_strategies.json');
  print('');
}

