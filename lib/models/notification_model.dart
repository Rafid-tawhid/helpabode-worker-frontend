class NotificationModel {
  NotificationModel({
    num? id,
    String? title,
    String? messages,
    String? isSeen,
    String? senderTextId,
    String? senderType,
    String? receiverTextId,
    String? receiverType,
    String? created,
    String? updated,
    String? getStatus,
    String? notificationSendStage, // New field added here
    dynamic optionJson,
  }) {
    _id = id;
    _title = title;
    _messages = messages;
    _isSeen = isSeen;
    _senderTextId = senderTextId;
    _senderType = senderType;
    _receiverTextId = receiverTextId;
    _receiverType = receiverType;
    _created = created;
    _updated = updated;
    _getStatus = getStatus;
    _notificationSendStage = notificationSendStage; // Initialize new field
    _optionJson = optionJson;
  }

  set setIsSeen(String value) {
    _isSeen = value;
  }

  NotificationModel.fromJson(dynamic json) {
    _id = json['id'] ?? '';
    _title = json['title'] ?? '';
    _messages = json['messages'] ?? '';
    _isSeen = json['isSeen'] ?? '';
    _senderTextId = json['senderTextId'] ?? '';
    _senderType = json['senderType'] ?? '';
    _receiverTextId = json['receiverTextId'] ?? '';
    _receiverType = json['receiverType'] ?? '';
    _created = json['created'] ?? '';
    _updated = json['updated'] ?? '';
    _getStatus = json['get_status'] ?? '';
    _notificationSendStage =
        json['notificationSendStage'] ?? ''; // Parse new field
    _optionJson = json['optionJson'] != null ? json['optionJson'] : null;
  }

  num? _id;
  String? _title;
  String? _messages;
  String? _isSeen;
  String? _senderTextId;
  String? _senderType;
  String? _receiverTextId;
  String? _receiverType;
  String? _created;
  String? _updated;
  String? _getStatus;
  String? _notificationSendStage; // New private variable for the field
  dynamic _optionJson;

  NotificationModel copyWith({
    num? id,
    String? title,
    String? messages,
    String? isSeen,
    String? senderTextId,
    String? senderType,
    String? receiverTextId,
    String? receiverType,
    String? created,
    String? updated,
    String? getStatus,
    String? notificationSendStage, // Include new field in copyWith method
    OptionJson? optionJson,
  }) =>
      NotificationModel(
        id: id ?? _id,
        title: title ?? _title,
        messages: messages ?? _messages,
        isSeen: isSeen ?? _isSeen,
        senderTextId: senderTextId ?? _senderTextId,
        senderType: senderType ?? _senderType,
        receiverTextId: receiverTextId ?? _receiverTextId,
        receiverType: receiverType ?? _receiverType,
        created: created ?? _created,
        updated: updated ?? _updated,
        getStatus: getStatus ?? _getStatus,
        notificationSendStage: notificationSendStage ??
            _notificationSendStage, // Initialize in copyWith
        optionJson: optionJson ?? _optionJson,
      );

  num? get id => _id;
  String? get title => _title;
  String? get messages => _messages;
  String? get isSeen => _isSeen;
  String? get senderTextId => _senderTextId;
  String? get senderType => _senderType;
  String? get receiverTextId => _receiverTextId;
  String? get receiverType => _receiverType;
  String? get created => _created;
  String? get updated => _updated;
  String? get getStatus => _getStatus;
  String? get notificationSendStage =>
      _notificationSendStage; // Getter for new field
  dynamic get optionJson => _optionJson;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['messages'] = _messages;
    map['isSeen'] = _isSeen;
    map['senderTextId'] = _senderTextId;
    map['senderType'] = _senderType;
    map['receiverTextId'] = _receiverTextId;
    map['receiverType'] = _receiverType;
    map['created'] = _created;
    map['updated'] = _updated;
    map['get_status'] = _getStatus;
    map['notificationSendStage'] =
        _notificationSendStage; // Serialize new field
    if (_optionJson != null) {
      map['optionJson'] = _optionJson?.toJson();
    }
    return map;
  }
}

class OptionJson {
  OptionJson({
    this.fullName = "",
    this.orderTextId = "",
    this.serviceTextId = "",
    this.endUserOrderTimeId,
    this.workerTextId = "",
    this.franchiseTextId = "",
    this.endUserTextId = "",
    this.serviceTitle = "",
    this.scheduleDate = "",
    this.servicePlan = "",
    this.amount = "",
  });

  String fullName;
  String orderTextId;
  String serviceTextId;
  var endUserOrderTimeId;
  String workerTextId;
  String franchiseTextId;
  String endUserTextId;
  String serviceTitle;
  String scheduleDate;
  String servicePlan;
  String amount;

  // Factory constructor to create an instance from a JSON map
  factory OptionJson.fromJson(Map<String, dynamic> json) {
    return OptionJson(
      fullName: json['fullName'] ?? "",
      orderTextId: json['orderTextId'] ?? "",
      serviceTextId: json['serviceTextId'] ?? "",
      endUserOrderTimeId: json['endUserOrderTimeId'],
      workerTextId: json['workerTextId'] ?? "",
      franchiseTextId: json['franchiseTextId'] ?? "",
      endUserTextId: json['endUserTextId'] ?? "",
      serviceTitle: json['serviceTitle'] ?? "",
      scheduleDate: json['scheduleDate'] ?? "",
      servicePlan: json['servicePlan'] ?? "",
      amount: json['amount'] ?? "",
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'orderTextId': orderTextId,
      'serviceTextId': serviceTextId,
      'endUserOrderTimeId': endUserOrderTimeId,
      'workerTextId': workerTextId,
      'franchiseTextId': franchiseTextId,
      'endUserTextId': endUserTextId,
      'serviceTitle': serviceTitle,
      'scheduleDate': scheduleDate,
      'servicePlan': servicePlan,
      'amount': amount,
    };
  }
}
