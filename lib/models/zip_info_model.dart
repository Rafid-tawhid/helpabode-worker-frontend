class ZipInfoModel {
  ZipInfoModel({
    num? id,
    String? zip,
    String? cityName,
    String? cityTextId,
    String? stateTextId,
    String? stateShortName,
    String? countryShortName,
  }) {
    _id = id;
    _zip = zip;
    _cityName = cityName;
    _cityTextId = cityTextId;
    _stateTextId = stateTextId;
    _stateShortName = stateShortName;
    _countryShortName = countryShortName;
  }

  ZipInfoModel.fromJson(dynamic json) {
    _id = json['id'];
    _zip = json['zip'];
    _cityName = json['cityName'];
    _cityTextId = json['cityTextId'];
    _stateTextId = json['stateTextId'];
    _stateShortName = json['stateShortName'];
    _countryShortName = json['countryShortName'];
  }
  num? _id;
  String? _zip;
  String? _cityName;
  String? _cityTextId;
  String? _stateTextId;
  String? _stateShortName;
  String? _countryShortName;
  ZipInfoModel copyWith({
    num? id,
    String? zip,
    String? cityName,
    String? cityTextId,
    String? stateTextId,
    String? stateShortName,
    String? countryShortName,
  }) =>
      ZipInfoModel(
        id: id ?? _id,
        zip: zip ?? _zip,
        cityName: cityName ?? _cityName,
        cityTextId: cityTextId ?? _cityTextId,
        stateTextId: stateTextId ?? _stateTextId,
        stateShortName: stateShortName ?? _stateShortName,
        countryShortName: countryShortName ?? _countryShortName,
      );
  num? get id => _id;
  String? get zip => _zip;
  String? get cityName => _cityName;
  String? get cityTextId => _cityTextId;
  String? get stateTextId => _stateTextId;
  String? get stateShortName => _stateShortName;
  String? get countryShortName => _countryShortName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['zip'] = _zip;
    map['cityName'] = _cityName;
    map['cityTextId'] = _cityTextId;
    map['stateTextId'] = _stateTextId;
    map['stateShortName'] = _stateShortName;
    map['countryShortName'] = _countryShortName;
    return map;
  }
}
