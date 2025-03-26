class ZoneServiceModel {
  ZoneServiceModel({
    String? zoneTextId,
    String? zoneTitle,
    String? serviceTextId,
    String? serviceTitle,
    String? pricingBy,
    String? image,
  }) {
    _zoneTextId = zoneTextId;
    _zoneTitle = zoneTitle;
    _serviceTextId = serviceTextId;
    _serviceTitle = serviceTitle;
    _pricingBy = pricingBy;
    _image = image;
  }

  ZoneServiceModel.fromJson(dynamic json) {
    _zoneTextId = json['zoneTextId'];
    _zoneTitle = json['zoneTitle'];
    _serviceTextId = json['serviceTextId'];
    _serviceTitle = json['serviceTitle'];
    _pricingBy = json['pricingBy'];
    _image = json['image'];
  }
  String? _zoneTextId;
  String? _serviceTextId;
  String? _serviceTitle;
  String? _pricingBy;
  String? _image;
  String? _zoneTitle;
  ZoneServiceModel copyWith({
    String? zoneTextId,
    String? serviceTextId,
    String? serviceTitle,
    String? pricingBy,
    String? image,
    String? zoneTitle,
  }) =>
      ZoneServiceModel(
        zoneTextId: zoneTextId ?? _zoneTextId,
        serviceTextId: serviceTextId ?? _serviceTextId,
        serviceTitle: serviceTitle ?? _serviceTitle,
        pricingBy: pricingBy ?? _pricingBy,
        image: image ?? _image,
        zoneTitle: zoneTitle ?? _zoneTitle,
      );
  String? get zoneTextId => _zoneTextId;
  String? get serviceTextId => _serviceTextId;
  String? get serviceTitle => _serviceTitle;
  String? get pricingBy => _pricingBy;
  String? get image => _image;
  String? get zoneTitle => _zoneTitle;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zoneTextId'] = _zoneTextId;
    map['serviceTextId'] = _serviceTextId;
    map['serviceTitle'] = _serviceTitle;
    map['pricingBy'] = _pricingBy;
    map['image'] = _image;
    map['zoneTitle'] = _zoneTitle;
    return map;
  }
}
