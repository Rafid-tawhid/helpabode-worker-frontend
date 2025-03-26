import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../misc/constants.dart';

class MyCustomDropDown extends StatelessWidget {
  String? item;
  List<String> itemList;
  final void Function(String? value) onChange;

  MyCustomDropDown(
      {required this.item, required this.itemList, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: EdgeInsets.fromLTRB(16.w, 3.w, 13.w, 3.w),
      decoration: BoxDecoration(
        color: textfieldClr,
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        //alignment: Alignment.bottomCenter,
        menuMaxHeight: 300.h,
        iconSize: 40.h,
        dropdownColor: textfieldClr,
        borderRadius: BorderRadius.circular(8.w),

        underline: Container(
          decoration: BoxDecoration(
            color: textfieldClr,
          ),
        ),
        hint: Text(
          'Select State',
          style: TextStyle(
            fontSize: 16.sp,
            color: fontClr,
            fontWeight: FontWeight.w400,
          ),
        ),
        value: item,
        onChanged: onChange,

        items: itemList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
