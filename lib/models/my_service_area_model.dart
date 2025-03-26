class MyServiceAreaModel {
  MyServiceAreaModel({
    String? workerTextId,
    String? franchiseTextId,
    String? zoneTextId,
    String? zoneTitle,
    List<String>? zipCodes,
  }) {
    _workerTextId = workerTextId;
    _franchiseTextId = franchiseTextId;
    _zoneTextId = zoneTextId;
    _zoneTitle = zoneTitle;
    _zipCodes = zipCodes;
  }

  MyServiceAreaModel.fromJson(dynamic json) {
    _workerTextId = json['workerTextId'];
    _franchiseTextId = json['franchiseTextId'];
    _zoneTextId = json['zoneTextId'];
    _zoneTitle = json['zoneTitle'];
    _zipCodes = json['zipCodes'] != null ? json['zipCodes'].cast<String>() : [];
  }
  String? _workerTextId;
  String? _franchiseTextId;
  String? _zoneTextId;
  String? _zoneTitle;
  List<String>? _zipCodes;
  MyServiceAreaModel copyWith({
    String? workerTextId,
    String? franchiseTextId,
    String? zoneTextId,
    String? zoneTitle,
    List<String>? zipCodes,
  }) =>
      MyServiceAreaModel(
        workerTextId: workerTextId ?? _workerTextId,
        franchiseTextId: franchiseTextId ?? _franchiseTextId,
        zoneTextId: zoneTextId ?? _zoneTextId,
        zoneTitle: zoneTitle ?? _zoneTitle,
        zipCodes: zipCodes ?? _zipCodes,
      );
  String? get workerTextId => _workerTextId;
  String? get franchiseTextId => _franchiseTextId;
  String? get zoneTextId => _zoneTextId;
  String? get zoneTitle => _zoneTitle;
  List<String>? get zipCodes => _zipCodes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['workerTextId'] = _workerTextId;
    map['franchiseTextId'] = _franchiseTextId;
    map['zoneTextId'] = _zoneTextId;
    map['zoneTitle'] = _zoneTitle;
    map['zipCodes'] = _zipCodes;
    return map;
  }
}
