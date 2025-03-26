class MySelectedZoneModel {
  MySelectedZoneModel({
    String? zontTextId,
    String? zoneTitle,
    String? workerTextId,
    String? franchiseTextId,
    List<ZipArray>? zipArray,
  }) {
    _zontTextId = zontTextId;
    _zoneTitle = zoneTitle;
    _workerTextId = workerTextId;
    _franchiseTextId = franchiseTextId;
    _zipArray = zipArray;
  }

  MySelectedZoneModel.fromJson(dynamic json) {
    _zontTextId = json['zontTextId'];
    _zoneTitle = json['zoneTitle'];
    _workerTextId = json['workerTextId'];
    _franchiseTextId = json['franchiseTextId'];
    if (json['zipArray'] != null) {
      _zipArray = [];
      json['zipArray'].forEach((v) {
        _zipArray?.add(ZipArray.fromJson(v));
      });
    }
  }
  String? _zontTextId;
  String? _zoneTitle;
  String? _workerTextId;
  String? _franchiseTextId;
  List<ZipArray>? _zipArray;
  MySelectedZoneModel copyWith({
    String? zontTextId,
    String? zoneTitle,
    String? workerTextId,
    String? franchiseTextId,
    List<ZipArray>? zipArray,
  }) =>
      MySelectedZoneModel(
        zontTextId: zontTextId ?? _zontTextId,
        zoneTitle: zoneTitle ?? _zoneTitle,
        workerTextId: workerTextId ?? _workerTextId,
        franchiseTextId: franchiseTextId ?? _franchiseTextId,
        zipArray: zipArray ?? _zipArray,
      );
  String? get zontTextId => _zontTextId;
  String? get zoneTitle => _zoneTitle;
  String? get workerTextId => _workerTextId;
  String? get franchiseTextId => _franchiseTextId;
  List<ZipArray>? get zipArray => _zipArray;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zontTextId'] = _zontTextId;
    map['zoneTitle'] = _zoneTitle;
    map['workerTextId'] = _workerTextId;
    map['franchiseTextId'] = _franchiseTextId;
    if (_zipArray != null) {
      map['zipArray'] = _zipArray?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ZipArray {
  ZipArray({
    String? zipAddress,
  }) {
    _zipAddress = zipAddress;
  }

  ZipArray.fromJson(dynamic json) {
    _zipAddress = json['zipAddress'];
  }
  String? _zipAddress;
  ZipArray copyWith({
    String? zipAddress,
  }) =>
      ZipArray(
        zipAddress: zipAddress ?? _zipAddress,
      );
  String? get zipAddress => _zipAddress;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zipAddress'] = _zipAddress;
    return map;
  }
}
