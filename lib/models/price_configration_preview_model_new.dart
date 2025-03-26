import 'package:help_abode_worker_app_ver_2/models/price_configration_model.dart';

class Attributes {
  Attributes({
    String? textId,
    String? type,
    String? attrName,
    Options? options,
    String? isPricing, // New field added
  }) {
    _textId = textId;
    _type = type;
    _attrName = attrName;
    _options = options;
    _isPricing = isPricing; // Initialize the new field
  }

  Attributes.fromJson(dynamic json) {
    _textId = json['textId'];
    _type = json['type'];
    _attrName = json['attrName'];
    _options =
        json['options'] != null ? Options.fromJson(json['options']) : null;
    _isPricing = json['isPricing']; // Parse the new field from JSON
  }

  String? _textId;
  String? _type;
  String? _attrName;
  Options? _options;
  String? _isPricing; // New field

  Attributes copyWith({
    String? textId,
    String? type,
    String? attrName,
    Options? options,
    String? isPricing, // New field in copyWith
  }) =>
      Attributes(
        textId: textId ?? _textId,
        type: type ?? _type,
        attrName: attrName ?? _attrName,
        options: options ?? _options,
        isPricing: isPricing ?? _isPricing, // Copy the new field
      );

  String? get textId => _textId;
  String? get type => _type;
  String? get attrName => _attrName;
  Options? get options => _options;
  String? get isPricing => _isPricing; // Getter for the new field

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['textId'] = _textId;
    map['type'] = _type;
    map['attrName'] = _attrName;
    if (_options != null) {
      map['options'] = _options?.toJson();
    }
    map['isPricing'] = _isPricing; // Add the new field to the JSON
    return map;
  }
}

//
// class Options {
//   Options({
//       String? price,
//       String? estTime,}){
//     _price = price;
//     _estTime = estTime;
// }
//
//   Options.fromJson(dynamic json) {
//     _price = json['price'];
//     _estTime = json['estTime'];
//   }
//   String? _price;
//   String? _estTime;
// Options copyWith({  String? price,
//   String? estTime,
// }) => Options(  price: price ?? _price,
//   estTime: estTime ?? _estTime,
// );
//   String? get price => _price;
//   String? get estTime => _estTime;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['price'] = _price;
//     map['estTime'] = _estTime;
//     return map;
//   }
//
// }
