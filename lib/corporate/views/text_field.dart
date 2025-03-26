import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class CustomTextFormField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool? readOnly;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final Function(String)? onChanged;
  final ontap;
  final Color? fillColor;
  final List<TextInputFormatter>? textInputFormatter;
  final IconData? errorIcon;

  CustomTextFormField({
    this.labelText,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
    this.labelStyle,
    this.hintStyle,
    this.onChanged,
    this.ontap,
    this.fillColor,
    this.readOnly,
    this.textInputFormatter,
    this.errorIcon = Icons.error, // Default error icon
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _hasError = false;
  String? _errorMessage;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus || !_hasError) {
      setState(() {
        _hasError = false;
        _errorMessage = null;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          onTap: widget.ontap ?? null,
          validator: (value) {
            // Handle validation with custom logic
            String? validationResult = widget.validator?.call(value);
            setState(() {
              _hasError = validationResult != null;
              _errorMessage = validationResult;
            });
            // Return the validation result to the form
            return validationResult;
          },
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          readOnly: widget.readOnly ?? false,
          focusNode: _focusNode,
          inputFormatters: [
            ...?widget
                .textInputFormatter, // Safely spread the optional formatter list
            FilteringTextInputFormatter.allow(
              RegExp(r'[a-zA-Z0-9\s.,!?@#\$%&*()\-_=+<>;:/\\"]'),
            )
          ],
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            labelStyle: widget.labelStyle ?? TextStyle(color: Colors.black),
            hintStyle: widget.hintStyle ??
                interText(14, myColors.greyTxt, FontWeight.w400),
            filled: true,
            fillColor: _hasError
                ? Colors.red.shade50
                : (widget.fillColor ?? Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.black),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide:
                  BorderSide(color: _hasError ? Colors.red : Colors.black),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.black),
            ),
            contentPadding: widget.contentPadding ??
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
          ),
          onChanged: (value) {
            if (_hasError) {
              setState(() {
                _hasError = false;
                _errorMessage = null;
              });
            }
            widget.onChanged?.call(value);
          },
        ),
        // if (_hasError && _errorMessage != null)
        //   Padding(
        //     padding: const EdgeInsets.only(top: 4.0), // Adjust padding as needed
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         Icon(widget.errorIcon, size: 16, color: Colors.red),
        //         SizedBox(width: 4),
        //         Flexible(child: Text(_errorMessage!, style: TextStyle(color: Colors.red))),
        //       ],
        //     ),
        //   ),
      ],
    );
  }
}
