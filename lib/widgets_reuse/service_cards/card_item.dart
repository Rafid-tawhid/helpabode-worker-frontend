import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class CardItem extends StatelessWidget {
  CardItem({
    required this.orderTextId,
    required this.isSingleItem,
    required this.isNumbering,
    this.textNumber,
    required this.title,
    required this.titleTextStyle,
    required this.bgColor,
    required this.date,
    required this.time,
    required this.price,
    required this.priceTextStyle,
    required this.imageUrl,
    required this.imageHeight,
    required this.topBorderRadius,
    required this.bottomBorderRadius,
    required this.funcOnPressed,
  });
  final String orderTextId;
  final bool isSingleItem;
  final bool isNumbering;
  final String? textNumber;
  final String title;
  final TextStyle titleTextStyle;
  final Color bgColor;
  final String date;
  final String time;
  final String price;
  final TextStyle priceTextStyle;
  final String imageUrl;
  final double imageHeight;
  final double topBorderRadius;
  final double bottomBorderRadius;
  final void Function() funcOnPressed;

  @override
  Widget build(BuildContext context) {
    // print('Card Item');
    return Stack(
      children: [
        Container(
          //width: MediaQuery.sizeOf(context).width,
          // margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            // color: Colors.red,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(topBorderRadius),
              bottom: Radius.circular(bottomBorderRadius),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.w),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  height: imageHeight,
                  width: imageHeight,
                  image: NetworkImage(
                    '${imageUrl}',
                  ),
                  placeholder: const NetworkImage(
                      'https://images.theconversation.com/files/270592/original/file-20190424-19297-1dn85pe.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=675.0&fit=crop'),
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://images.theconversation.com/files/270592/original/file-20190424-19297-1dn85pe.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=675.0&fit=crop',
                      fit: BoxFit.cover,
                      height: 60,
                      width: 60,
                    );
                  },
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: interText(14, Colors.black, FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '$date | $time',
                      style: interText(13, myColors.greyTxt, FontWeight.w500),
                    ),
                    // Add additional widgets if needed
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
            bottom: 0,
            right: 0,
            child: Text(
              '$price\$',
              style: interText(16, Colors.black, FontWeight.bold),
            ))
      ],
    );
  }
}
