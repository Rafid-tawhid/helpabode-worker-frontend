// class BundlePriceConfigerationModel {
//   BundlePriceConfigerationModel({
//       String? zoneTitle,
//       String? zoneTextId,
//       List<String>? zipWisePrice,
//       List<PlanArray>? planArray,}){
//     _zoneTitle = zoneTitle;
//     _zoneTextId = zoneTextId;
//     _zipWisePrice = zipWisePrice;
//     _planArray = planArray;
// }
//
//   BundlePriceConfigerationModel.fromJson(dynamic json) {
//     _zoneTitle = json['zoneTitle'];
//     _zoneTextId = json['zoneTextId'];
//     _zipWisePrice = json['zipWisePrice'] != null ? json['zipWisePrice'].cast<String>() : [];
//     if (json['planArray'] != null) {
//       _planArray = [];
//       json['planArray'].forEach((v) {
//         _planArray?.add(PlanArray.fromJson(v));
//       });
//     }
//   }
//   String? _zoneTitle;
//   String? _zoneTextId;
//   List<String>? _zipWisePrice;
//   List<PlanArray>? _planArray;
// BundlePriceConfigerationModel copyWith({  String? zoneTitle,
//   String? zoneTextId,
//   List<String>? zipWisePrice,
//   List<PlanArray>? planArray,
// }) => BundlePriceConfigerationModel(  zoneTitle: zoneTitle ?? _zoneTitle,
//   zoneTextId: zoneTextId ?? _zoneTextId,
//   zipWisePrice: zipWisePrice ?? _zipWisePrice,
//   planArray: planArray ?? _planArray,
// );
//   String? get zoneTitle => _zoneTitle;
//   String? get zoneTextId => _zoneTextId;
//   List<String>? get zipWisePrice => _zipWisePrice;
//   List<PlanArray>? get planArray => _planArray;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['zoneTitle'] = _zoneTitle;
//     map['zoneTextId'] = _zoneTextId;
//     map['zipWisePrice'] = _zipWisePrice;
//     if (_planArray != null) {
//       map['planArray'] = _planArray?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
//
// }
//
// class PlanArray {
//   PlanArray({
//       String? planName,
//       String? planTextId,
//       String? rank,
//       String? minimumPrice,
//       String? estTime,}){
//     _planName = planName;
//     _planTextId = planTextId;
//     _rank = rank;
//     _minimumPrice = minimumPrice;
//     _estTime = estTime;
// }
//
//   PlanArray.fromJson(dynamic json) {
//     _planName = json['planName'];
//     _planTextId = json['planTextId'];
//     _rank = json['rank'];
//     _minimumPrice = json['minimumPrice'];
//     _estTime = json['estTime'];
//   }
//   String? _planName;
//   String? _planTextId;
//   String? _rank;
//   String? _minimumPrice;
//   String? _estTime;
// PlanArray copyWith({  String? planName,
//   String? planTextId,
//   String? rank,
//   String? minimumPrice,
//   String? estTime,
// }) => PlanArray(  planName: planName ?? _planName,
//   planTextId: planTextId ?? _planTextId,
//   rank: rank ?? _rank,
//   minimumPrice: minimumPrice ?? _minimumPrice,
//   estTime: estTime ?? _estTime,
// );
//   String? get planName => _planName;
//   String? get planTextId => _planTextId;
//   String? get rank => _rank;
//   String? get minimumPrice => _minimumPrice;
//   String? get estTime => _estTime;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['planName'] = _planName;
//     map['planTextId'] = _planTextId;
//     map['rank'] = _rank;
//     map['minimumPrice'] = _minimumPrice;
//     map['estTime'] = _estTime;
//     return map;
//   }
//
// }
