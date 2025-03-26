import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/signin_signup_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class NewCustomTextField extends StatefulWidget {
  NewCustomTextField(
      {this.fieldTextFieldController,
      this.isError,
      this.errorMsg,
      this.formKey,
      this.keyboard,
      required this.funcOnChanged,
      required this.funcValidate,
      this.hintText,
      this.width,
      required this.borderRadius,
      this.height,
      this.focusNode,
      this.isValid,
      this.inputFormat,
      this.isCheck,
      this.enable,
      this.maxLength,
      this.fillColor,
      this.obsecureText = false,
      this.leading,
      this.labelText,
      this.ontapped,
      this.onEditingComplete,
      this.isDolar});

  final TextEditingController? fieldTextFieldController;
  final void Function(String?)? funcOnChanged;
  final void Function()? ontapped;
  final void Function()? onEditingComplete;
  bool? isError;
  bool? isDolar;
  final String? errorMsg;
  final String? labelText;
  //final void Function(String?)? funcOnSubmitted;
  final String? hintText;
  final double? width;
  final double? height;
  final double borderRadius;
  final int? maxLength;
  final TextInputType? keyboard;
  final GlobalKey<FormState>? formKey;
  final FocusNode? focusNode;
  final bool? isValid;
  bool? enable;
  var isCheck;
  Color? fillColor;
  bool? obsecureText;
  Widget? leading;

  final List<TextInputFormatter>? inputFormat;

  final String? Function(String?, Function(bool?, String?)) funcValidate;

  @override
  State<NewCustomTextField> createState() => _NewCustomTextFieldState();
}

class _NewCustomTextFieldState extends State<NewCustomTextField> {
  bool _isER = false;
  String _msg = 'Required.';
  bool isEmpty = false;

  @override
  void initState() {
    super.initState();
    // widget.focusNode!.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    //  widget.focusNode!.removeListener(_onFocusChange);
    // widget.focusNode!.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    print('widget.focusNode!.hasFocus ${widget.focusNode!.hasFocus}');
    if (!widget.focusNode!.hasFocus) {
      // Call your method when the TextField is unfocused
      _handleUnfocused();
    }
  }

  void _handleUnfocused() {
    print('TextField unfocused. Do something here.');
    // Add your method logic here
  }

  @override
  Widget build(BuildContext context) {
    double tfheight = 50;
    if (widget.height == null) {
      tfheight = 50;
    } else {
      tfheight = widget.height!;
    }
    return Container(
      height: widget.isValid == null
          ? null
          : (widget.isValid == true ? tfheight : tfheight + 12),
      width: widget.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            key: widget.formKey,
            autofillHints: widget.keyboard == TextInputType.emailAddress
                ? [AutofillHints.email]
                : [],
            textInputAction: TextInputAction.next,
            cursorColor: Colors.black,
            maxLength: widget.maxLength,
            onEditingComplete: widget.onEditingComplete,
            obscureText: widget.obsecureText ?? false,
            enabled: widget.enable ?? true,
            scrollPadding: EdgeInsets.only(bottom: 40.h),
            textAlignVertical: TextAlignVertical.center,
            focusNode: widget.focusNode,
            controller: widget.fieldTextFieldController,
            keyboardType: widget.keyboard,
            inputFormatters: widget.inputFormat,
            onTap: widget.ontapped,
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  isEmpty = true;
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
            validator: (value) {
              return widget.funcValidate(value, (isError, errorMsg) {
                setState(() {
                  _isER = isError!;
                  _msg = errorMsg!;
                });
              });
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              isDense: true,
              prefixText: widget.isDolar == true ? '\$' : '',
              prefixStyle: interText(14, Colors.black, FontWeight.w500),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.5,
                ),
              ),
              labelText: widget.labelText,
              prefix: widget.leading,
              errorStyle: const TextStyle(
                color: Color(0xffC40606),
                fontSize: 0,
                height: 1,
              ),
              fillColor: _isER == true ? Color(0xffFFF1F1) : textfieldClr,
              hintText: widget.hintText,
              hintStyle: GoogleFonts.inter(
                color: fontClr,
                fontSize: CurrentDevice.isAndroid() ? 14 : 20,
              ),
              suffixIcon: widget.isCheck == null
                  ? null
                  : Icon(
                      Icons.check,
                      color: buttonClr,
                    ),
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
                  color: Color(0xffC40606),
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
                      borderSide: BorderSide(
                        color: _isER ? Color(0xffC40606) : Colors.black,
                        width: 1.5,
                      ),
                    ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: textfieldClr,
                  width: 1.5,
                ),
              ),
            ),
            // onFieldSubmitted: (value) {
            //   _validate();
            // },
          ),
          const SizedBox(
            height: 4,
          ),
          if (_isER)
            Row(
              children: [
                const Icon(
                  Icons.error,
                  color: Color(0xffC40606),
                  size: 16,
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                    child: Text(
                  _msg,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xffC40606)),
                )),
              ],
            )
        ],
      ),
    );
  }

  void _validate() {
    if (widget.focusNode!.hasFocus) {
      print('THIS IS UNFOCUS');
      widget.focusNode!.unfocus(); // Remove focus to trigger validation
    } else {
      print('CALLING VALIDATE');
      widget.formKey!.currentState!.validate(); // Manually trigger validation
    }
  }
}
