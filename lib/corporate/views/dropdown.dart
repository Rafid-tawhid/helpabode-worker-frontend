import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items; // List of model items
  final T? selectedItem; // Currently selected item
  final String Function(T item)
      itemLabel; // Function to extract label text from the model
  final String hint; // Hint text when no item is selected
  final ValueChanged<T?>?
      onChanged; // Callback for when the selected item changes
  final String? Function(T?)? validator; // Validator for dropdown
  bool isError = false; // To control the error border state
  final String errorMessage; // Custom error message to show
  final VoidCallback? onDropdownTap;
  Color? bgColor;
  // Callback when dropdown is tapped

  CustomDropdown({
    Key? key,
    required this.items,
    required this.itemLabel,
    required this.hint,
    this.selectedItem,
    this.onChanged,
    this.bgColor,
    this.validator,
    this.isError = false,
    this.errorMessage = '',
    this.onDropdownTap, // Added onDropdownTap callback
  }) : super(key: key);

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton2<T>(
            isExpanded: true,

            // Ensures the dropdown takes full width
            hint: Text(
              widget.hint,
              style: interText(14, myColors.greyTxt, FontWeight.w400),
            ),
            items: widget.items
                .map((item) => DropdownMenuItem<T>(
                      value: item,
                      onTap: () {
                        setState(() {
                          widget.isError =
                              true; // Clear error when item is selected
                        });
                      },
                      child: Text(
                        widget.itemLabel(item),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black, // Text color for items
                        ),
                      ),
                    ))
                .toList(),
            value: widget.selectedItem,
            onChanged: widget.onChanged,
            buttonStyleData: ButtonStyleData(
              height: 50,
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: widget.isError
                    ? Colors.red.shade50
                    : widget.bgColor == null
                        ? Colors.white
                        : widget.bgColor,
                border: Border.all(
                  width: 1,
                  color: widget.isError ? Colors.red : Colors.white,
                ),
              ),
              elevation: 0,
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                CupertinoIcons.chevron_down,
              ),
              iconSize: 18,
              iconEnabledColor: Colors.black,
              iconDisabledColor: Colors.grey,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
              ),
              offset: const Offset(0, -4),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(5),
                thumbColor: WidgetStateProperty.all<Color>(Colors.black),
                thickness: WidgetStateProperty.all<double>(4),
                thumbVisibility: WidgetStateProperty.all<bool>(true),
              ),
            ),

            menuItemStyleData: MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.only(left: 14, right: 14),
            ),
          ),
        ),
        if (widget.isError) // Display error message if there is an error
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              widget.errorMessage,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}

//
// class CustomDropDown2 extends StatefulWidget {
//   const CustomDropDown2({
//     super.key,
//     required this.dropDownList,
//     required this.itemId,
//     required this.attributeCollectionId,
//     required this.attributeId,
//     required this.value,
//     this.isServiceConfig,
//     this.onTap,
//     this.radius,
//     this.attribute,
//   });
//   final List<dynamic> dropDownList;
//   final String? value;
//   final String itemId;
//   final String attributeCollectionId;
//   final String attributeId;
//   final bool? isServiceConfig;
//   final Function(String)? onTap;
//   final double? radius;
//   final AttributeModel? attribute;
//
//   @override
//   State<CustomDropDown2> createState() => _CustomDropDown2State();
// }
//
// class _CustomDropDown2State extends State<CustomDropDown2> {
//   List<String> items = [];
//   String? selectedValue;
//   bool isDropdownOpen = false;
//   FocusNode dropdownFocusNode = FocusNode();
//
//   @override
//   void initState() {
//     // selectedValue = 'Option 1';
//     super.initState();
//     items = widget.dropDownList
//         .map((dynamicItem) => dynamicItem.toString())
//         .toList();
//     // selectedValue = items.first;
//
//     selectedValue = widget.value ?? items.first;
//
//     setAttributesData();
//
//     dropdownFocusNode.unfocus();
//   }
//
//   setAttributesData() {
//     var hcp = context.read<HouseConfigProvider>();
//     var scp = context.read<ServiceSelectionProvider>();
//
//     Future.microtask(() {
//       if (widget.value != null) {
//         widget.isServiceConfig == true
//             ? scp
//             .updateAttributeValuMap(widget.attributeId, widget.value ?? '')
//             .then((value) => widget.onTap!(selectedValue ?? ''))
//             : hcp.updateAttributeValuMap(
//             widget.attributeId, widget.value ?? '');
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var hcp = context.read<HouseConfigProvider>();
//     var scp = context.read<ServiceSelectionProvider>();
//     return DropdownButtonHideUnderline(
//       child: DropdownButton2<String>(
//         focusNode: dropdownFocusNode,
//         isExpanded: true,
//         hint: DropdownHint(selectedValue: selectedValue),
//         items: items
//             .map((String item) => DropdownMenuItem<String>(
//           value: item,
//           child: Text(
//             item,
//             style: interStyle14_500.copyWith(
//               color: AppColors.secondaryTextColor,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ))
//             .toList(),
//         value: selectedValue,
//         onChanged: (String? value) async {
//           setState(() {
//             selectedValue = value;
//           });
//
//           if (widget.isServiceConfig == true) {
//             if (widget.attribute!.inputType == "selectNumber") {
//               if (AppServices.extractNumber(value ?? '') > 0) {
//                 scp
//                     .updateAttributeValuMap(widget.attributeId, value ?? '')
//                     .then((value) {
//                   widget.onTap!(selectedValue ?? '');
//                 });
//               } else {
//                 scp.removeAttributeValueMapKey(widget.attribute!.textId!);
//               }
//               scp.chanageAttributeValue(
//                 attributeCollectionId: widget.attributeCollectionId,
//                 attributeId: widget.attributeId,
//                 updateValue: AppServices.extractNumber(value ?? '') > 0
//                     ? value ?? ''
//                     : "",
//                 isDropdown: true,
//               );
//             } else {
//               scp
//                   .updateAttributeValuMap(widget.attributeId, value ?? '')
//                   .then((value) => widget.onTap!(selectedValue ?? ''));
//             }
//           } else {
//             hcp.updateAttributeValuMap(widget.attributeId, value ?? '');
//           }
//
//           FocusScope.of(context).unfocus();
//           // hcp.chanageAttributeValue(
//           //   itemId: widget.itemId,
//           //   attributeCollectionId: widget.attributeCollectionId,
//           //   attributeId: widget.attributeId,
//           //   updateValue: value!,
//           // );
//           widget.onTap != null ? widget.onTap!(selectedValue ?? '') : null;
//         },
//         buttonStyleData: ButtonStyleData(
//           height: 50,
//           width: 160,
//           padding: const EdgeInsets.only(left: 14, right: 14),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(widget.radius ?? 30),
//             color: AppColors.attributeBoxColor,
//             border: Border.all(
//               width: 1.5,
//               color: dropdownFocusNode.hasFocus
//                   ? Colors.black
//                   : Colors.transparent,
//             ),
//           ),
//           elevation: 0,
//         ),
//         iconStyleData: const IconStyleData(
//           icon: Icon(
//             CupertinoIcons.chevron_down,
//           ),
//           iconSize: 18,
//           iconEnabledColor: Colors.black,
//           iconDisabledColor: Colors.grey,
//         ),
//         dropdownStyleData: DropdownStyleData(
//           maxHeight: 200,
//           width: MediaQuery.of(context).size.width - 72,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14),
//             color: Colors.white,
//           ),
//           offset: const Offset(0, -4),
//           scrollbarTheme: ScrollbarThemeData(
//             radius: const Radius.circular(5),
//             thumbColor: WidgetStateProperty.all<Color>(AppColors.borderColor),
//             thickness: WidgetStateProperty.all<double>(4),
//             thumbVisibility: WidgetStateProperty.all<bool>(true),
//           ),
//         ),
//         // barrierLabel: 'skfj',
//         menuItemStyleData: MenuItemStyleData(
//           selectedMenuItemBuilder: (BuildContext context, Widget child) {
//             return Container(
//               width: 100,
//               height: 50,
//               padding: EdgeInsets.symmetric(horizontal: 14),
//               alignment: Alignment.centerLeft,
//               decoration: BoxDecoration(
//                 color: Color(0xFFD5E7E0),
//                 border: Border(
//                   left: BorderSide(
//                     color: AppColors.primaryColor,
//                     width: 2,
//                   ),
//                 ),
//               ),
//               child: Text(
//                 selectedValue ?? '',
//                 style: interStyle14_500.copyWith(
//                   color: AppColors.secondaryTextColor,
//                 ),
//               ),
//             );
//           },
//           height: 40,
//           padding: EdgeInsets.only(left: 14, right: 14),
//         ),
//       ),
//     );
//     // return DropdownButtonHideUnderline(
//     //   child: DropdownButton<String>(
//     //     value: 'Option 1',
//     // items: [
//     //   'Option 1',
//     //   'Option 2',
//     //   'Option 3',
//     // ].map((String value) {
//     //       return DropdownMenuItem<String>(
//     //         value: value,
//     //         child: Text(
//     //           value,
//     //           style: TextStyle(
//     //             color: Colors.red,
//     //           ),
//     //         ),
//     //       );
//     //     }).toList(),
//     //     onChanged: (value) {
//     //       setState(() {
//     //         selectedValue = value;
//     //       });
//     //     },
//     //   ),
//     // );
//   }
// }
//
// class DropdownHint extends StatelessWidget {
//   const DropdownHint({
//     super.key,
//     required this.selectedValue,
//   });
//
//   final String? selectedValue;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Text(
//             selectedValue ?? '',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
// }
