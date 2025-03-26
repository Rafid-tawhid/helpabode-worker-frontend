class ServiceAreaWithInfoModel {
  ServiceAreaWithInfoModel({
    String? zoneTitle,
    String? zoneTextId,
    num? totalZip,
    num? totalService,
    List<ServiceArray>? serviceArray,
  }) {
    _zoneTitle = zoneTitle;
    _zoneTextId = zoneTextId;
    _totalZip = totalZip;
    _totalService = totalService;
    _serviceArray = serviceArray;
  }

  ServiceAreaWithInfoModel.fromJson(dynamic json) {
    _zoneTitle = json['zoneTitle'];
    _zoneTextId = json['zoneTextId'];
    _totalZip = json['total_zip'];
    _totalService = json['total_service'];
    if (json['service_array'] != null) {
      _serviceArray = [];
      json['service_array'].forEach((v) {
        _serviceArray?.add(ServiceArray.fromJson(v));
      });
    }
  }
  String? _zoneTitle;
  String? _zoneTextId;
  num? _totalZip;
  num? _totalService;
  List<ServiceArray>? _serviceArray;
  ServiceAreaWithInfoModel copyWith({
    String? zoneTitle,
    String? zoneTextId,
    num? totalZip,
    num? totalService,
    List<ServiceArray>? serviceArray,
  }) =>
      ServiceAreaWithInfoModel(
        zoneTitle: zoneTitle ?? _zoneTitle,
        zoneTextId: zoneTextId ?? _zoneTextId,
        totalZip: totalZip ?? _totalZip,
        totalService: totalService ?? _totalService,
        serviceArray: serviceArray ?? _serviceArray,
      );
  String? get zoneTitle => _zoneTitle;
  String? get zoneTextId => _zoneTextId;
  num? get totalZip => _totalZip;
  num? get totalService => _totalService;
  List<ServiceArray>? get serviceArray => _serviceArray;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zoneTitle'] = _zoneTitle;
    map['zoneTextId'] = _zoneTextId;
    map['total_zip'] = _totalZip;
    map['total_service'] = _totalService;
    if (_serviceArray != null) {
      map['service_array'] = _serviceArray?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  void updateZipAndService({num? zip, num? service}) {
    if (zip != null) {
      _totalZip = zip;
    }
    if (service != null) {
      _totalService = service;
    }
  }
}

class ServiceArray {
  ServiceArray({
    String? serviceTitle,
    String? serviceTextId,
    String? categoryTextId,
  }) {
    _serviceTitle = serviceTitle;
    _serviceTextId = serviceTextId;
    _categoryTextId = categoryTextId;
  }

  ServiceArray.fromJson(dynamic json) {
    _serviceTitle = json['serviceTitle'];
    _serviceTextId = json['serviceTextId'];
    _categoryTextId = json['categoryTextId'];
  }
  String? _serviceTitle;
  String? _serviceTextId;
  String? _categoryTextId;
  ServiceArray copyWith({
    String? serviceTitle,
    String? serviceTextId,
    String? categoryTextId,
  }) =>
      ServiceArray(
        serviceTitle: serviceTitle ?? _serviceTitle,
        serviceTextId: serviceTextId ?? _serviceTextId,
        categoryTextId: categoryTextId ?? _categoryTextId,
      );
  String? get serviceTitle => _serviceTitle;
  String? get serviceTextId => _serviceTextId;
  String? get categoryTextId => _categoryTextId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serviceTitle'] = _serviceTitle;
    map['serviceTextId'] = _serviceTextId;
    map['categoryTextId'] = _categoryTextId;
    return map;
  }
}
