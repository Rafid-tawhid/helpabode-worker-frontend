import 'package:help_abode_worker_app_ver_2/models/pending_service_details_model.dart';

class CompletedOrderDetailsModel {
  CompletedOrderDetailsModel({
    num? orderItemId,
    String? orderTextId,
    String? workerTextId,
    String? orderDate,
    String? scheduledDate,
    String? startTime,
    String? endtime,
    num? workHour,
    String? serviceTextId,
    String? serviceTitle,
    String? serviceImage,
    num? serviceAmount,
    String? servicePlan,
    List<ServiceJson>? serviceJson,
    String? shortDescription,
    OrderDeliveryAddress? orderDeliveryAddress,
    String? orderStatus,
    num? rateForWorkerByEndUser,
    String? comments,
    String? order_place_time,
    String? reviewRatingDate,
    String? userFullName,
    num? tipAmount,
    bool? isReviewImages,
    List<String>? beforeArray,
    List<String>? afterArray,
  }) {
    _orderItemId = orderItemId;
    _orderTextId = orderTextId;
    _workerTextId = workerTextId;
    _orderDate = orderDate;
    _scheduledDate = scheduledDate;
    _startTime = startTime;
    _endtime = endtime;
    _workHour = workHour;
    _serviceTextId = serviceTextId;
    _serviceTitle = serviceTitle;
    _serviceImage = serviceImage;
    _serviceAmount = serviceAmount;
    _servicePlan = servicePlan;
    _serviceJson = serviceJson;
    _shortDescription = shortDescription;
    _reviewRatingDate = reviewRatingDate;
    _orderDeliveryAddress = orderDeliveryAddress;
    _orderStatus = orderStatus;
    _rateForWorkerByEndUser = rateForWorkerByEndUser;
    _comments = comments;
    _isReviewImages = isReviewImages;
    _beforeArray = beforeArray;
    _afterArray = afterArray;
    _userFullName = userFullName;
    _tipAmount = tipAmount;
  }

  CompletedOrderDetailsModel.fromJson(dynamic json) {
    _orderItemId = json['orderItemId'];
    _orderTextId = json['orderTextId'];
    _workerTextId = json['workerTextId'];
    _orderDate = json['orderDate'];
    _scheduledDate = json['scheduledDate'];
    _startTime = json['scheduledStartTime'];
    _endtime = json['ScheduleEndtime'];
    _workHour = json['workHour'];
    _serviceTextId = json['serviceTextId'];
    _reviewRatingDate = json['reviewRatingDate'];
    _serviceTitle = json['serviceTitle'];
    _serviceImage = json['serviceImage'];
    _serviceAmount = json['serviceAmount'];
    _order_place_time = json['order_place_time'];
    _userFullName = json['userFullName'];
    _servicePlan = json['servicePlan'];
    _tipAmount = json['tipAmount'];
    if (json['serviceJson'] != null) {
      _serviceJson = [];
      json['serviceJson'].forEach((v) {
        _serviceJson?.add(ServiceJson.fromJson(v));
      });
    }
    _shortDescription = json['shortDescription'];
    _orderDeliveryAddress = json['orderDeliveryAddress'] != null
        ? OrderDeliveryAddress.fromJson(json['orderDeliveryAddress'])
        : null;
    _orderStatus = json['orderStatus'];
    _rateForWorkerByEndUser = json['rateForWorkerByEndUser'];
    _comments = json['comments'];
    _isReviewImages = json['isReviewImages'];
    _beforeArray =
        json['beforeArray'] != null ? json['beforeArray'].cast<String>() : [];
    _afterArray =
        json['afterArray'] != null ? json['afterArray'].cast<String>() : [];
  }
  num? _orderItemId;
  String? _orderTextId;
  String? _workerTextId;
  String? _orderDate;
  String? _scheduledDate;
  String? _startTime;
  String? _endtime;
  num? _workHour;
  String? _serviceTextId;
  String? _serviceTitle;
  String? _serviceImage;
  num? _serviceAmount;
  String? _servicePlan;
  num? _tipAmount;
  List<ServiceJson>? _serviceJson;
  String? _shortDescription;
  OrderDeliveryAddress? _orderDeliveryAddress;
  String? _orderStatus;
  num? _rateForWorkerByEndUser;
  String? _comments;
  String? _order_place_time;
  String? _reviewRatingDate;
  String? _userFullName;
  bool? _isReviewImages;

  List<String>? _beforeArray;
  List<String>? _afterArray;
  CompletedOrderDetailsModel copyWith({
    num? orderItemId,
    String? orderTextId,
    String? workerTextId,
    String? orderDate,
    String? scheduledDate,
    String? startTime,
    String? endtime,
    num? tipAmount,
    String? reviewRatingDate,
    num? workHour,
    String? serviceTextId,
    String? serviceTitle,
    String? serviceImage,
    num? serviceAmount,
    String? servicePlan,
    List<ServiceJson>? serviceJson,
    String? shortDescription,
    OrderDeliveryAddress? orderDeliveryAddress,
    String? orderStatus,
    num? rateForWorkerByEndUser,
    String? comments,
    String? order_place_time,
    String? userFullName,
    bool? isReviewImages,
    List<String>? beforeArray,
    List<String>? afterArray,
  }) =>
      CompletedOrderDetailsModel(
        orderItemId: orderItemId ?? _orderItemId,
        orderTextId: orderTextId ?? _orderTextId,
        workerTextId: workerTextId ?? _workerTextId,
        orderDate: orderDate ?? _orderDate,
        scheduledDate: scheduledDate ?? _scheduledDate,
        reviewRatingDate: reviewRatingDate ?? _reviewRatingDate,
        startTime: startTime ?? _startTime,
        endtime: endtime ?? _endtime,
        workHour: workHour ?? _workHour,
        tipAmount: tipAmount ?? _tipAmount,
        serviceTextId: serviceTextId ?? _serviceTextId,
        serviceTitle: serviceTitle ?? _serviceTitle,
        serviceImage: serviceImage ?? _serviceImage,
        serviceAmount: serviceAmount ?? _serviceAmount,
        servicePlan: servicePlan ?? _servicePlan,
        serviceJson: serviceJson ?? _serviceJson,
        order_place_time: order_place_time ?? _order_place_time,
        shortDescription: shortDescription ?? _shortDescription,
        orderDeliveryAddress: orderDeliveryAddress ?? _orderDeliveryAddress,
        orderStatus: orderStatus ?? _orderStatus,
        rateForWorkerByEndUser:
            rateForWorkerByEndUser ?? _rateForWorkerByEndUser,
        comments: comments ?? _comments,
        isReviewImages: isReviewImages ?? _isReviewImages,
        beforeArray: beforeArray ?? _beforeArray,
        afterArray: afterArray ?? _afterArray,
        userFullName: userFullName ?? _userFullName,
      );
  num? get orderItemId => _orderItemId;
  String? get orderTextId => _orderTextId;
  String? get workerTextId => _workerTextId;
  String? get reviewRatingDate => _reviewRatingDate;
  String? get orderDate => _orderDate;
  String? get scheduledDate => _scheduledDate;
  String? get startTime => _startTime;
  String? get endtime => _endtime;
  String? get order_place_time => _order_place_time;
  num? get workHour => _workHour;
  String? get serviceTextId => _serviceTextId;
  String? get serviceTitle => _serviceTitle;
  String? get serviceImage => _serviceImage;
  num? get serviceAmount => _serviceAmount;
  String? get servicePlan => _servicePlan;
  List<ServiceJson>? get serviceJson => _serviceJson;
  String? get shortDescription => _shortDescription;
  OrderDeliveryAddress? get orderDeliveryAddress => _orderDeliveryAddress;
  String? get orderStatus => _orderStatus;
  num? get rateForWorkerByEndUser => _rateForWorkerByEndUser;
  String? get comments => _comments;
  String? get userFullName => _userFullName;
  num? get tipAmount => _tipAmount;
  bool? get isReviewImages => _isReviewImages;
  List<String>? get beforeArray => _beforeArray;
  List<String>? get afterArray => _afterArray;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orderItemId'] = _orderItemId;
    map['orderTextId'] = _orderTextId;
    map['workerTextId'] = _workerTextId;
    map['reviewRatingDate'] = _reviewRatingDate;
    map['orderDate'] = _orderDate;
    map['scheduledDate'] = _scheduledDate;
    map['StartTime'] = _startTime;
    map['Endtime'] = _endtime;
    map['workHour'] = _workHour;
    map['serviceTextId'] = _serviceTextId;
    map['serviceTitle'] = _serviceTitle;
    map['serviceImage'] = _serviceImage;
    map['serviceAmount'] = _serviceAmount;
    map['servicePlan'] = _servicePlan;
    if (_serviceJson != null) {
      map['serviceJson'] = _serviceJson?.map((v) => v.toJson()).toList();
    }
    map['shortDescription'] = _shortDescription;
    if (_orderDeliveryAddress != null) {
      map['orderDeliveryAddress'] = _orderDeliveryAddress?.toJson();
    }
    map['orderStatus'] = _orderStatus;
    map['rateForWorkerByEndUser'] = _rateForWorkerByEndUser;
    map['comments'] = _comments;
    map['isReviewImages'] = _isReviewImages;
    map['beforeArray'] = _beforeArray;
    map['afterArray'] = _afterArray;
    map['userFullName'] = _userFullName;
    return map;
  }
}

// class OrderDeliveryAddress {
//   OrderDeliveryAddress({
//       String? zip,
//       String? addressLine1Data,
//       String? addressLine2,
//       String? doorCode,
//       String? city,
//       String? state,
//       String? latitude,
//       String? longitude,
//       String? countryIso2Code,}){
//     _zip = zip;
//     _addressLine1Data = addressLine1Data;
//     _addressLine2 = addressLine2;
//     _doorCode = doorCode;
//     _city = city;
//     _state = state;
//     _latitude = latitude;
//     _longitude = longitude;
//     _countryIso2Code = countryIso2Code;
// }
//
//   OrderDeliveryAddress.fromJson(dynamic json) {
//     _zip = json['zip'];
//     _addressLine1Data = json['addressLine1Data'];
//     _addressLine2 = json['addressLine2'];
//     _doorCode = json['doorCode'];
//     _city = json['city'];
//     _state = json['state'];
//     _latitude = json['latitude'];
//     _longitude = json['longitude'];
//     _countryIso2Code = json['countryIso2Code'];
//   }
//   String? _zip;
//   String? _addressLine1Data;
//   String? _addressLine2;
//   String? _doorCode;
//   String? _city;
//   String? _state;
//   String? _latitude;
//   String? _longitude;
//   String? _countryIso2Code;
// OrderDeliveryAddress copyWith({  String? zip,
//   String? addressLine1Data,
//   String? addressLine2,
//   String? doorCode,
//   String? city,
//   String? state,
//   String? latitude,
//   String? longitude,
//   String? countryIso2Code,
// }) => OrderDeliveryAddress(  zip: zip ?? _zip,
//   addressLine1Data: addressLine1Data ?? _addressLine1Data,
//   addressLine2: addressLine2 ?? _addressLine2,
//   doorCode: doorCode ?? _doorCode,
//   city: city ?? _city,
//   state: state ?? _state,
//   latitude: latitude ?? _latitude,
//   longitude: longitude ?? _longitude,
//   countryIso2Code: countryIso2Code ?? _countryIso2Code,
// );
//   String? get zip => _zip;
//   String? get addressLine1Data => _addressLine1;
//   String? get addressLine2 => _addressLine2;
//   String? get doorCode => _doorCode;
//   String? get city => _city;
//   String? get state => _state;
//   String? get latitude => _latitude;
//   String? get longitude => _longitude;
//   String? get countryIso2Code => _countryIso2Code;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['zip'] = _zip;
//     map['addressLine1'] = _addressLine1;
//     map['addressLine2'] = _addressLine2;
//     map['doorCode'] = _doorCode;
//     map['city'] = _city;
//     map['state'] = _state;
//     map['latitude'] = _latitude;
//     map['longitude'] = _longitude;
//     map['countryIso2Code'] = _countryIso2Code;
//     return map;
//   }
//
// }

// class ServiceJson {
//   ServiceJson({
//       String? textId,
//       String? title,
//       num? amount,
//       num? attributeValue,}){
//     _textId = textId;
//     _title = title;
//     _amount = amount;
//     _attributeValue = attributeValue;
// }
//
//   ServiceJson.fromJson(dynamic json) {
//     _textId = json['textId'];
//     _title = json['title'];
//     _amount = json['amount'];
//     _attributeValue = json['attributeValue'];
//   }
//   String? _textId;
//   String? _title;
//   num? _amount;
//   num? _attributeValue;
// ServiceJson copyWith({  String? textId,
//   String? title,
//   num? amount,
//   num? attributeValue,
// }) => ServiceJson(  textId: textId ?? _textId,
//   title: title ?? _title,
//   amount: amount ?? _amount,
//   attributeValue: attributeValue ?? _attributeValue,
// );
//   String? get textId => _textId;
//   String? get title => _title;
//   num? get amount => _amount;
//   num? get attributeValue => _attributeValue;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['textId'] = _textId;
//     map['title'] = _title;
//     map['amount'] = _amount;
//     map['attributeValue'] = _attributeValue;
//     return map;
//   }
//
// }
