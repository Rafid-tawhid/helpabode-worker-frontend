class ServiceAccordingCategoryModel {
  ServiceAccordingCategoryModel(
      {num? id,
      String? textId,
      String? title,
      String? attributeGroupTextId,
      String? categoryTextId,
      String? subCategoryTextId,
      String? shortDescription,
      num? basePrice,
      String? image,
      String? isExist,
      bool isSelected = false}) {
    _id = id;
    _textId = textId;
    _title = title;
    _attributeGroupTextId = attributeGroupTextId;
    _categoryTextId = categoryTextId;
    _subCategoryTextId = subCategoryTextId;
    _shortDescription = shortDescription;
    _basePrice = basePrice;
    _image = image;
    _isSelected = isSelected;
    _isExist = isExist;
  }

  ServiceAccordingCategoryModel.fromJson(dynamic json) {
    _id = json['id'];
    _textId = json['textId'];
    _title = json['title'];
    _attributeGroupTextId = json['attributeGroupTextId'];
    _categoryTextId = json['categoryTextId'];
    _subCategoryTextId = json['subCategoryTextId'];
    _shortDescription = json['shortDescription'];
    _basePrice = json['basePrice'];
    _image = json['image'];
    _isExist = json['isExist'];
  }
  num? _id;
  String? _textId;
  String? _title;
  String? _attributeGroupTextId;
  String? _categoryTextId;
  String? _subCategoryTextId;
  String? _shortDescription;
  num? _basePrice;
  String? _image;
  bool? _isSelected;
  String? _isExist;

  ServiceAccordingCategoryModel copyWith({
    num? id,
    String? textId,
    String? title,
    String? attributeGroupTextId,
    String? categoryTextId,
    String? subCategoryTextId,
    String? shortDescription,
    num? basePrice,
    String? image,
    String? isExist,
  }) =>
      ServiceAccordingCategoryModel(
        id: id ?? _id,
        textId: textId ?? _textId,
        title: title ?? _title,
        attributeGroupTextId: attributeGroupTextId ?? _attributeGroupTextId,
        categoryTextId: categoryTextId ?? _categoryTextId,
        subCategoryTextId: subCategoryTextId ?? _subCategoryTextId,
        shortDescription: shortDescription ?? _shortDescription,
        basePrice: basePrice ?? _basePrice,
        image: image ?? _image,
        isExist: isExist ?? _isExist,
      );
  num? get id => _id;
  String? get textId => _textId;
  String? get title => _title;
  String? get attributeGroupTextId => _attributeGroupTextId;
  String? get categoryTextId => _categoryTextId;
  String? get subCategoryTextId => _subCategoryTextId;
  String? get shortDescription => _shortDescription;
  num? get basePrice => _basePrice;
  String? get image => _image;
  String? get isExist => _isExist;
  bool? get isSelected => _isSelected;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['textId'] = _textId;
    map['title'] = _title;
    map['attributeGroupTextId'] = _attributeGroupTextId;
    map['categoryTextId'] = _categoryTextId;
    map['subCategoryTextId'] = _subCategoryTextId;
    map['shortDescription'] = _shortDescription;
    map['basePrice'] = _basePrice;
    map['image'] = _image;
    map['isExist'] = _isExist;
    return map;
  }
}
