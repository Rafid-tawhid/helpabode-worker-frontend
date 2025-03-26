//    "status": "Approved",
//             "pricingBy": "areaSize",

class ServiceSearchModel {
  ServiceSearchModel({
    String? serviceTitle,
    String? serviceTextId,
    String? attributeGroupTextId,
    String? categoryTitle,
    String? categoryTextId,
    String? serviceImage,
    String? status,
    String? pricingBy,
  }) {
    _serviceTitle = serviceTitle;
    _serviceTextId = serviceTextId;
    _attributeGroupTextId = attributeGroupTextId;
    _categoryTitle = categoryTitle;
    _categoryTextId = categoryTextId;
    _serviceImage = serviceImage;
  }

  ServiceSearchModel.fromJson(dynamic json) {
    _serviceTitle = json['serviceTitle'];
    _serviceTextId = json['serviceTextId'];
    _attributeGroupTextId = json['attributeGroupTextId'];
    _categoryTitle = json['categoryTitle'];
    _categoryTextId = json['categoryTextId'];
    _serviceImage = json['serviceImage'];
    _status = json['status'];
    _pricingBy = json['pricingBy'];
  }
  String? _serviceTitle;
  String? _serviceTextId;
  String? _attributeGroupTextId;
  String? _categoryTitle;
  String? _categoryTextId;
  String? _serviceImage;
  String? _status;
  String? _pricingBy;
  ServiceSearchModel copyWith({
    String? serviceTitle,
    String? serviceTextId,
    String? attributeGroupTextId,
    String? categoryTitle,
    String? categoryTextId,
    String? serviceImage,
    String? status,
    String? pricingBy,
  }) =>
      ServiceSearchModel(
        serviceTitle: serviceTitle ?? _serviceTitle,
        serviceTextId: serviceTextId ?? _serviceTextId,
        attributeGroupTextId: attributeGroupTextId ?? _attributeGroupTextId,
        categoryTitle: categoryTitle ?? _categoryTitle,
        categoryTextId: categoryTextId ?? _categoryTextId,
        serviceImage: serviceImage ?? _serviceImage,
        status: status ?? _status,
        pricingBy: pricingBy ?? _pricingBy,
      );
  String? get serviceTitle => _serviceTitle;
  String? get serviceTextId => _serviceTextId;
  String? get attributeGroupTextId => _attributeGroupTextId;
  String? get categoryTitle => _categoryTitle;
  String? get categoryTextId => _categoryTextId;
  String? get serviceImage => _serviceImage;
  String? get status => _status;
  String? get pricingBy => _pricingBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serviceTitle'] = _serviceTitle;
    map['serviceTextId'] = _serviceTextId;
    map['attributeGroupTextId'] = _attributeGroupTextId;
    map['categoryTitle'] = _categoryTitle;
    map['categoryTextId'] = _categoryTextId;
    map['serviceImage'] = _serviceImage;
    map['status'] = _status;
    map['pricingBy'] = _pricingBy;
    return map;
  }
}
