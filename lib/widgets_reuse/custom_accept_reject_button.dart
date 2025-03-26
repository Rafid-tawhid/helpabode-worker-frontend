import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAcceptRejectButton extends StatelessWidget {
  String label;
  Color buttonClr;
  final VoidCallback funcOnTap;
  final TextStyle labelTextStyle;

  CustomAcceptRejectButton({
    required this.label,
    required this.buttonClr,
    required this.funcOnTap,
    required this.labelTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: funcOnTap,
      child: Container(
        padding: EdgeInsets.all(4.h),
        //height: 30.h,
        width: 170.w,
        decoration: BoxDecoration(
          color: buttonClr,
          borderRadius: BorderRadius.circular(50.w),
        ),
        child: Center(
          child: Text(
            label,
            style: labelTextStyle,
          ),
        ),
      ),
    );
  }
}
