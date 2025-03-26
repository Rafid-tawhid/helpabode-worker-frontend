/// zoneTextId : "Brentwood-car"
/// zoneTitle : "Brentwood-car"
/// zipArray : ["94513","37027","37027","94513"]

class ZonZipArray {
  ZonZipArray({
    String? zoneTextId,
    String? zoneTitle,
    List<String>? zipArray,
  }) {
    _zoneTextId = zoneTextId;
    _zoneTitle = zoneTitle;
    _zipArray = zipArray;
  }

  ZonZipArray.fromJson(dynamic json) {
    _zoneTextId = json['zoneTextId'];
    _zoneTitle = json['zoneTitle'];
    _zipArray = json['zipArray'] != null ? json['zipArray'].cast<String>() : [];
  }
  String? _zoneTextId;
  String? _zoneTitle;
  List<String>? _zipArray;
  ZonZipArray copyWith({
    String? zoneTextId,
    String? zoneTitle,
    List<String>? zipArray,
  }) =>
      ZonZipArray(
        zoneTextId: zoneTextId ?? _zoneTextId,
        zoneTitle: zoneTitle ?? _zoneTitle,
        zipArray: zipArray ?? _zipArray,
      );
  String? get zoneTextId => _zoneTextId;
  String? get zoneTitle => _zoneTitle;
  List<String>? get zipArray => _zipArray;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zoneTextId'] = _zoneTextId;
    map['zoneTitle'] = _zoneTitle;
    map['zipArray'] = _zipArray;
    return map;
  }
}
