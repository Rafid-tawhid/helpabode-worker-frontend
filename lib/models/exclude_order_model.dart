class ExcludeOrderModel {
  ExcludeOrderModel({
    String? orderTextId,
    num? amount,
    String? orderPlaceTime,
    String? scheduledDate,
    String? scheduledStartTime,
    String? scheduleEndtime,
    num? rateForWorkerByEndUser,
    dynamic commentForWorkerByEndUser,
    String? userName,
    String? userImage,
  }) {
    _orderTextId = orderTextId;
    _amount = amount;
    _orderPlaceTime = orderPlaceTime;
    _scheduledDate = scheduledDate;
    _scheduledStartTime = scheduledStartTime;
    _scheduleEndtime = scheduleEndtime;
    _rateForWorkerByEndUser = rateForWorkerByEndUser;
    _commentForWorkerByEndUser = commentForWorkerByEndUser;
    _userName = userName;
    _userImage = userImage;
  }

  ExcludeOrderModel.fromJson(dynamic json) {
    _orderTextId = json['orderTextId'];
    _amount = json['amount'];
    _orderPlaceTime = json['order_place_time'];
    _scheduledDate = json['scheduledDate'];
    _scheduledStartTime = json['scheduledStartTime'];
    _scheduleEndtime = json['ScheduleEndtime'];
    _rateForWorkerByEndUser = json['rateForWorkerByEndUser'];
    _commentForWorkerByEndUser = json['commentForWorkerByEndUser'];
    _userName = json['userName'];
    _userImage = json['userImage'];
  }
  String? _orderTextId;
  num? _amount;
  String? _orderPlaceTime;
  String? _scheduledDate;
  String? _scheduledStartTime;
  String? _scheduleEndtime;
  num? _rateForWorkerByEndUser;
  dynamic _commentForWorkerByEndUser;
  String? _userName;
  String? _userImage;
  ExcludeOrderModel copyWith({
    String? orderTextId,
    num? amount,
    String? orderPlaceTime,
    String? scheduledDate,
    String? scheduledStartTime,
    String? scheduleEndtime,
    num? rateForWorkerByEndUser,
    dynamic commentForWorkerByEndUser,
    String? userName,
    String? userImage,
  }) =>
      ExcludeOrderModel(
        orderTextId: orderTextId ?? _orderTextId,
        amount: amount ?? _amount,
        orderPlaceTime: orderPlaceTime ?? _orderPlaceTime,
        scheduledDate: scheduledDate ?? _scheduledDate,
        scheduledStartTime: scheduledStartTime ?? _scheduledStartTime,
        scheduleEndtime: scheduleEndtime ?? _scheduleEndtime,
        rateForWorkerByEndUser:
            rateForWorkerByEndUser ?? _rateForWorkerByEndUser,
        commentForWorkerByEndUser:
            commentForWorkerByEndUser ?? _commentForWorkerByEndUser,
        userName: userName ?? _userName,
        userImage: userImage ?? _userImage,
      );
  String? get orderTextId => _orderTextId;
  num? get amount => _amount;
  String? get orderPlaceTime => _orderPlaceTime;
  String? get scheduledDate => _scheduledDate;
  String? get scheduledStartTime => _scheduledStartTime;
  String? get scheduleEndtime => _scheduleEndtime;
  num? get rateForWorkerByEndUser => _rateForWorkerByEndUser;
  dynamic get commentForWorkerByEndUser => _commentForWorkerByEndUser;
  String? get userName => _userName;
  String? get userImage => _userImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orderTextId'] = _orderTextId;
    map['amount'] = _amount;
    map['order_place_time'] = _orderPlaceTime;
    map['scheduledDate'] = _scheduledDate;
    map['scheduledStartTime'] = _scheduledStartTime;
    map['ScheduleEndtime'] = _scheduleEndtime;
    map['rateForWorkerByEndUser'] = _rateForWorkerByEndUser;
    map['commentForWorkerByEndUser'] = _commentForWorkerByEndUser;
    map['userName'] = _userName;
    map['userImage'] = _userImage;
    return map;
  }
}
