class NotificationMenuModel {
  NotificationMenuModel({
    num? id,
    String? textId,
    String? title,
    String? notificationStatus,
    String? smsStatus,
    String? description,
  }) {
    _id = id;
    _textId = textId;
    _title = title;
    _notificationStatus = notificationStatus;
    _smsStatus = smsStatus;
    _description = description;
  }

  NotificationMenuModel.fromJson(dynamic json) {
    _id = json['id'];
    _textId = json['textId'];
    _title = json['title'];
    _notificationStatus = json['notificationStatus'];
    _smsStatus = json['smsStatus'];
    _description = json['description'];
  }
  num? _id;
  String? _textId;
  String? _title;
  String? _notificationStatus;
  String? _smsStatus;
  String? _description;
  NotificationMenuModel copyWith({
    num? id,
    String? textId,
    String? title,
    String? notificationStatus,
    String? smsStatus,
    String? description,
  }) =>
      NotificationMenuModel(
        id: id ?? _id,
        textId: textId ?? _textId,
        title: title ?? _title,
        notificationStatus: notificationStatus ?? _notificationStatus,
        smsStatus: smsStatus ?? _smsStatus,
        description: description ?? _description,
      );
  num? get id => _id;
  String? get textId => _textId;
  String? get title => _title;
  String? get notificationStatus => _notificationStatus;
  String? get smsStatus => _smsStatus;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['textId'] = _textId;
    map['title'] = _title;
    map['notificationStatus'] = _notificationStatus;
    map['smsStatus'] = _smsStatus;
    map['description'] = _description;
    return map;
  }
}
