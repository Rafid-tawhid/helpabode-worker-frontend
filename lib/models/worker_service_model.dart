class WorkerServiceModel {
  WorkerServiceModel({
    String? workerTextId,
    String? serviceTextId,
    String? serviceTitle,
    num? rank,
    String? pricingBy,
    String? shortDescription,
    String? image,
    bool? selected, // Add boolean field
    bool? isPrice, // New boolean attribute
    String? firstPlanTextId, // New attribute
    String? firstZoneTextId, // New attribute
  })  : _workerTextId = workerTextId,
        _serviceTextId = serviceTextId,
        _serviceTitle = serviceTitle,
        _rank = rank,
        _pricingBy = pricingBy,
        _shortDescription = shortDescription,
        _image = image,
        _selected = selected ?? false, // Set default value
        _isPrice = isPrice ?? false, // Set default value
        _firstPlanTextId = firstPlanTextId, // Initialize new attribute
        _firstZoneTextId = firstZoneTextId; // Initialize new attribute

  WorkerServiceModel.fromJson(dynamic json) {
    _workerTextId = json['workerTextId'];
    _serviceTextId = json['serviceTextId'];
    _serviceTitle = json['serviceTitle'];
    _rank = json['rank'];
    _pricingBy = json['pricingBy'];
    _shortDescription = json['shortDescription'];
    _image = json['image'];
    _selected = false; // Set default value
    _isPrice = json['isPrice'] ?? false; // Set default value
    _firstPlanTextId = json['firstPlanTextId']; // Initialize new attribute
    _firstZoneTextId = json['firstZoneTextId']; // Initialize new attribute
  }

  String? _workerTextId;
  String? _serviceTextId;
  String? _serviceTitle;
  num? _rank;
  String? _pricingBy;
  String? _shortDescription;
  String? _image;
  bool? _selected; // Add boolean field
  bool? _isPrice; // New boolean attribute
  String? _firstPlanTextId; // New attribute
  String? _firstZoneTextId; // New attribute

  // Getter methods for all fields

  String? get workerTextId => _workerTextId;
  String? get serviceTextId => _serviceTextId;
  String? get serviceTitle => _serviceTitle;
  num? get rank => _rank;
  String? get pricingBy => _pricingBy;
  String? get shortDescription => _shortDescription;
  String? get image => _image;
  bool? get selected => _selected;
  bool? get isPrice => _isPrice; // New getter
  String? get firstPlanTextId => _firstPlanTextId; // New getter
  String? get firstZoneTextId => _firstZoneTextId; // New getter

  set selected(bool? value) {
    _selected = value;
  }

  set isPrice(bool? value) {
    // New setter
    _isPrice = value;
  }

  set firstPlanTextId(String? value) {
    // New setter
    _firstPlanTextId = value;
  }

  set firstZoneTextId(String? value) {
    // New setter
    _firstZoneTextId = value;
  }

  WorkerServiceModel copyWith({
    String? workerTextId,
    String? serviceTextId,
    String? serviceTitle,
    num? rank,
    String? pricingBy,
    String? shortDescription,
    String? image,
    bool? selected,
    bool? isPrice, // New attribute
    String? firstPlanTextId, // New attribute
    String? firstZoneTextId, // New attribute
  }) =>
      WorkerServiceModel(
        workerTextId: workerTextId ?? _workerTextId,
        serviceTextId: serviceTextId ?? _serviceTextId,
        serviceTitle: serviceTitle ?? _serviceTitle,
        rank: rank ?? _rank,
        pricingBy: pricingBy ?? _pricingBy,
        shortDescription: shortDescription ?? _shortDescription,
        image: image ?? _image,
        selected: selected ?? _selected,
        isPrice: isPrice ?? _isPrice, // New attribute
        firstPlanTextId: firstPlanTextId ?? _firstPlanTextId, // New attribute
        firstZoneTextId: firstZoneTextId ?? _firstZoneTextId, // New attribute
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['workerTextId'] = _workerTextId;
    map['serviceTextId'] = _serviceTextId;
    map['serviceTitle'] = _serviceTitle;
    map['rank'] = _rank;
    map['pricingBy'] = _pricingBy;
    map['shortDescription'] = _shortDescription;
    map['image'] = _image;
    map['selected'] = _selected; // Add selected to toJson
    map['isPrice'] = _isPrice; // Add isPrice to toJson
    map['firstPlanTextId'] = _firstPlanTextId; // Add firstPlanTextId to toJson
    map['firstZoneTextId'] = _firstZoneTextId; // Add firstZoneTextId to toJson
    return map;
  }
}
