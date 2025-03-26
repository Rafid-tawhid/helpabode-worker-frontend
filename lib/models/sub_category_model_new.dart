class SubCategoryModelNew {
  SubCategoryModelNew({
    String? title,
    String? textId,
    String? categoryTextId,
    String? breadcrumb,
    String? attributeGroupTextId,
    num? rank,
    String? status,
    String? image, // New attribute
    String? icon, // New attribute
  }) {
    _title = title;
    _textId = textId;
    _categoryTextId = categoryTextId;
    _breadcrumb = breadcrumb;
    _attributeGroupTextId = attributeGroupTextId;
    _rank = rank;
    _status = status;
    _image = image; // Initialize new attribute
    _icon = icon; // Initialize new attribute
  }

  SubCategoryModelNew.fromJson(dynamic json) {
    _title = json['title'];
    _textId = json['textId'];
    _categoryTextId = json['categoryTextId'];
    _breadcrumb = json['breadcrumb'];
    _attributeGroupTextId = json['attributeGroupTextId'];
    _rank = json['rank'];
    _status = json['status'];
    _image = json['image']; // Parse new attribute
    _icon = json['icon']; // Parse new attribute
  }

  String? _title;
  String? _textId;
  String? _categoryTextId;
  String? _breadcrumb;
  String? _attributeGroupTextId;
  num? _rank;
  String? _status;
  String? _image; // New property
  String? _icon; // New property

  SubCategoryModelNew copyWith({
    String? title,
    String? textId,
    String? categoryTextId,
    String? breadcrumb,
    String? attributeGroupTextId,
    num? rank,
    String? status,
    String? image, // New parameter
    String? icon, // New parameter
  }) =>
      SubCategoryModelNew(
        title: title ?? _title,
        textId: textId ?? _textId,
        categoryTextId: categoryTextId ?? _categoryTextId,
        breadcrumb: breadcrumb ?? _breadcrumb,
        attributeGroupTextId: attributeGroupTextId ?? _attributeGroupTextId,
        rank: rank ?? _rank,
        status: status ?? _status,
        image: image ?? _image, // Handle new parameter
        icon: icon ?? _icon, // Handle new parameter
      );

  String? get title => _title;
  String? get textId => _textId;
  String? get categoryTextId => _categoryTextId;
  String? get breadcrumb => _breadcrumb;
  String? get attributeGroupTextId => _attributeGroupTextId;
  num? get rank => _rank;
  String? get status => _status;
  String? get image => _image; // Getter for new attribute
  String? get icon => _icon; // Getter for new attribute

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['textId'] = _textId;
    map['categoryTextId'] = _categoryTextId;
    map['breadcrumb'] = _breadcrumb;
    map['attributeGroupTextId'] = _attributeGroupTextId;
    map['rank'] = _rank;
    map['status'] = _status;
    map['image'] = _image; // Include new attribute
    map['icon'] = _icon; // Include new attribute
    return map;
  }
}
