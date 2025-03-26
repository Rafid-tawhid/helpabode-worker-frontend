import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class CustomDropdownButtonTest extends StatelessWidget {
  const CustomDropdownButtonTest({
    super.key,
    required this.hintLabel,
    required this.width,
    required this.itemList,
    required this.itemText,
    this.itemVal,
    required this.selectedValue,
    required this.funcOnChanged,
    required this.dropDownClr,
    required this.style,
  });

  final List itemList;
  final String itemText;
  final String? itemVal;
  final String hintLabel;
  final double width;
  final selectedValue;
  final void Function(Object?)? funcOnChanged;
  final Color dropDownClr;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      padding: EdgeInsets.fromLTRB(16.w, 3.w, 13.w, 3.w),
      decoration: BoxDecoration(
        color: dropDownClr,
        // border: Border.all(
        //   color: borderClr,
        //   width: 1.w,
        // ),
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: DropdownButton(
        isExpanded: true,
        //alignment: Alignment.bottomCenter,
        menuMaxHeight: 300.h,
        iconSize: 40.h,
        dropdownColor: dropDownClr,
        focusColor: dropDownClr,

        borderRadius: BorderRadius.circular(8.w),
        // decoration: InputDecoration(
        //   filled: true,
        //   fillColor: Colors.black,
        // ),
        underline: Container(
          decoration: BoxDecoration(
            color: dropDownClr,
          ),
        ),
        hint: Text(
          hintLabel,
          style: TextStyle(
            fontSize: 16.sp,
            color: fontClr,
            fontWeight: FontWeight.w400,
          ),
        ),
        value: selectedValue,
        items: itemList.map((mapElem) {
          return DropdownMenuItem(
            value: itemVal == null ? mapElem : mapElem['$itemVal'],
            //value: mapElem['${itemVal}'],
            //value: mapElem,
            child: Text(
              mapElem['${itemText}'],
              style: style,
            ),
          );
        }).toList(),
        onChanged: funcOnChanged,
      ),
    );
  }
}
