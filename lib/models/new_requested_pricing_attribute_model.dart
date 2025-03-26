import 'package:help_abode_worker_app_ver_2/models/price_configration_model.dart';

/// zoneTitle : "Brentwood-car"
/// zoneTextId : "Brentwood-car"
/// zoneSchedule : "Yes"
/// zipWisePrice : ["37027","94513"]
/// planArray : {"planName":"Default","planTextId":"Default","rank":"70","minimumPrice":"50","attributes":[{"title":"Choose Your Car Wash Add-ons","textId":"f454717349bf302c48b6244cc41f6d","labelType":"listItem","instruction":"","options":[{"price":"9","estTime":"30","optionLabel":"100% Hand Wash"},{"price":"10","estTime":"30","optionLabel":"Interior Vacuum"},{"price":"10","estTime":"30","optionLabel":"Clean Windows Inside and Out"}],"isPricing":"Yes"},{"title":"Optional Add-ons","textId":"a7f87c2e4088118e76da2c2d3b9a71","labelType":"listItem","instruction":"","options":[{"price":"10","estTime":"30","optionLabel":"Platinum Bubble Bath"},{"price":"6","estTime":"30","optionLabel":"Extreme Shine Wax With Waterfall Rinse"}],"isPricing":"Yes"}]}

class NewRequestedPricingAttributeModel {
  NewRequestedPricingAttributeModel({
    String? zoneTitle,
    String? zoneTextId,
    String? zoneSchedule,
    List<String>? zipWisePrice,
    PlanArrayReq? planArray,
  }) {
    _zoneTitle = zoneTitle;
    _zoneTextId = zoneTextId;
    _zoneSchedule = zoneSchedule;
    _zipWisePrice = zipWisePrice;
    _planArray = planArray;
  }

  NewRequestedPricingAttributeModel.fromJson(dynamic json) {
    _zoneTitle = json['zoneTitle'];
    _zoneTextId = json['zoneTextId'];
    _zoneSchedule = json['zoneSchedule'];
    _zipWisePrice =
        json['zipWisePrice'] != null ? json['zipWisePrice'].cast<String>() : [];
    _planArray = json['planArray'] != null
        ? PlanArrayReq.fromJson(json['planArray'])
        : null;
  }
  String? _zoneTitle;
  String? _zoneTextId;
  String? _zoneSchedule;
  List<String>? _zipWisePrice;
  PlanArrayReq? _planArray;
  NewRequestedPricingAttributeModel copyWith({
    String? zoneTitle,
    String? zoneTextId,
    String? zoneSchedule,
    List<String>? zipWisePrice,
    PlanArrayReq? planArray,
  }) =>
      NewRequestedPricingAttributeModel(
        zoneTitle: zoneTitle ?? _zoneTitle,
        zoneTextId: zoneTextId ?? _zoneTextId,
        zoneSchedule: zoneSchedule ?? _zoneSchedule,
        zipWisePrice: zipWisePrice ?? _zipWisePrice,
        planArray: planArray ?? _planArray,
      );
  String? get zoneTitle => _zoneTitle;
  String? get zoneTextId => _zoneTextId;
  String? get zoneSchedule => _zoneSchedule;
  List<String>? get zipWisePrice => _zipWisePrice;
  PlanArrayReq? get planArray => _planArray;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zoneTitle'] = _zoneTitle;
    map['zoneTextId'] = _zoneTextId;
    map['zoneSchedule'] = _zoneSchedule;
    map['zipWisePrice'] = _zipWisePrice;
    if (_planArray != null) {
      map['planArray'] = _planArray?.toJson();
    }
    return map;
  }
}

/// planName : "Default"
/// planTextId : "Default"
/// rank : "70"
/// minimumPrice : "50"
/// attributes : [{"title":"Choose Your Car Wash Add-ons","textId":"f454717349bf302c48b6244cc41f6d","labelType":"listItem","instruction":"","options":[{"price":"9","estTime":"30","optionLabel":"100% Hand Wash"},{"price":"10","estTime":"30","optionLabel":"Interior Vacuum"},{"price":"10","estTime":"30","optionLabel":"Clean Windows Inside and Out"}],"isPricing":"Yes"},{"title":"Optional Add-ons","textId":"a7f87c2e4088118e76da2c2d3b9a71","labelType":"listItem","instruction":"","options":[{"price":"10","estTime":"30","optionLabel":"Platinum Bubble Bath"},{"price":"6","estTime":"30","optionLabel":"Extreme Shine Wax With Waterfall Rinse"}],"isPricing":"Yes"}]

class PlanArrayReq {
  PlanArray({
    String? planName,
    String? planTextId,
    String? rank,
    String? minimumPrice,
    List<AttributesReq>? attributes,
  }) {
    _planName = planName;
    _planTextId = planTextId;
    _rank = rank;
    _minimumPrice = minimumPrice;
    _attributes = attributes;
  }

  PlanArrayReq.fromJson(dynamic json) {
    _planName = json['planName'];
    _planTextId = json['planTextId'];
    _rank = json['rank'];
    _minimumPrice = json['minimumPrice'];
    if (json['attributes'] != null) {
      _attributes = [];
      json['attributes'].forEach((v) {
        _attributes?.add(AttributesReq.fromJson(v));
      });
    }
  }
  String? _planName;
  String? _planTextId;
  String? _rank;
  String? _minimumPrice;
  List<AttributesReq>? _attributes;
  PlanArrayReq copyWith({
    String? planName,
    String? planTextId,
    String? rank,
    String? minimumPrice,
    List<AttributesReq>? attributes,
  }) =>
      PlanArray(
        planName: planName ?? _planName,
        planTextId: planTextId ?? _planTextId,
        rank: rank ?? _rank,
        minimumPrice: minimumPrice ?? _minimumPrice,
        attributes: attributes ?? _attributes,
      );
  String? get planName => _planName;
  String? get planTextId => _planTextId;
  String? get rank => _rank;
  String? get minimumPrice => _minimumPrice;
  List<AttributesReq>? get attributes => _attributes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['planName'] = _planName;
    map['planTextId'] = _planTextId;
    map['rank'] = _rank;
    map['minimumPrice'] = _minimumPrice;
    if (_attributes != null) {
      map['attributes'] = _attributes?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// title : "Choose Your Car Wash Add-ons"
/// textId : "f454717349bf302c48b6244cc41f6d"
/// labelType : "listItem"
/// instruction : ""
/// options : [{"price":"9","estTime":"30","optionLabel":"100% Hand Wash"},{"price":"10","estTime":"30","optionLabel":"Interior Vacuum"},{"price":"10","estTime":"30","optionLabel":"Clean Windows Inside and Out"}]
/// isPricing : "Yes"

class AttributesReq {
  AttributesReq({
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
    _instruction = instruction;
    _options = options;
    _isPricing = isPricing;
  }

  AttributesReq.fromJson(dynamic json) {
    _title = json['title'];
    _textId = json['textId'];
    _labelType = json['labelType'];
    _instruction = json['instruction'];
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
  String? _instruction;
  List<Options>? _options;
  String? _isPricing;
  AttributesReq copyWith({
    String? title,
    String? textId,
    String? labelType,
    String? instruction,
    List<Options>? options,
    String? isPricing,
  }) =>
      AttributesReq(
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
