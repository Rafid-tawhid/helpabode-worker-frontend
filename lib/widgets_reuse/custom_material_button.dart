import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/signin_signup_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class CustomMaterialButton extends StatelessWidget {
  CustomMaterialButton({
    required this.label,
    required this.buttonColor,
    required this.fontColor,
    required this.funcName,
    required this.borderRadius,
    this.width,
    this.isLoading,
  });

  String label;
  Color buttonColor;
  Color? fontColor;
  VoidCallback? funcName;
  double borderRadius;
  bool? isLoading;
  double? width;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,

      onPressed: funcName,
      //padding: isLoading == true ? EdgeInsets.fromLTRB(0, 10, 0, 10) : EdgeInsets.fromLTRB(52.w, 13.w, 52.w, 13.w),
      color: buttonColor,
      minWidth: width ?? 388,
      height: 48,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(36),
      ),
      // padding: EdgeInsets.fromLTRB(52.w, 13.w, 52.w, 13.w),
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
          : Text(label,
              style: interText(
                  CurrentDevice.isAndroid() ? 18 : 20,
                  fontColor == null ? Colors.white : fontColor!,
                  FontWeight.w500)),
    );
  }
}
