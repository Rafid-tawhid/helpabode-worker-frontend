import 'package:help_abode_worker_app_ver_2/models/pending_service_details_model.dart';

class UpcomingServiceDetailsModel {
  UpcomingServiceDetailsModel({
    String? orderItemId,
    String? groupName,
    String? orderTextId,
    String? workerTextId,
    String? orderDate,
    String? scheduledDate,
    String? startTime,
    String? endtime,
    String? workHour,
    String? serviceTextId,
    String? serviceTitle,
    String? serviceImage,
    String? serviceAmount,
    String? shortDescription,
    String? latitude,
    String? longitude,
    dynamic instructionToWorker,
    String? serviceStatus,
    String? servicePlan,
    List<ServiceJson>? serviceJson,
    OrderDeliveryAddress? orderDeliveryAddress,
    String? orderStatus,
    List<OrderTracking>? orderTracking,
    List<dynamic>? reviewImage,
  }) {
    _orderItemId = orderItemId;
    _groupName = groupName;
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
    _shortDescription = shortDescription;
    _latitude = latitude;
    _longitude = longitude;
    _instructionToWorker = instructionToWorker;
    _serviceStatus = serviceStatus;
    _servicePlan = servicePlan;
    _serviceJson = serviceJson;
    _orderDeliveryAddress = orderDeliveryAddress;
    _orderStatus = orderStatus;
    _orderTracking = orderTracking;
    _reviewImage = reviewImage;
  }

  UpcomingServiceDetailsModel.fromJson(dynamic json) {
    _orderItemId = json['orderItemId'].toString();
    _groupName = json["groupName"];
    _orderTextId = json['orderTextId'];
    _workerTextId = json['workerTextId'];
    _orderDate = json['orderDate'];
    _scheduledDate = json['scheduledDate'];
    _startTime = json['StartTime'];
    _endtime = json['Endtime'];
    _workHour = json['workHour'].toString();
    _serviceTextId = json['serviceTextId'];
    _serviceTitle = json['serviceTitle'];
    _serviceImage = json['serviceImage'];
    _serviceAmount = json['serviceAmount'].toString();
    _shortDescription = json['shortDescription'];
    _latitude = json['latitude'].toString();
    _longitude = json['longitude'].toString();
    _instructionToWorker = json['instructionToWorker'];
    _serviceStatus = json['serviceStatus'];
    _servicePlan = json['servicePlan'];
    if (json['serviceJson'] != null) {
      _serviceJson = [];
      json['serviceJson'].forEach((v) {
        _serviceJson?.add(ServiceJson.fromJson(v));
      });
    }
    _orderDeliveryAddress = json['orderDeliveryAddress'] != null
        ? OrderDeliveryAddress.fromJson(json['orderDeliveryAddress'])
        : null;
    _orderStatus = json['orderStatus'];
    if (json['order_tracking'] != null) {
      _orderTracking = [];
      json['order_tracking'].forEach((v) {
        _orderTracking?.add(OrderTracking.fromJson(v));
      });
    }
    if (json['review_image'] != null) {
      // _reviewImage = [];
      // json['review_image'].forEach((v) {
      //   _reviewImage?.add(Dynamic.fromJson(v));
      // });
    }
  }
  String? _orderItemId;
  String? _groupName;
  String? _orderTextId;
  String? _workerTextId;
  String? _orderDate;
  String? _scheduledDate;
  String? _startTime;
  String? _endtime;
  String? _workHour;
  String? _serviceTextId;
  String? _serviceTitle;
  String? _serviceImage;
  String? _serviceAmount;
  String? _shortDescription;
  String? _latitude;
  String? _longitude;
  dynamic _instructionToWorker;
  String? _serviceStatus;
  String? _servicePlan;
  List<ServiceJson>? _serviceJson;
  OrderDeliveryAddress? _orderDeliveryAddress;
  String? _orderStatus;
  List<OrderTracking>? _orderTracking;
  List<dynamic>? _reviewImage;
  UpcomingServiceDetailsModel copyWith({
    String? orderItemId,
    String? groupName,
    String? orderTextId,
    String? workerTextId,
    String? orderDate,
    String? scheduledDate,
    String? startTime,
    String? endtime,
    String? workHour,
    String? serviceTextId,
    String? serviceTitle,
    String? serviceImage,
    String? serviceAmount,
    String? shortDescription,
    String? latitude,
    String? longitude,
    dynamic instructionToWorker,
    String? serviceStatus,
    String? servicePlan,
    List<ServiceJson>? serviceJson,
    OrderDeliveryAddress? orderDeliveryAddress,
    String? orderStatus,
    List<OrderTracking>? orderTracking,
    List<dynamic>? reviewImage,
  }) =>
      UpcomingServiceDetailsModel(
        orderItemId: orderItemId ?? _orderItemId,
        groupName: groupName ?? _groupName,
        orderTextId: orderTextId ?? _orderTextId,
        workerTextId: workerTextId ?? _workerTextId,
        orderDate: orderDate ?? _orderDate,
        scheduledDate: scheduledDate ?? _scheduledDate,
        startTime: startTime ?? _startTime,
        endtime: endtime ?? _endtime,
        workHour: workHour ?? _workHour,
        serviceTextId: serviceTextId ?? _serviceTextId,
        serviceTitle: serviceTitle ?? _serviceTitle,
        serviceImage: serviceImage ?? _serviceImage,
        serviceAmount: serviceAmount ?? _serviceAmount,
        shortDescription: shortDescription ?? _shortDescription,
        latitude: latitude ?? _latitude,
        longitude: longitude ?? _longitude,
        instructionToWorker: instructionToWorker ?? _instructionToWorker,
        serviceStatus: serviceStatus ?? _serviceStatus,
        servicePlan: servicePlan ?? _servicePlan,
        serviceJson: serviceJson ?? _serviceJson,
        orderDeliveryAddress: orderDeliveryAddress ?? _orderDeliveryAddress,
        orderStatus: orderStatus ?? _orderStatus,
        orderTracking: orderTracking ?? _orderTracking,
        reviewImage: reviewImage ?? _reviewImage,
      );
  String? get orderItemId => _orderItemId;
  String? get groupName => _groupName;
  String? get orderTextId => _orderTextId;
  String? get workerTextId => _workerTextId;
  String? get orderDate => _orderDate;
  String? get scheduledDate => _scheduledDate;
  String? get startTime => _startTime;
  String? get endtime => _endtime;
  String? get workHour => _workHour;
  String? get serviceTextId => _serviceTextId;
  String? get serviceTitle => _serviceTitle;
  String? get serviceImage => _serviceImage;
  String? get serviceAmount => _serviceAmount;
  String? get shortDescription => _shortDescription;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  dynamic get instructionToWorker => _instructionToWorker;
  String? get serviceStatus => _serviceStatus;
  String? get servicePlan => _servicePlan;
  List<ServiceJson>? get serviceJson => _serviceJson;
  OrderDeliveryAddress? get orderDeliveryAddress => _orderDeliveryAddress;
  String? get orderStatus => _orderStatus;
  List<OrderTracking>? get orderTracking => _orderTracking;
  List<dynamic>? get reviewImage => _reviewImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orderItemId'] = _orderItemId;
    map['groupName'] = _groupName;
    map['orderTextId'] = _orderTextId;
    map['workerTextId'] = _workerTextId;
    map['orderDate'] = _orderDate;
    map['scheduledDate'] = _scheduledDate;
    map['StartTime'] = _startTime;
    map['Endtime'] = _endtime;
    map['workHour'] = _workHour;
    map['serviceTextId'] = _serviceTextId;
    map['serviceTitle'] = _serviceTitle;
    map['serviceImage'] = _serviceImage;
    map['serviceAmount'] = _serviceAmount;
    map['shortDescription'] = _shortDescription;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['instructionToWorker'] = _instructionToWorker;
    map['serviceStatus'] = _serviceStatus;
    map['servicePlan'] = _servicePlan;
    if (_serviceJson != null) {
      map['serviceJson'] = _serviceJson?.map((v) => v.toJson()).toList();
    }
    if (_orderDeliveryAddress != null) {
      map['orderDeliveryAddress'] = _orderDeliveryAddress?.toJson();
    }
    map['orderStatus'] = _orderStatus;
    if (_orderTracking != null) {
      map['order_tracking'] = _orderTracking?.map((v) => v.toJson()).toList();
    }
    if (_reviewImage != null) {
      map['review_image'] = _reviewImage?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class OrderTracking {
  OrderTracking({
    String? endUserOrderTimeId,
    String? serviceTextId,
    String? status,
    String? created,
  }) {
    _endUserOrderTimeId = endUserOrderTimeId;
    _serviceTextId = serviceTextId;
    _status = status;
    _created = created;
  }

  OrderTracking.fromJson(dynamic json) {
    _endUserOrderTimeId = json['endUserOrderTimeId'].toString();
    _serviceTextId = json['serviceTextId'];
    _status = json['status'];
    _created = json['created'];
  }
  String? _endUserOrderTimeId;
  String? _serviceTextId;
  String? _status;
  String? _created;
  OrderTracking copyWith({
    String? endUserOrderTimeId,
    String? serviceTextId,
    String? status,
    String? created,
  }) =>
      OrderTracking(
        endUserOrderTimeId: endUserOrderTimeId ?? _endUserOrderTimeId,
        serviceTextId: serviceTextId ?? _serviceTextId,
        status: status ?? _status,
        created: created ?? _created,
      );
  String? get endUserOrderTimeId => _endUserOrderTimeId;
  String? get serviceTextId => _serviceTextId;
  String? get status => _status;
  String? get created => _created;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['endUserOrderTimeId'] = _endUserOrderTimeId;
    map['serviceTextId'] = _serviceTextId;
    map['status'] = _status;
    map['created'] = _created;
    return map;
  }
}

// class OrderDeliveryAddress {
//   OrderDeliveryAddress({
//     String? zip,
//     String? addressLine1Data,
//     dynamic addressLine2,
//     dynamic doorCode,
//     String? city,
//     String? state,
//     String? latitude,
//     String? longitude,
//     String? countryIso2Code,
//   }) {
//     _zip = zip;
//     _addressLine1Data = addressLine1Data;
//     _addressLine2 = addressLine2;
//     _doorCode = doorCode;
//     _city = city;
//     _state = state;
//     _latitude = latitude;
//     _longitude = longitude;
//     _countryIso2Code = countryIso2Code;
//   }
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
//   dynamic _addressLine2;
//   dynamic _doorCode;
//   String? _city;
//   String? _state;
//   String? _latitude;
//   String? _longitude;
//   String? _countryIso2Code;
//   OrderDeliveryAddress copyWith({
//     String? zip,
//     String? addressLine1Data,
//     dynamic addressLine2,
//     dynamic doorCode,
//     String? city,
//     String? state,
//     String? latitude,
//     String? longitude,
//     String? countryIso2Code,
//   }) =>
//       OrderDeliveryAddress(
//         zip: zip ?? _zip,
//         addressLine1Data: addressLine1Data ?? _addressLine1Data,
//         addressLine2: addressLine2 ?? _addressLine2,
//         doorCode: doorCode ?? _doorCode,
//         city: city ?? _city,
//         state: state ?? _state,
//         latitude: latitude ?? _latitude,
//         longitude: longitude ?? _longitude,
//         countryIso2Code: countryIso2Code ?? _countryIso2Code,
//       );
//   String? get zip => _zip;
//   String? get addressLine1Data => _addressLine1Data;
//   dynamic get addressLine2 => _addressLine2;
//   dynamic get doorCode => _doorCode;
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
// }

// class ServiceJson {
//   ServiceJson({
//     String? textId,
//     String? title,
//     String? amount,
//     String? attributeValue,
//   }) {
//     _textId = textId;
//     _title = title;
//     _amount = amount;
//     _attributeValue = attributeValue;
//   }
//
//   ServiceJson.fromJson(dynamic json) {
//     _textId = json['textId'];
//     _title = json['title'];
//     _amount = json['amount'].toString();
//     _attributeValue = json['attributeValue'].toString();
//   }
//   String? _textId;
//   String? _title;
//   String? _amount;
//   String? _attributeValue;
//   ServiceJson copyWith({
//     String? textId,
//     String? title,
//     String? amount,
//     String? attributeValue,
//   }) =>
//       ServiceJson(
//         textId: textId ?? _textId,
//         title: title ?? _title,
//         amount: amount ?? _amount,
//         attributeValue: attributeValue ?? _attributeValue,
//       );
//   String? get textId => _textId;
//   String? get title => _title;
//   String? get amount => _amount;
//   String? get attributeValue => _attributeValue;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['textId'] = _textId;
//     map['title'] = _title;
//     map['amount'] = _amount;
//     map['attributeValue'] = _attributeValue;
//     return map;
//   }
// }
