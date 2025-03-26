class DateWiseEarningModel {
  DateWiseEarningModel({
    num? totalOrder,
    num? totalOrderAmount,
    num? totalWorkHour,
    num? totalTipAmount,
    List<OrderArray>? orderArray,
  }) {
    _totalOrder = totalOrder;
    _totalOrderAmount = totalOrderAmount;
    _totalWorkHour = totalWorkHour;
    _totalTipAmount = totalTipAmount;
    _orderArray = orderArray;
  }

  DateWiseEarningModel.fromJson(dynamic json) {
    _totalOrder = json['total_order'];
    _totalOrderAmount = json['total_order_amount'];
    _totalWorkHour = json['total_work_hour'];
    _totalTipAmount = json['total_tip_amount'];
    if (json['orderArray'] != null) {
      _orderArray = [];
      json['orderArray'].forEach((v) {
        _orderArray?.add(OrderArray.fromJson(v));
      });
    }
  }
  num? _totalOrder;
  num? _totalOrderAmount;
  num? _totalWorkHour;
  num? _totalTipAmount;
  List<OrderArray>? _orderArray;
  DateWiseEarningModel copyWith({
    num? totalOrder,
    num? totalOrderAmount,
    num? totalWorkHour,
    num? totalTipAmount,
    List<OrderArray>? orderArray,
  }) =>
      DateWiseEarningModel(
        totalOrder: totalOrder ?? _totalOrder,
        totalOrderAmount: totalOrderAmount ?? _totalOrderAmount,
        totalWorkHour: totalWorkHour ?? _totalWorkHour,
        totalTipAmount: totalTipAmount ?? _totalTipAmount,
        orderArray: orderArray ?? _orderArray,
      );
  num? get totalOrder => _totalOrder;
  num? get totalOrderAmount => _totalOrderAmount;
  num? get totalWorkHour => _totalWorkHour;
  num? get totalTipAmount => _totalTipAmount;
  List<OrderArray>? get orderArray => _orderArray;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_order'] = _totalOrder;
    map['total_order_amount'] = _totalOrderAmount;
    map['total_work_hour'] = _totalWorkHour;
    map['total_tip_amount'] = _totalTipAmount;
    if (_orderArray != null) {
      map['orderArray'] = _orderArray?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class OrderArray {
  OrderArray({
    String? orderDate,
    String? orderTextId,
    num? amount,
  }) {
    _orderDate = orderDate;
    _orderTextId = orderTextId;
    _amount = amount;
  }

  OrderArray.fromJson(dynamic json) {
    _orderDate = json['orderDate'];
    _orderTextId = json['orderTextId'];
    _amount = json['amount'];
  }
  String? _orderDate;
  String? _orderTextId;
  num? _amount;
  OrderArray copyWith({
    String? orderDate,
    String? orderTextId,
    num? amount,
  }) =>
      OrderArray(
        orderDate: orderDate ?? _orderDate,
        orderTextId: orderTextId ?? _orderTextId,
        amount: amount ?? _amount,
      );
  String? get orderDate => _orderDate;
  String? get orderTextId => _orderTextId;
  num? get amount => _amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orderDate'] = _orderDate;
    map['orderTextId'] = _orderTextId;
    map['amount'] = _amount;
    return map;
  }
}
