class WorkServiceModel {
  WorkServiceModel({
    num? id,
    String? textId,
    String? title,
    String? shortDescription,
    dynamic categoryBreadcrumb,
    String? houseService,
    String? isCustomizable,
    num? basePrice,
    bool isSelected = false, // Add isSelected parameter with a default value
  })  : _id = id,
        _textId = textId,
        _title = title,
        _shortDescription = shortDescription,
        _categoryBreadcrumb = categoryBreadcrumb,
        _houseService = houseService,
        _isCustomizable = isCustomizable,
        _basePrice = basePrice,
        _isSelected = isSelected; // Assign isSelected to the internal variable

  WorkServiceModel.fromJson(dynamic json) {
    _id = json['id'];
    _textId = json['textId'];
    _title = json['title'];
    _shortDescription = json['shortDescription'];
    _categoryBreadcrumb = json['categoryBreadcrumb'];
    _houseService = json['houseService'];
    _isCustomizable = json['isCustomizable'];
    _basePrice = json['basePrice'];
  }

  num? _id;
  String? _textId;
  String? _title;
  String? _shortDescription;
  dynamic _categoryBreadcrumb;
  String? _houseService;
  String? _isCustomizable;
  num? _basePrice;
  bool _isSelected = false; // Add isSelected property with a default value

  num? get id => _id;
  String? get textId => _textId;
  String? get title => _title;
  String? get shortDescription => _shortDescription;
  dynamic get categoryBreadcrumb => _categoryBreadcrumb;
  String? get houseService => _houseService;
  String? get isCustomizable => _isCustomizable;
  num? get basePrice => _basePrice;
  bool get isSelected => _isSelected; // Getter for isSelected
  // Getter for isSelected

  set isSelected(bool value) {
    _isSelected = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['textId'] = _textId;
    map['title'] = _title;
    map['shortDescription'] = _shortDescription;
    map['categoryBreadcrumb'] = _categoryBreadcrumb;
    map['houseService'] = _houseService;
    map['isCustomizable'] = _isCustomizable;
    map['basePrice'] = _basePrice;
    map['isSelected'] = _isSelected; // Include isSelected in the JSON
    return map;
  }
}
