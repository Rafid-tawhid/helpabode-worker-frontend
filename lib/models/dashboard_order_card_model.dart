/// label : "Open Orders"
/// order_amount : 12345.0
/// order_number : 12
/// score_rate : ""
/// score_rate_position : ""

class DashboardOrderCardModel {
  DashboardOrderCardModel({
    String? label,
    String? orderAmount,
    String? orderNumber,
    String? scoreRate,
    String? scoreRatePosition,
  }) {
    _label = label;
    _orderAmount = orderAmount;
    _orderNumber = orderNumber;
    _scoreRate = scoreRate;
    _scoreRatePosition = scoreRatePosition;
  }

  DashboardOrderCardModel.fromJson(dynamic json) {
    _label = json['label'].toString();
    _orderAmount = json['order_amount'].toString();
    _orderNumber = json['order_number'].toString();
    _scoreRate = json['score_rate'].toString();
    _scoreRatePosition = json['score_rate_position'].toString();
  }
  String? _label;
  String? _orderAmount;
  String? _orderNumber;
  String? _scoreRate;
  String? _scoreRatePosition;
  DashboardOrderCardModel copyWith({
    String? label,
    String? orderAmount,
    String? orderNumber,
    String? scoreRate,
    String? scoreRatePosition,
  }) =>
      DashboardOrderCardModel(
        label: label ?? _label,
        orderAmount: orderAmount ?? _orderAmount,
        orderNumber: orderNumber ?? _orderNumber,
        scoreRate: scoreRate ?? _scoreRate,
        scoreRatePosition: scoreRatePosition ?? _scoreRatePosition,
      );
  String? get label => _label;
  String? get orderAmount => _orderAmount;
  String? get orderNumber => _orderNumber;
  String? get scoreRate => _scoreRate;
  String? get scoreRatePosition => _scoreRatePosition;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['order_amount'] = _orderAmount;
    map['order_number'] = _orderNumber;
    map['score_rate'] = _scoreRate;
    map['score_rate_position'] = _scoreRatePosition;
    return map;
  }
}
