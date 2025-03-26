// class GetMyCategoriesAndServices {
//   GetMyCategoriesAndServices({
//     String? categoryTitle,
//     String? categoryTextId,
//     String? categoryStatus,
//     String? categoryIcon,
//     num? totalService,
//     List<Services>? services,
//   }) {
//     _categoryTitle = categoryTitle;
//     _categoryTextId = categoryTextId;
//     _categoryStatus = categoryStatus;
//     _categoryIcon = categoryIcon;
//     _totalService = totalService;
//     _services = services;
//   }
//
//   GetMyCategoriesAndServices.fromJson(dynamic json) {
//     _categoryTitle = json['categoryTitle'];
//     _categoryTextId = json['categoryTextId'];
//     _categoryStatus = json['categoryStatus'];
//     _categoryIcon = json['categoryIcon'];
//     _totalService = json['totalService'];
//     if (json['services'] != null) {
//       _services = [];
//       json['services'].forEach((v) {
//         _services?.add(Services.fromJson(v));
//       });
//     }
//   }
//   String? _categoryTitle;
//   String? _categoryTextId;
//   String? _categoryStatus;
//   String? _categoryIcon;
//   num? _totalService;
//   List<Services>? _services;
//   GetMyCategoriesAndServices copyWith({
//     String? categoryTitle,
//     String? categoryTextId,
//     String? categoryStatus,
//     String? categoryIcon,
//     num? totalService,
//     List<Services>? services,
//   }) =>
//       GetMyCategoriesAndServices(
//         categoryTitle: categoryTitle ?? _categoryTitle,
//         categoryTextId: categoryTextId ?? _categoryTextId,
//         categoryStatus: categoryStatus ?? _categoryStatus,
//         categoryIcon: categoryIcon ?? _categoryIcon,
//         totalService: totalService ?? _totalService,
//         services: services ?? _services,
//       );
//   String? get categoryTitle => _categoryTitle;
//   String? get categoryTextId => _categoryTextId;
//   String? get categoryStatus => _categoryStatus;
//   String? get categoryIcon => _categoryIcon;
//   num? get totalService => _totalService;
//   List<Services>? get services => _services;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['categoryTitle'] = _categoryTitle;
//     map['categoryTextId'] = _categoryTextId;
//     map['categoryStatus'] = _categoryStatus;
//     map['categoryIcon'] = _categoryIcon;
//     map['totalService'] = _totalService;
//     if (_services != null) {
//       map['services'] = _services?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
// }
class Services {
  Services({
    this.workerTextId,
    this.serviceTitle,
    this.serviceTextId,
    this.categoryTitle,
    this.categoryTextId,
    this.rank,
    this.pricingBy,
    this.isPrice,
    this.shortDescription,
    this.image,
    this.status,
    this.firstPlanTextId,
    this.firstZoneTextId,
    this.firstPlanPrice,
  });

  String? workerTextId;
  String? serviceTitle;
  String? serviceTextId;
  String? categoryTitle;
  String? categoryTextId;
  int? rank;
  String? pricingBy;
  String? isPrice;
  String? shortDescription;
  String? image;
  String? status;
  String? firstPlanTextId;
  String? firstZoneTextId;
  dynamic firstPlanPrice;

  factory Services.fromJson(Map<String, dynamic> json) => Services(
        workerTextId: json["workerTextId"],
        serviceTitle: json["ServiceTitle"],
        serviceTextId: json["serviceTextId"],
        categoryTitle: json["categoryTitle"],
        categoryTextId: json["categoryTextId"],
        rank: json["rank"],
        pricingBy: json["pricingBy"],
        isPrice: json["isPrice"],
        shortDescription: json["shortDescription"],
        image: json["image"],
        status: json["status"],
        firstPlanTextId: json["firstPlanTextId"],
        firstZoneTextId: json["firstZoneTextId"],
        firstPlanPrice: json["firstPlanPrice"],
      );

  Map<String, dynamic> toJson() => {
        "workerTextId": workerTextId,
        "serviceTitle": serviceTitle,
        "serviceTextId": serviceTextId,
        "categoryTitle": categoryTitle,
        "categoryTextId": categoryTextId,
        "rank": rank,
        "pricingBy": pricingBy,
        "isPrice": isPrice,
        "shortDescription": shortDescription,
        "image": image,
        "status": status,
        "firstPlanTextId": firstPlanTextId,
        "firstZoneTextId": firstZoneTextId,
        "firstPlanPrice": firstPlanPrice,
      };
}
