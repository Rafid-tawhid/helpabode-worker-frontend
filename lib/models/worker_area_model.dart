class WorkerAreaModel {
  WorkerAreaModel({
    String? zoneTextId,
    String? zoneTitle,
    String? workerTextId,
  }) {
    _zoneTextId = zoneTextId;
    _zoneTitle = zoneTitle;
    _workerTextId = workerTextId;
  }

  WorkerAreaModel.fromJson(dynamic json) {
    _zoneTextId = json['zoneTextId'];
    _zoneTitle = json['zoneTitle'];
    _workerTextId = json['workerTextId'];
  }
  String? _zoneTextId;
  String? _zoneTitle;
  String? _workerTextId;
  WorkerAreaModel copyWith({
    String? zoneTextId,
    String? zoneTitle,
    String? workerTextId,
  }) =>
      WorkerAreaModel(
        zoneTextId: zoneTextId ?? _zoneTextId,
        zoneTitle: zoneTitle ?? _zoneTitle,
        workerTextId: workerTextId ?? _workerTextId,
      );
  String? get zoneTextId => _zoneTextId;
  String? get zoneTitle => _zoneTitle;
  String? get workerTextId => _workerTextId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zoneTextId'] = _zoneTextId;
    map['zoneTitle'] = _zoneTitle;
    map['workerTextId'] = _workerTextId;
    return map;
  }
}
