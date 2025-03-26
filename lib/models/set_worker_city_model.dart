class SetWorkerCityModel {
  SetWorkerCityModel({
    String? cityTextId,
    String? cityTitle,
    String? stateTextId,
    String? stateTitle,
    String? stateIso2Code,
    String? country,
    String? currency,
    String? zipCode,
    String? workerTextId,
    String? franchiseTextId,
  }) {
    _cityTextId = cityTextId;
    _cityTitle = cityTitle;
    _stateTextId = stateTextId;
    _stateTitle = stateTitle;
    _stateIso2Code = stateIso2Code;
    _country = country;
    _currency = currency;
    _zipCode = zipCode;
    _workerTextId = workerTextId;
    _franchiseTextId = franchiseTextId;
  }

  SetWorkerCityModel.fromJson(dynamic json) {
    _cityTextId = json['cityTextId'];
    _cityTitle = json['cityTitle'];
    _stateTextId = json['stateTextId'];
    _stateTitle = json['stateTitle'];
    _stateIso2Code = json['stateIso2Code'];
    _country = json['country'];
    _currency = json['currency'];
    _zipCode = json['zipCode'];
    _workerTextId = json['workerTextId'];
    _franchiseTextId = json['franchiseTextId'];
  }
  String? _cityTextId;
  String? _cityTitle;
  String? _stateTextId;
  String? _stateTitle;
  String? _stateIso2Code;
  String? _country;
  String? _currency;
  String? _zipCode;
  String? _workerTextId;
  String? _franchiseTextId;
  SetWorkerCityModel copyWith({
    String? cityTextId,
    String? cityTitle,
    String? stateTextId,
    String? stateTitle,
    String? stateIso2Code,
    String? country,
    String? currency,
    String? zipCode,
    String? workerTextId,
    String? franchiseTextId,
  }) =>
      SetWorkerCityModel(
        cityTextId: cityTextId ?? _cityTextId,
        cityTitle: cityTitle ?? _cityTitle,
        stateTextId: stateTextId ?? _stateTextId,
        stateTitle: stateTitle ?? _stateTitle,
        stateIso2Code: stateIso2Code ?? _stateIso2Code,
        country: country ?? _country,
        currency: currency ?? _currency,
        zipCode: zipCode ?? _zipCode,
        workerTextId: workerTextId ?? _workerTextId,
        franchiseTextId: franchiseTextId ?? _franchiseTextId,
      );
  String? get cityTextId => _cityTextId;
  String? get cityTitle => _cityTitle;
  String? get stateTextId => _stateTextId;
  String? get stateTitle => _stateTitle;
  String? get stateIso2Code => _stateIso2Code;
  String? get country => _country;
  String? get currency => _currency;
  String? get zipCode => _zipCode;
  String? get workerTextId => _workerTextId;
  String? get franchiseTextId => _franchiseTextId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cityTextId'] = _cityTextId;
    map['cityTitle'] = _cityTitle;
    map['stateTextId'] = _stateTextId;
    map['stateTitle'] = _stateTitle;
    map['stateIso2Code'] = _stateIso2Code;
    map['country'] = _country;
    map['currency'] = _currency;
    map['zipCode'] = _zipCode;
    map['workerTextId'] = _workerTextId;
    map['franchiseTextId'] = _franchiseTextId;
    return map;
  }
}
