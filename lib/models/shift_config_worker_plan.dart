class ShiftConfigWorkerPlan {
  ShiftConfigWorkerPlan({
    String? workerTextId,
    String? dayOfWeek,
    List<Quarters>? quarters,
  }) {
    _workerTextId = workerTextId;
    _dayOfWeek = dayOfWeek;
    _quarters = quarters;
  }

  ShiftConfigWorkerPlan.fromJson(dynamic json) {
    _workerTextId = json['workerTextId'];
    _dayOfWeek = json['dayOfWeek'];
    if (json['quarters'] != null) {
      _quarters = [];
      json['quarters'].forEach((v) {
        _quarters?.add(Quarters.fromJson(v));
      });
    }
  }
  String? _workerTextId;
  String? _dayOfWeek;
  List<Quarters>? _quarters;
  ShiftConfigWorkerPlan copyWith({
    String? workerTextId,
    String? dayOfWeek,
    List<Quarters>? quarters,
  }) =>
      ShiftConfigWorkerPlan(
        workerTextId: workerTextId ?? _workerTextId,
        dayOfWeek: dayOfWeek ?? _dayOfWeek,
        quarters: quarters ?? _quarters,
      );
  String? get workerTextId => _workerTextId;
  String? get dayOfWeek => _dayOfWeek;
  List<Quarters>? get quarters => _quarters;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['workerTextId'] = _workerTextId;
    map['dayOfWeek'] = _dayOfWeek;
    if (_quarters != null) {
      map['quarters'] = _quarters?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Quarters {
  Quarters({
    List<ClmData>? clmData,
  }) {
    _clmData = clmData;
  }

  Quarters.fromJson(dynamic json) {
    if (json['clm_data'] != null) {
      _clmData = [];
      json['clm_data'].forEach((v) {
        _clmData?.add(ClmData.fromJson(v));
      });
    }
  }
  List<ClmData>? _clmData;
  Quarters copyWith({
    List<ClmData>? clmData,
  }) =>
      Quarters(
        clmData: clmData ?? _clmData,
      );
  List<ClmData>? get clmData => _clmData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_clmData != null) {
      map['clm_data'] = _clmData?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ClmData {
  ClmData({
    String? zoneTitle,
    String? zoneTextId,
    List<String>? zipCode,
    String? timeSlot,
    String? duration,
    String? status,
  }) {
    _zoneTitle = zoneTitle;
    _zoneTextId = zoneTextId;
    _zipCode = zipCode;
    _timeSlot = timeSlot;
    _duration = duration;
    _status = status;
  }

  ClmData.fromJson(dynamic json) {
    _zoneTitle = json['zoneTitle'];
    _zoneTextId = json['zoneTextId'];
    _zipCode = json['zipCode'] != null ? json['zipCode'].cast<String>() : [];
    _timeSlot = json['timeSlot'];
    _duration = json['duration'];
    _status = json['status'];
  }
  String? _zoneTitle;
  String? _zoneTextId;
  List<String>? _zipCode;
  String? _timeSlot;
  String? _duration;
  String? _status;
  ClmData copyWith({
    String? zoneTitle,
    String? zoneTextId,
    List<String>? zipCode,
    String? timeSlot,
    String? duration,
    String? status,
  }) =>
      ClmData(
        zoneTitle: zoneTitle ?? _zoneTitle,
        zoneTextId: zoneTextId ?? _zoneTextId,
        zipCode: zipCode ?? _zipCode,
        timeSlot: timeSlot ?? _timeSlot,
        duration: duration ?? _duration,
        status: status ?? _status,
      );
  String? get zoneTitle => _zoneTitle;
  String? get zoneTextId => _zoneTextId;
  List<String>? get zipCode => _zipCode;
  String? get timeSlot => _timeSlot;
  String? get duration => _duration;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zoneTitle'] = _zoneTitle;
    map['zoneTextId'] = _zoneTextId;
    map['zipCode'] = _zipCode;
    map['timeSlot'] = _timeSlot;
    map['duration'] = _duration;
    map['status'] = _status;
    return map;
  }
}
