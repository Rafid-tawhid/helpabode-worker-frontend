import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_material_button.dart';

class NoServiceMessage extends StatelessWidget {
  NoServiceMessage({required this.label});

  final label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: 15.h,
              ),
              SvgPicture.asset('assets/svg/no_service_available.svg'),
              SizedBox(
                height: 15.h,
              ),
              // AutoSizeText(
              //   'No ${label} Services',
              //   style: noServiceTitleTextStyle,
              // ),
              // AutoSizeText(
              //   'Available right now',
              //   style: noServiceSubtitleTextStyle,
              // ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'No ${label} Services\nAvailable right now',
                    style: noServiceSubtitle_600_TextStyle,
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              SvgPicture.asset(
                'assets/svg/no-service.svg',
                width: 428.w,
                height: 324.h,
              ),
            ],
          ),

          Column(
            children: [
              CustomMaterialButton(
                label: 'Back to Dashboard',
                buttonColor: buttonClr,
                fontColor: buttonFontClr,
                funcName: () {
                  Navigator.pop(context);
                },
                borderRadius: 50.w,
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
          // SizedBox(
          //   height: 10.h,
          // ),
        ],
      ),
    );
  }
}
