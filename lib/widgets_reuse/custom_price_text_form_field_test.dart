import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_text_form_field.dart';

class CustomPriceTextFormFieldTest extends StatelessWidget {
  const CustomPriceTextFormFieldTest({
    super.key,
    required this.priceTextFormController,
    required this.funcOnChanged,
    required this.isAdd,
    required this.isPercent,
    required this.incDecFunc,
    required this.percentFunc,
    required this.formKey,
  });

  final TextEditingController priceTextFormController;
  final void Function(String?)? funcOnChanged;
  final bool isAdd;
  final bool isPercent;
  final VoidCallback incDecFunc;
  final VoidCallback percentFunc;
  final formKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: incDecFunc,
          child: Container(
            width: 78.w,
            height: 60.h,
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(8.w)),
              // border: Border.all(
              //   color: borderClr,
              //   width: 1.w,
              // ),
              //color: Colors.black,
              color: buttonDisableClr,
            ),
            child: Container(
              width: 50.w,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.w),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 12.w,
                    backgroundColor: isAdd == true ? buttonClr : Colors.white,
                    child: Icon(
                      Icons.add,
                      color: isAdd == true ? Colors.white : fontClr,
                      size: 15.w,
                    ),
                  ),
                  CircleAvatar(
                    radius: 12.w,
                    backgroundColor: isAdd == true ? Colors.white : buttonClr,
                    child: Icon(
                      Icons.remove,
                      color: isAdd == true ? fontClr : Colors.white,
                      size: 15.w,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        CustomTextField(
          formKey: formKey,
          fieldTextFieldController: priceTextFormController,
          keyboard: TextInputType.number,
          funcOnChanged: funcOnChanged,
          funcValidate: (value) {
            return null;
          },
          hintText: 'Enter your price',
          width: 265.w,
          borderRadius: 0.w,
        ),
        GestureDetector(
          onTap: percentFunc,
          child: Container(
            padding: EdgeInsets.all(8.w),
            width: 42.w,
            //height: 60.h,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.horizontal(right: Radius.circular(8.w)),
              // border: Border.all(
              //   color: borderClr,
              //   width: 1.w,
              // ),
              color: buttonDisableClr,
            ),
            child: CircleAvatar(
              backgroundColor: isPercent == true ? buttonClr : fontClr,
              radius: 12.w,
              child: Icon(
                Icons.percent_outlined,
                size: 16.w,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
