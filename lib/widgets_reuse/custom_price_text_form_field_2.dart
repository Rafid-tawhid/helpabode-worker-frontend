import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_text_form_field_no_border.dart';

class CustomPriceTextFormField2 extends StatelessWidget {
  const CustomPriceTextFormField2({
    super.key,
    required this.priceTextFormController,
    required GlobalKey<FormState> formPriceKey,
    required this.isValid,
    required this.focusNodePrice,
    required this.funcOnChanged,
    required this.isAdd,
    required this.isPercent,
    required this.incDecFunc,
    required this.percentFunc,
    required this.isSelected,
  }) : _formPriceKey = formPriceKey;

  final TextEditingController priceTextFormController;
  final GlobalKey<FormState> _formPriceKey;
  final bool isValid;
  final FocusNode focusNodePrice;
  final void Function(String?)? funcOnChanged;
  final bool isAdd;
  final bool isPercent;
  final VoidCallback incDecFunc;
  final VoidCallback percentFunc;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.w),
        border: Border.all(
          color: isSelected == true ? Colors.black : textfieldClr,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: incDecFunc,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 14,
              ),
              height: 50,
              width: 88.w,
              decoration: BoxDecoration(
                color: textfieldClr,
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(6.w)),
              ),
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.w),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: isAdd == true ? buttonClr : Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: isAdd == true ? Colors.white : fontClr,
                        size: 15,
                      ),
                    ),
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: isAdd == true ? Colors.white : buttonClr,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.remove,
                        color: isAdd == true ? fontClr : Colors.white,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CustomTextFieldNoBorder(
            fieldTextFieldController: priceTextFormController,
            formKey: _formPriceKey,
            keyboard: TextInputType.number,
            funcOnChanged: funcOnChanged,
            //     (value) {
            //   // if (!RegExp(r"^[0-9]$").hasMatch(value!) && value.isNotEmpty) {
            //   // } else {}
            // },
            funcValidate: (value) {
              return null;
            },
            //     (value) {
            //   // if (!RegExp(r"^[0-9]$").hasMatch(value!) || value.isEmpty) {
            //   //   setState(() {
            //   //     isValid = false;
            //   //     //print('isValid : ' + isValid.toString());
            //   //   });
            //   //   return 'Invalid';
            //   // } else {
            //   //   setState(() {
            //   //     isValid = true;
            //   //     //print('isValid : ' + isValid.toString());
            //   //   });
            //   //   return null;
            //   // }
            // },
            hintText: 'Enter Price',
            width: 235.w,
            borderRadius: 0.0,
            isValid: isValid,
            focusNode: focusNodePrice,
          ),
          GestureDetector(
            onTap: percentFunc,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              height: 50,
              width: 60.w,
              decoration: BoxDecoration(
                color: textfieldClr,
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(6.w)),
              ),
              child: Container(
                //padding: EdgeInsets.all(2),

                decoration: BoxDecoration(
                  color: isPercent == true ? buttonClr : fontClr,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.percent_outlined,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
