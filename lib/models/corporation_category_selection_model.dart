class CorporationCategorySelectionModel {
  CorporationCategorySelectionModel({
    String? textId,
    String? title,
    num? rank,
    List<Children>? children,
    bool isSelected = false, // Add isSelected with default value of false
  }) {
    _textId = textId;
    _title = title;
    _rank = rank;
    _children = children;
    _isSelected = isSelected; // Initialize isSelected
  }

  CorporationCategorySelectionModel.fromJson(dynamic json) {
    _textId = json['textId'];
    _title = json['title'];
    _rank = json['rank'];
    _isSelected = json['isSelected'] ?? false; // Deserialize isSelected
    if (json['children'] != null) {
      _children = [];
      json['children'].forEach((v) {
        _children?.add(Children.fromJson(v));
      });
    }
  }

  String? _textId;
  String? _title;
  num? _rank;
  List<Children>? _children;
  bool _isSelected = false; // Default value is false

  CorporationCategorySelectionModel copyWith({
    String? textId,
    String? title,
    num? rank,
    List<Children>? children,
    bool? isSelected, // Add isSelected to copyWith
  }) =>
      CorporationCategorySelectionModel(
        textId: textId ?? _textId,
        title: title ?? _title,
        rank: rank ?? _rank,
        children: children ?? _children,
        isSelected: isSelected ?? _isSelected, // Update isSelected
      );

  String? get textId => _textId;
  String? get title => _title;
  num? get rank => _rank;
  List<Children>? get children => _children;
  bool get isSelected => _isSelected;

  set isSelected(bool value) {
    _isSelected = value;
  } // Add getter for isSelected

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['textId'] = _textId;
    map['title'] = _title;
    map['rank'] = _rank;
    map['isSelected'] = _isSelected; // Serialize isSelected
    if (_children != null) {
      map['children'] = _children?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Children {
  Children({
    String? textId,
    String? title,
    String? categoryTextId,
    num? rank,
    bool isSelected = false, // Add isSelected with default value of false
  }) {
    _textId = textId;
    _title = title;
    _categoryTextId = categoryTextId;
    _rank = rank;
    _isSelected = isSelected; // Initialize isSelected
  }

  Children.fromJson(dynamic json) {
    _textId = json['textId'];
    _title = json['title'];
    _categoryTextId = json['categoryTextId'];
    _rank = json['rank'];
    _isSelected = json['isSelected'] ?? false; // Deserialize isSelected
  }

  String? _textId;
  String? _title;
  String? _categoryTextId;
  num? _rank;
  bool _isSelected = false; // Default value is false

  Children copyWith({
    String? textId,
    String? title,
    String? categoryTextId,
    num? rank,
    bool? isSelected, // Add isSelected to copyWith
  }) =>
      Children(
        textId: textId ?? _textId,
        title: title ?? _title,
        categoryTextId: categoryTextId ?? _categoryTextId,
        rank: rank ?? _rank,
        isSelected: isSelected ?? _isSelected, // Update isSelected
      );

  String? get textId => _textId;
  String? get title => _title;
  String? get categoryTextId => _categoryTextId;
  num? get rank => _rank;
  bool get isSelected => _isSelected; // Add getter for isSelected

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['textId'] = _textId;
    map['title'] = _title;
    map['categoryTextId'] = _categoryTextId;
    map['rank'] = _rank;
    map['isSelected'] = _isSelected; // Serialize isSelected
    return map;
  }
}
