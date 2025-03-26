import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../helper_functions/signin_signup_helpers.dart';

class CustomRoundedButton extends StatefulWidget {
  CustomRoundedButton(
      {required this.label,
      required this.buttonColor,
      required this.fontColor,
      required this.funcName,
      required this.borderRadius,
      this.width,
      this.isLoading,
      required this.controller,
      this.animate,
      this.height});

  final String label;
  final Color buttonColor;
  final Color fontColor;
  final VoidCallback? funcName;
  final double borderRadius;
  final bool? isLoading;
  final double? width;
  final double? height;
  final RoundedLoadingButtonController controller;
  final bool? animate;

  @override
  State<CustomRoundedButton> createState() => _CustomRoundedButtonState();
}

class _CustomRoundedButtonState extends State<CustomRoundedButton> {
  bool isClicked = false;

  @override
  void initState() {
    super.initState();
    widget.controller.stateStream.listen((value) {
      if (ButtonState.loading == value) {
        setState(() {
          isClicked = true;
        });
      } else {
        setState(() {
          isClicked = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
      elevation: 0,
      onPressed: isClicked ? null : widget.funcName,
      // padding: isLoading == true ? EdgeInsets.fromLTRB(0, 10, 0, 10) : EdgeInsets.fromLTRB(52.w, 13.w, 52.w, 13.w),
      color: widget.buttonColor,
      width: widget.width ?? 388,
      animateOnTap: widget.animate ?? false,
      successColor: myColors.green,
      height: 48,
      borderRadius: widget.borderRadius,
      // padding: EdgeInsets.fromLTRB(52.w, 13.w, 52.w, 13.w),
      controller: widget.controller,
      child: Text(widget.label,
          style: interText(
              CurrentDevice.isAndroid() ? 16 : 20,
              widget.funcName == null ? Colors.black : widget.fontColor,
              FontWeight.w600)),
    );
  }
}
