/// available : ["06:45","24:00"]

class AvailableScheduleNew {
  AvailableScheduleNew({
    List<String>? available,
  }) {
    _available = available;
  }

  AvailableScheduleNew.fromJson(dynamic json) {
    _available =
        json['available'] != null ? json['available'].cast<String>() : [];
  }
  List<String>? _available;
  AvailableScheduleNew copyWith({
    List<String>? available,
  }) =>
      AvailableScheduleNew(
        available: available ?? _available,
      );
  List<String>? get available => _available;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['available'] = _available;
    return map;
  }
}
