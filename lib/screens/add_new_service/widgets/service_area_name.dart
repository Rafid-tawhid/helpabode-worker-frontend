import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/provider/addnew_services_provider.dart';
import 'package:provider/provider.dart';
import '../../../misc/constants.dart';
import '../../../models/my_service_area_model.dart';
import '../../../widgets_reuse/new_text_formfield.dart';

class SelectAreaName extends StatefulWidget {
  SelectAreaName({
    super.key,
    required this.searchKey,
    required this.zoneNameCon,
  });

  final GlobalKey<FormState> searchKey;
  final TextEditingController zoneNameCon;

  @override
  State<SelectAreaName> createState() => _SelectAreaNameState();
}

class _SelectAreaNameState extends State<SelectAreaName> {
  bool showZoneSelectType = false;
  MyServiceAreaModel? selectedItem;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Form(
        key: widget.searchKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'Service Zone ',
                  style: interText(16, Colors.black, FontWeight.w500),
                ),
                const Text(
                  '*',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                )
              ],
            ),
            SizedBox(
              height: 6.h,
            ),
            Consumer<AddNewServiceProvider>(
                builder: (context, pro, _) => pro.isLoading
                    ? CircularProgressIndicator(
                        color: myColors.green,
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          showZoneSelectType
                              ? Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: textfieldClr,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: FormField<MyServiceAreaModel>(
                                        validator: (value) {
                                          // Check if a value has been selected
                                          if (value == null) {
                                            return 'Please select a zone';
                                          }
                                          return null;
                                        },
                                        builder:
                                            (FormFieldState<MyServiceAreaModel>
                                                state) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              DropdownButton2<
                                                  MyServiceAreaModel>(
                                                isExpanded: true,
                                                hint: const Row(
                                                  children: [
                                                    SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        'Select saved zone'
                                                        '',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                items: pro.myServiceAreaList
                                                    .map((MyServiceAreaModel
                                                        item) {
                                                  return DropdownMenuItem<
                                                      MyServiceAreaModel>(
                                                    value: item,
                                                    child: Text(
                                                      item.zoneTitle ?? '',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (value) async {
                                                  setState(() {
                                                    widget.zoneNameCon.text =
                                                        value!.zoneTitle ?? '';
                                                    selectedItem = value;
                                                    state.didChange(
                                                        value); // Update FormField state
                                                  });
                                                  pro.getTheZipCodesAccordingToZoneName(
                                                      value!.zoneTextId);
                                                },
                                                value: selectedItem,
                                                buttonStyleData:
                                                    ButtonStyleData(
                                                  height: 44,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0, right: 14),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: textfieldClr,
                                                  ),
                                                  elevation: 0,
                                                ),
                                                iconStyleData:
                                                    const IconStyleData(
                                                  icon: Icon(
                                                    Icons.keyboard_arrow_down,
                                                  ),
                                                  iconEnabledColor:
                                                      Colors.black,
                                                  iconDisabledColor:
                                                      Colors.grey,
                                                ),
                                                dropdownStyleData:
                                                    DropdownStyleData(
                                                  maxHeight: 400,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: textfieldClr,
                                                  ),
                                                  offset: const Offset(0, 0),
                                                  scrollbarTheme:
                                                      ScrollbarThemeData(
                                                    radius:
                                                        const Radius.circular(
                                                            8),
                                                    thickness:
                                                        WidgetStateProperty.all(
                                                            6),
                                                    thumbVisibility:
                                                        WidgetStateProperty.all(
                                                            true),
                                                  ),
                                                ),
                                                menuItemStyleData:
                                                    const MenuItemStyleData(
                                                  height: 40,
                                                  padding: EdgeInsets.only(
                                                      left: 14, right: 14),
                                                ),
                                              ),
                                              // Display validation error below the dropdown
                                              if (state.hasError)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 14, top: 4),
                                                  child: Text(
                                                    state.errorText ?? '',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: NewCustomTextField(
                                      fieldTextFieldController:
                                          widget.zoneNameCon,
                                      funcOnChanged: (val) {},
                                      funcValidate: (value, setErrorInfo) {
                                        if (value == null || value.isEmpty) {
                                          setErrorInfo(
                                              true, 'Zone name is required');
                                          return '';
                                        }
                                        if (value.length < 3) {
                                          setErrorInfo(
                                              true, 'Minimum 3 character');
                                          return '';
                                        }
                                        return null;
                                      },
                                      hintText: 'Enter service zone',
                                      borderRadius: 8),
                                ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: myColors.greyBtn,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 13, horizontal: 12)),
                                onPressed: () {
                                  //dsds
                                  pro.clearFiltteredZipcodeListByZone();
                                  setState(() {
                                    showZoneSelectType = !showZoneSelectType;
                                    pro.setSelection(showZoneSelectType);
                                    // selectedItem=null;
                                  });
                                },
                                child: Text(
                                  showZoneSelectType
                                      ? 'Add new'
                                      : 'Select saved zone',
                                  style: TextStyle(color: Colors.black),
                                )),
                          )
                        ],
                      )),
          ],
        ),
      ),
    );
  }
}
