class UserModelWithAddress {
  UserModelWithAddress({
    String? endUserTextId,
    String? endUserName,
    String? endUserImage,
    EndUserAddress? endUserAddress,
  }) {
    _endUserTextId = endUserTextId;
    _endUserName = endUserName;
    _endUserImage = endUserImage;
    _endUserAddress = endUserAddress;
  }

  UserModelWithAddress.fromJson(dynamic json) {
    _endUserTextId = json["endUserTextId"];
    _endUserName = json['endUserName'];
    _endUserImage = json['endUserImage'];
    _endUserAddress = json['endUserAddress'] != null
        ? EndUserAddress.fromJson(json['endUserAddress'])
        : null;
  }
  String? _endUserTextId;
  String? _endUserName;
  String? _endUserImage;
  EndUserAddress? _endUserAddress;
  UserModelWithAddress copyWith({
    String? endUserTextId,
    String? endUserName,
    String? endUserImage,
    EndUserAddress? endUserAddress,
  }) =>
      UserModelWithAddress(
        endUserTextId: endUserTextId ?? _endUserTextId,
        endUserName: endUserName ?? _endUserName,
        endUserImage: endUserImage ?? _endUserImage,
        endUserAddress: endUserAddress ?? _endUserAddress,
      );
  String? get endUserTextId => _endUserTextId;
  String? get endUserName => _endUserName;
  String? get endUserImage => _endUserImage;
  EndUserAddress? get endUserAddress => _endUserAddress;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['endUserTextId'] = _endUserTextId;
    map['endUserName'] = _endUserName;
    map['endUserImage'] = _endUserImage;
    if (_endUserAddress != null) {
      map['endUserAddress'] = _endUserAddress?.toJson();
    }
    return map;
  }
}

class EndUserAddress {
  EndUserAddress({
    String? zip,
    String? addressLine1,
    String? addressLine2,
    String? doorCode,
    String? city,
    String? state,
    String? latitude,
    String? longitude,
    String? countryIso2Code,
  }) {
    _zip = zip;
    _addressLine1 = addressLine1;
    _addressLine2 = addressLine2;
    _doorCode = doorCode;
    _city = city;
    _state = state;
    _latitude = latitude;
    _longitude = longitude;
    _countryIso2Code = countryIso2Code;
  }

  EndUserAddress.fromJson(dynamic json) {
    _zip = json['zip'];
    _addressLine1 = json['addressLine1'];
    _addressLine2 = json['addressLine2'];
    _doorCode = json['doorCode'];
    _city = json['city'];
    _state = json['state'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _countryIso2Code = json['countryIso2Code'];
  }
  String? _zip;
  String? _addressLine1;
  String? _addressLine2;
  String? _doorCode;
  String? _city;
  String? _state;
  String? _latitude;
  String? _longitude;
  String? _countryIso2Code;
  EndUserAddress copyWith({
    String? zip,
    String? addressLine1,
    String? addressLine2,
    String? doorCode,
    String? city,
    String? state,
    String? latitude,
    String? longitude,
    String? countryIso2Code,
  }) =>
      EndUserAddress(
        zip: zip ?? _zip,
        addressLine1: addressLine1 ?? _addressLine1,
        addressLine2: addressLine2 ?? _addressLine2,
        doorCode: doorCode ?? _doorCode,
        city: city ?? _city,
        state: state ?? _state,
        latitude: latitude ?? _latitude,
        longitude: longitude ?? _longitude,
        countryIso2Code: countryIso2Code ?? _countryIso2Code,
      );
  String? get zip => _zip;
  String? get addressLine1 => _addressLine1;
  String? get addressLine2 => _addressLine2;
  String? get doorCode => _doorCode;
  String? get city => _city;
  String? get state => _state;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get countryIso2Code => _countryIso2Code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zip'] = _zip;
    map['addressLine1'] = _addressLine1;
    map['addressLine2'] = _addressLine2;
    map['doorCode'] = _doorCode;
    map['city'] = _city;
    map['state'] = _state;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['countryIso2Code'] = _countryIso2Code;
    return map;
  }
}
