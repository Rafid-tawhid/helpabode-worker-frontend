class WorkerCityModel {
  WorkerCityModel({
    String? workerTextId,
    String? franchiseTextId,
    String? stateTextId,
    String? cityTextId,
    String? stateShortName,
    String? zipCode,
    String? country,
  }) {
    _workerTextId = workerTextId;
    _franchiseTextId = franchiseTextId;
    _stateTextId = stateTextId;
    _cityTextId = cityTextId;
    _stateShortName = stateShortName;
    _zipCode = zipCode;
    _country = country;
  }

  WorkerCityModel.fromJson(dynamic json) {
    _workerTextId = json['workerTextId'];
    _franchiseTextId = json['franchiseTextId'];
    _stateTextId = json['stateTextId'];
    _cityTextId = json['cityTextId'];
    _stateShortName = json['stateShortName'];
    _zipCode = json['zipCode'];
    _country = json['country'];
  }
  String? _workerTextId;
  String? _franchiseTextId;
  String? _stateTextId;
  String? _cityTextId;
  String? _stateShortName;
  String? _zipCode;
  String? _country;
  WorkerCityModel copyWith({
    String? workerTextId,
    String? franchiseTextId,
    String? stateTextId,
    String? cityTextId,
    String? stateShortName,
    String? zipCode,
    String? country,
  }) =>
      WorkerCityModel(
        workerTextId: workerTextId ?? _workerTextId,
        franchiseTextId: franchiseTextId ?? _franchiseTextId,
        stateTextId: stateTextId ?? _stateTextId,
        cityTextId: cityTextId ?? _cityTextId,
        stateShortName: stateShortName ?? _stateShortName,
        zipCode: zipCode ?? _zipCode,
        country: country ?? _country,
      );
  String? get workerTextId => _workerTextId;
  String? get franchiseTextId => _franchiseTextId;
  String? get stateTextId => _stateTextId;
  String? get cityTextId => _cityTextId;
  String? get stateShortName => _stateShortName;
  String? get zipCode => _zipCode;
  String? get country => _country;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['workerTextId'] = _workerTextId;
    map['franchiseTextId'] = _franchiseTextId;
    map['stateTextId'] = _stateTextId;
    map['cityTextId'] = _cityTextId;
    map['stateShortName'] = _stateShortName;
    map['zipCode'] = _zipCode;
    map['country'] = _country;
    return map;
  }
}
