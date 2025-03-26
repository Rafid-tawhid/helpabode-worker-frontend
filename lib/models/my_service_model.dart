class MyServiceModel {
  MyServiceModel({
    String? serviceTextId,
    String? serviceTitle,
    String? image,
    String? attributeGroupTextId,
    String? pricingBy,
    List<String>? zoneArray,
    List<CategoryArray>? categoryArray,
  }) {
    _serviceTextId = serviceTextId;
    _serviceTitle = serviceTitle;
    _image = image;
    _attributeGroupTextId = attributeGroupTextId;
    _pricingBy = pricingBy;
    _zoneArray = zoneArray;
    _categoryArray = categoryArray;
  }

  MyServiceModel.fromJson(dynamic json) {
    _serviceTextId = json['serviceTextId'];
    _serviceTitle = json['serviceTitle'];
    _image = json['image'];
    _attributeGroupTextId = json['attributeGroupTextId'];
    _pricingBy = json['pricingBy'];
    _zoneArray =
        json['zoneArray'] != null ? json['zoneArray'].cast<String>() : [];
    if (json['categoryArray'] != null) {
      _categoryArray = [];
      json['categoryArray'].forEach((v) {
        _categoryArray?.add(CategoryArray.fromJson(v));
      });
    }
  }
  String? _serviceTextId;
  String? _serviceTitle;
  String? _image;
  String? _attributeGroupTextId;
  String? _pricingBy;
  List<String>? _zoneArray;
  List<CategoryArray>? _categoryArray;
  MyServiceModel copyWith({
    String? serviceTextId,
    String? serviceTitle,
    String? image,
    String? attributeGroupTextId,
    String? pricingBy,
    List<String>? zoneArray,
    List<CategoryArray>? categoryArray,
  }) =>
      MyServiceModel(
        serviceTextId: serviceTextId ?? _serviceTextId,
        serviceTitle: serviceTitle ?? _serviceTitle,
        image: image ?? _image,
        attributeGroupTextId: attributeGroupTextId ?? _attributeGroupTextId,
        pricingBy: pricingBy ?? _pricingBy,
        zoneArray: zoneArray ?? _zoneArray,
        categoryArray: categoryArray ?? _categoryArray,
      );
  String? get serviceTextId => _serviceTextId;
  String? get serviceTitle => _serviceTitle;
  String? get image => _image;
  String? get attributeGroupTextId => _attributeGroupTextId;
  String? get pricingBy => _pricingBy;
  List<String>? get zoneArray => _zoneArray;
  List<CategoryArray>? get categoryArray => _categoryArray;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serviceTextId'] = _serviceTextId;
    map['serviceTitle'] = _serviceTitle;
    map['image'] = _image;
    map['attributeGroupTextId'] = _attributeGroupTextId;
    map['pricingBy'] = _pricingBy;
    map['zoneArray'] = _zoneArray;
    map['zoneArray'] = _zoneArray;
    if (_categoryArray != null) {
      map['categoryArray'] = _categoryArray?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class CategoryArray {
  CategoryArray({
    String? categoryTextId,
    String? categoryTitle,
    String? image,
    String? serviceStatus,
  }) {
    _categoryTextId = categoryTextId;
    _categoryTitle = categoryTitle;
    _image = image;
    _serviceStatus = serviceStatus;
  }

  CategoryArray.fromJson(dynamic json) {
    _categoryTextId = json['categoryTextId'];
    _categoryTitle = json['categoryTitle'];
    _image = json['image'];
    _serviceStatus = json['serviceStatus'];
  }
  String? _categoryTextId;
  String? _categoryTitle;
  String? _image;
  String? _serviceStatus;
  CategoryArray copyWith({
    String? categoryTextId,
    String? categoryTitle,
    String? image,
    String? serviceStatus,
  }) =>
      CategoryArray(
          categoryTextId: categoryTextId ?? _categoryTextId,
          categoryTitle: categoryTitle ?? _categoryTitle,
          image: image ?? _image,
          serviceStatus: serviceStatus ?? _serviceStatus);
  String? get categoryTextId => _categoryTextId;
  String? get categoryTitle => _categoryTitle;
  String? get image => _image;
  String? get serviceStatus => _serviceStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['categoryTextId'] = _categoryTextId;
    map['categoryTitle'] = _categoryTitle;
    map['image'] = _image;
    map['serviceStatus'] = _serviceStatus;
    return map;
  }
}
