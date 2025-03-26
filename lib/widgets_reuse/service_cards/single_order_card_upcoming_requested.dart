import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/service_cards/card_customer.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/service_cards/card_item.dart';

class SingleOrderCardUpcomingRequested extends StatelessWidget {
  SingleOrderCardUpcomingRequested({
    required this.order,
    required this.orderTextId,
    required this.funcOnPressed,
  });

  final Map order;
  final String orderTextId;
  final void Function() funcOnPressed;

  @override
  Widget build(BuildContext context) {
    // print('Single');
    // print(order['orderItems'][0]['serviceAmount']);
    // print(orderTextId);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          CardCustomer(
            customerName: '${order['endUserName']}',
            customerAddress: '${order['endUserFullAddress']}',
            customerImageUrl: 'customerImageUrl',
            topBorderRadius: 8,
            bottomBorderRadius: 0,
          ),
          Divider(
            thickness: 1,
            height: 1,
          ),
          CardItem(
            orderTextId: orderTextId,
            isSingleItem: true,
            isNumbering: false,
            // textNumber: '0',
            title: '${order['orderItems'][0]['serviceTitle']}',
            titleTextStyle: text_16_black_700_TextStyle,
            bgColor: messageClr,
            date: '${order['orderItems'][0]['scheduledDate']}',
            time:
                '${order['orderItems'][0]['scheduledStartTime']} - ${order['orderItems'][0]['ScheduleEndtime']}',
            price: '${order['orderItems'][0]['serviceAmount']}',
            priceTextStyle: text_18_green_700_TextStyle,
            imageUrl: 'imageUrl',
            imageHeight: 74.h,
            topBorderRadius: 0,
            bottomBorderRadius: 8.w,
            funcOnPressed: funcOnPressed,
            //     () {
            //   Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) => RequestedServiceDetailsScreen(
            //             orderTextId: orderTextId,
            //           )));
            // },
          ),
        ],
      ),
    );
  }
}
