import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {this.fieldTextFieldController,
      this.formKey,
      this.keyboard,
      required this.funcOnChanged,
      required this.funcValidate,
      //required this.funcOnSubmitted,
      required this.hintText,
      this.width,
      required this.borderRadius,
      this.height,
      this.focusNode,
      this.isValid,
      this.inputFormat,
      this.isCheck,
      this.enable,
      this.lableText});

  final TextEditingController? fieldTextFieldController;
  final void Function(String?)? funcOnChanged;
  final String? Function(String?)? funcValidate;
  //final void Function(String?)? funcOnSubmitted;
  final String? hintText;
  final String? lableText;
  final double? width;
  final double? height;
  final double borderRadius;
  final TextInputType? keyboard;
  final GlobalKey<FormState>? formKey;
  final FocusNode? focusNode;
  final bool? isValid;
  bool? enable;
  var isCheck;
  final List<TextInputFormatter>? inputFormat;

  @override
  Widget build(BuildContext context) {
    double tfheight = 50;
    if (height == null) {
      tfheight = 50;
    } else {
      tfheight = height!;
    }
    return Container(
      //color: Colors.yellow,
      height: isValid == null
          ? null
          : isValid == true
              ? tfheight
              : tfheight + 12,
      width: width,
      child: Form(
        key: formKey,
        child: TextFormField(
          //autofocus: true,
          enabled: enable ?? true,
          scrollPadding: EdgeInsets.only(bottom: 40),
          textInputAction: TextInputAction.next,
          focusNode: focusNode,
          controller: fieldTextFieldController,
          keyboardType: keyboard,

          // inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          inputFormatters: inputFormat,
          onChanged: funcOnChanged,
          style: textFieldContentTextStyle,
          //onSubmitted: funcOnSubmitted,
          validator: funcValidate,
          decoration: InputDecoration(
            // contentPadding: EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
            contentPadding: EdgeInsets.fromLTRB(16, 12, 16, 12),
            // contentPadding: isValid == null ? null : EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
            filled: true,
            fillColor: textfieldClr,
            hintText: hintText,
            labelText: lableText,
            hintStyle: TextStyle(
              color: fontClr,
              fontSize: 16,
            ),

            suffixIcon: isCheck == null
                ? null
                : Icon(
                    Icons.check,
                    color: buttonClr,
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
              borderSide: BorderSide(
                color: textfieldClr,
                width: 0.1,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: Colors.redAccent,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: textfieldClr,
                width: 0.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
