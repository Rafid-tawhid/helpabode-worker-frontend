// class AddIndividualUserModel {
//   AddIndividualUserModel({
//     num? id,
//     String? textId,
//     String? teamName,
//     String? email,
//     String? phone,
//     String? countryCode,
//     String? profileImage,
//     String? employeeType,
//     String? status,
//   }) {
//     _id = id;
//     _textId = textId;
//     _teamName = teamName;
//     _email = email;
//     _phone = phone;
//     _countryCode = countryCode;
//     _profileImage = profileImage;
//     _employeeType = employeeType;
//     _status = status;
//   }
//
//   AddIndividualUserModel.fromJson(dynamic json) {
//     _id = json['id'];
//     _textId = json['textId'];
//     _teamName = json['team_name'];
//     _email = json['email'];
//     _phone = json['phone'];
//     _countryCode = json['countryCode'];
//     _profileImage = json['profileImage'];
//     _employeeType = json['employeeType'];
//     _status = json['status'];
//   }
//
//   num? _id;
//   String? _textId;
//   String? _teamName;
//   String? _email;
//   String? _phone;
//   String? _countryCode;
//   String? _profileImage;
//   String? _employeeType;
//   String? _status;
//
//   AddIndividualUserModel copyWith({
//     num? id,
//     String? textId,
//     String? teamName,
//     String? email,
//     String? phone,
//     String? countryCode,
//     String? profileImage,
//     String? employeeType,
//     String? status,
//   }) =>
//       AddIndividualUserModel(
//         id: id ?? _id,
//         textId: textId ?? _textId,
//         teamName: teamName ?? _teamName,
//         email: email ?? _email,
//         phone: phone ?? _phone,
//         countryCode: countryCode ?? _countryCode,
//         profileImage: profileImage ?? _profileImage,
//         employeeType: employeeType ?? _employeeType,
//         status: status ?? _status,
//       );
//
//   num? get id => _id;
//   String? get textId => _textId;
//   String? get teamName => _teamName;
//   String? get email => _email;
//   String? get phone => _phone;
//   String? get countryCode => _countryCode;
//   String? get profileImage => _profileImage;
//   String? get employeeType => _employeeType;
//   String? get status => _status;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['textId'] = _textId;
//     map['team_name'] = _teamName;
//     map['email'] = _email;
//     map['phone'] = _phone;
//     map['countryCode'] = _countryCode;
//     map['profileImage'] = _profileImage;
//     map['employeeType'] = _employeeType;
//     map['status'] = _status;
//     return map;
//   }
// }
