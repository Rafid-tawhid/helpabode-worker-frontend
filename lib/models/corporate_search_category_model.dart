class CorporateSearchCategoryModel {
  CorporateSearchCategoryModel({
    String? textId,
    String? title,
    String? categoryTextId,
    num? rank,
    String? image,
  }) {
    _textId = textId;
    _title = title;
    _categoryTextId = categoryTextId;
    _rank = rank;
    _image = image;
  }

  CorporateSearchCategoryModel.fromJson(dynamic json) {
    _textId = json['textId'];
    _title = json['title'];
    _categoryTextId = json['categoryTextId'];
    _rank = json['rank'];
    _image = json['image'];
  }
  String? _textId;
  String? _title;
  String? _categoryTextId;
  num? _rank;
  String? _image;
  CorporateSearchCategoryModel copyWith({
    String? textId,
    String? title,
    num? rank,
    String? image,
  }) =>
      CorporateSearchCategoryModel(
        textId: textId ?? _textId,
        title: title ?? _title,
        rank: rank ?? _rank,
        image: image ?? _image,
      );
  String? get textId => _textId;
  String? get title => _title;
  String? get categoryTextId => _categoryTextId;
  num? get rank => _rank;
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['textId'] = _textId;
    map['title'] = _title;
    map['categoryTextId'] = _categoryTextId;
    map['rank'] = _rank;
    map['image'] = _image;
    return map;
  }
}
