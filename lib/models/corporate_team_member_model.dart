class TeamMemberModel {
  TeamMemberModel({
    num? id,
    String? textId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? countryCode,
    String? status,
    String? employeeType,
    String? joined,
    String? profileImage,
  }) {
    _id = id;
    _textId = textId;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _phone = phone;
    _countryCode = countryCode;
    _status = status;
    _employeeType = employeeType;
    _joined = joined;
    _profileImage = profileImage;
  }

  TeamMemberModel.fromJson(dynamic json) {
    _id = json['id'];
    _textId = json['textId'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _email = json['email'];
    _phone = json['phone'];
    _countryCode = json['countryCode'];
    _status = json['status'];
    _employeeType = json['employeeType'];
    _joined = json['joined'];
    _profileImage = json['profileImage'];
  }
  num? _id;
  String? _textId;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phone;
  String? _countryCode;
  String? _status;
  String? _employeeType;
  String? _joined;
  String? _profileImage;
  TeamMemberModel copyWith({
    num? id,
    String? textId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? countryCode,
    String? status,
    String? employeeType,
    String? joined,
    String? profileImage,
  }) =>
      TeamMemberModel(
        id: id ?? _id,
        textId: textId ?? _textId,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        email: email ?? _email,
        phone: phone ?? _phone,
        countryCode: countryCode ?? _countryCode,
        status: status ?? _status,
        employeeType: employeeType ?? _employeeType,
        joined: joined ?? _joined,
        profileImage: profileImage ?? _profileImage,
      );
  num? get id => _id;
  String? get textId => _textId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get phone => _phone;
  String? get countryCode => _countryCode;
  String? get status => _status;
  String? get employeeType => _employeeType;
  String? get joined => _joined;
  String? get profileImage => _profileImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['textId'] = _textId;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['email'] = _email;
    map['phone'] = _phone;
    map['countryCode'] = _countryCode;
    map['status'] = _status;
    map['employeeType'] = _employeeType;
    map['joined'] = _joined;
    map['profileImage'] = _profileImage;
    return map;
  }
}
