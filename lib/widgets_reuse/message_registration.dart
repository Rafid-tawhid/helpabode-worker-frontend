import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class MessageRegistration extends StatelessWidget {
  const MessageRegistration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h,
      width: double.infinity,
      color: messageClr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 55.w,
          ),
          SvgPicture.asset("assets/svg/star.svg"),
          SizedBox(
            width: 22.w,
          ),
          Text(
            "Sign in to access services and offers",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
