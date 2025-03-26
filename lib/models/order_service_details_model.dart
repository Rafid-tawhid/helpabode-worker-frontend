import 'package:help_abode_worker_app_ver_2/models/worker_service_request_model.dart';

class OrderServiceDetailsModel {
  OrderServiceDetailsModel({
    List<UserData>? userData,
    List<OrderItems>? orderData,
  }) {
    _userData = userData;
    _orderData = orderData;
  }

  OrderServiceDetailsModel.fromJson(dynamic json) {
    if (json['userData'] != null) {
      _userData = [];
      json['userData'].forEach((v) {
        _userData?.add(UserData.fromJson(v));
      });
    }
    if (json['order_data'] != null) {
      _orderData = [];
      json['order_data'].forEach((v) {
        _orderData?.add(OrderItems.fromJson(v));
      });
    }
  }
  List<UserData>? _userData;
  List<OrderItems>? _orderData;
  OrderServiceDetailsModel copyWith({
    List<UserData>? userData,
    List<OrderItems>? orderData,
  }) =>
      OrderServiceDetailsModel(
        userData: userData ?? _userData,
        orderData: orderData ?? _orderData,
      );
  List<UserData>? get userData => _userData;
  List<OrderItems>? get orderData => _orderData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_userData != null) {
      map['userData'] = _userData?.map((v) => v.toJson()).toList();
    }
    if (_orderData != null) {
      map['order_data'] = _orderData?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class UserData {
  UserData({
    String? userFullName,
    String? userImage,
    String? userAddress,
  }) {
    _userFullName = userFullName;
    _userImage = userImage;
    _userAddress = userAddress;
  }

  UserData.fromJson(dynamic json) {
    _userFullName = json['endUserName'];
    _userImage = json['endUserImage'];
    _userAddress = json['endUserAddress'];
  }
  String? _userFullName;
  String? _userImage;
  String? _userAddress;
  UserData copyWith({
    String? userFullName,
    String? userImage,
    String? userAddress,
  }) =>
      UserData(
        userFullName: userFullName ?? _userFullName,
        userImage: userImage ?? _userImage,
        userAddress: userAddress ?? _userAddress,
      );
  String? get userFullName => _userFullName;
  String? get userImage => _userImage;
  String? get userAddress => _userAddress;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userFullName'] = _userFullName;
    map['userImage'] = _userImage;
    map['userAddress'] = _userAddress;
    return map;
  }
}
