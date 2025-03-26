/// schedule : ["06:30","06:45"]
/// zone : ["zone1"]
/// currentStatus : "available"

class ScheduleModelNew {
  ScheduleModelNew({
    List<String>? schedule,
    List<String>? zone,
    String? currentStatus,
  }) {
    _schedule = schedule;
    _zone = zone;
    _currentStatus = currentStatus;
  }

  ScheduleModelNew.fromJson(dynamic json) {
    _schedule = json['schedule'] != null ? json['schedule'].cast<String>() : [];
    _zone = json['zone'] != null ? json['zone'].cast<String>() : [];
    _currentStatus = json['currentStatus'];
  }
  List<String>? _schedule;
  List<String>? _zone;
  String? _currentStatus;
  ScheduleModelNew copyWith({
    List<String>? schedule,
    List<String>? zone,
    String? currentStatus,
  }) =>
      ScheduleModelNew(
        schedule: schedule ?? _schedule,
        zone: zone ?? _zone,
        currentStatus: currentStatus ?? _currentStatus,
      );
  List<String>? get schedule => _schedule;
  List<String>? get zone => _zone;
  String? get currentStatus => _currentStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['schedule'] = _schedule;
    map['zone'] = _zone;
    map['currentStatus'] = _currentStatus;
    return map;
  }
}
