class WorkerServiceRequestModel {
  WorkerServiceRequestModel({
    String? orderNumber,
    String? endUserName,
    String? endUserImage,
    EndUserFullAddress? endUserFullAddress,
    List<OrderItems>? orderItems,
  }) {
    _orderNumber = orderNumber;
    _endUserName = endUserName;
    _endUserImage = endUserImage;
    _endUserFullAddress = endUserFullAddress;
    _orderItems = orderItems;
  }

  WorkerServiceRequestModel.fromJson(dynamic json) {
    _orderNumber = json['orderNumber'];
    _endUserName = json['endUserName'];
    _endUserImage = json['endUserImage'];
    _endUserFullAddress = json['endUserFullAddress'] != null
        ? EndUserFullAddress.fromJson(json['endUserFullAddress'])
        : null;
    if (json['orderItems'] != null) {
      _orderItems = [];
      json['orderItems'].forEach((v) {
        _orderItems?.add(OrderItems.fromJson(v));
      });
    }
  }
  String? _orderNumber;
  String? _endUserName;
  String? _endUserImage;
  EndUserFullAddress? _endUserFullAddress;
  List<OrderItems>? _orderItems;
  WorkerServiceRequestModel copyWith({
    String? orderNumber,
    String? endUserName,
    String? endUserImage,
    EndUserFullAddress? endUserFullAddress,
    List<OrderItems>? orderItems,
  }) =>
      WorkerServiceRequestModel(
        orderNumber: orderNumber ?? _orderNumber,
        endUserName: endUserName ?? _endUserName,
        endUserImage: endUserImage ?? _endUserImage,
        endUserFullAddress: endUserFullAddress ?? _endUserFullAddress,
        orderItems: orderItems ?? _orderItems,
      );
  String? get orderNumber => _orderNumber;
  String? get endUserName => _endUserName;
  String? get endUserImage => _endUserImage;
  EndUserFullAddress? get endUserFullAddress => _endUserFullAddress;
  List<OrderItems>? get orderItems => _orderItems;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orderNumber'] = _orderNumber;
    map['endUserName'] = _endUserName;
    map['endUserImage'] = _endUserImage;
    if (_endUserFullAddress != null) {
      map['endUserFullAddress'] = _endUserFullAddress?.toJson();
    }
    if (_orderItems != null) {
      map['orderItems'] = _orderItems?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class OrderItems {
  OrderItems({
    num? orderTimesId,
    String? serviceTitle,
    String? serviceTextId,
    String? serviceImage,
    num? serviceAmount,
    String? serviceStatus,
    String? pricingBy,
    EndUserDeliveryAddress? endUserDeliveryAddress,
    String? scheduledDate,
    String? scheduledStartTime,
    String? orderPlaceTime,
    String? reviewRatingDate,
    String? comments,
    num? rateForWorkerByEndUser,
    String? scheduleEndtime,
    //only for member view details
    String? orderNumber,
  }) {
    _orderTimesId = orderTimesId;
    _serviceTitle = serviceTitle;
    _serviceTextId = serviceTextId;
    _serviceImage = serviceImage;
    _serviceAmount = serviceAmount;
    _serviceStatus = serviceStatus;
    _pricingBy = pricingBy;
    _endUserDeliveryAddress = endUserDeliveryAddress;
    _scheduledDate = scheduledDate;
    _scheduledStartTime = scheduledStartTime;
    _orderPlaceTime = orderPlaceTime;
    _scheduleEndtime = scheduleEndtime;
    _reviewRatingDate = reviewRatingDate;
    _orderNumber = orderNumber;
  }

  OrderItems.fromJson(dynamic json) {
    _orderTimesId = json['orderTimesId'];
    _serviceTitle = json['serviceTitle'];
    _serviceTextId = json['serviceTextId'];
    _serviceImage = json['serviceImage'];
    _serviceAmount = json['serviceAmount'];
    _serviceStatus = json['serviceStatus'];
    _reviewRatingDate = json['reviewRatingDate'];
    _pricingBy = json['pricingBy'];
    _comments = json['comments'];
    _endUserDeliveryAddress = json['endUserDeliveryAddress'] != null
        ? EndUserDeliveryAddress.fromJson(json['endUserDeliveryAddress'])
        : null;
    _scheduledDate = json['scheduledDate'];
    _scheduledStartTime = json['scheduledStartTime'];
    _orderPlaceTime = json['order_place_time'];
    _scheduleEndtime = json['ScheduleEndtime'];
    _rateForWorkerByEndUser = json['rateForWorkerByEndUser'] ?? 0;
    _scheduleEndtime = json['ScheduleEndtime'];
    _orderNumber = json['orderNumber'] ?? '';
  }
  num? _orderTimesId;
  String? _serviceTitle;
  String? _serviceTextId;
  String? _serviceImage;
  num? _serviceAmount;
  String? _serviceStatus;
  String? _pricingBy;
  EndUserDeliveryAddress? _endUserDeliveryAddress;
  String? _scheduledDate;
  String? _scheduledStartTime;
  String? _orderPlaceTime;
  String? _scheduleEndtime;
  String? _reviewRatingDate;
  String? _comments;
  String? _orderNumber;
  num? _rateForWorkerByEndUser;

  OrderItems copyWith(
          {num? orderTimesId,
          String? serviceTitle,
          String? serviceTextId,
          String? serviceImage,
          num? serviceAmount,
          String? serviceStatus,
          String? reviewRatingDate,
          String? pricingBy,
          String? comments,
          EndUserDeliveryAddress? endUserDeliveryAddress,
          String? scheduledDate,
          String? scheduledStartTime,
          String? orderPlaceTime,
          String? scheduleEndtime,
          String? orderNumber,
          num? rateForWorkerByEndUser}) =>
      OrderItems(
          orderTimesId: orderTimesId ?? _orderTimesId,
          serviceTitle: serviceTitle ?? _serviceTitle,
          serviceTextId: serviceTextId ?? _serviceTextId,
          serviceImage: serviceImage ?? _serviceImage,
          comments: comments ?? _comments,
          serviceAmount: serviceAmount ?? _serviceAmount,
          reviewRatingDate: reviewRatingDate ?? _reviewRatingDate,
          serviceStatus: serviceStatus ?? _serviceStatus,
          pricingBy: pricingBy ?? _pricingBy,
          endUserDeliveryAddress:
              endUserDeliveryAddress ?? _endUserDeliveryAddress,
          scheduledDate: scheduledDate ?? _scheduledDate,
          scheduledStartTime: scheduledStartTime ?? _scheduledStartTime,
          orderPlaceTime: orderPlaceTime ?? _orderPlaceTime,
          scheduleEndtime: scheduleEndtime ?? _scheduleEndtime,
          orderNumber: orderNumber ?? _orderNumber,
          rateForWorkerByEndUser:
              rateForWorkerByEndUser ?? _rateForWorkerByEndUser);
  num? get orderTimesId => _orderTimesId;
  String? get serviceTitle => _serviceTitle;
  String? get serviceTextId => _serviceTextId;
  String? get serviceImage => _serviceImage;
  num? get serviceAmount => _serviceAmount;
  String? get serviceStatus => _serviceStatus;
  String? get comments => _comments;
  String? get pricingBy => _pricingBy;
  EndUserDeliveryAddress? get endUserDeliveryAddress => _endUserDeliveryAddress;
  String? get scheduledDate => _scheduledDate;
  String? get scheduledStartTime => _scheduledStartTime;
  String? get orderPlaceTime => _orderPlaceTime;
  String? get scheduleEndtime => _scheduleEndtime;
  String? get reviewRatingDate => _reviewRatingDate;
  String? get orderNumber => _orderNumber;
  num? get rateForWorkerByEndUser => _rateForWorkerByEndUser;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orderTimesId'] = _orderTimesId;
    map['serviceTitle'] = _serviceTitle;
    map['serviceTextId'] = _serviceTextId;
    map['serviceImage'] = _serviceImage;
    map['serviceAmount'] = _serviceAmount;
    map['serviceStatus'] = _serviceStatus;
    map['comments'] = _comments;
    map['pricingBy'] = _pricingBy;
    if (_endUserDeliveryAddress != null) {
      map['endUserDeliveryAddress'] = _endUserDeliveryAddress?.toJson();
    }
    map['scheduledDate'] = _scheduledDate;
    map['scheduledStartTime'] = _scheduledStartTime;
    map['order_place_time'] = _orderPlaceTime;
    map['ScheduleEndtime'] = _scheduleEndtime;
    map['orderNumber'] = _orderNumber;
    return map;
  }
}

class EndUserDeliveryAddress {
  EndUserDeliveryAddress({
    String? zip,
    String? addressLine1,
    dynamic addressLine2,
    dynamic doorCode,
    String? city,
    String? state,
    String? latitude,
    String? longitude,
    String? countryIso2Code,
  }) {
    _zip = zip;
    _addressLine1 = addressLine1;
    _addressLine2 = addressLine2;
    _doorCode = doorCode;
    _city = city;
    _state = state;
    _latitude = latitude;
    _longitude = longitude;
    _countryIso2Code = countryIso2Code;
  }

  EndUserDeliveryAddress.fromJson(dynamic json) {
    _zip = json['zip'];
    _addressLine1 = json['addressLine1'];
    _addressLine2 = json['addressLine2'];
    _doorCode = json['doorCode'];
    _city = json['city'];
    _state = json['state'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _countryIso2Code = json['countryIso2Code'];
  }
  String? _zip;
  String? _addressLine1;
  dynamic _addressLine2;
  dynamic _doorCode;
  String? _city;
  String? _state;
  String? _latitude;
  String? _longitude;
  String? _countryIso2Code;
  EndUserDeliveryAddress copyWith({
    String? zip,
    String? addressLine1,
    dynamic addressLine2,
    dynamic doorCode,
    String? city,
    String? state,
    String? latitude,
    String? longitude,
    String? countryIso2Code,
  }) =>
      EndUserDeliveryAddress(
        zip: zip ?? _zip,
        addressLine1: addressLine1 ?? _addressLine1,
        addressLine2: addressLine2 ?? _addressLine2,
        doorCode: doorCode ?? _doorCode,
        city: city ?? _city,
        state: state ?? _state,
        latitude: latitude ?? _latitude,
        longitude: longitude ?? _longitude,
        countryIso2Code: countryIso2Code ?? _countryIso2Code,
      );
  String? get zip => _zip;
  String? get addressLine1 => _addressLine1;
  dynamic get addressLine2 => _addressLine2;
  dynamic get doorCode => _doorCode;
  String? get city => _city;
  String? get state => _state;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get countryIso2Code => _countryIso2Code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zip'] = _zip;
    map['addressLine1'] = _addressLine1;
    map['addressLine2'] = _addressLine2;
    map['doorCode'] = _doorCode;
    map['city'] = _city;
    map['state'] = _state;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['countryIso2Code'] = _countryIso2Code;
    return map;
  }
}

class EndUserFullAddress {
  EndUserFullAddress({
    String? zip,
    String? addressLine1,
    dynamic addressLine2,
    dynamic doorCode,
    String? city,
    String? state,
    String? latitude,
    String? longitude,
    String? countryIso2Code,
  }) {
    _zip = zip;
    _addressLine1 = addressLine1;
    _addressLine2 = addressLine2;
    _doorCode = doorCode;
    _city = city;
    _state = state;
    _latitude = latitude;
    _longitude = longitude;
    _countryIso2Code = countryIso2Code;
  }

  EndUserFullAddress.fromJson(dynamic json) {
    _zip = json['zip'];
    _addressLine1 = json['addressLine1'];
    _addressLine2 = json['addressLine2'];
    _doorCode = json['doorCode'];
    _city = json['city'];
    _state = json['state'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _countryIso2Code = json['countryIso2Code'];
  }
  String? _zip;
  String? _addressLine1;
  dynamic _addressLine2;
  dynamic _doorCode;
  String? _city;
  String? _state;
  String? _latitude;
  String? _longitude;
  String? _countryIso2Code;
  EndUserFullAddress copyWith({
    String? zip,
    String? addressLine1,
    dynamic addressLine2,
    dynamic doorCode,
    String? city,
    String? state,
    String? latitude,
    String? longitude,
    String? countryIso2Code,
  }) =>
      EndUserFullAddress(
        zip: zip ?? _zip,
        addressLine1: addressLine1 ?? _addressLine1,
        addressLine2: addressLine2 ?? _addressLine2,
        doorCode: doorCode ?? _doorCode,
        city: city ?? _city,
        state: state ?? _state,
        latitude: latitude ?? _latitude,
        longitude: longitude ?? _longitude,
        countryIso2Code: countryIso2Code ?? _countryIso2Code,
      );
  String? get zip => _zip;
  String? get addressLine1 => _addressLine1;
  dynamic get addressLine2 => _addressLine2;
  dynamic get doorCode => _doorCode;
  String? get city => _city;
  String? get state => _state;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get countryIso2Code => _countryIso2Code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zip'] = _zip;
    map['addressLine1'] = _addressLine1;
    map['addressLine2'] = _addressLine2;
    map['doorCode'] = _doorCode;
    map['city'] = _city;
    map['state'] = _state;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['countryIso2Code'] = _countryIso2Code;
    return map;
  }
}
