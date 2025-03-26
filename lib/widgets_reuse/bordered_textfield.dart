import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/signin_signup_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class TextFieldBordered extends StatefulWidget {
  TextFieldBordered(
      {this.fieldTextFieldController,
      this.initialValue,
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
      this.isDolar,
      this.isPostFix,
      this.keys});

  final TextEditingController? fieldTextFieldController;
  final void Function(String?)? funcOnChanged;
  final void Function()? ontapped;
  final void Function()? onEditingComplete;
  bool? isError;
  bool? isDolar;
  bool? isPostFix;
  final String? errorMsg;
  final String? labelText;
  final String? keys;
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
  final String? initialValue;

  bool? enable;
  var isCheck;
  Color? fillColor;
  bool? obsecureText;
  Widget? leading;

  final List<TextInputFormatter>? inputFormat;

  final String? Function(String?, Function(bool?, String?)) funcValidate;

  @override
  State<TextFieldBordered> createState() => _NewCustomTextFieldState();
}

class _NewCustomTextFieldState extends State<TextFieldBordered> {
  bool _isER = false;
  String _msg = 'Required.';
  bool isEmpty = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // Clear error when TextField gains focus
        setState(() {
          _isER = false;
        });

        debugPrint('ERROR ${_isER}');
      }
    });
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
            // key: widget.formKey,
            key: Key(widget.keys ?? ''),
            cursorColor: Colors.black,
            initialValue: widget.initialValue,
            maxLength: widget.maxLength,
            onEditingComplete: widget.onEditingComplete,
            obscureText: widget.obsecureText ?? false,
            enabled: widget.enable ?? true,
            scrollPadding: EdgeInsets.only(bottom: 40.h),
            textInputAction: TextInputAction.next,
            textAlignVertical: TextAlignVertical.center,
            focusNode: _focusNode,
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
              suffixText: widget.isPostFix == true ? 'Min' : '',
              prefixStyle: interText(14, Colors.black, FontWeight.w500),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              labelText: widget.labelText,
              prefix: widget.leading,
              errorStyle: const TextStyle(
                color: Color(0xffC40606),
                fontSize: 0,
                height: 1,
              ),
              fillColor: _isER == true
                  ? const Color(0xffFFF1F1)
                  : widget.fillColor == null
                      ? Colors.white
                      : widget.fillColor,
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
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Color(0xFFE9E9E9),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: _isER ? Color(0xffC40606) : Colors.black,
                  width: 1.5,
                ),
              ),
              errorBorder: widget.isError != null
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1.5,
                      ),
                    )
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
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
}
