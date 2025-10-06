import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

// Mock classes
@GenerateMocks([http.Client])
import 'test_broker_sequence.mocks.dart';

// Test data
const testBrokers = [
  {
    "id": 4,
    "userId": 31,
    "brokerName": "FINVASIA",
    "brokerInfo": {
      "userId": "FA30962",
      "password": "Viren@008",
      "vendorCode": "FA30962_U",
      "apiKey": "APILi22112021AKLMAH1D9091",
      "secretKey": "",
      "twoFAKey": "73U37W6E2VH2E26E3332HR2EC2456OG4",
      "imei": "abc1234"
    },
    "isActive": true,
    "preferences": {
      "quantity": {"nifty": 225, "sensex": 60, "stocks": 10, "banknifty": 70},
      "brokerName": "FINVASIA",
      "displayName": "FINVASIA[FA30962]",
      "default": true  // This is the current default
    }
  },
  {
    "id": 3,
    "userId": 31,
    "brokerName": "ANGELONE",
    "brokerInfo": {
      "userId": "S2110038",
      "password": "1111",
      "vendorCode": "",
      "apiKey": "y4dy2E9o",
      "secretKey": "11e45d59-0151-4ee7-b961-9d9a8e42fac4",
      "twoFAKey": "SREPTMAVV6C7X4C7I7Q5ZFIP6I",
      "imei": "abcde"
    },
    "isActive": true,
    "preferences": {
      "quantity": {"nifty": 225, "sensex": 60, "stocks": 10, "banknifty": 70},
      "brokerName": "ANGELONE",
      "displayName": "ANGELONE[S2110038]",
      "default": false  // This is the target to make default
    }
  }
];

void main() {
  group('Broker Default Sequence Test', () {
    late MockClient mockClient;
    late List<Map<String, dynamic>> apiCallLog;

    setUp(() {
      mockClient = MockClient();
      apiCallLog = [];
    });

    test('Should call APIs in correct sequence when setting default broker', () async {
      // Arrange: Mock the HTTP client to capture API calls
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({
            "status": true,
            "data": testBrokers
          }), 200));

      // Mock PUT requests and capture the sequence
      when(mockClient.put(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((invocation) async {
            final uri = invocation.positionalArguments[0] as Uri;
            final body = invocation.namedArguments[#body] as String;
            
            // Log the API call
            apiCallLog.add({
              'method': 'PUT',
              'url': uri.toString(),
              'body': jsonDecode(body),
              'timestamp': DateTime.now().millisecondsSinceEpoch
            });
            
            // Return success response
            return http.Response(jsonEncode({
              "status": true,
              "data": jsonDecode(body)
            }), 200);
          });

      // Act: Simulate setting broker 3 as default
      await setDefaultBrokerSequence(3, mockClient);

      // Assert: Check the API call sequence
      expect(apiCallLog.length, equals(2), reason: 'Should make exactly 2 API calls');
      
      // First call should disable current default (broker 4)
      final firstCall = apiCallLog[0];
      expect(firstCall['url'], contains('/broker/4'), reason: 'First call should be to broker 4');
      expect(firstCall['body']['preferences']['default'], equals(false), reason: 'First call should set default=false');
      
      // Second call should enable new default (broker 3)
      final secondCall = apiCallLog[1];
      expect(secondCall['url'], contains('/broker/3'), reason: 'Second call should be to broker 3');
      expect(secondCall['body']['preferences']['default'], equals(true), reason: 'Second call should set default=true');
      
      // Verify sequence timing
      expect(firstCall['timestamp'], lessThan(secondCall['timestamp']), 
             reason: 'First call should happen before second call');
      
      print('✅ Test passed: API calls are in correct sequence');
      print('📋 API Call Log:');
      for (int i = 0; i < apiCallLog.length; i++) {
        final call = apiCallLog[i];
        print('  ${i + 1}. ${call['method']} ${call['url']}');
        print('     Body: ${call['body']['preferences']['default']}');
      }
    });

    test('Should handle API errors correctly', () async {
      // Arrange: Mock first API call to fail
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({
            "status": true,
            "data": testBrokers
          }), 200));

      when(mockClient.put(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((invocation) async {
            final uri = invocation.positionalArguments[0] as Uri;
            
            // First call (disable) succeeds
            if (uri.toString().contains('/broker/4')) {
              apiCallLog.add({
                'method': 'PUT',
                'url': uri.toString(),
                'success': true
              });
              return http.Response(jsonEncode({
                "status": true,
                "data": {"preferences": {"default": false}}
              }), 200);
            }
            
            // Second call (enable) fails
            if (uri.toString().contains('/broker/3')) {
              apiCallLog.add({
                'method': 'PUT',
                'url': uri.toString(),
                'success': false
              });
              return http.Response(jsonEncode({
                "errorCode": "APPLICATION_ERROR",
                "httpStatus": 409,
                "message": "Can't be default broker. Please disable other broker as default!!!"
              }), 409);
            }
            
            return http.Response('{}', 200);
          });

      // Act & Assert: Should throw error
      expect(() => setDefaultBrokerSequence(3, mockClient), throwsException);
      
      // Should have made both calls
      expect(apiCallLog.length, equals(2));
      expect(apiCallLog[0]['success'], equals(true));
      expect(apiCallLog[1]['success'], equals(false));
      
      print('✅ Test passed: Error handling works correctly');
    });
  });
}

// Simulate the broker default sequence logic
Future<void> setDefaultBrokerSequence(int targetBrokerId, http.Client client) async {
  print('🔄 Starting broker default sequence test...');
  
  // Step 1: Get current brokers
  final response = await client.get(
    Uri.parse('https://apivtrader.a.pinggy.link/broker'),
    headers: {'authorization': 'Bearer test-token'}
  );
  
  final brokersData = jsonDecode(response.body)['data'] as List;
  print('📊 Found ${brokersData.length} brokers');
  
  // Step 2: Find current default broker
  final currentDefault = brokersData.firstWhere(
    (broker) => broker['preferences']['default'] == true,
    orElse: () => throw Exception('No current default broker found')
  );
  
  print('🎯 Current default: Broker ${currentDefault['id']} (${currentDefault['brokerName']})');
  print('🎯 Target: Broker $targetBrokerId');
  
  if (currentDefault['id'] == targetBrokerId) {
    print('ℹ️ Target broker is already default. No action needed.');
    return;
  }
  
  // Step 3: Disable current default broker
  print('🔄 Step 1: Disabling current default broker ${currentDefault['id']}...');
  
  final brokerToDisable = Map<String, dynamic>.from(currentDefault);
  brokerToDisable['preferences'] = Map<String, dynamic>.from(currentDefault['preferences']);
  brokerToDisable['preferences']['default'] = false;
  
  final disableResponse = await client.put(
    Uri.parse('https://apivtrader.a.pinggy.link/broker/${currentDefault['id']}'),
    headers: {
      'authorization': 'Bearer test-token',
      'Content-Type': 'application/json'
    },
    body: jsonEncode(brokerToDisable)
  );
  
  if (disableResponse.statusCode != 200) {
    throw Exception('Failed to disable default broker: ${disableResponse.body}');
  }
  
  print('✅ Successfully disabled default for broker ${currentDefault['id']}');
  
  // Step 4: Enable target broker as default
  print('🔄 Step 2: Enabling target broker $targetBrokerId as default...');
  
  final targetBroker = brokersData.firstWhere((b) => b['id'] == targetBrokerId);
  final brokerToEnable = Map<String, dynamic>.from(targetBroker);
  brokerToEnable['preferences'] = Map<String, dynamic>.from(targetBroker['preferences']);
  brokerToEnable['preferences']['default'] = true;
  
  final enableResponse = await client.put(
    Uri.parse('https://apivtrader.a.pinggy.link/broker/$targetBrokerId'),
    headers: {
      'authorization': 'Bearer test-token',
      'Content-Type': 'application/json'
    },
    body: jsonEncode(brokerToEnable)
  );
  
  if (enableResponse.statusCode != 200) {
    throw Exception('Failed to enable default broker: ${enableResponse.body}');
  }
  
  print('✅ Successfully enabled default for broker $targetBrokerId');
  print('🎉 Broker default sequence completed successfully!');
}
