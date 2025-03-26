class MyServiceWorkModel {
  MyServiceWorkModel({
    String? categoryTextId,
    String? workerZoneTitle,
    String? workerZoneTextId,
    String? workerServiceZipCode,
    String? cityTextId,
    String? stateTextId,
    String? countryShortName,
  }) {
    _categoryTextId = categoryTextId;
    _workerZoneTitle = workerZoneTitle;
    _workerZoneTextId = workerZoneTextId;
    _workerServiceZipCode = workerServiceZipCode;
    _cityTextId = cityTextId;
    _stateTextId = stateTextId;
    _countryShortName = countryShortName;
  }

  MyServiceWorkModel.fromJson(dynamic json) {
    _categoryTextId = json['categoryTextId'];
    _workerZoneTitle = json['workerZoneTitle'];
    _workerZoneTextId = json['workerZoneTextId'];
    _workerServiceZipCode = json['workerServiceZipCode'];
    _cityTextId = json['cityTextId'];
    _stateTextId = json['stateTextId'];
    _countryShortName = json['countryShortName'];
  }
  String? _categoryTextId;
  String? _workerZoneTitle;
  String? _workerZoneTextId;
  String? _workerServiceZipCode;
  String? _cityTextId;
  String? _stateTextId;
  String? _countryShortName;
  MyServiceWorkModel copyWith({
    String? categoryTextId,
    String? workerZoneTitle,
    String? workerZoneTextId,
    String? workerServiceZipCode,
    String? cityTextId,
    String? stateTextId,
    String? countryShortName,
  }) =>
      MyServiceWorkModel(
        categoryTextId: categoryTextId ?? _categoryTextId,
        workerZoneTitle: workerZoneTitle ?? _workerZoneTitle,
        workerZoneTextId: workerZoneTextId ?? _workerZoneTextId,
        workerServiceZipCode: workerServiceZipCode ?? _workerServiceZipCode,
        cityTextId: cityTextId ?? _cityTextId,
        stateTextId: stateTextId ?? _stateTextId,
        countryShortName: countryShortName ?? _countryShortName,
      );
  String? get categoryTextId => _categoryTextId;
  String? get workerZoneTitle => _workerZoneTitle;
  String? get workerZoneTextId => _workerZoneTextId;
  String? get workerServiceZipCode => _workerServiceZipCode;
  String? get cityTextId => _cityTextId;
  String? get stateTextId => _stateTextId;
  String? get countryShortName => _countryShortName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['categoryTextId'] = _categoryTextId;
    map['workerZoneTitle'] = _workerZoneTitle;
    map['workerZoneTextId'] = _workerZoneTextId;
    map['workerServiceZipCode'] = _workerServiceZipCode;
    map['cityTextId'] = _cityTextId;
    map['stateTextId'] = _stateTextId;
    map['countryShortName'] = _countryShortName;
    return map;
  }

  @override
  String toString() {
    return 'MyServiceWorkModel{_categoryTextId: $_categoryTextId, _workerZoneTitle: $_workerZoneTitle, _workerZoneTextId: $_workerZoneTextId, _workerServiceZipCode: $_workerServiceZipCode, _cityTextId: $_cityTextId, _stateTextId: $_stateTextId, _countryShortName: $_countryShortName}';
  }
}
