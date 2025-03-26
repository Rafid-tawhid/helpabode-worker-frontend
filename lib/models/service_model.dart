class ServiceModel {
  ServiceModel({
    String? serviceName,
    String? serviceTextId,
    String? serviceImage,
  }) {
    _serviceName = serviceName;
    _serviceTextId = serviceTextId;
    _serviceImage = serviceImage;
  }

  ServiceModel.fromJson(dynamic json) {
    _serviceName = json['serviceName'];
    _serviceTextId = json['serviceTextId'];
    _serviceImage = json['serviceImage'];
  }
  String? _serviceName;
  String? _serviceTextId;
  String? _serviceImage;
  ServiceModel copyWith({
    String? serviceName,
    String? serviceTextId,
    String? serviceImage,
  }) =>
      ServiceModel(
        serviceName: serviceName ?? _serviceName,
        serviceTextId: serviceTextId ?? _serviceTextId,
        serviceImage: serviceImage ?? _serviceImage,
      );
  String? get serviceName => _serviceName;
  String? get serviceTextId => _serviceTextId;
  String? get serviceImage => _serviceImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serviceName'] = _serviceName;
    map['serviceTextId'] = _serviceTextId;
    map['serviceImage'] = _serviceImage;
    return map;
  }
}
