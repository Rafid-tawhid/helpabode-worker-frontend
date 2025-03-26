import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class CustomTextFieldNoBorder extends StatelessWidget {
  CustomTextFieldNoBorder({
    required this.fieldTextFieldController,
    required this.formKey,
    required this.keyboard,
    required this.funcOnChanged,
    required this.funcValidate,
    //required this.funcOnSubmitted,
    required this.hintText,
    required this.width,
    required this.borderRadius,
    this.focusNode,
    this.isValid,
  });

  final TextEditingController fieldTextFieldController;
  final void Function(String?)? funcOnChanged;
  final String? Function(String?)? funcValidate;
  //final void Function(String?)? funcOnSubmitted;
  final String? hintText;
  final double width;
  final double borderRadius;
  final TextInputType keyboard;
  final GlobalKey<FormState> formKey;
  final FocusNode? focusNode;
  final bool? isValid;

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.yellow,
      height: isValid == null
          ? null
          : isValid == true
              ? 50
              : 72,
      width: width,
      child: Form(
        key: formKey,
        child: TextFormField(
          //autofocus: true,
          focusNode: focusNode,
          controller: fieldTextFieldController,
          keyboardType: keyboard,
          onChanged: funcOnChanged,
          style: textFieldContentTextStyle,
          //onSubmitted: funcOnSubmitted,
          validator: funcValidate,
          decoration: InputDecoration(
            // contentPadding: EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
            // contentPadding: isValid == null ? null : EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
            contentPadding: null,
            filled: true,
            fillColor: textfieldClr,
            hintText: hintText,
            hintStyle: TextStyle(
              color: fontClr,
              fontSize: 16.sp,
            ),
            //border: InputBorder.none,

            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(8),
            //   borderSide: BorderSide(
            //     color: borderClr,
            //     width: 1,
            //   ),
            // ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
