import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_small_material_button_2.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/service_cards/card_customer.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/service_cards/card_item.dart';

class MultipleOrderCardUpcomingRequested extends StatelessWidget {
  const MultipleOrderCardUpcomingRequested({
    super.key,
    required this.order,
    required this.orderTextId,
    required this.funcOnPressed,
  });

  final Map order;
  final String orderTextId;
  final void Function() funcOnPressed;

  @override
  Widget build(BuildContext context) {
    // print('Multiple');
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          CardCustomer(
            customerName: '${order['endUserName']}',
            customerAddress: '${order['endUserFullAddress']}',
            customerImageUrl: 'customerImageUrl',
            bottomBorderRadius: 0,
            topBorderRadius: 8,
          ),
          Column(
            children: (order['orderItems'] as List<dynamic>)
                .map(
                  (e) => Column(
                    children: [
                      Divider(
                        thickness: 1,
                        height: 1,
                      ),
                      CardItem(
                        orderTextId: orderTextId,
                        isSingleItem: false,
                        isNumbering: false,
                        // textNumber: '0',
                        title: '${e['serviceTitle']}',
                        titleTextStyle: text_16_black_700_TextStyle,
                        bgColor: messageClr,
                        date: '${e['scheduledDate']}',
                        time:
                            '${e['scheduledStartTime']} - ${e['ScheduleEndtime']}',
                        price: '${e['serviceAmount']}',
                        priceTextStyle: text_18_green_700_TextStyle,
                        imageUrl: 'imageUrl',
                        imageHeight: 74.h,
                        topBorderRadius: 0,
                        bottomBorderRadius: 0,
                        funcOnPressed: funcOnPressed,
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(0),
                bottom: Radius.circular(8),
              ),
              color: messageClr,
            ),
            child: CustomMaterialSmallButton2(
              label: 'View Details',
              buttonColor: buttonClr,
              fontColor: Colors.white,
              height: 30.h,
              // width: 354.w,
              width: double.infinity,
              funcName: funcOnPressed,
            ),
          ),
        ],
      ),
    );
  }
}
