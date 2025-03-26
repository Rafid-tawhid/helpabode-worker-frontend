class EarningHistoryModel {
  EarningHistoryModel({
    String? workerTextId,
    String? franchiseTextId,
    String? date,
    num? totalAmount,
  }) {
    _workerTextId = workerTextId;
    _franchiseTextId = franchiseTextId;
    _date = date;
    _totalAmount = totalAmount;
  }

  EarningHistoryModel.fromJson(dynamic json) {
    _workerTextId = json['workerTextId'];
    _franchiseTextId = json['franchiseTextId'];
    _date = json['date'];
    _totalAmount = json['total_amount'];
  }
  String? _workerTextId;
  String? _franchiseTextId;
  String? _date;
  num? _totalAmount;
  EarningHistoryModel copyWith({
    String? workerTextId,
    String? franchiseTextId,
    String? date,
    num? totalAmount,
  }) =>
      EarningHistoryModel(
        workerTextId: workerTextId ?? _workerTextId,
        franchiseTextId: franchiseTextId ?? _franchiseTextId,
        date: date ?? _date,
        totalAmount: totalAmount ?? _totalAmount,
      );
  String? get workerTextId => _workerTextId;
  String? get franchiseTextId => _franchiseTextId;
  String? get date => _date;
  num? get totalAmount => _totalAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['workerTextId'] = _workerTextId;
    map['franchiseTextId'] = _franchiseTextId;
    map['date'] = _date;
    map['total_amount'] = _totalAmount;
    return map;
  }
}
