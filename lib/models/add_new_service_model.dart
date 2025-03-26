class AddNewServiceModel {
  AddNewServiceModel({
    num? id,
    String? textId,
    String? title,
    String? parent,
    num? rank,
    String? details,
    String? status,
    bool isSelected = false,
    dynamic dataRequireStatusOnNewUser,
  }) {
    _id = id;
    _textId = textId;
    _title = title;
    _parent = parent;
    _rank = rank;
    _details = details;
    _status = status;
    _dataRequireStatusOnNewUser = dataRequireStatusOnNewUser;
  }

  AddNewServiceModel.fromJson(dynamic json) {
    _id = json['id'];
    _textId = json['textId'];
    _title = json['title'];
    _parent = json['parent'];
    _rank = json['rank'];
    _details = json['details'];
    _status = json['status'];
    _dataRequireStatusOnNewUser = json['dataRequireStatusOnNewUser'];
  }
  num? _id;
  String? _textId;
  String? _title;
  String? _parent;
  num? _rank;
  String? _details;
  String? _status;
  dynamic _dataRequireStatusOnNewUser;
  bool isSelected = false;
  AddNewServiceModel copyWith({
    num? id,
    String? textId,
    String? title,
    String? parent,
    num? rank,
    String? details,
    String? status,
    dynamic dataRequireStatusOnNewUser,
  }) =>
      AddNewServiceModel(
        id: id ?? _id,
        textId: textId ?? _textId,
        title: title ?? _title,
        parent: parent ?? _parent,
        rank: rank ?? _rank,
        details: details ?? _details,
        status: status ?? _status,
        dataRequireStatusOnNewUser:
            dataRequireStatusOnNewUser ?? _dataRequireStatusOnNewUser,
      );
  num? get id => _id;
  String? get textId => _textId;
  String? get title => _title;
  String? get parent => _parent;
  num? get rank => _rank;
  String? get details => _details;
  String? get status => _status;
  dynamic get dataRequireStatusOnNewUser => _dataRequireStatusOnNewUser;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['textId'] = _textId;
    map['title'] = _title;
    map['parent'] = _parent;
    map['rank'] = _rank;
    map['details'] = _details;
    map['status'] = _status;
    map['dataRequireStatusOnNewUser'] = _dataRequireStatusOnNewUser;
    return map;
  }
}
