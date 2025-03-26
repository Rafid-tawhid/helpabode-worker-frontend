class PendingRequestedServiceList {
  PendingRequestedServiceList({
    String? workerTextId,
    String? serviceTextId,
    String? serviceTitle,
    num? rank,
    String? pricingBy,
    String? isPrice,
    String? shortDescription,
    String? image,
    String? status,
    String? firstPlanTextId,
    String? firstZoneTextId,
    String? statusId,
    String? categoryTitle,
    String? categoryTextId,
    String? priceRejectedNote,
    String? priceRejectedDate,
    bool selected = false, // Default value set to false
  }) {
    _workerTextId = workerTextId;
    _serviceTextId = serviceTextId;
    _serviceTitle = serviceTitle;
    _rank = rank;
    _pricingBy = pricingBy;
    _isPrice = isPrice;
    _shortDescription = shortDescription;
    _image = image;
    _status = status;
    _firstPlanTextId = firstPlanTextId;
    _firstZoneTextId = firstZoneTextId;
    _statusId = statusId;
    _categoryTitle = categoryTitle;
    _categoryTextId = categoryTextId;
    _priceRejectedNote = priceRejectedNote;
    _priceRejectedDate = priceRejectedDate;
    _selected = selected;
  }

  PendingRequestedServiceList.fromJson(dynamic json) {
    _workerTextId = json['workerTextId'];
    _serviceTextId = json['serviceTextId'];
    _serviceTitle = json['serviceTitle'];
    _rank = json['rank'];
    _pricingBy = json['pricingBy'];
    _isPrice = json['isPrice'];
    _shortDescription = json['shortDescription'];
    _image = json['image'];
    _status = json['status'];
    _statusId = json['statusId'];
    _firstPlanTextId = json['firstPlanTextId'];
    _firstZoneTextId = json['firstZoneTextId'];
    _categoryTitle = json['categoryTitle'];
    _categoryTextId = json['categoryTextId'];
    _priceRejectedNote = json['priceRejectedNote'] ?? '';
    _priceRejectedDate = json['priceRejectedDate'] ?? '';
    _selected = json['selected'] ?? false; // Default to false if not present
  }

  String? _workerTextId;
  String? _serviceTextId;
  String? _serviceTitle;
  num? _rank;
  String? _pricingBy;
  String? _isPrice;
  String? _shortDescription;
  String? _image;
  String? _status;
  String? _firstPlanTextId;
  String? _firstZoneTextId;
  String? _statusId;
  String? _categoryTitle;
  String? _categoryTextId;
  String? _priceRejectedNote;
  String? _priceRejectedDate;
  bool _selected = false;

  PendingRequestedServiceList copyWith({
    String? workerTextId,
    String? serviceTextId,
    String? serviceTitle,
    num? rank,
    String? pricingBy,
    String? isPrice,
    String? shortDescription,
    String? image,
    String? status,
    String? firstPlanTextId,
    String? firstZoneTextId,
    String? statusId,
    String? categoryTitle,
    String? categoryTextId,
    String? priceRejectedNote,
    String? priceRejectedDate,
    bool? selected,
  }) =>
      PendingRequestedServiceList(
        workerTextId: workerTextId ?? _workerTextId,
        serviceTextId: serviceTextId ?? _serviceTextId,
        serviceTitle: serviceTitle ?? _serviceTitle,
        rank: rank ?? _rank,
        pricingBy: pricingBy ?? _pricingBy,
        isPrice: isPrice ?? _isPrice,
        shortDescription: shortDescription ?? _shortDescription,
        image: image ?? _image,
        status: status ?? _status,
        statusId: statusId ?? _statusId,
        firstPlanTextId: firstPlanTextId ?? _firstPlanTextId,
        firstZoneTextId: firstZoneTextId ?? _firstZoneTextId,
        categoryTitle: categoryTitle ?? _categoryTitle,
        categoryTextId: categoryTextId ?? _categoryTextId,
        priceRejectedNote: priceRejectedNote ?? _priceRejectedNote,
        priceRejectedDate: priceRejectedDate ?? _priceRejectedDate,
        selected: selected ?? _selected,
      );

  String? get workerTextId => _workerTextId;
  String? get serviceTextId => _serviceTextId;
  String? get serviceTitle => _serviceTitle;
  num? get rank => _rank;
  String? get pricingBy => _pricingBy;
  String? get isPrice => _isPrice;
  String? get shortDescription => _shortDescription;
  String? get image => _image;
  String? get status => _status;
  String? get firstPlanTextId => _firstPlanTextId;
  String? get firstZoneTextId => _firstZoneTextId;
  String? get statusId => _statusId;
  String? get categoryTitle => _categoryTitle;
  String? get categoryTextId => _categoryTextId;
  String? get priceRejectedNote => _priceRejectedNote;
  String? get priceRejectedDate => _priceRejectedDate;
  bool get selected => _selected;

  set selected(bool value) {
    _selected = value;
  }

  set categoryTitle(String? value) {
    _categoryTitle = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['workerTextId'] = _workerTextId;
    map['serviceTextId'] = _serviceTextId;
    map['serviceTitle'] = _serviceTitle;
    map['rank'] = _rank;
    map['pricingBy'] = _pricingBy;
    map['isPrice'] = _isPrice;
    map['shortDescription'] = _shortDescription;
    map['image'] = _image;
    map['status'] = _status;
    map['statusId'] = _statusId;
    map['firstPlanTextId'] = _firstPlanTextId;
    map['firstZoneTextId'] = _firstZoneTextId;
    map['categoryTitle'] = _categoryTitle;
    map['categoryTextId'] = _categoryTextId;
    map['priceRejectedNote'] = _priceRejectedNote;
    map['priceRejectedDate'] = _priceRejectedDate;
    map['selected'] = _selected;
    return map;
  }

  set categoryTextId(String? value) {
    _categoryTextId = value;
  }
}
