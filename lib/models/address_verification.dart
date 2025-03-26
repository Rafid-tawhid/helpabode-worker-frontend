class AddressVerification {
  AddressVerification({
    String? zipData,
    String? addressLine1Data,
    String? addressLine2Data,
    String? cityData,
    String? stateData,
  }) {
    _zipData = zipData;
    _addressLine1Data = addressLine1Data;
    _addressLine2Data = addressLine2Data;
    _cityData = cityData;
    _stateData = stateData;
  }

  AddressVerification.fromJson(dynamic json) {
    _zipData = json['zipData'].toString();
    _addressLine1Data = json['addressLine1Data'].toString();
    _addressLine2Data = json['addressLine2Data'].toString();
    _cityData = json['cityData'].toString();
    _stateData = json['stateData'].toString();
  }
  String? _zipData;
  String? _addressLine1Data;
  String? _addressLine2Data;
  String? _cityData;
  String? _stateData;
  AddressVerification copyWith({
    String? zipData,
    String? addressLine1Data,
    String? addressLine2Data,
    String? cityData,
    String? stateData,
  }) =>
      AddressVerification(
        zipData: zipData ?? _zipData,
        addressLine1Data: addressLine1Data ?? _addressLine1Data,
        addressLine2Data: addressLine2Data ?? _addressLine2Data,
        cityData: cityData ?? _cityData,
        stateData: stateData ?? _stateData,
      );
  String? get zipData => _zipData;
  String? get addressLine1Data => _addressLine1Data;
  String? get addressLine2Data => _addressLine2Data;
  String? get cityData => _cityData;
  String? get stateData => _stateData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zipData'] = _zipData;
    map['addressLine1Data'] = _addressLine1Data;
    map['addressLine2Data'] = _addressLine2Data;
    map['cityData'] = _cityData;
    map['stateData'] = _stateData;
    return map;
  }
}
