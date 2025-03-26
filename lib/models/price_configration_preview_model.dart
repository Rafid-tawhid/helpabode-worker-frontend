// class PriceConfigrationPreviewModel {
//   PriceConfigrationPreviewModel({
//       String? zoneTitle,
//       String? zoneTextId,
//       List<String>? zipWisePrice,
//       List<PlanArrayPreview>? planArrayPreview,}){
//     _zoneTitle = zoneTitle;
//     _zoneTextId = zoneTextId;
//     _zipWisePrice = zipWisePrice;
//     _planArrayPreview = planArrayPreview;
// }
//
//   PriceConfigrationPreviewModel.fromJson(dynamic json) {
//     _zoneTitle = json['zoneTitle'];
//     _zoneTextId = json['zoneTextId'];
//     _zipWisePrice = json['zipWisePrice'] != null ? json['zipWisePrice'].cast<String>() : [];
//     if (json['planArray_preview'] != null) {
//       _planArrayPreview = [];
//       json['planArray_preview'].forEach((v) {
//         _planArrayPreview?.add(PlanArrayPreview.fromJson(v));
//       });
//     }
//   }
//   String? _zoneTitle;
//   String? _zoneTextId;
//   List<String>? _zipWisePrice;
//   List<PlanArrayPreview>? _planArrayPreview;
// PriceConfigrationPreviewModel copyWith({  String? zoneTitle,
//   String? zoneTextId,
//   List<String>? zipWisePrice,
//   List<PlanArrayPreview>? planArrayPreview,
// }) => PriceConfigrationPreviewModel(  zoneTitle: zoneTitle ?? _zoneTitle,
//   zoneTextId: zoneTextId ?? _zoneTextId,
//   zipWisePrice: zipWisePrice ?? _zipWisePrice,
//   planArrayPreview: planArrayPreview ?? _planArrayPreview,
// );
//   String? get zoneTitle => _zoneTitle;
//   String? get zoneTextId => _zoneTextId;
//   List<String>? get zipWisePrice => _zipWisePrice;
//   List<PlanArrayPreview>? get planArrayPreview => _planArrayPreview;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['zoneTitle'] = _zoneTitle;
//     map['zoneTextId'] = _zoneTextId;
//     map['zipWisePrice'] = _zipWisePrice;
//     if (_planArrayPreview != null) {
//       map['planArray_preview'] = _planArrayPreview?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
//
// }
//
// class PlanArrayPreview {
//   PlanArrayPreview({
//       String? planName,
//       String? planTextId,
//       String? rank,
//       String? minimumPrice,
//       List<AttributesPreview>? attributesPreview,}){
//     _planName = planName;
//     _planTextId = planTextId;
//     _rank = rank;
//     _minimumPrice = minimumPrice;
//     _attributesPreview = attributesPreview;
// }
//
//   PlanArrayPreview.fromJson(dynamic json) {
//     _planName = json['planName'];
//     _planTextId = json['planTextId'];
//     _rank = json['rank'];
//     _minimumPrice = json['minimumPrice'];
//     if (json['attributes_preview'] != null) {
//       _attributesPreview = [];
//       json['attributes_preview'].forEach((v) {
//         _attributesPreview?.add(AttributesPreview.fromJson(v));
//       });
//     }
//   }
//   String? _planName;
//   String? _planTextId;
//   String? _rank;
//   String? _minimumPrice;
//   List<AttributesPreview>? _attributesPreview;
// PlanArrayPreview copyWith({  String? planName,
//   String? planTextId,
//   String? rank,
//   String? minimumPrice,
//   List<AttributesPreview>? attributesPreview,
// }) => PlanArrayPreview(  planName: planName ?? _planName,
//   planTextId: planTextId ?? _planTextId,
//   rank: rank ?? _rank,
//   minimumPrice: minimumPrice ?? _minimumPrice,
//   attributesPreview: attributesPreview ?? _attributesPreview,
// );
//   String? get planName => _planName;
//   String? get planTextId => _planTextId;
//   String? get rank => _rank;
//   String? get minimumPrice => _minimumPrice;
//   List<AttributesPreview>? get attributesPreview => _attributesPreview;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['planName'] = _planName;
//     map['planTextId'] = _planTextId;
//     map['rank'] = _rank;
//     map['minimumPrice'] = _minimumPrice;
//     if (_attributesPreview != null) {
//       map['attributes_preview'] = _attributesPreview?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
//
// }
//
// class AttributesPreview {
//   AttributesPreview({
//       String? title,
//       String? textId,
//       String? labelType,
//       List<OptionsPreview>? optionsPreview,
//       String? isPricing,}){
//     _title = title;
//     _textId = textId;
//     _labelType = labelType;
//     _optionsPreview = optionsPreview;
//     _isPricing = isPricing;
// }
//
//   AttributesPreview.fromJson(dynamic json) {
//     _title = json['title'];
//     _textId = json['textId'];
//     _labelType = json['labelType'];
//     if (json['options_preview'] != null) {
//       _optionsPreview = [];
//       json['options_preview'].forEach((v) {
//         _optionsPreview?.add(OptionsPreview.fromJson(v));
//       });
//     }
//     _isPricing = json['isPricing'];
//   }
//   String? _title;
//   String? _textId;
//   String? _labelType;
//   List<OptionsPreview>? _optionsPreview;
//   String? _isPricing;
// AttributesPreview copyWith({  String? title,
//   String? textId,
//   String? labelType,
//   List<OptionsPreview>? optionsPreview,
//   String? isPricing,
// }) => AttributesPreview(  title: title ?? _title,
//   textId: textId ?? _textId,
//   labelType: labelType ?? _labelType,
//   optionsPreview: optionsPreview ?? _optionsPreview,
//   isPricing: isPricing ?? _isPricing,
// );
//   String? get title => _title;
//   String? get textId => _textId;
//   String? get labelType => _labelType;
//   List<OptionsPreview>? get optionsPreview => _optionsPreview;
//   String? get isPricing => _isPricing;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['title'] = _title;
//     map['textId'] = _textId;
//     map['labelType'] = _labelType;
//     if (_optionsPreview != null) {
//       map['options_preview'] = _optionsPreview?.map((v) => v.toJson()).toList();
//     }
//     map['isPricing'] = _isPricing;
//     return map;
//   }
//
// }
//
// class OptionsPreview {
//   OptionsPreview({
//       String? price,
//       String? estTime,
//       String? optionLabel,}){
//     _price = price;
//     _estTime = estTime;
//     _optionLabel = optionLabel;
// }
//
//   OptionsPreview.fromJson(dynamic json) {
//     _price = json['price'];
//     _estTime = json['estTime'];
//     _optionLabel = json['optionLabel'];
//   }
//   String? _price;
//   String? _estTime;
//   String? _optionLabel;
// OptionsPreview copyWith({  String? price,
//   String? estTime,
//   String? optionLabel,
// }) => OptionsPreview(  price: price ?? _price,
//   estTime: estTime ?? _estTime,
//   optionLabel: optionLabel ?? _optionLabel,
// );
//   String? get price => _price;
//   String? get estTime => _estTime;
//   String? get optionLabel => _optionLabel;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['price'] = _price;
//     map['estTime'] = _estTime;
//     map['optionLabel'] = _optionLabel;
//     return map;
//   }
//
// }
