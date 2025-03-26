class DashboardRunningServicemodel {
  DashboardRunningServicemodel({
    String? serviceTitle,
    String? serviceTextId,
    String? serviceImage,
    num? serviceAmount,
    String? serviceStatus,
    String? scheduledDate,
    String? scheduledStartTime,
    String? scheduleEndtime,
    String? orderNumber,
    String? workerTextId,
    String? franchiseTextId,
    num? orderTimesId, // New field added
    bool isSelected = false,
  }) {
    _serviceTitle = serviceTitle;
    _serviceTextId = serviceTextId;
    _serviceImage = serviceImage;
    _serviceAmount = serviceAmount;
    _serviceStatus = serviceStatus;
    _scheduledDate = scheduledDate;
    _scheduledStartTime = scheduledStartTime;
    _scheduleEndtime = scheduleEndtime;
    _orderNumber = orderNumber;
    _workerTextId = workerTextId;
    _franchiseTextId = franchiseTextId;
    _orderTimesId = orderTimesId; // Initialize orderTimesId
    _isSelected = isSelected; // Initialize isSelected
  }

  // fromJson method
  DashboardRunningServicemodel.fromJson(dynamic json) {
    _serviceTitle = json['serviceTitle'];
    _serviceTextId = json['serviceTextId'];
    _serviceImage = json['serviceImage'];
    _serviceAmount = json['serviceAmount'];
    _serviceStatus = json['serviceStatus'];
    _scheduledDate = json['scheduledDate'];
    _scheduledStartTime = json['scheduledStartTime'];
    _scheduleEndtime = json['ScheduleEndtime'];
    _orderNumber = json['orderNumber'];
    _workerTextId = json['workerTextId'];
    _franchiseTextId = json['franchiseTextId'];
    _orderTimesId = json['orderTimesId']; // Extract orderTimesId from JSON
  }

  // Private members
  String? _serviceTitle;
  String? _serviceTextId;
  String? _serviceImage;
  num? _serviceAmount;
  String? _serviceStatus;
  String? _scheduledDate;
  String? _scheduledStartTime;
  String? _scheduleEndtime;
  String? _orderNumber;
  String? _workerTextId;
  String? _franchiseTextId;
  num? _orderTimesId; // New private variable
  bool _isSelected = false;

  // Getter and Setter for orderTimesId
  num? get orderTimesId => _orderTimesId;
  set orderTimesId(num? id) {
    _orderTimesId = id;
  }

  // Getter and Setter for isSelected
  bool get isSelected => _isSelected;
  set isSelected(bool value) {
    _isSelected = value;
  }

  // copyWith method
  DashboardRunningServicemodel copyWith({
    String? serviceTitle,
    String? serviceTextId,
    String? serviceImage,
    num? serviceAmount,
    String? serviceStatus,
    String? scheduledDate,
    String? scheduledStartTime,
    String? scheduleEndtime,
    String? orderNumber,
    String? workerTextId,
    String? franchiseTextId,
    num? orderTimesId, // Add orderTimesId to copyWith method
    bool? isSelected,
  }) =>
      DashboardRunningServicemodel(
        serviceTitle: serviceTitle ?? _serviceTitle,
        serviceTextId: serviceTextId ?? _serviceTextId,
        serviceImage: serviceImage ?? _serviceImage,
        serviceAmount: serviceAmount ?? _serviceAmount,
        serviceStatus: serviceStatus ?? _serviceStatus,
        scheduledDate: scheduledDate ?? _scheduledDate,
        scheduledStartTime: scheduledStartTime ?? _scheduledStartTime,
        scheduleEndtime: scheduleEndtime ?? _scheduleEndtime,
        orderNumber: orderNumber ?? _orderNumber,
        workerTextId: workerTextId ?? _workerTextId,
        franchiseTextId: franchiseTextId ?? _franchiseTextId,
        orderTimesId: orderTimesId ?? _orderTimesId, // Handle orderTimesId
        isSelected: isSelected ?? _isSelected,
      );

  // Getters for other fields
  String? get serviceTitle => _serviceTitle;
  String? get serviceTextId => _serviceTextId;
  String? get serviceImage => _serviceImage;
  num? get serviceAmount => _serviceAmount;
  String? get serviceStatus => _serviceStatus;
  String? get scheduledDate => _scheduledDate;
  String? get scheduledStartTime => _scheduledStartTime;
  String? get scheduleEndtime => _scheduleEndtime;
  String? get orderNumber => _orderNumber;
  String? get workerTextId => _workerTextId;
  String? get franchiseTextId => _franchiseTextId;

  // toJson method
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serviceTitle'] = _serviceTitle;
    map['serviceTextId'] = _serviceTextId;
    map['serviceImage'] = _serviceImage;
    map['serviceAmount'] = _serviceAmount;
    map['serviceStatus'] = _serviceStatus;
    map['scheduledDate'] = _scheduledDate;
    map['scheduledStartTime'] = _scheduledStartTime;
    map['ScheduleEndtime'] = _scheduleEndtime;
    map['orderNumber'] = _orderNumber;
    map['workerTextId'] = _workerTextId;
    map['franchiseTextId'] = _franchiseTextId;
    map['orderTimesId'] = _orderTimesId; // Add orderTimesId to JSON
    return map;
  }
}
