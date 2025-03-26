class DocumentUpdateModel {
  DocumentUpdateModel({
    String? status,
    String? photoIdNo,
    String? photoIdExpirationDate,
    List<String>? issueFor,
    String? workerTextId,
  }) {
    _status = status;
    _photoIdNo = photoIdNo;
    _photoIdExpirationDate = photoIdExpirationDate;
    _issueFor = issueFor;
    _workerTextId = workerTextId;
  }

  DocumentUpdateModel.fromJson(dynamic json) {
    _status = json['status'];
    _photoIdNo = json['photoIdNo'];
    _photoIdExpirationDate = json['photoIdExpirationDate'];
    _issueFor =
        json['issue_for'] != null ? json['issue_for'].cast<String>() : [];
    _workerTextId = json['workerTextId'];
  }
  String? _status;
  String? _photoIdNo;
  String? _photoIdExpirationDate;
  List<String>? _issueFor;
  String? _workerTextId;
  DocumentUpdateModel copyWith({
    String? status,
    String? photoIdNo,
    String? photoIdExpirationDate,
    List<String>? issueFor,
    String? workerTextId,
  }) =>
      DocumentUpdateModel(
        status: status ?? _status,
        photoIdNo: photoIdNo ?? _photoIdNo,
        photoIdExpirationDate: photoIdExpirationDate ?? _photoIdExpirationDate,
        issueFor: issueFor ?? _issueFor,
        workerTextId: workerTextId ?? _workerTextId,
      );
  String? get status => _status;
  String? get photoIdNo => _photoIdNo;
  String? get photoIdExpirationDate => _photoIdExpirationDate;
  List<String>? get issueFor => _issueFor;
  String? get workerTextId => _workerTextId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['photoIdNo'] = _photoIdNo;
    map['photoIdExpirationDate'] = _photoIdExpirationDate;
    map['issue_for'] = _issueFor;
    map['workerTextId'] = _workerTextId;
    return map;
  }
}
