class StateModel {
  StateModel({
    String? textId,
    String? title,
  }) {
    _textId = textId;
    _title = title;
  }

  StateModel.fromJson(dynamic json) {
    _textId = json['textId'];
    _title = json['title'];
  }
  String? _textId;
  String? _title;
  StateModel copyWith({
    String? textId,
    String? title,
  }) =>
      StateModel(
        textId: textId ?? _textId,
        title: title ?? _title,
      );
  String? get textId => _textId;
  String? get title => _title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['textId'] = _textId;
    map['title'] = _title;
    return map;
  }
}
