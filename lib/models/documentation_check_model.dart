class DocumentationCheckModel {
  DocumentationCheckModel({
    String? stage,
    String? status,
    String? title,
    String? details,
    String? errorTitle,
    String? errorDetails,
    String? popupTitle,
    String? popupDetails,
  }) {
    _stage = stage;
    _status = status;
    _title = title;
    _details = details;
    _errorTitle = errorTitle;
    _errorDetails = errorDetails;
    _popupTitle = popupTitle;
    _popupDetails = popupDetails;
  }

  DocumentationCheckModel.fromJson(dynamic json) {
    _stage = json['stage'];
    _status = json['status'];
    _title = json['title'];
    _details = json['details'];
    _errorTitle = json['error_title'];
    _errorDetails = json['error_details'];
    _popupTitle = json['popup_title'];
    _popupDetails = json['popup_details'];
  }
  String? _stage;
  String? _status;
  String? _title;
  String? _details;
  String? _errorTitle;
  String? _errorDetails;
  String? _popupTitle;
  String? _popupDetails;
  DocumentationCheckModel copyWith({
    String? stage,
    String? status,
    String? title,
    String? details,
    String? errorTitle,
    String? errorDetails,
    String? popupTitle,
    String? popupDetails,
  }) =>
      DocumentationCheckModel(
        stage: stage ?? _stage,
        status: status ?? _status,
        title: title ?? _title,
        details: details ?? _details,
        errorTitle: errorTitle ?? _errorTitle,
        errorDetails: errorDetails ?? _errorDetails,
        popupTitle: popupTitle ?? _popupTitle,
        popupDetails: popupDetails ?? _popupDetails,
      );
  String? get stage => _stage;
  String? get status => _status;
  String? get title => _title;
  String? get details => _details;
  String? get errorTitle => _errorTitle;
  String? get errorDetails => _errorDetails;
  String? get popupTitle => _popupTitle;
  String? get popupDetails => _popupDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['stage'] = _stage;
    map['status'] = _status;
    map['title'] = _title;
    map['details'] = _details;
    map['error_title'] = _errorTitle;
    map['error_details'] = _errorDetails;
    map['popup_title'] = _popupTitle;
    map['popup_details'] = _popupDetails;
    return map;
  }
}
