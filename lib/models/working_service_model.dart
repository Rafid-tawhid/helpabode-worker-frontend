class WorkingServiceModel {
  WorkingServiceModel({
    List<Category>? category,
    List<ServiceList>? serviceList,
    List<WorkerService>? workerService,
  }) {
    _category = category;
    _serviceList = serviceList;
    _workerService = workerService;
  }

  WorkingServiceModel.fromJson(dynamic json) {
    if (json['category'] != null) {
      _category = [];
      json['category'].forEach((v) {
        _category?.add(Category.fromJson(v));
      });
    }
    if (json['service_list'] != null) {
      _serviceList = [];
      json['service_list'].forEach((v) {
        _serviceList?.add(ServiceList.fromJson(v));
      });
    }
    if (json['worker_service'] != null) {
      _workerService = [];
      json['worker_service'].forEach((v) {
        _workerService?.add(WorkerService.fromJson(v));
      });
    }
  }
  List<Category>? _category;
  List<ServiceList>? _serviceList;
  List<WorkerService>? _workerService;
  WorkingServiceModel copyWith({
    List<Category>? category,
    List<ServiceList>? serviceList,
    List<WorkerService>? workerService,
  }) =>
      WorkingServiceModel(
        category: category ?? _category,
        serviceList: serviceList ?? _serviceList,
        workerService: workerService ?? _workerService,
      );
  List<Category>? get category => _category;
  List<ServiceList>? get serviceList => _serviceList;
  List<WorkerService>? get workerService => _workerService;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_category != null) {
      map['category'] = _category?.map((v) => v.toJson()).toList();
    }
    if (_serviceList != null) {
      map['service_list'] = _serviceList?.map((v) => v.toJson()).toList();
    }
    if (_workerService != null) {
      map['worker_service'] = _workerService?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class WorkerService {
  WorkerService({
    num? workingServiceId,
    String? franchiseTextId,
    String? workerTextId,
    dynamic categoryBreadcrumb,
    dynamic serviceTitle,
    String? serviceTextId,
    num? basePrice,
    String? priceVariationJson,
  }) {
    _workingServiceId = workingServiceId;
    _franchiseTextId = franchiseTextId;
    _workerTextId = workerTextId;
    _categoryBreadcrumb = categoryBreadcrumb;
    _serviceTitle = serviceTitle;
    _serviceTextId = serviceTextId;
    _basePrice = basePrice;
    _priceVariationJson = priceVariationJson;
  }

  WorkerService.fromJson(dynamic json) {
    _workingServiceId = json['workingServiceId'];
    _franchiseTextId = json['franchiseTextId'];
    _workerTextId = json['workerTextId'];
    _categoryBreadcrumb = json['categoryBreadcrumb'];
    _serviceTitle = json['serviceTitle'];
    _serviceTextId = json['serviceTextId'];
    _basePrice = json['basePrice'];
    _priceVariationJson = json['priceVariationJson'];
  }
  num? _workingServiceId;
  String? _franchiseTextId;
  String? _workerTextId;
  dynamic _categoryBreadcrumb;
  dynamic _serviceTitle;
  String? _serviceTextId;
  num? _basePrice;
  String? _priceVariationJson;
  WorkerService copyWith({
    num? workingServiceId,
    String? franchiseTextId,
    String? workerTextId,
    dynamic categoryBreadcrumb,
    dynamic serviceTitle,
    String? serviceTextId,
    num? basePrice,
    String? priceVariationJson,
  }) =>
      WorkerService(
        workingServiceId: workingServiceId ?? _workingServiceId,
        franchiseTextId: franchiseTextId ?? _franchiseTextId,
        workerTextId: workerTextId ?? _workerTextId,
        categoryBreadcrumb: categoryBreadcrumb ?? _categoryBreadcrumb,
        serviceTitle: serviceTitle ?? _serviceTitle,
        serviceTextId: serviceTextId ?? _serviceTextId,
        basePrice: basePrice ?? _basePrice,
        priceVariationJson: priceVariationJson ?? _priceVariationJson,
      );
  num? get workingServiceId => _workingServiceId;
  String? get franchiseTextId => _franchiseTextId;
  String? get workerTextId => _workerTextId;
  dynamic get categoryBreadcrumb => _categoryBreadcrumb;
  dynamic get serviceTitle => _serviceTitle;
  String? get serviceTextId => _serviceTextId;
  num? get basePrice => _basePrice;
  String? get priceVariationJson => _priceVariationJson;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['workingServiceId'] = _workingServiceId;
    map['franchiseTextId'] = _franchiseTextId;
    map['workerTextId'] = _workerTextId;
    map['categoryBreadcrumb'] = _categoryBreadcrumb;
    map['serviceTitle'] = _serviceTitle;
    map['serviceTextId'] = _serviceTextId;
    map['basePrice'] = _basePrice;
    map['priceVariationJson'] = _priceVariationJson;
    return map;
  }
}

class ServiceList {
  ServiceList({
    num? serviceId,
    String? serviceTextId,
    String? serviceTitle,
    num? basePrice,
    String? optionJson,
    String? categoryBreadcrumb,
  }) {
    _serviceId = serviceId;
    _serviceTextId = serviceTextId;
    _serviceTitle = serviceTitle;
    _basePrice = basePrice;
    _optionJson = optionJson;
    _categoryBreadcrumb = categoryBreadcrumb;
  }

  ServiceList.fromJson(dynamic json) {
    _serviceId = json['serviceId'];
    _serviceTextId = json['serviceTextId'];
    _serviceTitle = json['serviceTitle'];
    _basePrice = json['basePrice'];
    _optionJson = json['optionJson'];
    _categoryBreadcrumb = json['categoryBreadcrumb'];
  }
  num? _serviceId;
  String? _serviceTextId;
  String? _serviceTitle;
  num? _basePrice;
  String? _optionJson;
  String? _categoryBreadcrumb;
  ServiceList copyWith({
    num? serviceId,
    String? serviceTextId,
    String? serviceTitle,
    num? basePrice,
    String? optionJson,
    String? categoryBreadcrumb,
  }) =>
      ServiceList(
        serviceId: serviceId ?? _serviceId,
        serviceTextId: serviceTextId ?? _serviceTextId,
        serviceTitle: serviceTitle ?? _serviceTitle,
        basePrice: basePrice ?? _basePrice,
        optionJson: optionJson ?? _optionJson,
        categoryBreadcrumb: categoryBreadcrumb ?? _categoryBreadcrumb,
      );
  num? get serviceId => _serviceId;
  String? get serviceTextId => _serviceTextId;
  String? get serviceTitle => _serviceTitle;
  num? get basePrice => _basePrice;
  String? get optionJson => _optionJson;
  String? get categoryBreadcrumb => _categoryBreadcrumb;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['serviceId'] = _serviceId;
    map['serviceTextId'] = _serviceTextId;
    map['serviceTitle'] = _serviceTitle;
    map['basePrice'] = _basePrice;
    map['optionJson'] = _optionJson;
    map['categoryBreadcrumb'] = _categoryBreadcrumb;
    return map;
  }
}

class Category {
  Category({
    num? id,
    String? textId,
    String? title,
    String? categoryTextId,
    String? breadcrumb,
    num? rank,
    String? status,
    List<Subcategories>? subcategories,
  }) {
    _id = id;
    _textId = textId;
    _title = title;
    _categoryTextId = categoryTextId;
    _breadcrumb = breadcrumb;
    _rank = rank;
    _status = status;
    _subcategories = subcategories;
  }

  Category.fromJson(dynamic json) {
    _id = json['id'];
    _textId = json['textId'];
    _title = json['title'];
    _categoryTextId = json['categoryTextId'];
    _breadcrumb = json['breadcrumb'];
    _rank = json['rank'];
    _status = json['status'];
    if (json['subcategories'] != null) {
      _subcategories = [];
      json['subcategories'].forEach((v) {
        _subcategories?.add(Subcategories.fromJson(v));
      });
    }
  }
  num? _id;
  String? _textId;
  String? _title;
  String? _categoryTextId;
  String? _breadcrumb;
  num? _rank;
  String? _status;
  List<Subcategories>? _subcategories;
  Category copyWith({
    num? id,
    String? textId,
    String? title,
    String? categoryTextId,
    String? breadcrumb,
    num? rank,
    String? status,
    List<Subcategories>? subcategories,
  }) =>
      Category(
        id: id ?? _id,
        textId: textId ?? _textId,
        title: title ?? _title,
        categoryTextId: categoryTextId ?? _categoryTextId,
        breadcrumb: breadcrumb ?? _breadcrumb,
        rank: rank ?? _rank,
        status: status ?? _status,
        subcategories: subcategories ?? _subcategories,
      );
  num? get id => _id;
  String? get textId => _textId;
  String? get title => _title;
  String? get categoryTextId => _categoryTextId;
  String? get breadcrumb => _breadcrumb;
  num? get rank => _rank;
  String? get status => _status;
  List<Subcategories>? get subcategories => _subcategories;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['textId'] = _textId;
    map['title'] = _title;
    map['categoryTextId'] = _categoryTextId;
    map['breadcrumb'] = _breadcrumb;
    map['rank'] = _rank;
    map['status'] = _status;
    if (_subcategories != null) {
      map['subcategories'] = _subcategories?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Subcategories {
  Subcategories({
    num? id,
    String? textId,
    String? title,
    String? categoryTextId,
    String? breadcrumb,
    num? rank,
    String? status,
  }) {
    _id = id;
    _textId = textId;
    _title = title;
    _categoryTextId = categoryTextId;
    _breadcrumb = breadcrumb;
    _rank = rank;
    _status = status;
  }

  Subcategories.fromJson(dynamic json) {
    _id = json['id'];
    _textId = json['textId'];
    _title = json['title'];
    _categoryTextId = json['categoryTextId'];
    _breadcrumb = json['breadcrumb'];
    _rank = json['rank'];
    _status = json['status'];
  }
  num? _id;
  String? _textId;
  String? _title;
  String? _categoryTextId;
  String? _breadcrumb;
  num? _rank;
  String? _status;
  Subcategories copyWith({
    num? id,
    String? textId,
    String? title,
    String? categoryTextId,
    String? breadcrumb,
    num? rank,
    String? status,
  }) =>
      Subcategories(
        id: id ?? _id,
        textId: textId ?? _textId,
        title: title ?? _title,
        categoryTextId: categoryTextId ?? _categoryTextId,
        breadcrumb: breadcrumb ?? _breadcrumb,
        rank: rank ?? _rank,
        status: status ?? _status,
      );
  num? get id => _id;
  String? get textId => _textId;
  String? get title => _title;
  String? get categoryTextId => _categoryTextId;
  String? get breadcrumb => _breadcrumb;
  num? get rank => _rank;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['textId'] = _textId;
    map['title'] = _title;
    map['categoryTextId'] = _categoryTextId;
    map['breadcrumb'] = _breadcrumb;
    map['rank'] = _rank;
    map['status'] = _status;
    return map;
  }
}
