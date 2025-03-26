class SignupInfoModel {
  SignupInfoModel({
    String? textId,
    String? title,
    num? rank,
  }) {
    _textId = textId;
    _title = title;
    _rank = rank;
  }

  SignupInfoModel.fromJson(dynamic json) {
    _textId = json['textId'];
    _title = json['title'];
    _rank = json['rank'];
  }
  String? _textId;
  String? _title;
  num? _rank;
  SignupInfoModel copyWith({
    String? textId,
    String? title,
    num? rank,
  }) =>
      SignupInfoModel(
        textId: textId ?? _textId,
        title: title ?? _title,
        rank: rank ?? _rank,
      );
  String? get textId => _textId;
  String? get title => _title;
  num? get rank => _rank;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['textId'] = _textId;
    map['title'] = _title;
    map['rank'] = _rank;
    return map;
  }
}
