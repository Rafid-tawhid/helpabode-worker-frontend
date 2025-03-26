class RequestedServiceDetailsModel {
  RequestedServiceDetailsModel({
    String? zoneTitle,
    String? zoneTextId,
    String? zoneSchedule,
    List<String>? zipWisePrice,
    List<RequestedplanArray>? requestedplanArray,
  }) {
    _zoneTitle = zoneTitle;
    _zoneTextId = zoneTextId;
    _zoneSchedule = zoneSchedule;
    _zipWisePrice = zipWisePrice;
    _requestedplanArray = requestedplanArray;
  }

  RequestedServiceDetailsModel.fromJson(dynamic json) {
    _zoneTitle = json['zoneTitle'];
    _zoneTextId = json['zoneTextId'];
    _zoneSchedule = json['zoneSchedule'];
    _zipWisePrice =
        json['zipWisePrice'] != null ? json['zipWisePrice'].cast<String>() : [];
    if (json['planArray'] != null) {
      _requestedplanArray = [];
      json['planArray'].forEach((v) {
        _requestedplanArray?.add(RequestedplanArray.fromJson(v));
      });
    }
  }
  String? _zoneTitle;
  String? _zoneTextId;
  String? _zoneSchedule;
  List<String>? _zipWisePrice;
  List<RequestedplanArray>? _requestedplanArray;
  RequestedServiceDetailsModel copyWith({
    String? zoneTitle,
    String? zoneTextId,
    String? zoneSchedule,
    List<String>? zipWisePrice,
    List<RequestedplanArray>? requestedplanArray,
  }) =>
      RequestedServiceDetailsModel(
        zoneTitle: zoneTitle ?? _zoneTitle,
        zoneTextId: zoneTextId ?? _zoneTextId,
        zoneSchedule: zoneSchedule ?? _zoneSchedule,
        zipWisePrice: zipWisePrice ?? _zipWisePrice,
        requestedplanArray: requestedplanArray ?? _requestedplanArray,
      );
  String? get zoneTitle => _zoneTitle;
  String? get zoneTextId => _zoneTextId;
  String? get zoneSchedule => _zoneSchedule;
  List<String>? get zipWisePrice => _zipWisePrice;
  List<RequestedplanArray>? get requestedplanArray => _requestedplanArray;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zoneTitle'] = _zoneTitle;
    map['zoneTextId'] = _zoneTextId;
    map['zoneSchedule'] = _zoneSchedule;
    map['zipWisePrice'] = _zipWisePrice;
    if (_requestedplanArray != null) {
      map['planArray'] = _requestedplanArray?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class RequestedplanArray {
  RequestedplanArray({
    String? planName,
    String? planTextId,
    String? rank,
    String? estTime,
    String? minimumPrice,
    String? priceStatus,
    String? rejectedNotes,
    List<RequestedAttributes>? requestedAttributes,
  }) {
    _planName = planName;
    _planTextId = planTextId;
    _rank = rank;
    _minimumPrice = minimumPrice;
    _priceStatus = priceStatus;
    _estTime = estTime;
    _requestedAttributes = requestedAttributes;
    _rejectedNotes = rejectedNotes;
  }

  RequestedplanArray.fromJson(dynamic json) {
    _planName = json['planName'];
    _planTextId = json['planTextId'];
    _rank = json['rank'];
    _minimumPrice = json['minimumPrice'];
    _priceStatus = json['priceStatus'];
    _rejectedNotes = json['rejectedNotes'];
    _estTime = json['estTime'] ?? '';
    if (json['attributes'] != null) {
      _requestedAttributes = [];
      json['attributes'].forEach((v) {
        _requestedAttributes?.add(RequestedAttributes.fromJson(v));
      });
    }
  }
  String? _planName;
  String? _planTextId;
  String? _rank;
  String? _minimumPrice;
  String? _priceStatus;
  String? _estTime;
  String? _rejectedNotes;
  List<RequestedAttributes>? _requestedAttributes;
  RequestedplanArray copyWith({
    String? planName,
    String? planTextId,
    String? rank,
    String? minimumPrice,
    String? estTime,
    String? rejectedNotes,
    List<RequestedAttributes>? requestedAttributes,
  }) =>
      RequestedplanArray(
        planName: planName ?? _planName,
        planTextId: planTextId ?? _planTextId,
        rank: rank ?? _rank,
        minimumPrice: minimumPrice ?? _minimumPrice,
        estTime: estTime ?? _estTime,
        rejectedNotes: rejectedNotes ?? _rejectedNotes,
        requestedAttributes: requestedAttributes ?? _requestedAttributes,
      );
  String? get planName => _planName;
  String? get planTextId => _planTextId;
  String? get rank => _rank;
  String? get minimumPrice => _minimumPrice;
  String? get priceStatus => _priceStatus;
  String? get rejectedNotes => _rejectedNotes;
  String? get estTime => _estTime;
  List<RequestedAttributes>? get requestedAttributes => _requestedAttributes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['planName'] = _planName;
    map['planTextId'] = _planTextId;
    map['rank'] = _rank;
    map['minimumPrice'] = _minimumPrice;
    map['estTime'] = _estTime;
    map['rejectedNotes'] = _rejectedNotes;
    if (_requestedAttributes != null) {
      map['attributes'] = _requestedAttributes?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class RequestedAttributes {
  RequestedAttributes({
    String? title,
    String? textId,
    String? labelType,
    List<RequestedOptions>? requestedOptions,
    String? isPricing,
  }) {
    _title = title;
    _textId = textId;
    _labelType = labelType;
    _requestedOptions = requestedOptions;
    _isPricing = isPricing;
  }

  RequestedAttributes.fromJson(dynamic json) {
    _title = json['title'];
    _textId = json['textId'];
    _labelType = json['labelType'];
    if (json['options'] != null) {
      _requestedOptions = [];
      json['options'].forEach((v) {
        _requestedOptions?.add(RequestedOptions.fromJson(v));
      });
    }
    _isPricing = json['isPricing'];
  }
  String? _title;
  String? _textId;
  String? _labelType;
  List<RequestedOptions>? _requestedOptions;
  String? _isPricing;
  RequestedAttributes copyWith({
    String? title,
    String? textId,
    String? labelType,
    List<RequestedOptions>? requestedOptions,
    String? isPricing,
  }) =>
      RequestedAttributes(
        title: title ?? _title,
        textId: textId ?? _textId,
        labelType: labelType ?? _labelType,
        requestedOptions: requestedOptions ?? _requestedOptions,
        isPricing: isPricing ?? _isPricing,
      );
  String? get title => _title;
  String? get textId => _textId;
  String? get labelType => _labelType;
  List<RequestedOptions>? get requestedOptions => _requestedOptions;
  String? get isPricing => _isPricing;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['textId'] = _textId;
    map['labelType'] = _labelType;
    if (_requestedOptions != null) {
      map['options'] = _requestedOptions?.map((v) => v.toJson()).toList();
    }
    map['isPricing'] = _isPricing;
    return map;
  }
}

class RequestedOptions {
  RequestedOptions({
    String? optionLabel,
    String? price,
    String? estTime,
  }) {
    _optionLabel = optionLabel;
    _price = price;
    _estTime = estTime;
  }

  RequestedOptions.fromJson(dynamic json) {
    _optionLabel = json['optionLabel'].toString();
    _price = json['price'].toString();
    _estTime = json['estTime'].toString();
  }
  String? _optionLabel;
  String? _price;
  String? _estTime;
  RequestedOptions copyWith({
    String? optionLabel,
    String? price,
    String? estTime,
  }) =>
      RequestedOptions(
        optionLabel: optionLabel ?? _optionLabel,
        price: price ?? _price,
        estTime: estTime ?? _estTime,
      );
  String? get optionLabel => _optionLabel;
  String? get price => _price;
  String? get estTime => _estTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['optionLabel'] = _optionLabel;
    map['price'] = _price;
    map['estTime'] = _estTime;
    return map;
  }
}
