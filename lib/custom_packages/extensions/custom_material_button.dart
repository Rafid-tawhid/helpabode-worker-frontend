import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

import '../../widgets_reuse/loading_indicator.dart';

class CustomMaterialButton extends StatelessWidget {
  CustomMaterialButton(
      {required this.label,
      required this.buttonColor,
      required this.fontColor,
      required this.funcName,
      required this.borderRadius,
      this.width,
      this.isLoading,
      this.height});

  String label;
  Color buttonColor;
  Color fontColor;
  VoidCallback? funcName;
  double borderRadius;
  bool? isLoading;
  double? width;
  double? height;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      onPressed: isLoading == true ? () {} : funcName,
      color: buttonColor,
      minWidth: width ?? 388,
      height: height ?? 40,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: isLoading == true
          ? const Center(
              child: SizedBox(
                child: LoadingIndicatorWidget(
                  color: Colors.white,
                ),
              ),
            )
          : Text(
              label,
              style: interText(16, fontColor, FontWeight.w600),
            ),
    );
  }
}
