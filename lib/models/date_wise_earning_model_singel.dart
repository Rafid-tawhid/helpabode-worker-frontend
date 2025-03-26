class DateWiseEarningModelSingel {
  DateWiseEarningModelSingel({
    String? workerTextId,
    String? franchiseTextId,
    num? amount,
    String? serviceTitle,
    String? serviceTextId,
    num? serviceAmount,
    String? serviceStatus,
    String? scheduledDate,
    String? scheduledStartTime,
    String? scheduleEndtime,
    num? tipAmount,
  }) {
    _workerTextId = workerTextId;
    _franchiseTextId = franchiseTextId;
    _amount = amount;
    _serviceTitle = serviceTitle;
    _serviceTextId = serviceTextId;
    _serviceAmount = serviceAmount;
    _serviceStatus = serviceStatus;
    _scheduledDate = scheduledDate;
    _scheduledStartTime = scheduledStartTime;
    _scheduleEndtime = scheduleEndtime;
    _tipAmount = tipAmount;
  }

  DateWiseEarningModelSingel.fromJson(dynamic json) {
    _workerTextId = json['workerTextId'];
    _franchiseTextId = json['franchiseTextId'];
    _amount = json['amount'];
    _serviceTitle = json['serviceTitle'];
    _serviceTextId = json['serviceTextId'];
    _serviceAmount = json['serviceAmount'];
    _serviceStatus = json['serviceStatus'];
    _scheduledDate = json['scheduledDate'];
    _scheduledStartTime = json['scheduledStartTime'];
    _scheduleEndtime = json['ScheduleEndtime'];
    _tipAmount = json['tipAmount'];
  }
  String? _workerTextId;
  String? _franchiseTextId;
  num? _amount;
  String? _serviceTitle;
  String? _serviceTextId;
  num? _serviceAmount;
  String? _serviceStatus;
  String? _scheduledDate;
  String? _scheduledStartTime;
  String? _scheduleEndtime;
  num? _tipAmount;
  DateWiseEarningModelSingel copyWith({
    String? workerTextId,
    String? franchiseTextId,
    num? amount,
    String? serviceTitle,
    String? serviceTextId,
    num? serviceAmount,
    String? serviceStatus,
    String? scheduledDate,
    String? scheduledStartTime,
    String? scheduleEndtime,
    num? tipAmount,
  }) =>
      DateWiseEarningModelSingel(
        workerTextId: workerTextId ?? _workerTextId,
        franchiseTextId: franchiseTextId ?? _franchiseTextId,
        amount: amount ?? _amount,
        serviceTitle: serviceTitle ?? _serviceTitle,
        serviceTextId: serviceTextId ?? _serviceTextId,
        serviceAmount: serviceAmount ?? _serviceAmount,
        serviceStatus: serviceStatus ?? _serviceStatus,
        scheduledDate: scheduledDate ?? _scheduledDate,
        scheduledStartTime: scheduledStartTime ?? _scheduledStartTime,
        scheduleEndtime: scheduleEndtime ?? _scheduleEndtime,
        tipAmount: tipAmount ?? _tipAmount,
      );
  String? get workerTextId => _workerTextId;
  String? get franchiseTextId => _franchiseTextId;
  num? get amount => _amount;
  String? get serviceTitle => _serviceTitle;
  String? get serviceTextId => _serviceTextId;
  num? get serviceAmount => _serviceAmount;
  String? get serviceStatus => _serviceStatus;
  String? get scheduledDate => _scheduledDate;
  String? get scheduledStartTime => _scheduledStartTime;
  String? get scheduleEndtime => _scheduleEndtime;
  num? get tipAmount => _tipAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['workerTextId'] = _workerTextId;
    map['franchiseTextId'] = _franchiseTextId;
    map['amount'] = _amount;
    map['serviceTitle'] = _serviceTitle;
    map['serviceTextId'] = _serviceTextId;
    map['serviceAmount'] = _serviceAmount;
    map['serviceStatus'] = _serviceStatus;
    map['scheduledDate'] = _scheduledDate;
    map['scheduledStartTime'] = _scheduledStartTime;
    map['ScheduleEndtime'] = _scheduleEndtime;
    map['tipAmount'] = _tipAmount;
    return map;
  }
}
