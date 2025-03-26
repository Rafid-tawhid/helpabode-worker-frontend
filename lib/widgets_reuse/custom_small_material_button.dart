import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomMaterialSmallButton extends StatelessWidget {
  CustomMaterialSmallButton({
    required this.label,
    required this.buttonColor,
    required this.fontColor,
    required this.funcName,
    required this.height,
    required this.width,
    this.isLoading,
    this.elevation,
    required this.padding,
    required this.fontSize,
  });

  String label;
  Color buttonColor;
  Color fontColor;
  VoidCallback funcName;
  final double height;
  final double width;
  bool? isLoading;
  EdgeInsetsGeometry? padding;
  double? fontSize;
  double? elevation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading == true ? null : funcName,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.w),
            ),
            backgroundColor:
                isLoading == true ? Colors.grey.shade300 : buttonColor,
            padding: EdgeInsets.all(6)),
        child: isLoading == true
            ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  color: isLoading == true ? Colors.black : fontColor,
                  fontSize: fontSize,
                ),
              ),
      ),
    );
  }
}
