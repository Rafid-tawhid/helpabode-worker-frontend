class CorporateRolesModel {
  CorporateRolesModel({
    String? title,
    String? textId,
    String? created,
  }) {
    _title = title;
    _textId = textId;
    _created = created;
  }

  CorporateRolesModel.fromJson(dynamic json) {
    _title = json['title'];
    _textId = json['textId'];
    _created = json['created'];
  }
  String? _title;
  String? _textId;
  String? _created;
  CorporateRolesModel copyWith({
    String? title,
    String? textId,
    String? created,
  }) =>
      CorporateRolesModel(
        title: title ?? _title,
        textId: textId ?? _textId,
        created: created ?? _created,
      );
  String? get title => _title;
  String? get textId => _textId;
  String? get created => _created;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['textId'] = _textId;
    map['created'] = _created;
    return map;
  }
}
