class BundleAttributeModel {
  final String title;
  final String textId;
  final String? instruction;
  final dynamic option; // Can hold either a list of options or a single value

  BundleAttributeModel({
    required this.title,
    required this.textId,
    this.instruction,
    required this.option,
  });

  factory BundleAttributeModel.fromJson(Map<String, dynamic> json) {
    return BundleAttributeModel(
      title: json['title'],
      textId: json['textId'],
      instruction: json['instruction'],
      option: json['option'], // Can be a list or single value
    );
  }
}

class BundleOption {
  final String title;
  final bool? isActive;

  BundleOption({required this.title, this.isActive});

  factory BundleOption.fromJson(Map<String, dynamic> json) {
    return BundleOption(
      title: json['title'],
      isActive: json['isActive'],
    );
  }
}

List<BundleAttributeModel> parseServiceDetails(List<dynamic> data) {
  return data.map((item) {
    if (item['option'] is List) {
      item['option'] = (item['option'] as List)
          .map((e) => BundleOption.fromJson(e))
          .toList();
    }
    return BundleAttributeModel.fromJson(item);
  }).toList();
}
