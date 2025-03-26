import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/service_cards/card_item.dart';

class SingleOrderCardCompleted extends StatelessWidget {
  const SingleOrderCardCompleted({
    super.key,
    required this.order,
    required this.orderTextId,
    required this.onTap,
  });

  final Map order;
  final String orderTextId;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            child: CardItem(
              orderTextId: orderTextId,
              isSingleItem: false,
              isNumbering: false,
              // textNumber: '0',
              title: order['orderItems'][0]['serviceTitle'],
              titleTextStyle: text_16_black_700_TextStyle,
              bgColor: messageClr,
              date: order['orderItems'][0]['scheduledDate'],
              time:
                  '${order['orderItems'][0]['scheduledStartTime']} - ${order['orderItems'][0]['ScheduleEndtime']}',
              price: order['orderItems'][0]['serviceAmount'].toString(),
              priceTextStyle: text_18_green_700_TextStyle,
              imageUrl: 'imageUrl',
              imageHeight: 74.h,
              topBorderRadius: 8.w,
              bottomBorderRadius: 0,
              funcOnPressed: () {},
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.only(bottom: 14.h),
            decoration: BoxDecoration(
              color: messageClr,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(0),
                bottom: Radius.circular(8.w),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 16 + 74.h + 16.w,
                ),
                Text(
                  'Rating',
                  style: cardRatingTextStyle,
                ),
                SizedBox(
                  width: 14.w,
                ),
                double.parse(order['orderItems'][0]['rateForEndUserByWorker']
                            .toString()) >=
                        1.0
                    ? SvgPicture.asset('assets/svg/star_active.svg')
                    : SvgPicture.asset('assets/svg/star_inactive.svg'),
                SizedBox(
                  width: 7.w,
                ),
                double.parse(order['orderItems'][0]['rateForEndUserByWorker']
                            .toString()) >=
                        2.0
                    ? SvgPicture.asset('assets/svg/star_active.svg')
                    : SvgPicture.asset('assets/svg/star_inactive.svg'),
                SizedBox(
                  width: 7.w,
                ),
                double.parse(order['orderItems'][0]['rateForEndUserByWorker']
                            .toString()) >=
                        3.0
                    ? SvgPicture.asset('assets/svg/star_active.svg')
                    : SvgPicture.asset('assets/svg/star_inactive.svg'),
                SizedBox(
                  width: 7.w,
                ),
                double.parse(order['orderItems'][0]['rateForEndUserByWorker']
                            .toString()) >=
                        4.0
                    ? SvgPicture.asset('assets/svg/star_active.svg')
                    : SvgPicture.asset('assets/svg/star_inactive.svg'),
                SizedBox(
                  width: 7.w,
                ),
                double.parse(order['orderItems'][0]['rateForEndUserByWorker']
                            .toString()) >=
                        5.0
                    ? SvgPicture.asset('assets/svg/star_active.svg')
                    : SvgPicture.asset('assets/svg/star_inactive.svg'),
                SizedBox(
                  width: 7.w,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
