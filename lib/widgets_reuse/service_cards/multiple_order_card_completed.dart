import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/service_cards/card_item.dart';

class MultipleOrderCardCompleted extends StatelessWidget {
  const MultipleOrderCardCompleted({
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
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: (order['orderItems'] as List).length,
      separatorBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: Divider(
            height: 0,
            thickness: 1,
          ),
        );
      },
      itemBuilder: (context, index) {
        double topBorderCard;
        double bottomBorderCard;

        double topBorderRating;
        double bottomBorderRating;

        if (index == 0) {
          topBorderCard = 8.w;
          bottomBorderCard = 0;

          topBorderRating = 0;
          bottomBorderRating = 0;
        } else if (index == (order['orderItems'] as List).length - 1) {
          topBorderCard = 0;
          bottomBorderCard = 0;

          topBorderRating = 0;
          bottomBorderRating = 8.w;
        } else {
          topBorderCard = 0;
          bottomBorderCard = 0;

          topBorderRating = 0;
          bottomBorderRating = 0;
        }
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
                  title: order['orderItems'][index]['serviceTitle'],
                  titleTextStyle: text_16_black_700_TextStyle,
                  bgColor: messageClr,
                  date: order['orderItems'][index]['scheduledDate'],
                  time:
                      '${order['orderItems'][index]['scheduledStartTime']} - ${order['orderItems'][index]['ScheduleEndtime']}',
                  price: order['orderItems'][index]['serviceAmount'].toString(),
                  priceTextStyle: text_18_green_700_TextStyle,
                  imageUrl: 'imageUrl',
                  imageHeight: 74.h,
                  topBorderRadius: topBorderCard,
                  bottomBorderRadius: bottomBorderCard,
                  funcOnPressed: () {},
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.only(bottom: 14.h),
                decoration: BoxDecoration(
                  color: messageClr,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(topBorderRating),
                    bottom: Radius.circular(bottomBorderRating),
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
                    double.parse(order['orderItems'][index]
                                    ['rateForEndUserByWorker']
                                .toString()) >=
                            1.0
                        ? SvgPicture.asset('assets/svg/star_active.svg')
                        : SvgPicture.asset('assets/svg/star_inactive.svg'),
                    SizedBox(
                      width: 7.w,
                    ),
                    double.parse(order['orderItems'][index]
                                    ['rateForEndUserByWorker']
                                .toString()) >=
                            2.0
                        ? SvgPicture.asset('assets/svg/star_active.svg')
                        : SvgPicture.asset('assets/svg/star_inactive.svg'),
                    SizedBox(
                      width: 7.w,
                    ),
                    double.parse(order['orderItems'][index]
                                    ['rateForEndUserByWorker']
                                .toString()) >=
                            3.0
                        ? SvgPicture.asset('assets/svg/star_active.svg')
                        : SvgPicture.asset('assets/svg/star_inactive.svg'),
                    SizedBox(
                      width: 7.w,
                    ),
                    double.parse(order['orderItems'][index]
                                    ['rateForEndUserByWorker']
                                .toString()) >=
                            4.0
                        ? SvgPicture.asset('assets/svg/star_active.svg')
                        : SvgPicture.asset('assets/svg/star_inactive.svg'),
                    SizedBox(
                      width: 7.w,
                    ),
                    double.parse(order['orderItems'][index]
                                    ['rateForEndUserByWorker']
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
      },
    );
  }
}
