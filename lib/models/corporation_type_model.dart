class CorporationTypeModel {
  CorporationTypeModel({
    String? title,
    String? textId,
    num? rank,
  }) {
    _title = title;
    _textId = textId;
    _rank = rank;
  }

  CorporationTypeModel.fromJson(dynamic json) {
    _title = json['title'];
    _textId = json['textId'];
    _rank = json['rank'];
  }
  String? _title;
  String? _textId;
  num? _rank;
  CorporationTypeModel copyWith({
    String? title,
    String? textId,
    num? rank,
  }) =>
      CorporationTypeModel(
        title: title ?? _title,
        textId: textId ?? _textId,
        rank: rank ?? _rank,
      );
  String? get title => _title;
  String? get textId => _textId;
  num? get rank => _rank;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['textId'] = _textId;
    map['rank'] = _rank;
    return map;
  }
}
