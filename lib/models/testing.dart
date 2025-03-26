class Plan {
  final String planName;
  final String planTextId;
  final int rank;
  final int minimumPrice;
  final List<Attribute> attributes;

  Plan({
    required this.planName,
    required this.planTextId,
    required this.rank,
    required this.minimumPrice,
    required this.attributes,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    var attributeList = json['attributes'] as List;
    List<Attribute> attributes =
        attributeList.map((e) => Attribute.fromJson(e)).toList();

    return Plan(
      planName: json['planName'],
      planTextId: json['planTextId'],
      rank: json['rank'],
      minimumPrice: json['minimumPrice'],
      attributes: attributes,
    );
  }
}

class Attribute {
  final String attrTextId;
  final String attrName;
  final int price;
  final int estTime;

  Attribute({
    required this.attrTextId,
    required this.attrName,
    required this.price,
    required this.estTime,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      attrTextId: json['attrTextId'],
      attrName: json['attrName'],
      price: json['price'],
      estTime: json['estTime'],
    );
  }
}

class Area {
  final String areaName;
  final String areaTextId;
  final List<Plan> planSet;

  Area({
    required this.areaName,
    required this.areaTextId,
    required this.planSet,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    var planSetList = json['planSet'] as List;
    List<Plan> planSet = planSetList.map((e) => Plan.fromJson(e)).toList();

    return Area(
      areaName: json['areaName'],
      areaTextId: json['areaTextId'],
      planSet: planSet,
    );
  }
}
