import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../helper_functions/colors.dart';
import '../../../models/dashboard_order_card_model.dart';
import '../../open_order/completed_order/completed_service.dart';
import '../../open_order/open_order_screen.dart';
import '../rating/rating_information_screen.dart';

class MyGridView extends StatelessWidget {
  final List<DashboardOrderCardModel> dataList;

  MyGridView({required this.dataList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 3.2),
        ),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          var data = dataList[index];
          return InkWell(
            onTap: () => _handleTap(context, data),
            borderRadius: BorderRadius.circular(12),
            splashColor: Colors.blue.withOpacity(0.3),
            highlightColor: Colors.blue.withOpacity(0.1),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: myColors.greyBtn, width: 1)
                  // gradient: LinearGradient(
                  //   colors: [
                  //     Colors.white,
                  //     Colors.grey.shade100,
                  //   ],
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  // ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.shade300,
                  //     blurRadius: 6,
                  //     offset: const Offset(0, 3),
                  //   ),
                  // ],
                  ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(data),
                    const Spacer(),
                    _buildValueRow(data),
                    const SizedBox(height: 8),
                    _buildDetails(data),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleTap(BuildContext context, DashboardOrderCardModel data) {
    if (data.label == 'Open Orders') {
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => RequestedServiceScreen()),
      );
    } else if (data.label == 'Completed Orders') {
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => CompletedServices()),
      );
    } else if (data.label == 'Customer Rating') {
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => RatingScreen()),
      );
    }
  }

  Widget _buildLabel(DashboardOrderCardModel data) {
    return FittedBox(
      child: Text(
        data.label ?? '',
        style: TextStyle(
          fontSize: 14,
          color: const Color(0xff535151),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildValueRow(DashboardOrderCardModel data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (data.label == 'Customer Rating')
          const Icon(Icons.star, color: Color(0xffFF9525), size: 20),
        if (data.label == 'Customer Rating') const SizedBox(width: 4),
        Text(
          data.label == 'Customer Rating'
              ? '${data.scoreRate == "0.0" ? 'N/A' : double.parse(data.scoreRate ?? "0.0").toStringAsFixed(2)}'
              : '\$${double.parse(data.orderAmount ?? "0.0").toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: data.label == 'Completed Orders'
                ? myColors.green
                : _getValueColor(data),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(DashboardOrderCardModel data) {
    if (data.label == 'Open Orders') {
      return Text(
        'Total: ${data.orderNumber}',
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      );
    } else if (data.label == 'Customer Rating') {
      return Text(
        'Based on last ${data.orderNumber == "0" ? '' : data.orderNumber} jobs',
        style: TextStyle(fontSize: 12, color: myColors.green),
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            data.scoreRatePosition == 'positive'
                ? Icons.trending_up
                : Icons.trending_down,
            size: 14,
            color: _getValueColor(data),
          ),
          const SizedBox(width: 2),
          Text(
            '${double.parse(data.scoreRate ?? "0.0").toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 12,
              color: _getValueColor(data),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }
  }

  Color _getValueColor(DashboardOrderCardModel data) {
    if (data.label == 'Customer Rating') {
      return const Color(0xffFF9525);
    }

    return data.scoreRatePosition == 'positive'
        ? myColors.green
        : Colors.redAccent;
  }
}
