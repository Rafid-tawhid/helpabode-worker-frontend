class CategoryServiceModel {
  CategoryServiceModel(
      {num? id,
      String? categoryTextId,
      String? categoryTitle,
      String? attributeGroupTextId,
      dynamic rank,
      String? details,
      String? image,
      bool isSelected = false}) {
    _id = id;
    _categoryTextId = categoryTextId;
    _categoryTitle = categoryTitle;
    _attributeGroupTextId = attributeGroupTextId;
    _rank = rank;
    _details = details;
    _image = image;
    _isSelected = isSelected;
  }

  CategoryServiceModel.fromJson(dynamic json) {
    _id = json['id'];
    _categoryTextId = json['categoryTextId'];
    _categoryTitle = json['categoryTitle'];
    _attributeGroupTextId = json['attributeGroupTextId'];
    _rank = json['rank'];
    _details = json['details'];
    _image = json['image'];
  }
  num? _id;
  String? _categoryTextId;
  String? _categoryTitle;
  String? _attributeGroupTextId;
  dynamic _rank;
  String? _details;
  String? _image;
  bool _isSelected = false;

  CategoryServiceModel copyWith({
    num? id,
    String? categoryTextId,
    String? categoryTitle,
    String? attributeGroupTextId,
    dynamic rank,
    String? details,
    String? image,
  }) =>
      CategoryServiceModel(
        id: id ?? _id,
        categoryTextId: categoryTextId ?? _categoryTextId,
        categoryTitle: categoryTitle ?? _categoryTitle,
        attributeGroupTextId: attributeGroupTextId ?? _attributeGroupTextId,
        rank: rank ?? _rank,
        details: details ?? _details,
        image: image ?? _image,
      );
  num? get id => _id;
  String? get categoryTextId => _categoryTextId;
  String? get categoryTitle => _categoryTitle;
  String? get attributeGroupTextId => _attributeGroupTextId;
  dynamic get rank => _rank;
  String? get details => _details;
  String? get image => _image;
  bool get isSelected => _isSelected;

  set isSelected(value) {
    _isSelected = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['categoryTextId'] = _categoryTextId;
    map['categoryTitle'] = _categoryTitle;
    map['attributeGroupTextId'] = _attributeGroupTextId;
    map['rank'] = _rank;
    map['details'] = _details;
    map['image'] = _image;
    return map;
  }
}
