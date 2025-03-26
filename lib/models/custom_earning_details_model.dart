class CustomEarningDetailsModel {
  final String date;
  final String amount;
  final String jobCompleted;
  final String avgAmount;
  final String totalAmountSummary;

  CustomEarningDetailsModel({
    required this.date,
    required this.amount,
    required this.jobCompleted,
    required this.avgAmount,
    required this.totalAmountSummary,
  });

  // Factory constructor to create an instance from JSON
  factory CustomEarningDetailsModel.fromJson(Map<String, dynamic> json) {
    return CustomEarningDetailsModel(
      date: json['date'] as String,
      amount: json['amount'] as String,
      jobCompleted: json['jobCompleted'] as String,
      avgAmount: json['avg_amount'] as String,
      totalAmountSummary: json['totalAmountSummary'] as String,
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'amount': amount,
      'jobCompleted': jobCompleted,
      'avg_amount': avgAmount,
      'totalAmountSummary': totalAmountSummary,
    };
  }
}
