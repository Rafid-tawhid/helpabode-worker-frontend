import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void showCustomSnackBar(BuildContext context, String message, Color bgClr,
    TextStyle textStyle, AnimationController? animationController) {
  return showTopSnackBar(
    Overlay.of(context),
    CustomSnackBarMessage(
      message: message,
      bgClr: bgClr,
      textStyle: textStyle,
    ),
    //persistent: true,
    animationDuration: Duration(milliseconds: 1200),
    displayDuration: Duration(milliseconds: 2400),
    reverseAnimationDuration: Duration(milliseconds: 1200),
    onAnimationControllerInit: (controller) {
      animationController = controller;
    },
  );
}

class CustomSnackBarMessage extends StatelessWidget {
  CustomSnackBarMessage({
    required this.message,
    required this.bgClr,
    required this.textStyle,
  });

  final String message;
  final Color bgClr;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return CustomSnackBar.info(
      message: message,
      backgroundColor: bgClr,
      // icon: Icon(
      //   Icons.check_circle,
      //   color: Colors.white,
      // ),
      icon: Container(),
      // iconRotationAngle: 0,
      // iconPositionLeft: 350.w,
      textStyle: textStyle,
    );
  }
}
