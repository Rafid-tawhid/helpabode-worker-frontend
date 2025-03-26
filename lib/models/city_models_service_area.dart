import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class CityModels {
  CityModels({
    List<ServiceArea>? serviceArea,
  }) {
    _serviceArea = serviceArea;
  }

  CityModels.fromJson(dynamic json) {
    if (json['service_area'] != null) {
      _serviceArea = [];
      json['service_area'].forEach((v) {
        _serviceArea?.add(ServiceArea.fromJson(v));
      });
    }
  }
  List<ServiceArea>? _serviceArea;
  CityModels copyWith({
    List<ServiceArea>? serviceArea,
  }) =>
      CityModels(
        serviceArea: serviceArea ?? _serviceArea,
      );
  List<ServiceArea>? get serviceArea => _serviceArea;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_serviceArea != null) {
      map['service_area'] = _serviceArea?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ServiceArea {
  ServiceArea({
    String? cityTextId,
    String? cityTitle,
    String? stateTextId,
    String? stateTitle,
    String? stateShortName,
    String? country,
    String? currency,
    String? zipCode,
  }) {
    _cityTextId = cityTextId;
    _cityTitle = cityTitle;
    _stateTextId = stateTextId;
    _stateTitle = stateTitle;
    _stateShortName = stateShortName;
    _country = country;
    _currency = currency;
    _zipCode = zipCode;
  }

  ServiceArea.fromJson(dynamic json) {
    _cityTextId = json['cityTextId'];
    _cityTitle = json['cityTitle'];
    _stateTextId = json['stateTextId'];
    _stateTitle = json['stateTitle'];
    _stateShortName = json['stateShortName'];
    _country = json['country'];
    _currency = json['currency'];
    _zipCode = json['zipCode'];
  }
  String? _cityTextId;
  String? _cityTitle;
  String? _stateTextId;
  String? _stateTitle;
  String? _stateShortName;
  String? _country;
  String? _currency;
  String? _zipCode;
  bool isChecked = false;

  ServiceArea copyWith({
    String? cityTextId,
    String? cityTitle,
    String? stateTextId,
    String? stateTitle,
    String? stateShortName,
    String? country,
    String? currency,
    String? zipCode,
  }) =>
      ServiceArea(
        cityTextId: cityTextId ?? _cityTextId,
        cityTitle: cityTitle ?? _cityTitle,
        stateTextId: stateTextId ?? _stateTextId,
        stateTitle: stateTitle ?? _stateTitle,
        stateShortName: stateShortName ?? _stateShortName,
        country: country ?? _country,
        currency: currency ?? _currency,
        zipCode: zipCode ?? _zipCode,
      );
  String? get cityTextId => _cityTextId;
  String? get cityTitle => _cityTitle;
  String? get stateTextId => _stateTextId;
  String? get stateTitle => _stateTitle;
  String? get stateShortName => _stateShortName;
  String? get country => _country;
  String? get currency => _currency;
  String? get zipCode => _zipCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cityTextId'] = _cityTextId;
    map['cityTitle'] = _cityTitle;
    map['stateTextId'] = _stateTextId;
    map['stateTitle'] = _stateTitle;
    map['stateShortName'] = _stateShortName;
    map['country'] = _country;
    map['currency'] = _currency;
    map['zipCode'] = _zipCode;
    //added 2 extra field for save user selected area
    map['workerTextId'] = textId;
    map['franchiseTextId'] = franchiseTextId;

    return map;
  }
}
