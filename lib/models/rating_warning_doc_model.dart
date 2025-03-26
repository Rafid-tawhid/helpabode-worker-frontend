class RatingWarningDocModel {
  RatingWarningDocModel({
    String? title,
    List<Reason>? reason,
  }) {
    _title = title;
    _reason = reason;
  }

  RatingWarningDocModel.fromJson(dynamic json) {
    _title = json['title'];
    if (json['reason'] != null) {
      _reason = [];
      json['reason'].forEach((v) {
        _reason?.add(Reason.fromJson(v));
      });
    }
  }
  String? _title;
  List<Reason>? _reason;
  RatingWarningDocModel copyWith({
    String? title,
    List<Reason>? reason,
  }) =>
      RatingWarningDocModel(
        title: title ?? _title,
        reason: reason ?? _reason,
      );
  String? get title => _title;
  List<Reason>? get reason => _reason;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    if (_reason != null) {
      map['reason'] = _reason?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Reason {
  Reason({
    String? title,
  }) {
    _title = title;
  }

  Reason.fromJson(dynamic json) {
    _title = json['title'];
  }
  String? _title;
  Reason copyWith({
    String? title,
  }) =>
      Reason(
        title: title ?? _title,
      );
  String? get title => _title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    return map;
  }
}
