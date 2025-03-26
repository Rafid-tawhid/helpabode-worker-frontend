class MyServiceZoneModel {
  MyServiceZoneModel({
    String? categoryTextId,
    String? categoryTitle,
    List<Values>? values,
  }) {
    _categoryTextId = categoryTextId;
    _categoryTitle = categoryTitle;
    _values = values;
  }

  MyServiceZoneModel.fromJson(dynamic json) {
    _categoryTextId = json['categoryTextId'];
    _categoryTitle = json['categoryTitle'];
    if (json['values'] != null) {
      _values = [];
      json['values'].forEach((v) {
        _values?.add(Values.fromJson(v));
      });
    }
  }
  String? _categoryTextId;
  String? _categoryTitle;
  List<Values>? _values;
  MyServiceZoneModel copyWith({
    String? categoryTextId,
    String? categoryTitle,
    List<Values>? values,
  }) =>
      MyServiceZoneModel(
        categoryTextId: categoryTextId ?? _categoryTextId,
        categoryTitle: categoryTitle ?? _categoryTitle,
        values: values ?? _values,
      );
  String? get categoryTextId => _categoryTextId;
  String? get categoryTitle => _categoryTitle;
  List<Values>? get values => _values;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['categoryTextId'] = _categoryTextId;
    map['categoryTitle'] = _categoryTitle;
    if (_values != null) {
      map['values'] = _values?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Values {
  Values({
    String? categoryTitle,
    String? categoryTextId,
    String? workerTextId,
    String? workerZoneTitle,
    String? workerZoneTextId,
    String? workerServiceZipCode,
    String? cityTextId,
    String? stateTextId,
    String? countryShortName,
  }) {
    _categoryTitle = categoryTitle;
    _categoryTextId = categoryTextId;
    _workerTextId = workerTextId;
    _workerZoneTitle = workerZoneTitle;
    _workerZoneTextId = workerZoneTextId;
    _workerServiceZipCode = workerServiceZipCode;
    _cityTextId = cityTextId;
    _stateTextId = stateTextId;
    _countryShortName = countryShortName;
  }

  Values.fromJson(dynamic json) {
    _categoryTitle = json['categoryTitle'];
    _categoryTextId = json['categoryTextId'];
    _workerTextId = json['workerTextId'];
    _workerZoneTitle = json['workerZoneTitle'];
    _workerZoneTextId = json['workerZoneTextId'];
    _workerServiceZipCode = json['workerServiceZipCode'];
    _cityTextId = json['cityTextId'];
    _stateTextId = json['stateTextId'];
    _countryShortName = json['countryShortName'];
  }
  String? _categoryTitle;
  String? _categoryTextId;
  String? _workerTextId;
  String? _workerZoneTitle;
  String? _workerZoneTextId;
  String? _workerServiceZipCode;
  String? _cityTextId;
  String? _stateTextId;
  String? _countryShortName;
  Values copyWith({
    String? categoryTitle,
    String? categoryTextId,
    String? workerTextId,
    String? workerZoneTitle,
    String? workerZoneTextId,
    String? workerServiceZipCode,
    String? cityTextId,
    String? stateTextId,
    String? countryShortName,
  }) =>
      Values(
        categoryTitle: categoryTitle ?? _categoryTitle,
        categoryTextId: categoryTextId ?? _categoryTextId,
        workerTextId: workerTextId ?? _workerTextId,
        workerZoneTitle: workerZoneTitle ?? _workerZoneTitle,
        workerZoneTextId: workerZoneTextId ?? _workerZoneTextId,
        workerServiceZipCode: workerServiceZipCode ?? _workerServiceZipCode,
        cityTextId: cityTextId ?? _cityTextId,
        stateTextId: stateTextId ?? _stateTextId,
        countryShortName: countryShortName ?? _countryShortName,
      );
  String? get categoryTitle => _categoryTitle;
  String? get categoryTextId => _categoryTextId;
  String? get workerTextId => _workerTextId;
  String? get workerZoneTitle => _workerZoneTitle;
  String? get workerZoneTextId => _workerZoneTextId;
  String? get workerServiceZipCode => _workerServiceZipCode;
  String? get cityTextId => _cityTextId;
  String? get stateTextId => _stateTextId;
  String? get countryShortName => _countryShortName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['categoryTitle'] = _categoryTitle;
    map['categoryTextId'] = _categoryTextId;
    map['workerTextId'] = _workerTextId;
    map['workerZoneTitle'] = _workerZoneTitle;
    map['workerZoneTextId'] = _workerZoneTextId;
    map['workerServiceZipCode'] = _workerServiceZipCode;
    map['cityTextId'] = _cityTextId;
    map['stateTextId'] = _stateTextId;
    map['countryShortName'] = _countryShortName;
    return map;
  }
}
