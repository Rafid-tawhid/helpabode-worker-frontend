class CorporationDocValidationModel {
  CorporationDocValidationModel({
    String? workerTextId,
    String? companyName,
    String? isCorporationArticleExist,
    String? entityNo,
    String? articleStateTextId,
    String? isStateSalesTaxCertificateExist,
    String? salesStateTaxId,
    String? salesStateTextId,
  }) {
    _workerTextId = workerTextId;
    _companyName = companyName;
    _isCorporationArticleExist = isCorporationArticleExist;
    _entityNo = entityNo;
    _articleStateTextId = articleStateTextId;
    _isStateSalesTaxCertificateExist = isStateSalesTaxCertificateExist;
    _salesStateTaxId = salesStateTaxId;
    _salesStateTextId = salesStateTextId;
  }

  CorporationDocValidationModel.fromJson(dynamic json) {
    _workerTextId = json['workerTextId'];
    _companyName = json['companyName'];
    _isCorporationArticleExist = json['isCorporationArticleExist'];
    _entityNo = json['entityNo'];
    _articleStateTextId = json['articleStateTextId'];
    _isStateSalesTaxCertificateExist = json['isStateSalesTaxCertificateExist'];
    _salesStateTaxId = json['salesStateTaxId'];
    _salesStateTextId = json['salesStateTextId'];
  }
  String? _workerTextId;
  String? _companyName;
  String? _isCorporationArticleExist;
  String? _entityNo;
  String? _articleStateTextId;
  String? _isStateSalesTaxCertificateExist;
  String? _salesStateTaxId;
  String? _salesStateTextId;
  CorporationDocValidationModel copyWith({
    String? workerTextId,
    String? companyName,
    String? isCorporationArticleExist,
    String? entityNo,
    String? articleStateTextId,
    String? isStateSalesTaxCertificateExist,
    String? salesStateTaxId,
    String? salesStateTextId,
  }) =>
      CorporationDocValidationModel(
        workerTextId: workerTextId ?? _workerTextId,
        companyName: companyName ?? _companyName,
        isCorporationArticleExist:
            isCorporationArticleExist ?? _isCorporationArticleExist,
        entityNo: entityNo ?? _entityNo,
        articleStateTextId: articleStateTextId ?? _articleStateTextId,
        isStateSalesTaxCertificateExist:
            isStateSalesTaxCertificateExist ?? _isStateSalesTaxCertificateExist,
        salesStateTaxId: salesStateTaxId ?? _salesStateTaxId,
        salesStateTextId: salesStateTextId ?? _salesStateTextId,
      );
  String? get workerTextId => _workerTextId;
  String? get companyName => _companyName;
  String? get isCorporationArticleExist => _isCorporationArticleExist;
  String? get entityNo => _entityNo;
  String? get articleStateTextId => _articleStateTextId;
  String? get isStateSalesTaxCertificateExist =>
      _isStateSalesTaxCertificateExist;
  String? get salesStateTaxId => _salesStateTaxId;
  String? get salesStateTextId => _salesStateTextId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['workerTextId'] = _workerTextId;
    map['companyName'] = _companyName;
    map['isCorporationArticleExist'] = _isCorporationArticleExist;
    map['entityNo'] = _entityNo;
    map['articleStateTextId'] = _articleStateTextId;
    map['isStateSalesTaxCertificateExist'] = _isStateSalesTaxCertificateExist;
    map['salesStateTaxId'] = _salesStateTaxId;
    map['salesStateTextId'] = _salesStateTextId;
    return map;
  }
}
