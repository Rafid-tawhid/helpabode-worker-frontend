class CorporateScheduleModel {
  CorporateScheduleModel({
    String? dayOfWeek,
    String? scheduleDate,
    List<Quarters>? quarters,
  }) {
    _dayOfWeek = dayOfWeek;
    _scheduleDate = scheduleDate;
    _quarters = quarters;
  }

  CorporateScheduleModel.fromJson(dynamic json) {
    _dayOfWeek = json['dayOfWeek'];
    _scheduleDate = json['scheduleDate'];
    if (json['quarters'] != null) {
      _quarters = [];
      json['quarters'].forEach((v) {
        _quarters?.add(Quarters.fromJson(v));
      });
    }
  }
  String? _dayOfWeek;
  String? _scheduleDate;
  List<Quarters>? _quarters;
  CorporateScheduleModel copyWith({
    String? dayOfWeek,
    String? scheduleDate,
    List<Quarters>? quarters,
  }) =>
      CorporateScheduleModel(
        dayOfWeek: dayOfWeek ?? _dayOfWeek,
        scheduleDate: scheduleDate ?? _scheduleDate,
        quarters: quarters ?? _quarters,
      );
  String? get dayOfWeek => _dayOfWeek;
  String? get scheduleDate => _scheduleDate;
  List<Quarters>? get quarters => _quarters;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['dayOfWeek'] = _dayOfWeek;
    map['scheduleDate'] = _scheduleDate;
    if (_quarters != null) {
      map['quarters'] = _quarters?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Quarters {
  Quarters({
    ClmData? clmData,
  }) {
    _clmData = clmData;
  }

  Quarters.fromJson(dynamic json) {
    _clmData =
        json['clm_data'] != null ? ClmData.fromJson(json['clm_data']) : null;
  }
  ClmData? _clmData;
  Quarters copyWith({
    ClmData? clmData,
  }) =>
      Quarters(
        clmData: clmData ?? _clmData,
      );
  ClmData? get clmData => _clmData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_clmData != null) {
      map['clm_data'] = _clmData?.toJson();
    }
    return map;
  }
}

class ClmData {
  ClmData({
    String? zoneTitle,
    String? zoneTextId,
    String? timeSlot,
    String? duration,
    String? status,
  }) {
    _zoneTitle = zoneTitle;
    _zoneTextId = zoneTextId;
    _timeSlot = timeSlot;
    _duration = duration;
    _status = status;
  }

  ClmData.fromJson(dynamic json) {
    _zoneTitle = json['zoneTitle'];
    _zoneTextId = json['zoneTextId'];
    _timeSlot = json['timeSlot'];
    _duration = json['duration'];
    _status = json['status'];
  }
  String? _zoneTitle;
  String? _zoneTextId;
  String? _timeSlot;
  String? _duration;
  String? _status;
  ClmData copyWith({
    String? zoneTitle,
    String? zoneTextId,
    String? timeSlot,
    String? duration,
    String? status,
  }) =>
      ClmData(
        zoneTitle: zoneTitle ?? _zoneTitle,
        zoneTextId: zoneTextId ?? _zoneTextId,
        timeSlot: timeSlot ?? _timeSlot,
        duration: duration ?? _duration,
        status: status ?? _status,
      );
  String? get zoneTitle => _zoneTitle;
  String? get zoneTextId => _zoneTextId;
  String? get timeSlot => _timeSlot;
  String? get duration => _duration;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zoneTitle'] = _zoneTitle;
    map['zoneTextId'] = _zoneTextId;
    map['timeSlot'] = _timeSlot;
    map['duration'] = _duration;
    map['status'] = _status;
    return map;
  }
}
