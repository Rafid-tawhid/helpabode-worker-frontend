class TipListModel {
  TipListModel({
    this.orderTextId,
    this.orderDate,
    this.orderAmount,
    this.tipAmount,
    this.tipDate,
    this.serviceTitle,
    this.serviceTextId,
    this.image,
    this.userName,
    this.userTextId,
  });

  TipListModel.fromJson(dynamic json) {
    orderTextId = json['orderTextId'];
    orderDate = json['orderDate'];
    orderAmount = json['orderAmount'];
    tipAmount = json['tipAmount'];
    tipDate = json['tipDate'];
    serviceTitle = json['serviceTitle'];
    serviceTextId = json['serviceTextId'];
    image = json['image'];
    userName = json['userName'];
    userTextId = json['userTextId'];
  }
  String? orderTextId;
  String? orderDate;
  num? orderAmount;
  num? tipAmount;
  String? tipDate;
  String? serviceTitle;
  String? serviceTextId;
  String? image;
  String? userName;
  String? userTextId;
  TipListModel copyWith({
    String? orderTextId,
    String? orderDate,
    num? orderAmount,
    num? tipAmount,
    String? tipDate,
    String? serviceTitle,
    String? serviceTextId,
    String? image,
    String? userName,
    String? userTextId,
  }) =>
      TipListModel(
        orderTextId: orderTextId ?? this.orderTextId,
        orderDate: orderDate ?? this.orderDate,
        orderAmount: orderAmount ?? this.orderAmount,
        tipAmount: tipAmount ?? this.tipAmount,
        tipDate: tipDate ?? this.tipDate,
        serviceTitle: serviceTitle ?? this.serviceTitle,
        serviceTextId: serviceTextId ?? this.serviceTextId,
        image: image ?? this.image,
        userName: userName ?? this.userName,
        userTextId: userTextId ?? this.userTextId,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['orderTextId'] = orderTextId;
    map['orderDate'] = orderDate;
    map['orderAmount'] = orderAmount;
    map['tipAmount'] = tipAmount;
    map['tipDate'] = tipDate;
    map['serviceTitle'] = serviceTitle;
    map['serviceTextId'] = serviceTextId;
    map['image'] = image;
    map['userName'] = userName;
    map['userTextId'] = userTextId;
    return map;
  }
}
