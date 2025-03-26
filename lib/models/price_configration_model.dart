import 'package:help_abode_worker_app_ver_2/models/price_configration_preview_model_new.dart';

class PriceConfigrationModel {
  PriceConfigrationModel({
    String? zoneTitle,
    String? zoneTextId,
    List<String>? zipWisePrice,
    List<PlanArray>? planArray,
  }) {
    _zoneTitle = zoneTitle;
    _zoneTextId = zoneTextId;
    _zipWisePrice = zipWisePrice;
    _planArray = planArray;
  }

  PriceConfigrationModel.fromJson(dynamic json) {
    _zoneTitle = json['zoneTitle'];
    _zoneTextId = json['zoneTextId'];
    _zipWisePrice =
        json['zipWisePrice'] != null ? json['zipWisePrice'].cast<String>() : [];
    if (json['planArray'] != null) {
      _planArray = [];
      json['planArray'].forEach((v) {
        _planArray?.add(PlanArray.fromJson(v));
      });
    }
  }
  String? _zoneTitle;
  String? _zoneTextId;
  List<String>? _zipWisePrice;
  List<PlanArray>? _planArray;
  PriceConfigrationModel copyWith({
    String? zoneTitle,
    String? zoneTextId,
    List<String>? zipWisePrice,
    List<PlanArray>? planArray,
  }) =>
      PriceConfigrationModel(
        zoneTitle: zoneTitle ?? _zoneTitle,
        zoneTextId: zoneTextId ?? _zoneTextId,
        zipWisePrice: zipWisePrice ?? _zipWisePrice,
        planArray: planArray ?? _planArray,
      );
  String? get zoneTitle => _zoneTitle;
  String? get zoneTextId => _zoneTextId;
  List<String>? get zipWisePrice => _zipWisePrice;
  List<PlanArray>? get planArray => _planArray;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zoneTitle'] = _zoneTitle;
    map['zoneTextId'] = _zoneTextId;
    map['zipWisePrice'] = _zipWisePrice;
    if (_planArray != null) {
      map['planArray'] = _planArray?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class PlanArray {
  PlanArray({
    String? planName,
    String? planTextId,
    String? rank,
    String? minimumPrice,
    List<Attributes>? attributes,
  }) {
    _planName = planName;
    _planTextId = planTextId;
    _rank = rank;
    _minimumPrice = minimumPrice;
    _attributes = attributes;
  }

  PlanArray.fromJson(dynamic json) {
    _planName = json['planName'];
    _planTextId = json['planTextId'];
    _rank = json['rank'];
    _minimumPrice = json['minimumPrice'];
    if (json['attributes'] != null) {
      _attributes = [];
      json['attributes'].forEach((v) {
        _attributes?.add(Attributes.fromJson(v));
      });
    }
  }
  String? _planName;
  String? _planTextId;
  String? _rank;
  String? _minimumPrice;
  List<Attributes>? _attributes;
  PlanArray copyWith({
    String? planName,
    String? planTextId,
    String? rank,
    String? minimumPrice,
    List<Attributes>? attributes,
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
  List<Attributes>? get attributes => _attributes;

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
    _price = json['price'];
    _estTime = json['estTime'];
    _optionLabel = json['optionLabel'];
  }
  String? _price;
  String? _estTime;
  String? _optionLabel;
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
