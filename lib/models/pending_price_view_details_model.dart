class PendingPriceViewDetailsModel {
  PendingPriceViewDetailsModel({
    PricingServiceData? pricingServiceData,
  }) {
    _pricingServiceData = pricingServiceData;
  }

  PendingPriceViewDetailsModel.fromJson(dynamic json) {
    _pricingServiceData = json['pricingServiceData'] != null
        ? PricingServiceData.fromJson(json['pricingServiceData'])
        : null;
  }
  PricingServiceData? _pricingServiceData;
  PendingPriceViewDetailsModel copyWith({
    PricingServiceData? pricingServiceData,
  }) =>
      PendingPriceViewDetailsModel(
        pricingServiceData: pricingServiceData ?? _pricingServiceData,
      );
  PricingServiceData? get pricingServiceData => _pricingServiceData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_pricingServiceData != null) {
      map['pricingServiceData'] = _pricingServiceData?.toJson();
    }
    return map;
  }
}

class PricingServiceData {
  PricingServiceData({
    PricingServiceInfo? pricingServiceInfo,
    List<PricingPlanArray>? pricingPlanArray,
    List<PricingZoneArray>? pricingZoneArray,
  }) {
    _pricingServiceInfo = pricingServiceInfo;
    _pricingPlanArray = pricingPlanArray;
    _pricingZoneArray = pricingZoneArray;
  }

  PricingServiceData.fromJson(dynamic json) {
    _pricingServiceInfo = json['pricingServiceInfo'] != null
        ? PricingServiceInfo.fromJson(json['pricingServiceInfo'])
        : null;
    if (json['pricingPlanArray'] != null) {
      _pricingPlanArray = [];
      json['pricingPlanArray'].forEach((v) {
        _pricingPlanArray?.add(PricingPlanArray.fromJson(v));
      });
    }
    if (json['pricingZoneArray'] != null) {
      _pricingZoneArray = [];
      json['pricingZoneArray'].forEach((v) {
        _pricingZoneArray?.add(PricingZoneArray.fromJson(v));
      });
    }
  }
  PricingServiceInfo? _pricingServiceInfo;
  List<PricingPlanArray>? _pricingPlanArray;
  List<PricingZoneArray>? _pricingZoneArray;
  PricingServiceData copyWith({
    PricingServiceInfo? pricingServiceInfo,
    List<PricingPlanArray>? pricingPlanArray,
    List<PricingZoneArray>? pricingZoneArray,
  }) =>
      PricingServiceData(
        pricingServiceInfo: pricingServiceInfo ?? _pricingServiceInfo,
        pricingPlanArray: pricingPlanArray ?? _pricingPlanArray,
        pricingZoneArray: pricingZoneArray ?? _pricingZoneArray,
      );
  PricingServiceInfo? get pricingServiceInfo => _pricingServiceInfo;
  List<PricingPlanArray>? get pricingPlanArray => _pricingPlanArray;
  List<PricingZoneArray>? get pricingZoneArray => _pricingZoneArray;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_pricingServiceInfo != null) {
      map['pricingServiceInfo'] = _pricingServiceInfo?.toJson();
    }
    if (_pricingPlanArray != null) {
      map['pricingPlanArray'] =
          _pricingPlanArray?.map((v) => v.toJson()).toList();
    }
    if (_pricingZoneArray != null) {
      map['pricingZoneArray'] =
          _pricingZoneArray?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class PricingZoneArray {
  PricingZoneArray({
    String? zoneTitle,
    String? zoneTextId,
  }) {
    _zoneTitle = zoneTitle;
    _zoneTextId = zoneTextId;
  }

  PricingZoneArray.fromJson(dynamic json) {
    _zoneTitle = json['zoneTitle'];
    _zoneTextId = json['zoneTextId'];
  }
  String? _zoneTitle;
  String? _zoneTextId;
  PricingZoneArray copyWith({
    String? zoneTitle,
    String? zoneTextId,
  }) =>
      PricingZoneArray(
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

class PricingPlanArray {
  PricingPlanArray({
    String? planTextId,
    String? planTitle,
    String? planDetails,
  }) {
    _planTextId = planTextId;
    _planTitle = planTitle;
    _planDetails = planDetails;
  }

  PricingPlanArray.fromJson(dynamic json) {
    _planTextId = json['planTextId'];
    _planTitle = json['planTitle'];
    _planDetails = json['planDetails'];
  }
  String? _planTextId;
  String? _planTitle;
  String? _planDetails;
  PricingPlanArray copyWith({
    String? planTextId,
    String? planTitle,
    String? planDetails,
  }) =>
      PricingPlanArray(
        planTextId: planTextId ?? _planTextId,
        planTitle: planTitle ?? _planTitle,
        planDetails: planDetails ?? _planDetails,
      );
  String? get planTextId => _planTextId;
  String? get planTitle => _planTitle;
  String? get planDetails => _planDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['planTextId'] = _planTextId;
    map['planTitle'] = _planTitle;
    map['planDetails'] = _planDetails;
    return map;
  }
}

class PricingServiceInfo {
  PricingServiceInfo({
    String? title,
    String? textId,
    String? shortDescription,
    String? pricingBy,
    String? areaSizeUnit,
    String? image,
    String? status,
    String? categoryTextId,
    int? totalLike,
    double? avgRating,
    List<RatingCard>? ratingCardArray,
    List<PendingAttribute>? attributes,
  }) {
    _title = title;
    _textId = textId;
    _shortDescription = shortDescription;
    _pricingBy = pricingBy;
    _areaSizeUnit = areaSizeUnit;
    _image = image;
    _status = status;
    _categoryTextId = status;
    _totalLike = totalLike;
    _avgRating = avgRating;
    _categoryTextId = categoryTextId;
    //_ratingCardArray = ratingCardArray;
    _attributes = attributes;
  }

  PricingServiceInfo.fromJson(dynamic json) {
    _title = json['title'];
    _textId = json['textId'];
    _shortDescription = json['shortDescription'];
    _pricingBy = json['pricingBy'];
    _areaSizeUnit = json['areaSizeUnit'] ?? ''; // Default empty string if null
    _image = json['image'];
    _status = json['status'];
    _categoryTextId = json['categoryTextId'];
    _totalLike = json['totalLike'];
    _avgRating =
        json['avgRating'] != null ? json['avgRating'].toDouble() : null;

    // Check and populate ratingCardArray if available
    // if (json['ratingCardArray'] != null) {
    //   _ratingCardArray = [];
    //   json['ratingCardArray'].forEach((v) {
    //     _ratingCardArray!.add(RatingCard.fromJson(v));
    //   });
    // }

    // Initialize _attributes as an empty list if null
    _attributes = json['attributes'] != null
        ? (json['attributes'] as List)
            .map((v) => PendingAttribute.fromJson(v))
            .toList()
        : []; // Use an empty list if json['attributes'] is null
  }

  String? _title;
  String? _textId;
  String? _shortDescription;
  String? _pricingBy;
  String? _areaSizeUnit;
  String? _image;
  String? _status;
  String? _categoryTextId;
  int? _totalLike;
  double? _avgRating;
  // List<RatingCard>? _ratingCardArray;
  List<PendingAttribute>? _attributes;
  PricingServiceInfo copyWith({
    String? title,
    String? textId,
    String? shortDescription,
    String? pricingBy,
    String? areaSizeUnit,
    String? image,
    String? status,
    int? totalLike,
    double? avgRating,
    List<RatingCard>? ratingCardArray,
    List<PendingAttribute>? attributes,
  }) =>
      PricingServiceInfo(
        title: title ?? _title,
        textId: textId ?? _textId,
        shortDescription: shortDescription ?? _shortDescription,
        pricingBy: pricingBy ?? _pricingBy,
        areaSizeUnit: areaSizeUnit ?? _areaSizeUnit,
        image: image ?? _image,
        status: status ?? _status,
        totalLike: totalLike ?? _totalLike,
        avgRating: avgRating ?? _avgRating,
        //  ratingCardArray: ratingCardArray ?? _ratingCardArray,
        attributes: attributes ?? _attributes,
      );

  String? get title => _title;
  String? get textId => _textId;
  String? get shortDescription => _shortDescription;
  String? get pricingBy => _pricingBy;
  String? get areaSizeUnit => _areaSizeUnit;
  String? get image => _image;
  String? get status => _status;
  String? get categoryTextId => _categoryTextId;
  int? get totalLike => _totalLike;
  double? get avgRating => _avgRating;
  // List<RatingCard>? get ratingCardArray => _ratingCardArray;
  List<PendingAttribute>? get attributes => _attributes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['textId'] = _textId;
    map['shortDescription'] = _shortDescription;
    map['pricingBy'] = _pricingBy;
    map['areaSizeUnit'] = _areaSizeUnit;
    map['image'] = _image;
    map['status'] = _status;
    map['totalLike'] = _totalLike;
    map['avgRating'] = _avgRating;
    map['categoryTextId'] = _categoryTextId;
    // if (_ratingCardArray != null) {
    //   map['ratingCardArray'] = _ratingCardArray!.map((v) => v.toJson()).toList();
    // }
    if (_attributes != null) {
      map['attributes'] = _attributes!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class RatingCard {
  RatingCard({
    String? userName,
    String? image,
    double? rating,
    String? comments,
  }) {
    _userName = userName;
    _image = image;
    _rating = rating;
    _comments = comments;
  }

  RatingCard.fromJson(dynamic json) {
    _userName = json['userName'];
    _image = json['image'];
    _rating = json['rating'] != null ? json['rating'].toDouble() : null;
    _comments = json['comments'];
  }

  String? _userName;
  String? _image;
  double? _rating;
  String? _comments;

  String? get userName => _userName;
  String? get image => _image;
  double? get rating => _rating;
  String? get comments => _comments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userName'] = _userName;
    map['image'] = _image;
    map['rating'] = _rating;
    map['comments'] = _comments;
    return map;
  }
}

class PendingAttribute {
  PendingAttribute({
    String? title,
    List<String>? values,
  }) {
    _title = title;
    _values = values;
  }

  PendingAttribute.fromJson(dynamic json) {
    _title = json['title'];
    _values = json['values'] != null ? json['values'].cast<String>() : [];
  }

  String? _title;
  List<String>? _values;

  String? get title => _title;
  List<String>? get values => _values;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['values'] = _values;
    return map;
  }
}
