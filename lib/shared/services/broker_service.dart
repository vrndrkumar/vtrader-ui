import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/broker_models.dart';
import '../../core/constants/app_constants.dart';
import '../../core/config/api_config.dart';
import 'api_service.dart';

class BrokerService {
  static const String _basePath = '/broker';

  /// Get all brokers for the current user
  static Future<BrokersResponse> getBrokers() async {
    try {
      print('Fetching brokers from: ${AppConstants.baseUrl}$_basePath');
      
      final response = await ApiService.instance.get(_basePath);
      
      print('Brokers API response status: ${response.statusCode}');
      
      if (response.success && response.data != null) {
        return BrokersResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to fetch brokers: ${response.error}');
      }
    } catch (e) {
      print('Error fetching brokers: $e');
      rethrow;
    }
  }

  /// Add a new broker
  static Future<Broker> addBroker(Broker broker) async {
    try {
      print('Adding broker to: ${AppConstants.baseUrl}$_basePath');
      
      final response = await ApiService.instance.post(
        _basePath,
        body: broker.toJson(),
      );
      
      print('Add broker API response status: ${response.statusCode}');
      
      if (response.success && response.data != null) {
        return Broker.fromJson(response.data['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Failed to add broker: ${response.error}');
      }
    } catch (e) {
      print('Error adding broker: $e');
      rethrow;
    }
  }

  /// Update an existing broker
  static Future<Broker> updateBroker(int brokerId, Broker broker) async {
    try {
      print('Updating broker at: ${AppConstants.baseUrl}$_basePath/$brokerId');
      print('Broker data being sent: ${broker.toJson()}');
      
      final response = await ApiService.instance.put(
        '$_basePath/$brokerId',
        body: broker.toJson(),
      );
      
      print('Update broker API response status: ${response.statusCode}');
      
      if (response.success && response.data != null) {
        return Broker.fromJson(response.data['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Failed to update broker: ${response.error}');
      }
    } catch (e) {
      print('Error updating broker: $e');
      rethrow;
    }
  }

  /// Delete a broker
  static Future<void> deleteBroker(int brokerId) async {
    try {
      print('Deleting broker at: ${AppConstants.baseUrl}$_basePath/$brokerId');
      
      final response = await ApiService.instance.delete('$_basePath/$brokerId');
      
      print('Delete broker API response status: ${response.statusCode}');
      
      if (!response.success) {
        throw Exception('Failed to delete broker: ${response.error}');
      }
    } catch (e) {
      print('Error deleting broker: $e');
      rethrow;
    }
  }

  /// Test broker connection
  static Future<bool> testBrokerConnection(Broker broker) async {
    try {
      // This would typically make a test API call to the broker
      // For now, we'll simulate a test
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate success/failure based on broker name
      return broker.brokerName.isNotEmpty;
    } catch (e) {
      print('Error testing broker connection: $e');
      return false;
    }
  }

  /// Get available broker names from master data
  static Future<List<String>> getAvailableBrokerNames() async {
    try {
      // This would fetch from broker master API
      // For now, return static list
      return ['FINVASIA', 'ANGELONE', 'DHAN', 'FYERS'];
    } catch (e) {
      print('Error fetching broker names: $e');
      return [];
    }
  }
}