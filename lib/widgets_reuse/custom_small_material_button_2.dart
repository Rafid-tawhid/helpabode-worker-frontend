import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomMaterialSmallButton2 extends StatelessWidget {
  CustomMaterialSmallButton2({
    required this.label,
    required this.buttonColor,
    required this.fontColor,
    required this.funcName,
    required this.height,
    required this.width,
  });

  String label;
  Color buttonColor;
  Color fontColor;
  VoidCallback funcName;
  final height;
  final width;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 5.0,
      onPressed: funcName,
      padding: EdgeInsets.fromLTRB(10.w, 5.w, 10.w, 5.w),
      // padding: EdgeInsets.fromLTRB(52.w, 13.w, 52.w, 13.w),
      child: Text(
        label,
        style: TextStyle(
          color: fontColor,
          fontSize: 20.sp,
        ),
      ),
      color: buttonColor,
      minWidth: width,
      height: height,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.w),
      ),
    );
  }
}
