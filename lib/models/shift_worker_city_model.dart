class ShiftWorkerCityModel {
  ShiftWorkerCityModel({
    String? zoneTitle,
    String? zoneTextId,
    String? workerTextId,
    String? franchiseTextId,
  }) {
    _zoneTitle = zoneTitle;
    _zoneTextId = zoneTextId;
    _workerTextId = workerTextId;
    _franchiseTextId = franchiseTextId;
  }

  ShiftWorkerCityModel.fromJson(dynamic json) {
    _zoneTitle = json['zoneTitle'];
    _zoneTextId = json['zoneTextId'];
    _workerTextId = json['workerTextId'];
    _franchiseTextId = json['franchiseTextId'];
  }
  String? _zoneTitle;
  String? _zoneTextId;
  String? _workerTextId;
  String? _franchiseTextId;
  ShiftWorkerCityModel copyWith({
    String? zoneTitle,
    String? zoneTextId,
    String? workerTextId,
    String? franchiseTextId,
  }) =>
      ShiftWorkerCityModel(
        zoneTitle: zoneTitle ?? _zoneTitle,
        zoneTextId: zoneTextId ?? _zoneTextId,
        workerTextId: workerTextId ?? _workerTextId,
        franchiseTextId: franchiseTextId ?? _franchiseTextId,
      );
  String? get zoneTitle => _zoneTitle;
  String? get zoneTextId => _zoneTextId;
  String? get workerTextId => _workerTextId;
  String? get franchiseTextId => _franchiseTextId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zoneTitle'] = _zoneTitle;
    map['zoneTextId'] = _zoneTextId;
    map['workerTextId'] = _workerTextId;
    map['franchiseTextId'] = _franchiseTextId;
    return map;
  }
}
