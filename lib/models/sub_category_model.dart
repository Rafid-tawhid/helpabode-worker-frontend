class SubCategoryModel {
  SubCategoryModel({
    num? id,
    String? textId,
    String? title,
    num? rank,
    String? details,
    String? status,
    dynamic dataRequireStatusOnNewUser,
  }) {
    _id = id;
    _textId = textId;
    _title = title;
    _rank = rank;
    _details = details;
    _status = status;
    _dataRequireStatusOnNewUser = dataRequireStatusOnNewUser;
  }

  SubCategoryModel.fromJson(dynamic json) {
    _id = json['id'];
    _textId = json['textId'];
    _title = json['title'];
    _rank = json['rank'];
    _details = json['details'];
    _status = json['status'];
    _dataRequireStatusOnNewUser = json['dataRequireStatusOnNewUser'];
  }
  num? _id;
  String? _textId;
  String? _title;
  num? _rank;
  String? _details;
  String? _status;
  dynamic _dataRequireStatusOnNewUser;
  SubCategoryModel copyWith({
    num? id,
    String? textId,
    String? title,
    num? rank,
    String? details,
    String? status,
    dynamic dataRequireStatusOnNewUser,
  }) =>
      SubCategoryModel(
        id: id ?? _id,
        textId: textId ?? _textId,
        title: title ?? _title,
        rank: rank ?? _rank,
        details: details ?? _details,
        status: status ?? _status,
        dataRequireStatusOnNewUser:
            dataRequireStatusOnNewUser ?? _dataRequireStatusOnNewUser,
      );
  num? get id => _id;
  String? get textId => _textId;
  String? get title => _title;
  num? get rank => _rank;
  String? get details => _details;
  String? get status => _status;
  dynamic get dataRequireStatusOnNewUser => _dataRequireStatusOnNewUser;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['textId'] = _textId;
    map['title'] = _title;
    map['rank'] = _rank;
    map['details'] = _details;
    map['status'] = _status;
    map['dataRequireStatusOnNewUser'] = _dataRequireStatusOnNewUser;
    return map;
  }
}
