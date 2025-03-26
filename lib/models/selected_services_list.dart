class SelectedServicesModel {
  String? _workerTextId;
  String? _franchiseTextId;
  String? _serviceTextId;
  double? _basePrice;

  SelectedServicesModel(
      {String? workerTextId,
      String? franchiseTextId,
      String? serviceTextId,
      double? basePrice}) {
    if (workerTextId != null) {
      this._workerTextId = workerTextId;
    }
    if (franchiseTextId != null) {
      this._franchiseTextId = franchiseTextId;
    }
    if (serviceTextId != null) {
      this._serviceTextId = serviceTextId;
    }
    if (basePrice != null) {
      this._basePrice = basePrice;
    }
  }

  String? get workerTextId => _workerTextId;
  set workerTextId(String? workerTextId) => _workerTextId = workerTextId;
  String? get franchiseTextId => _franchiseTextId;
  set franchiseTextId(String? franchiseTextId) =>
      _franchiseTextId = franchiseTextId;
  String? get serviceTextId => _serviceTextId;
  set serviceTextId(String? serviceTextId) => _serviceTextId = serviceTextId;
  double? get basePrice => _basePrice;
  set basePrice(double? basePrice) => _basePrice = basePrice;

  SelectedServicesModel.fromJson(Map<String, dynamic> json) {
    _workerTextId = json['workerTextId'];
    _franchiseTextId = json['franchiseTextId'];
    _serviceTextId = json['serviceTextId'];
    _basePrice = json['basePrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workerTextId'] = this._workerTextId;
    data['franchiseTextId'] = this._franchiseTextId;
    data['serviceTextId'] = this._serviceTextId;
    data['basePrice'] = this._basePrice;
    return data;
  }
}
