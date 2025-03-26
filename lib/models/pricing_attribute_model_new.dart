class PricingAttributeModelNew {
  PricingAttributeModelNew({
    ServiceData? serviceData,
  }) {
    _serviceData = serviceData;
  }

  PricingAttributeModelNew.fromJson(dynamic json) {
    _serviceData = json['serviceData'] != null
        ? ServiceData.fromJson(json['serviceData'])
        : null;
  }
  ServiceData? _serviceData;
  PricingAttributeModelNew copyWith({
    ServiceData? serviceData,
  }) =>
      PricingAttributeModelNew(
        serviceData: serviceData ?? _serviceData,
      );
  ServiceData? get serviceData => _serviceData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_serviceData != null) {
      map['serviceData'] = _serviceData?.toJson();
    }
    return map;
  }
}

class ServiceData {
  ServiceData({
    ServiceInfo? serviceInfo,
    List<GetPlanList>? getPlanList,
    List<ZoneList>? zoneList,
    String? minimumPrice,
    List<PriceConfigaruatinAttr>? priceConfigaruatinAttr,
  }) {
    _serviceInfo = serviceInfo;
    _getPlanList = getPlanList;
    _zoneList = zoneList;
    _minimumPrice = minimumPrice;
    _priceConfigaruatinAttr = priceConfigaruatinAttr;
  }

  ServiceData.fromJson(dynamic json) {
    _serviceInfo = json['service_info'] != null
        ? ServiceInfo.fromJson(json['service_info'])
        : null;
    if (json['get_plan_list'] != null) {
      _getPlanList = [];
      json['get_plan_list'].forEach((v) {
        _getPlanList?.add(GetPlanList.fromJson(v));
      });
    }
    if (json['zone_list'] != null) {
      _zoneList = [];
      json['zone_list'].forEach((v) {
        _zoneList?.add(ZoneList.fromJson(v));
      });
    }
    _minimumPrice = json['minimumPrice'];
    if (json['price_configaruatin_attr'] != null) {
      _priceConfigaruatinAttr = [];
      json['price_configaruatin_attr'].forEach((v) {
        _priceConfigaruatinAttr?.add(PriceConfigaruatinAttr.fromJson(v));
      });
    }
  }
  ServiceInfo? _serviceInfo;
  List<GetPlanList>? _getPlanList;
  List<ZoneList>? _zoneList;
  String? _minimumPrice;
  List<PriceConfigaruatinAttr>? _priceConfigaruatinAttr;
  ServiceData copyWith({
    ServiceInfo? serviceInfo,
    List<GetPlanList>? getPlanList,
    List<ZoneList>? zoneList,
    String? minimumPrice,
    List<PriceConfigaruatinAttr>? priceConfigaruatinAttr,
  }) =>
      ServiceData(
        serviceInfo: serviceInfo ?? _serviceInfo,
        getPlanList: getPlanList ?? _getPlanList,
        zoneList: zoneList ?? _zoneList,
        minimumPrice: minimumPrice ?? _minimumPrice,
        priceConfigaruatinAttr:
            priceConfigaruatinAttr ?? _priceConfigaruatinAttr,
      );
  ServiceInfo? get serviceInfo => _serviceInfo;
  List<GetPlanList>? get getPlanList => _getPlanList;
  List<ZoneList>? get zoneList => _zoneList;
  String? get minimumPrice => _minimumPrice;
  List<PriceConfigaruatinAttr>? get priceConfigaruatinAttr =>
      _priceConfigaruatinAttr;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_serviceInfo != null) {
      map['service_info'] = _serviceInfo?.toJson();
    }
    if (_getPlanList != null) {
      map['get_plan_list'] = _getPlanList?.map((v) => v.toJson()).toList();
    }
    if (_zoneList != null) {
      map['zone_list'] = _zoneList?.map((v) => v.toJson()).toList();
    }
    map['minimumPrice'] = _minimumPrice;
    if (_priceConfigaruatinAttr != null) {
      map['price_configaruatin_attr'] =
          _priceConfigaruatinAttr?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class PriceConfigaruatinAttr {
  PriceConfigaruatinAttr({
    String? title,
    String? textId,
    String? labelType,
    String? instruction,
    List<Options>? options,
    String? isPricing,
  }) {
    _title = title;
    _textId = textId;
    _labelType = labelType;
    _options = options;
    _isPricing = isPricing;
    _instruction = instruction;
  }

  PriceConfigaruatinAttr.fromJson(dynamic json) {
    _title = json['title'];
    _textId = json['textId'];
    _labelType = json['labelType'];
    _instruction = json['instruction'] ?? '';
    if (json['options'] != null) {
      _options = [];
      json['options'].forEach((v) {
        _options?.add(Options.fromJson(v));
      });
    }
    _isPricing = json['isPricing'];
  }
  String? _title;
  String? _textId;
  String? _labelType;
  List<Options>? _options;
  String? _isPricing;
  String? _instruction;
  PriceConfigaruatinAttr copyWith({
    String? title,
    String? textId,
    String? labelType,
    List<Options>? options,
    String? isPricing,
    String? instruction,
  }) =>
      PriceConfigaruatinAttr(
        title: title ?? _title,
        textId: textId ?? _textId,
        labelType: labelType ?? _labelType,
        instruction: instruction ?? _instruction,
        options: options ?? _options,
        isPricing: isPricing ?? _isPricing,
      );
  String? get title => _title;
  String? get textId => _textId;
  String? get labelType => _labelType;
  String? get instruction => _instruction;
  List<Options>? get options => _options;
  String? get isPricing => _isPricing;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['textId'] = _textId;
    map['labelType'] = _labelType;
    map['instruction'] = _instruction;
    if (_options != null) {
      map['options'] = _options?.map((v) => v.toJson()).toList();
    }
    map['isPricing'] = _isPricing;
    return map;
  }
}

class Options {
  Options({
    String? price,
    String? estTime,
    String? optionLabel,
  }) {
    _price = price;
    _estTime = estTime;
    _optionLabel = optionLabel;
  }

  Options.fromJson(dynamic json) {
    _price = json['price'].toString();
    _estTime = json['estTime'].toString();
    _optionLabel = json['optionLabel'].toString();
  }

  String? _price;
  String? _estTime;
  String? _optionLabel;

  // Setters
  set price(String? value) {
    _price = value;
  }

  set estTime(String? value) {
    _estTime = value;
  }

  set optionLabel(String? value) {
    _optionLabel = value;
  }

  Options copyWith({
    String? price,
    String? estTime,
    String? optionLabel,
  }) =>
      Options(
        price: price ?? _price,
        estTime: estTime ?? _estTime,
        optionLabel: optionLabel ?? _optionLabel,
      );

  String? get price => _price;
  String? get estTime => _estTime;
  String? get optionLabel => _optionLabel;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['price'] = _price;
    map['estTime'] = _estTime;
    map['optionLabel'] = _optionLabel;
    return map;
  }
}

class ZoneList {
  ZoneList({
    String? zoneTitle,
    String? zoneTextId,
  }) {
    _zoneTitle = zoneTitle;
    _zoneTextId = zoneTextId;
  }

  ZoneList.fromJson(dynamic json) {
    _zoneTitle = json['zoneTitle'];
    _zoneTextId = json['zoneTextId'];
  }
  String? _zoneTitle;
  String? _zoneTextId;
  ZoneList copyWith({
    String? zoneTitle,
    String? zoneTextId,
  }) =>
      ZoneList(
        zoneTitle: zoneTitle ?? _zoneTitle,
        zoneTextId: zoneTextId ?? _zoneTextId,
      );
  String? get zoneTitle => _zoneTitle;
  String? get zoneTextId => _zoneTextId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zoneTitle'] = _zoneTitle;
    map['zoneTextId'] = _zoneTextId;
    return map;
  }
}

class GetPlanList {
  GetPlanList({
    String? planTitle,
    String? planTextId,
    num? rank,
    String? servicePlanDescription,
  }) {
    _planTitle = planTitle;
    _planTextId = planTextId;
    _rank = rank;
    _servicePlanDescription = servicePlanDescription;
  }

  GetPlanList.fromJson(dynamic json) {
    _planTitle = json['planTitle'];
    _planTextId = json['planTextId'];
    _rank = json['rank'];
    _servicePlanDescription = json['servicePlanDescription'];
  }
  String? _planTitle;
  String? _planTextId;
  num? _rank;
  String? _servicePlanDescription;
  GetPlanList copyWith({
    String? planTitle,
    String? planTextId,
    num? rank,
    String? servicePlanDescription,
  }) =>
      GetPlanList(
        planTitle: planTitle ?? _planTitle,
        planTextId: planTextId ?? _planTextId,
        rank: rank ?? _rank,
        servicePlanDescription:
            servicePlanDescription ?? _servicePlanDescription,
      );
  String? get planTitle => _planTitle;
  String? get planTextId => _planTextId;
  num? get rank => _rank;
  String? get servicePlanDescription => _servicePlanDescription;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['planTitle'] = _planTitle;
    map['planTextId'] = _planTextId;
    map['rank'] = _rank;
    map['servicePlanDescription'] = _servicePlanDescription;
    return map;
  }
}

class ServiceInfo {
  ServiceInfo({
    String? serviceName,
    String? serviceTextId,
    String? pricingBy,
    String? shortDescription,
    String? categoryTextId,
  }) {
    _serviceName = serviceName;
    _serviceTextId = serviceTextId;
    _pricingBy = pricingBy;
    _shortDescription = shortDescription;
    _categoryTextId = categoryTextId;
  }

  ServiceInfo.fromJson(dynamic json) {
    _serviceName = json['serviceName'];
    _serviceTextId = json['serviceTextId'];
    _pricingBy = json['pricingBy'];
    _shortDescription = json['shortDescription'];
    _categoryTextId = json['categoryTextId'];
  }
  String? _serviceName;
  String? _serviceTextId;
  String? _pricingBy;
  String? _shortDescription;
  String? _categoryTextId;

  ServiceInfo copyWith({
    String? serviceName,
    String? serviceTextId,
    String? pricingBy,
    String? shortDescription,
    String? categoryTextId,
  }) =>
      ServiceInfo(
        serviceName: serviceName ?? _serviceName,
        serviceTextId: serviceTextId ?? _serviceTextId,
        pricingBy: pricingBy ?? _pricingBy,
        shortDescription: shortDescription ?? _shortDescription,
        categoryTextId: categoryTextId ?? _categoryTextId,
      );
  String? get serviceName => _serviceName;
  String? get serviceTextId => _serviceTextId;
  String? get pricingBy => _pricingBy;
  String? get shortDescription => _shortDescription;
  String? get categoryTextId => _categoryTextId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serviceName'] = _serviceName;
    map['serviceTextId'] = _serviceTextId;
    map['pricingBy'] = _pricingBy;
    map['shortDescription'] = _shortDescription;
    map['categoryTextId'] = _categoryTextId;
    return map;
  }
}
