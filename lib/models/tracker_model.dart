class OrderTrackingInfoModel {
  int? endUserOrderTimeId;
  String? serviceTextId;
  String? status;
  String? created;

  OrderTrackingInfoModel(
      {this.endUserOrderTimeId, this.serviceTextId, this.status, this.created});

  OrderTrackingInfoModel.fromJson(Map<String, dynamic> json) {
    endUserOrderTimeId = json['endUserOrderTimeId'];
    serviceTextId = json['serviceTextId'];
    status = json['status'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['endUserOrderTimeId'] = this.endUserOrderTimeId;
    data['serviceTextId'] = this.serviceTextId;
    data['status'] = this.status;
    data['created'] = this.created;
    return data;
  }
}
