import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/signin_signup_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class CardAnalyticsDashboard extends StatelessWidget {
  CardAnalyticsDashboard({
    required this.textLabel_1,
    required this.textLabel_2,
    required this.iconPath,
    required this.textRating,
    required this.iconColor,
  });

  final textLabel_1;
  final textLabel_2;
  final iconPath;
  final textRating;
  final iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.w),
      height: 100.h,
      width: 123.w,
      decoration: BoxDecoration(
        color: buttonClr,
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 63.h,
                decoration: BoxDecoration(
                  color: buttonClr,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8.w),
                    topLeft: Radius.circular(8.w),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textLabel_1,
                      style: GoogleFonts.roboto(
                          fontSize: CurrentDevice.isAndroid() ? 16 : 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                      maxLines: 2,
                    ),
                    FittedBox(
                      child: Text(
                        textLabel_2,
                        style: GoogleFonts.roboto(
                            fontSize: CurrentDevice.isAndroid() ? 16 : 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 37.h,
                decoration: BoxDecoration(
                  color: Color(0XFF00683E),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.w),
                    bottomRight: Radius.circular(8.w),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: SvgPicture.asset(
                        iconPath,
                        color: iconColor,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      textRating,
                      style: CurrentDevice.isAndroid()
                          ? text_16_white_400_TextStyle
                          : TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Positioned(
          //   //width: 165.w,
          //   height: 120.h,
          //   top: 12.h,
          //   left: 20.w,
          //   right: 20.w,
          //   child: AutoSizeText(
          //     'Total\nWorking Hours',
          //     style: textField_16_LabelTextStyle,
          //     maxLines: 2,
          //   ),
          // ),
        ],
      ),
    );
  }
}
