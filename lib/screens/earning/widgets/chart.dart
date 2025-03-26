import 'package:d_chart/d_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../helper_functions/colors.dart';
import '../../../models/earning_chart_model.dart';

class MonthlyEarningsChart extends StatelessWidget {
  List<EarningChartModel> data;
  MonthlyEarningsChart(this.data);
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Scroll to the end of the chart after layout
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
    return Container(
      height: 200,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal, // Enable horizontal scrolling
        child: AspectRatio(
          aspectRatio: data.length > 12
              ? data.length / 4
              : 20 / 10, // Adjust width dynamically for scrolling
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: DChartBarO(
              animate: true,
              allowSliding: data.length > 12 ? true : false,
              animationDuration: const Duration(milliseconds: 600),
              groupList: [
                OrdinalGroup(
                  color: myColors.green,
                  id: '3',
                  data: data.map((e) {
                    String month =
                        e.label.length > 3 ? formatDate(e.label) : e.label;
                    int measure = e.totalEarned.toInt();
                    return OrdinalData(domain: month, measure: measure);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatDate(String date) {
    try {
      // Parse the input date string
      DateTime parsedDate = DateTime.parse(date);

      // Convert to desired format
      String formattedDate =
          "${_monthName(parsedDate.month)} ${parsedDate.day}";

      return formattedDate;
    } catch (e) {
      // Handle invalid date format
      return "Invalid date";
    }
  }

// Helper method to get month name abbreviation
  String _monthName(int month) {
    const List<String> monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    return monthNames[month - 1]; // Adjust for zero-based index
  }
}
