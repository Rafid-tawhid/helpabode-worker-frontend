/// average_rating : "4.00"
/// title : "Customer Rating"
/// sub_title : "Based on last 5 job ratings"
/// status : "positive"

class RatingScreenModel {
  RatingScreenModel({
    String? averageRating,
    String? title,
    String? subTitle,
    String? status,
    String? isPercent,
  }) {
    _averageRating = averageRating;
    _title = title;
    _subTitle = subTitle;
    _status = status;
    _isPercent = isPercent;
  }

  RatingScreenModel.fromJson(dynamic json) {
    _averageRating = json['average_rating'].toString() ?? '';
    _title = json['title'];
    _subTitle = json['sub_title'];
    _status = json['status'];
    _isPercent = json['is_percent'];
  }
  String? _averageRating;
  String? _title;
  String? _subTitle;
  String? _status;
  String? _isPercent;
  RatingScreenModel copyWith({
    String? averageRating,
    String? title,
    String? subTitle,
    String? status,
    String? isPercent,
  }) =>
      RatingScreenModel(
        averageRating: averageRating ?? _averageRating,
        title: title ?? _title,
        subTitle: subTitle ?? _subTitle,
        status: status ?? _status,
        isPercent: isPercent ?? _isPercent,
      );
  String? get averageRating => _averageRating;
  String? get title => _title;
  String? get subTitle => _subTitle;
  String? get status => _status;
  String? get isPercent => _isPercent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['average_rating'] = _averageRating;
    map['title'] = _title;
    map['sub_title'] = _subTitle;
    map['status'] = _status;
    return map;
  }
}
