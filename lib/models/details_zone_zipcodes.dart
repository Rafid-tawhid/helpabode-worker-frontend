class DetailsZoneZipcodes {
  DetailsZoneZipcodes({
    String? zoneTitle,
    String? zoneTextId,
    List<ZipCode>? zipCode,
  }) {
    _zoneTitle = zoneTitle;
    _zoneTextId = zoneTextId;
    _zipCode = zipCode;
  }

  DetailsZoneZipcodes.fromJson(dynamic json) {
    _zoneTitle = json['zoneTitle'] ?? '';
    _zoneTextId = json['zoneTextId'] ?? '';
    if (json['zipCode'] != null && json['zipCode'] is List) {
      _zipCode = [];
      json['zipCode'].forEach((v) {
        _zipCode?.add(ZipCode.fromJson(v));
      });
    } else {
      _zipCode = []; // Initialize as empty list if null or not a List
    }
  }

  String? _zoneTitle;
  String? _zoneTextId;
  List<ZipCode>? _zipCode;
  DetailsZoneZipcodes copyWith({
    String? zoneTitle,
    String? zoneTextId,
    List<ZipCode>? zipCode,
  }) =>
      DetailsZoneZipcodes(
        zoneTitle: zoneTitle ?? _zoneTitle,
        zoneTextId: zoneTextId ?? _zoneTextId,
        zipCode: zipCode ?? _zipCode,
      );
  String? get zoneTitle => _zoneTitle;
  String? get zoneTextId => _zoneTextId;
  List<ZipCode>? get zipCode => _zipCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zoneTitle'] = _zoneTitle;
    map['zoneTextId'] = _zoneTextId;
    if (_zipCode != null) {
      map['zipCode'] = _zipCode?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ZipCode {
  ZipCode({
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

  ZipCode.fromJson(dynamic json) {
    _id = json['id'] ?? '';
    _zip = json['zip'] ?? '';
    _cityName = json['cityName'] ?? '';
    _cityTextId = json['cityTextId'] ?? '';
    _stateTextId = json['stateTextId'] ?? '';
    _stateShortName = json['stateShortName'] ?? '';
    _countryShortName = json['countryShortName'] ?? '';
  }
  num? _id;
  String? _zip;
  String? _cityName;
  String? _cityTextId;
  String? _stateTextId;
  String? _stateShortName;
  String? _countryShortName;
  ZipCode copyWith({
    num? id,
    String? zip,
    String? cityName,
    String? cityTextId,
    String? stateTextId,
    String? stateShortName,
    String? countryShortName,
  }) =>
      ZipCode(
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
