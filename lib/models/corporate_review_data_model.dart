class CorporateReviewDataModel {
  CorporateReviewDataModel({
    String? textId,
    String? corporationName,
    String? alternateName,
    List<Address>? address,
    List<String>? isCorporationArticleExist,
    String? articleStateTitle,
    String? articleStateTextId,
    String? entityNo,
    List<String>? isStateSalesTaxCertificateExist,
    String? salesStateTaxId,
    String? salesStateTitle,
    String? salesStateTextId,
    String? corporationTypeTextId,
    dynamic corporationRoleTextId,
    String? created,
    List<WorkerCategory>? workerCategory,
  }) {
    _textId = textId;
    _corporationName = corporationName;
    _alternateName = alternateName;
    _address = address;
    _isCorporationArticleExist = isCorporationArticleExist;
    _articleStateTitle = articleStateTitle;
    _articleStateTextId = articleStateTextId;
    _entityNo = entityNo;
    _isStateSalesTaxCertificateExist = isStateSalesTaxCertificateExist;
    _salesStateTaxId = salesStateTaxId;
    _salesStateTitle = salesStateTitle;
    _salesStateTextId = salesStateTextId;
    _corporationTypeTextId = corporationTypeTextId;
    _corporationRoleTextId = corporationRoleTextId;
    _created = created;
    _workerCategory = workerCategory;
  }

  CorporateReviewDataModel.fromJson(dynamic json) {
    _textId = json['textId'];
    _corporationName = json['corporationName'];
    _alternateName = json['alternateName'];
    if (json['address'] != null) {
      _address = [];
      json['address'].forEach((v) {
        _address?.add(Address.fromJson(v));
      });
    }
    _isCorporationArticleExist = json['isCorporationArticleExist'] != null
        ? json['isCorporationArticleExist'].cast<String>()
        : [];
    _articleStateTitle = json['articleStateTitle'];
    _articleStateTextId = json['articleStateTextId'];
    _entityNo = json['entityNo'];
    _isStateSalesTaxCertificateExist =
        json['isStateSalesTaxCertificateExist'] != null
            ? json['isStateSalesTaxCertificateExist'].cast<String>()
            : [];
    _salesStateTaxId = json['salesStateTaxId'];
    _salesStateTitle = json['salesStateTitle'];
    _salesStateTextId = json['salesStateTextId'];
    _corporationTypeTextId = json['corporationTypeTextId'];
    _corporationRoleTextId = json['corporationRoleTextId'];
    _created = json['created'];
    if (json['worker_category'] != null) {
      _workerCategory = [];
      json['worker_category'].forEach((v) {
        _workerCategory?.add(WorkerCategory.fromJson(v));
      });
    }
  }
  String? _textId;
  String? _corporationName;
  String? _alternateName;
  List<Address>? _address;
  List<String>? _isCorporationArticleExist;
  String? _articleStateTitle;
  String? _articleStateTextId;
  String? _entityNo;
  List<String>? _isStateSalesTaxCertificateExist;
  String? _salesStateTaxId;
  String? _salesStateTitle;
  String? _salesStateTextId;
  String? _corporationTypeTextId;
  dynamic _corporationRoleTextId;
  String? _created;
  List<WorkerCategory>? _workerCategory;
  CorporateReviewDataModel copyWith({
    String? textId,
    String? corporationName,
    String? alternateName,
    List<Address>? address,
    List<String>? isCorporationArticleExist,
    String? articleStateTitle,
    String? articleStateTextId,
    String? entityNo,
    List<String>? isStateSalesTaxCertificateExist,
    String? salesStateTaxId,
    String? salesStateTitle,
    String? salesStateTextId,
    String? corporationTypeTextId,
    dynamic corporationRoleTextId,
    String? created,
    List<WorkerCategory>? workerCategory,
  }) =>
      CorporateReviewDataModel(
        textId: textId ?? _textId,
        corporationName: corporationName ?? _corporationName,
        alternateName: alternateName ?? _alternateName,
        address: address ?? _address,
        isCorporationArticleExist:
            isCorporationArticleExist ?? _isCorporationArticleExist,
        articleStateTitle: articleStateTitle ?? _articleStateTitle,
        articleStateTextId: articleStateTextId ?? _articleStateTextId,
        entityNo: entityNo ?? _entityNo,
        isStateSalesTaxCertificateExist:
            isStateSalesTaxCertificateExist ?? _isStateSalesTaxCertificateExist,
        salesStateTaxId: salesStateTaxId ?? _salesStateTaxId,
        salesStateTitle: salesStateTitle ?? _salesStateTitle,
        salesStateTextId: salesStateTextId ?? _salesStateTextId,
        corporationTypeTextId: corporationTypeTextId ?? _corporationTypeTextId,
        corporationRoleTextId: corporationRoleTextId ?? _corporationRoleTextId,
        created: created ?? _created,
        workerCategory: workerCategory ?? _workerCategory,
      );
  String? get textId => _textId;
  String? get corporationName => _corporationName;
  String? get alternateName => _alternateName;
  List<Address>? get address => _address;
  List<String>? get isCorporationArticleExist => _isCorporationArticleExist;
  String? get articleStateTitle => _articleStateTitle;
  String? get articleStateTextId => _articleStateTextId;
  String? get entityNo => _entityNo;
  List<String>? get isStateSalesTaxCertificateExist =>
      _isStateSalesTaxCertificateExist;
  String? get salesStateTaxId => _salesStateTaxId;
  String? get salesStateTitle => _salesStateTitle;
  String? get salesStateTextId => _salesStateTextId;
  String? get corporationTypeTextId => _corporationTypeTextId;
  dynamic get corporationRoleTextId => _corporationRoleTextId;
  String? get created => _created;
  List<WorkerCategory>? get workerCategory => _workerCategory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['textId'] = _textId;
    map['corporationName'] = _corporationName;
    map['alternateName'] = _alternateName;
    if (_address != null) {
      map['address'] = _address?.map((v) => v.toJson()).toList();
    }
    map['isCorporationArticleExist'] = _isCorporationArticleExist;
    map['articleStateTitle'] = _articleStateTitle;
    map['articleStateTextId'] = _articleStateTextId;
    map['entityNo'] = _entityNo;
    map['isStateSalesTaxCertificateExist'] = _isStateSalesTaxCertificateExist;
    map['salesStateTaxId'] = _salesStateTaxId;
    map['salesStateTitle'] = _salesStateTitle;
    map['salesStateTextId'] = _salesStateTextId;
    map['corporationTypeTextId'] = _corporationTypeTextId;
    map['corporationRoleTextId'] = _corporationRoleTextId;
    map['created'] = _created;
    if (_workerCategory != null) {
      map['worker_category'] = _workerCategory?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class WorkerCategory {
  WorkerCategory({
    String? parentTitle,
    String? parentTextId,
    List<SubCategory>? subCategory,
  }) {
    _parentTitle = parentTitle;
    _parentTextId = parentTextId;
    _subCategory = subCategory;
  }

  WorkerCategory.fromJson(dynamic json) {
    _parentTitle = json['parentTitle'];
    _parentTextId = json['parentTextId'];
    if (json['subCategory'] != null) {
      _subCategory = [];
      json['subCategory'].forEach((v) {
        _subCategory?.add(SubCategory.fromJson(v));
      });
    }
  }
  String? _parentTitle;
  String? _parentTextId;
  List<SubCategory>? _subCategory;
  WorkerCategory copyWith({
    String? parentTitle,
    String? parentTextId,
    List<SubCategory>? subCategory,
  }) =>
      WorkerCategory(
        parentTitle: parentTitle ?? _parentTitle,
        parentTextId: parentTextId ?? _parentTextId,
        subCategory: subCategory ?? _subCategory,
      );
  String? get parentTitle => _parentTitle;
  String? get parentTextId => _parentTextId;
  List<SubCategory>? get subCategory => _subCategory;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['parentTitle'] = _parentTitle;
    map['parentTextId'] = _parentTextId;
    if (_subCategory != null) {
      map['subCategory'] = _subCategory?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class SubCategory {
  SubCategory({
    String? title,
    String? textId,
    num? rank,
  }) {
    _title = title;
    _textId = textId;
    _rank = rank;
  }

  SubCategory.fromJson(dynamic json) {
    _title = json['title'];
    _textId = json['textId'];
    _rank = json['rank'];
  }
  String? _title;
  String? _textId;
  num? _rank;
  SubCategory copyWith({
    String? title,
    String? textId,
    num? rank,
  }) =>
      SubCategory(
        title: title ?? _title,
        textId: textId ?? _textId,
        rank: rank ?? _rank,
      );
  String? get title => _title;
  String? get textId => _textId;
  num? get rank => _rank;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['textId'] = _textId;
    map['rank'] = _rank;
    return map;
  }
}

class Address {
  Address({
    String? addressLine1Data,
    String? addressLine2Data,
    String? cityData,
    String? stateData,
    String? zipData,
    String? type,
  }) {
    _addressLine1Data = addressLine1Data;
    _addressLine2Data = addressLine2Data;
    _cityData = cityData;
    _stateData = stateData;
    _zipData = zipData;
    _type = type;
  }

  Address.fromJson(dynamic json) {
    _addressLine1Data = json['addressLine1Data'];
    _addressLine2Data = json['addressLine2Data'];
    _cityData = json['cityData'];
    _stateData = json['stateData'];
    _zipData = json['zipData'];
    _type = json['type'];
  }
  String? _addressLine1Data;
  String? _addressLine2Data;
  String? _cityData;
  String? _stateData;
  String? _zipData;
  String? _type;

  Address copyWith({
    String? addressLine1Data,
    String? addressLine2Data,
    String? cityData,
    String? stateData,
    String? zipData,
    String? type,
  }) =>
      Address(
        addressLine1Data: addressLine1Data ?? _addressLine1Data,
        addressLine2Data: addressLine2Data ?? _addressLine2Data,
        cityData: cityData ?? _cityData,
        stateData: stateData ?? _stateData,
        zipData: zipData ?? _zipData,
        type: type ?? _type,
      );
  String? get addressLine1Data => _addressLine1Data;
  String? get addressLine2Data => _addressLine2Data;
  String? get cityData => _cityData;
  String? get stateData => _stateData;
  String? get zipData => _zipData;
  String? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['addressLine1Data'] = _addressLine1Data;
    map['addressLine2Data'] = _addressLine2Data;
    map['cityData'] = _cityData;
    map['stateData'] = _stateData;
    map['zipData'] = _zipData;
    map['type'] = _type;
    return map;
  }
}
