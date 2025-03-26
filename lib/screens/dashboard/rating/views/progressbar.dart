import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:provider/provider.dart';

// final List<Map<String, dynamic>> items = [
//   {'rating': 5, 'maxValue': 10, 'currentValue': 6, 'total': '6'},
//   {'rating': 4, 'maxValue': 10, 'currentValue': 8, 'total': '8'},
//   {'rating': 3, 'maxValue': 10, 'currentValue': 7, 'total': '7'},
//   {'rating': 2, 'maxValue': 10, 'currentValue': 5, 'total': '5'},
//   {'rating': 1, 'maxValue': 10, 'currentValue': 3, 'total': '3'},
// ];

Consumer RatingSection(BuildContext context) {
  return Consumer<UserProvider>(
      builder: (context, provider, _) => ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: provider.convertRatingList.length,
            itemBuilder: (context, index) {
              var item = provider.convertRatingList[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        children: [
                          Text(
                            '${item['rating'].toString()}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Icon(
                            Icons.star,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: AnimatedProgressBar(
                          currentValue: item['currentValue'],
                          rating: int.parse(item['rating'].toString()),
                          total: item['total'],
                        ),
                      ),
                    ),
                    Container(
                      width: 40,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          '${getPercentage(item['currentValue'], item['total'])}%',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ));
}

String getPercentage(current, total) {
  int c = int.parse(current.toString());
  int t = int.parse(total.toString());
  debugPrint('getPercentage $c and $t');
  return (c / t * 100).toStringAsFixed(0);
}

class AnimatedProgressBar extends StatelessWidget {
  final int currentValue;
  final int rating;
  final String total;

  AnimatedProgressBar(
      {required this.currentValue, required this.rating, required this.total});

  @override
  Widget build(BuildContext context) {
    final int maxValue = 13;
    final progress = (currentValue / maxValue).clamp(0.0, 1.0);
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey.shade300, // Background color
        borderRadius: BorderRadius.circular(5), // Rounded edges
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Green progress indicator
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: MediaQuery.of(context).size.width *
                progress, // Adjust width based on progress
            decoration: BoxDecoration(
              color: Colors.green, // Progress bar color
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }
}
