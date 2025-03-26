class AllServiceItems {
  AllServiceItems({
    num? id,
    String? textId,
    String? title,
    String? attributeGroupTextId,
    num? rank,
    String? image,
  }) {
    _id = id;
    _textId = textId;
    _title = title;
    _attributeGroupTextId = attributeGroupTextId;
    _rank = rank;
    _image = image;
  }

  AllServiceItems.fromJson(dynamic json) {
    _id = json['id'];
    _textId = json['textId'];
    _title = json['title'];
    _attributeGroupTextId = json['attributeGroupTextId'];
    _rank = json['rank'];
    _image = json['image'];
  }
  num? _id;
  String? _textId;
  String? _title;
  String? _attributeGroupTextId;
  num? _rank;
  String? _image;
  AllServiceItems copyWith({
    num? id,
    String? textId,
    String? title,
    String? attributeGroupTextId,
    num? rank,
    String? image,
  }) =>
      AllServiceItems(
        id: id ?? _id,
        textId: textId ?? _textId,
        title: title ?? _title,
        attributeGroupTextId: attributeGroupTextId ?? _attributeGroupTextId,
        rank: rank ?? _rank,
        image: image ?? _image,
      );
  num? get id => _id;
  String? get textId => _textId;
  String? get title => _title;
  String? get attributeGroupTextId => _attributeGroupTextId;
  num? get rank => _rank;
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['textId'] = _textId;
    map['title'] = _title;
    map['attributeGroupTextId'] = _attributeGroupTextId;
    map['rank'] = _rank;
    map['image'] = _image;
    return map;
  }
}
