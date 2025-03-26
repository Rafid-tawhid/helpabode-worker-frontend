class AddressModel {
  AddressModel({
    this.addressLine1Data,
    this.addressLine2Data,
    this.stateData,
    this.cityData,
    this.zipData,
  });

  String? addressLine1Data;
  String? addressLine2Data;
  String? stateData;
  String? cityData;
  String? zipData;

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        addressLine1Data: json["addressLine1Data"],
        addressLine2Data: json["addressLine2Data"],
        stateData: json["stateData"],
        cityData: json["cityData"],
        zipData: json["zipData"],
      );

  Map<String, dynamic> toJson() => {
        "addressLine1Data": addressLine1Data,
        "addressLine2Data": addressLine2Data,
        "stateData": stateData,
        "cityData": cityData,
        "zipData": zipData,
      };
}

class UserModel {
  UserModel({
    this.id,
    this.textId,
    this.franchiseTextId,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.countryCode,
    this.dob,
    this.status,
    this.ssn,
    this.employeeType,
    this.photoIdType,
    this.photoIdNo,
    this.photoIdExpirationDate,
    this.workerDesignationTextId,
    this.countryName,
    this.selfieData,
    this.address,
    this.created,
    this.durationSinceCreated,
    this.updated,
    this.photoIdData1,
    this.photoIdData2,
  });

  set setStatus(String value) {
    employeeType = value;
  }

  String? id;
  String? textId;
  String? franchiseTextId;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? countryCode;
  String? dob;
  String? status;
  String? ssn;
  String? employeeType;
  String? photoIdType;
  String? photoIdNo;
  String? photoIdExpirationDate;
  String? workerDesignationTextId;
  String? durationSinceCreated;
  String? countryName;
  String? selfieData;
  List<AddressModel>? address;
  DateTime? created;
  DateTime? updated;
  String? photoIdData1;
  String? photoIdData2;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"].toString(),
        textId: json["textId"],
        franchiseTextId: json["franchiseTextId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phone: json["phone"],
        countryCode: json["countryCode"],
        dob: json["dob"],
        status: json["status"],
        ssn: json["ssn"],
        employeeType: json["employeeType"],
        photoIdType: json["photoIdType"],
        photoIdNo: json["photoIdNo"],
        photoIdExpirationDate: json["photoIdExpirationDate"],
        workerDesignationTextId: json["workerDesignationTextId"],
        durationSinceCreated: json["durationSinceCreated"],
        countryName: json["countryName"],
        selfieData: json["selfieData"],
        address: json["address"] != null
            ? List<AddressModel>.from(
                json["address"].map((x) => AddressModel.fromJson(x)))
            : [],
        created:
            json["created"] != null ? DateTime.parse(json["created"]) : null,
        updated:
            json["updated"] != null ? DateTime.parse(json["updated"]) : null,
        photoIdData1: json["photoIdData1"],
        photoIdData2: json["photoIdData2"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "textId": textId,
        "franchiseTextId": franchiseTextId,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "countryCode": countryCode,
        "dob": dob,
        "status": status,
        "ssn": ssn,
        "employeeType": employeeType,
        "photoIdType": photoIdType,
        "photoIdNo": photoIdNo,
        "photoIdExpirationDate": photoIdExpirationDate,
        "workerDesignationTextId": workerDesignationTextId,
        "countryName": countryName,
        "selfieData": selfieData,
        "address": address != null
            ? List<dynamic>.from(address!.map((x) => x.toJson()))
            : [],
        "created": created?.toIso8601String(),
        "updated": updated?.toIso8601String(),
        "durationSinceCreated": durationSinceCreated,
        "photoIdData1": photoIdData1,
        "photoIdData2": photoIdData2,
      };

  UserModel copyWith({
    String? id,
    String? textId,
    String? franchiseTextId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? countryCode,
    String? dob,
    String? status,
    String? ssn,
    String? employeeType,
    String? photoIdType,
    String? photoIdNo,
    String? photoIdExpirationDate,
    String? workerDesignationTextId,
    String? countryName,
    String? selfieData,
    List<AddressModel>? address,
    DateTime? created,
    DateTime? updated,
    String? durationSinceCreated,
    String? photoIdData1,
    String? photoIdData2,
  }) =>
      UserModel(
        id: id ?? this.id,
        textId: textId ?? this.textId,
        franchiseTextId: franchiseTextId ?? this.franchiseTextId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        countryCode: countryCode ?? this.countryCode,
        dob: dob ?? this.dob,
        status: status ?? this.status,
        ssn: ssn ?? this.ssn,
        employeeType: employeeType ?? this.employeeType,
        photoIdType: photoIdType ?? this.photoIdType,
        photoIdNo: photoIdNo ?? this.photoIdNo,
        photoIdExpirationDate:
            photoIdExpirationDate ?? this.photoIdExpirationDate,
        workerDesignationTextId:
            workerDesignationTextId ?? this.workerDesignationTextId,
        countryName: countryName ?? this.countryName,
        selfieData: selfieData ?? this.selfieData,
        address: address ?? this.address,
        created: created ?? this.created,
        updated: updated ?? this.updated,
        durationSinceCreated: durationSinceCreated ?? this.durationSinceCreated,
        photoIdData1: photoIdData1 ?? this.photoIdData1,
        photoIdData2: photoIdData2 ?? this.photoIdData2,
      );

  @override
  String toString() {
    return 'UserModel{id: $id, textId: $textId, franchiseTextId: $franchiseTextId, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, countryCode: $countryCode, dob: $dob, status: $status, ssn: $ssn, employeeType: $employeeType, photoIdType: $photoIdType, photoIdNo: $photoIdNo, photoIdExpirationDate: $photoIdExpirationDate, workerDesignationTextId: $workerDesignationTextId, countryName: $countryName, selfieData: $selfieData, address: $address, created: $created, updated: $updated, photoIdData1: $photoIdData1, photoIdData2: $photoIdData2}';
  }
}
