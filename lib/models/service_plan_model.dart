import 'dart:convert';

import 'package:flutter/cupertino.dart';

ServicePlanModel ServicePlanModelFromJson(String str) =>
    ServicePlanModel.fromJson(json.decode(str));

String ServicePlanModelToJson(ServicePlanModel data) =>
    json.encode(data.toJson());

class ServicePlanModel {
  String? textId;
  String? title;
  String? image;
  String? shortDescription;
  String? categoryBreadcrumb;
  String? servicePlanTextId;
  String? servicePlanTitle;
  String? level1;
  String? level2;
  TextEditingController controller1;
  TextEditingController controller2;
  int? rank;
  double? calculatedPrice;

  ServicePlanModel(
      {this.textId,
      this.title,
      this.image,
      this.shortDescription,
      this.categoryBreadcrumb,
      this.servicePlanTextId,
      this.servicePlanTitle,
      this.level1,
      this.level2,
      this.rank,
      this.calculatedPrice,
      required this.controller1,
      required this.controller2});

  factory ServicePlanModel.fromJson(Map<String, dynamic> json) =>
      ServicePlanModel(
        textId: json["textId"] ?? '',
        title: json["title"] ?? '',
        image: json["image"] ?? '',
        shortDescription: json["shortDescription"] ?? '',
        categoryBreadcrumb: json["categoryBreadcrumb"] ?? '',
        servicePlanTextId: json["servicePlanTextId"] ?? '',
        servicePlanTitle: json["servicePlanTitle"] ?? '',
        controller1: json["con1"] ?? '',
        controller2: json["con2"] ?? '',
        rank: json["rank"] ?? 0,
        calculatedPrice: json["calculatedPrice"] ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "textId": textId,
        "title": title,
        "image": image,
        "shortDescription": shortDescription,
        "categoryBreadcrumb": categoryBreadcrumb,
        "servicePlanTextId": servicePlanTextId,
        "servicePlanTitle": servicePlanTitle,
        "con1": controller1,
        "con2": controller2,
        "rank": rank,
        "calculatedPrice": calculatedPrice,
      };
}
