class EarningChartModel {
  final String label;
  final double totalEarned;

  EarningChartModel({
    required this.label,
    required this.totalEarned,
  });

  // Factory constructor to create an instance from a JSON map
  factory EarningChartModel.fromJson(Map<String, dynamic> json) {
    return EarningChartModel(
      label: json['label'],
      totalEarned: json['totalEarned'],
    );
  }
}
