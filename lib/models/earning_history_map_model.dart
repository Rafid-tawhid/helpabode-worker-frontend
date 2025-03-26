class EarningHistoryMapModel {
  EarningHistoryMapModel({
    String? monthName,
    String? year,
    num? totalEarned,
  }) {
    _monthName = monthName;
    _year = year;
    _totalEarned = totalEarned;
  }

  EarningHistoryMapModel.fromJson(dynamic json) {
    _monthName = json['monthName'];
    _year = json['year'];
    _totalEarned = json['totalEarned'];
  }
  String? _monthName;
  String? _year;
  num? _totalEarned;
  EarningHistoryMapModel copyWith({
    String? monthName,
    String? year,
    num? totalEarned,
  }) =>
      EarningHistoryMapModel(
        monthName: monthName ?? _monthName,
        year: year ?? _year,
        totalEarned: totalEarned ?? _totalEarned,
      );
  String? get monthName => _monthName;
  String? get year => _year;
  num? get totalEarned => _totalEarned;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['monthName'] = _monthName;
    map['year'] = _year;
    map['totalEarned'] = _totalEarned;
    return map;
  }
}
