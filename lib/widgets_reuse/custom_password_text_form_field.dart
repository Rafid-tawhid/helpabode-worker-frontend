import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

import '../helper_functions/signin_signup_helpers.dart';

class CustomPasswordTextField extends StatefulWidget {
  CustomPasswordTextField(
      {required this.fieldTextFieldController,
      required this.funcOnChanged,
      required this.funcValidate,
      required this.funcVisible,
      //required this.funcOnSubmitted,
      required this.hintText,
      required this.width,
      required this.height,
      required this.borderRadius,
      required this.isVisible,
      required this.keyboard,
      this.formKey,
      this.focusNode,
      this.isCheck,
      this.errStyle,
      this.isError,
      this.errorMsg});

  final TextEditingController fieldTextFieldController;
  final void Function(String?)? funcOnChanged;
  final String? Function(String?, Function(bool?, String?)) funcValidate;
  //final void Function(String?)? funcOnSubmitted;
  final String? hintText;
  final double width;
  final double height;
  final double borderRadius;
  final VoidCallback funcVisible;
  final bool isVisible;
  var isCheck;
  final TextInputType keyboard;
  final GlobalKey<FormState>? formKey;
  final FocusNode? focusNode;
  final TextStyle? errStyle;
  bool? isError;
  final String? errorMsg;

  @override
  State<CustomPasswordTextField> createState() =>
      _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool _isER = false;
  String _msg = 'Required.';
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: height,
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            //autofocus: true,
            key: widget.formKey,
            focusNode: widget.focusNode,
            controller: widget.fieldTextFieldController,
            keyboardType: widget.keyboard,
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  // isEmpty=true;
                });
              }

              // Reset error state when onChanged is called
              setState(() {
                _isER = false;
                _msg = 'Required.';
              });
              widget.funcOnChanged!(value);
            },
            style: textFieldContentTextStyle,
            //onSubmitted: funcOnSubmitted,
            validator: (value) {
              return widget.funcValidate(value, (isError, errorMsg) {
                setState(() {
                  _isER = isError!;
                  _msg = errorMsg!;
                });
              });
            },
            obscureText: !widget.isVisible,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              filled: true,
              errorStyle: const TextStyle(
                color: Colors.red,
                fontSize: 0,
                height: .5,
              ),
              fillColor: _isER == true ? const Color(0xffFFF1F1) : textfieldClr,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: fontClr,
                fontSize: CurrentDevice.isAndroid() ? 16 : 20,
              ),
              //errorText: isError ? 'hello' : null,
              // suffixIconConstraints: BoxConstraints.tightForFinite(),
              suffixIcon: GestureDetector(
                onTap: widget.funcVisible,
                child: widget.isCheck == null
                    ? (widget.isVisible == true
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Hide',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              Icon(
                                Icons.add,
                                color: Colors.transparent,
                              )
                            ],
                          )
                        : const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Show',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                              Icon(
                                Icons.add,
                                color: Colors.transparent,
                              )
                            ],
                          ))
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          widget.isVisible == true
                              ? Text(
                                  'Hide',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                )
                              : Text(
                                  'Show',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                          const SizedBox(
                            width: 20,
                          ),
                          Icon(
                            Icons.check,
                            color: buttonClr,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
              ),
              suffixIconColor: borderClr,

              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(8),
              //   borderSide: BorderSide(
              //     color: borderClr,
              //     width: 1,
              //   ),
              // ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  color: _isER ? Colors.transparent : textfieldClr,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.w),
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1.5,
                ),
              ),
              errorBorder: widget.isError != null
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.w),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1.5,
                      ),
                    )
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.w),
                      borderSide: const BorderSide(
                        color: Color(0xffC40606),
                        width: 1.5,
                      ),
                    ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          if (_isER)
            Row(
              children: [
                Icon(
                  Icons.error,
                  color: Color(0xffC40606),
                  size: 14,
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Text(
                  _msg,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xffC40606)),
                )),
              ],
            )
        ],
      ),
    );
  }
}
