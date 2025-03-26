import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class CardAddress extends StatelessWidget {
  const CardAddress({
    super.key,
    required this.requestedServiceDetailsMap,
  });

  final Map requestedServiceDetailsMap;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      color: fontClr,
      radius: Radius.circular(8),
      dashPattern: [8, 6],
      strokeWidth: 1,
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/svg/location_icon.svg',
              height: 18.h,
              width: 14.w,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Billing Address : ',
                  style: text_16_black_500_TextStyle,
                ),
                Text(
                  requestedServiceDetailsMap['orderDeliveryAddress'],
                  // 'hello world',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    color: hintClr,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
