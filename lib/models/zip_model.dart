class ZipModel {
  ZipModel({
    String? country,
    String? stateName,
    String? cityName,
    String? zipCode,
  }) {
    _country = country;
    _stateName = stateName;
    _cityName = cityName;
    _zipCode = zipCode;
  }

  ZipModel.fromJson(dynamic json) {
    _country = json['country'];
    _stateName = json['stateName'];
    _cityName = json['cityName'];
    _zipCode = json['zipCode'];
  }
  String? _country;
  String? _stateName;
  String? _cityName;
  String? _zipCode;
  ZipModel copyWith({
    String? country,
    String? stateName,
    String? cityName,
    String? zipCode,
  }) =>
      ZipModel(
        country: country ?? _country,
        stateName: stateName ?? _stateName,
        cityName: cityName ?? _cityName,
        zipCode: zipCode ?? _zipCode,
      );
  String? get country => _country;
  String? get stateName => _stateName;
  String? get cityName => _cityName;
  String? get zipCode => _zipCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['country'] = _country;
    map['stateName'] = _stateName;
    map['cityName'] = _cityName;
    map['zipCode'] = _zipCode;
    return map;
  }
}
