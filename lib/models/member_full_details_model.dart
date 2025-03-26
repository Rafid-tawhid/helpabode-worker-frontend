import 'package:help_abode_worker_app_ver_2/models/user_model.dart';
import 'package:help_abode_worker_app_ver_2/models/worker_service_request_model.dart';

class MemberFullDetailsModel {
  MemberFullDetailsModel({
    UserModel? profileData,
    num? successRate,
    num? averageRating,
    num? totalEarned,
    num? totalOrders,
    num? totalHours,
    List<WorkerServiceArray>? workerServiceArray,
    List<OrderItems>? orderData,
  }) {
    _profileData = profileData;
    _successRate = successRate;
    _averageRating = averageRating;
    _totalEarned = totalEarned;
    _totalOrders = totalOrders;
    _totalHours = totalHours;
    _workerServiceArray = workerServiceArray;
    _orderData = orderData;
  }

  MemberFullDetailsModel.fromJson(dynamic json) {
    _profileData = json['profile_data'] != null
        ? UserModel.fromJson(json['profile_data'])
        : null;
    _successRate = json['success_rate'];
    _averageRating = json['average_rating'];
    _totalEarned = json['total_earned'];
    _totalOrders = json['total_orders'];
    _totalHours = json['total_hours'];
    if (json['worker_service_array'] != null) {
      _workerServiceArray = [];
      json['worker_service_array'].forEach((v) {
        _workerServiceArray?.add(WorkerServiceArray.fromJson(v));
      });
    }
    if (json['runningOrderData'] != null) {
      _orderData = [];
      json['runningOrderData'].forEach((v) {
        _orderData?.add(OrderItems.fromJson(v));
      });
    }
  }
  UserModel? _profileData;
  num? _successRate;
  num? _averageRating;
  num? _totalEarned;
  num? _totalOrders;
  num? _totalHours;
  List<WorkerServiceArray>? _workerServiceArray;
  List<OrderItems>? _orderData;
  MemberFullDetailsModel copyWith({
    UserModel? profileData,
    num? successRate,
    num? averageRating,
    num? totalEarned,
    num? totalOrders,
    num? totalHours,
    List<WorkerServiceArray>? workerServiceArray,
    List<OrderItems>? orderData,
  }) =>
      MemberFullDetailsModel(
        profileData: profileData ?? _profileData,
        successRate: successRate ?? _successRate,
        averageRating: averageRating ?? _averageRating,
        totalEarned: totalEarned ?? _totalEarned,
        totalOrders: totalOrders ?? _totalOrders,
        totalHours: totalHours ?? _totalHours,
        workerServiceArray: workerServiceArray ?? _workerServiceArray,
        orderData: orderData ?? _orderData,
      );
  UserModel? get profileData => _profileData;
  num? get successRate => _successRate;
  num? get averageRating => _averageRating;
  num? get totalEarned => _totalEarned;
  num? get totalOrders => _totalOrders;
  num? get totalHours => _totalHours;
  List<WorkerServiceArray>? get workerServiceArray => _workerServiceArray;
  List<OrderItems>? get orderData => _orderData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_profileData != null) {
      map['profile_data'] = _profileData?.toJson();
    }
    map['success_rate'] = _successRate;
    map['average_rating'] = _averageRating;
    map['total_earned'] = _totalEarned;
    map['total_orders'] = _totalOrders;
    map['total_hours'] = _totalHours;
    if (_workerServiceArray != null) {
      map['worker_service_array'] =
          _workerServiceArray?.map((v) => v.toJson()).toList();
    }
    if (_orderData != null) {
      map['orderData'] = _orderData?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class EndUserDeliveryAddress {
  EndUserDeliveryAddress({
    String? zip,
    String? addressLine1,
    String? addressLine2,
    String? doorCode,
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
  String? _addressLine2;
  String? _doorCode;
  String? _city;
  String? _state;
  String? _latitude;
  String? _longitude;
  String? _countryIso2Code;
  EndUserDeliveryAddress copyWith({
    String? zip,
    String? addressLine1,
    String? addressLine2,
    String? doorCode,
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
  String? get addressLine2 => _addressLine2;
  String? get doorCode => _doorCode;
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
    String? addressLine2,
    String? doorCode,
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
  String? _addressLine2;
  String? _doorCode;
  String? _city;
  String? _state;
  String? _latitude;
  String? _longitude;
  String? _countryIso2Code;
  EndUserFullAddress copyWith({
    String? zip,
    String? addressLine1,
    String? addressLine2,
    String? doorCode,
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
  String? get addressLine2 => _addressLine2;
  String? get doorCode => _doorCode;
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

class WorkerServiceArray {
  WorkerServiceArray({
    String? serviceTitle,
    String? serviceTextId,
    String? status,
    String? pricingBy,
    String? categoryTitle,
    String? categoryTextId,
    String? serviceImage,
  }) {
    _serviceTitle = serviceTitle;
    _serviceTextId = serviceTextId;
    _status = status;
    _pricingBy = pricingBy;
    _categoryTitle = categoryTitle;
    _categoryTextId = categoryTextId;
    _serviceImage = serviceImage;
  }

  WorkerServiceArray.fromJson(dynamic json) {
    _serviceTitle = json['serviceTitle'];
    _serviceTextId = json['serviceTextId'];
    _status = json['status'];
    _pricingBy = json['pricingBy'];
    _categoryTitle = json['categoryTitle'];
    _categoryTextId = json['categoryTextId'];
    _serviceImage = json['service_image'];
  }
  String? _serviceTitle;
  String? _serviceTextId;
  String? _status;
  String? _pricingBy;
  String? _categoryTitle;
  String? _categoryTextId;
  String? _serviceImage;
  WorkerServiceArray copyWith({
    String? serviceTitle,
    String? serviceTextId,
    String? status,
    String? pricingBy,
    String? categoryTitle,
    String? categoryTextId,
    String? serviceImage,
  }) =>
      WorkerServiceArray(
        serviceTitle: serviceTitle ?? _serviceTitle,
        serviceTextId: serviceTextId ?? _serviceTextId,
        status: status ?? _status,
        pricingBy: pricingBy ?? _pricingBy,
        categoryTitle: categoryTitle ?? _categoryTitle,
        categoryTextId: categoryTextId ?? _categoryTextId,
        serviceImage: serviceImage ?? _serviceImage,
      );
  String? get serviceTitle => _serviceTitle;
  String? get serviceTextId => _serviceTextId;
  String? get status => _status;
  String? get pricingBy => _pricingBy;
  String? get categoryTitle => _categoryTitle;
  String? get categoryTextId => _categoryTextId;
  String? get serviceImage => _serviceImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serviceTitle'] = _serviceTitle;
    map['serviceTextId'] = _serviceTextId;
    map['status'] = _status;
    map['pricingBy'] = _pricingBy;
    map['categoryTitle'] = _categoryTitle;
    map['categoryTextId'] = _categoryTextId;
    map['service_image'] = _serviceImage;
    return map;
  }
}
