import 'package:json_annotation/json_annotation.dart';

part 'broker_models.g.dart';

/// Broker information model
@JsonSerializable()
class BrokerInfo {
  final String userId;
  final String password;
  final String vendorCode;
  final String apiKey;
  final String secretKey;
  final String twoFAKey;
  final String imei;

  const BrokerInfo({
    required this.userId,
    required this.password,
    required this.vendorCode,
    required this.apiKey,
    required this.secretKey,
    required this.twoFAKey,
    required this.imei,
  });

  factory BrokerInfo.fromJson(Map<String, dynamic> json) => _$BrokerInfoFromJson(json);
  Map<String, dynamic> toJson() => _$BrokerInfoToJson(this);
}

/// Broker quantity preferences
@JsonSerializable()
class BrokerQuantity {
  final int nifty;
  final int sensex;
  final int stocks;
  final int banknifty;

  const BrokerQuantity({
    required this.nifty,
    required this.sensex,
    required this.stocks,
    required this.banknifty,
  });

  factory BrokerQuantity.fromJson(Map<String, dynamic> json) => _$BrokerQuantityFromJson(json);
  Map<String, dynamic> toJson() => _$BrokerQuantityToJson(this);
}

/// Broker preferences
@JsonSerializable()
class BrokerPreferences {
  final BrokerQuantity quantity;
  final String brokerName;
  final String displayName;
  final bool defaultBroker;

  const BrokerPreferences({
    required this.quantity,
    required this.brokerName,
    required this.displayName,
    required this.defaultBroker,
  });

  factory BrokerPreferences.fromJson(Map<String, dynamic> json) => _$BrokerPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$BrokerPreferencesToJson(this);
}

/// Complete broker model
@JsonSerializable()
class Broker {
  final int? id;
  final int? userId;
  final BrokerInfo brokerInfo;
  final bool isActive;
  final String brokerName;
  final BrokerPreferences preferences;
  final String? createdAt;
  final String? updatedAt;

  const Broker({
    this.id,
    this.userId,
    required this.brokerInfo,
    required this.isActive,
    required this.brokerName,
    required this.preferences,
    this.createdAt,
    this.updatedAt,
  });

  factory Broker.fromJson(Map<String, dynamic> json) {
    try {
      return Broker(
        id: json['id'] as int?,
        userId: json['userId'] as int?,
        brokerInfo: BrokerInfo.fromJson(json['brokerInfo'] as Map<String, dynamic>),
        isActive: json['isActive'] as bool,
        brokerName: json['brokerName'] as String,
        preferences: BrokerPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
        createdAt: json['createdAt'] as String?,
        updatedAt: json['updatedAt'] as String?,
      );
    } catch (e) {
      print('Error parsing Broker: $e, JSON: $json');
      rethrow;
    }
  }
  
  Map<String, dynamic> toJson() => _$BrokerToJson(this);
}

/// Broker response model
@JsonSerializable()
class BrokersResponse {
  final bool status;
  final List<Broker> data;

  const BrokersResponse({
    required this.status,
    required this.data,
  });

  factory BrokersResponse.fromJson(Map<String, dynamic> json) => _$BrokersResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BrokersResponseToJson(this);
}

/// Broker integration step model
enum BrokerIntegrationStep {
  brokerSelection,
  basicInfo,
  credentials,
  preferences,
  confirmation,
  testing,
  completed,
}

/// Broker integration state
class BrokerIntegrationState {
  final BrokerIntegrationStep currentStep;
  final String? selectedBrokerName;
  final BrokerInfo? brokerInfo;
  final BrokerPreferences? preferences;
  final bool isDefault;
  final bool isLoading;
  final String? error;
  final bool isTestingConnection;

  const BrokerIntegrationState({
    this.currentStep = BrokerIntegrationStep.brokerSelection,
    this.selectedBrokerName,
    this.brokerInfo,
    this.preferences,
    this.isDefault = false,
    this.isLoading = false,
    this.error,
    this.isTestingConnection = false,
  });

  BrokerIntegrationState copyWith({
    BrokerIntegrationStep? currentStep,
    String? selectedBrokerName,
    BrokerInfo? brokerInfo,
    BrokerPreferences? preferences,
    bool? isDefault,
    bool? isLoading,
    String? error,
    bool? isTestingConnection,
  }) {
    return BrokerIntegrationState(
      currentStep: currentStep ?? this.currentStep,
      selectedBrokerName: selectedBrokerName ?? this.selectedBrokerName,
      brokerInfo: brokerInfo ?? this.brokerInfo,
      preferences: preferences ?? this.preferences,
      isDefault: isDefault ?? this.isDefault,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isTestingConnection: isTestingConnection ?? this.isTestingConnection,
    );
  }
}
