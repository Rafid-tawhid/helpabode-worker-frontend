import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/misc/shift_config_day_time_constants.dart';
import 'package:help_abode_worker_app_ver_2/models/city_model_worker.dart';
import 'package:help_abode_worker_app_ver_2/models/shift_worker_city_model.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_small_material_button.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_snackbar_message.dart';
import 'package:http/http.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
//import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';
import 'package:provider/provider.dart';

import '../provider/shift_config_provider.dart';

class ShiftConfigBottomModalSheet extends StatefulWidget {
  ShiftConfigBottomModalSheet({
    super.key,
    //required this.selectedDurationValue,
    required this.min,
    required this.max,
    required this.day,
  });

  //final selectedDurationValue;
  final day;
  final min;
  final max;
  final List<CityModelWorker> workerCities = [];
  // final List<String> workerCityNames = [];

  @override
  State<ShiftConfigBottomModalSheet> createState() =>
      _ShiftConfigBottomModalSheetState();
}

class _ShiftConfigBottomModalSheetState
    extends State<ShiftConfigBottomModalSheet> {
  ShiftWorkerCityModel? selectedZoneValue;

  var selectedDurationValue;

  var selectedStartTimeHour;

  var selectedStartTimeMinute;

  var selectedEndTimeHour;

  var selectedEndTimeMinute;

  bool isButtonLoading = false;

  AnimationController? localAnimationController;
  late ShiftProvider provider;

  Future postShiftConfig(
      String startTime, String endTime, ShiftWorkerCityModel selectZone) async {
    if (provider.isLoadingBttn == false) {
      try {
        print("try");

        print("before post");

        provider.setLoadingBtn(true);

        var header = {
          "Authorization": "Bearer ${token}",
        };

        var data = {
          "zoneTextId": selectedZoneValue!.zoneTextId,
          "dayOfWeek": widget.day.toString(),
          "startTimeSlot": startTime,
          "endTimeSlot": endTime,
          "duration": selectedDurationValue['value'].toString(),
          //"duration": 3,
        };

        print('Post Data ${data}');
        var body = jsonEncode(data);

        Response response = await post(
          Uri.parse("${urlBase}api/workerShiftConfiguration"),
          body: body,
          headers: header,
        );
        print('Response Json ${response.body}');
        if (response.statusCode == 200) {
          var responseDecodeJson = jsonDecode(response.body);
          print('Returning Response Json');

          await postPlanGenerate();

          return true;
        } else if (response.statusCode == 409) {
          print('Inside 409');
          return false;
        }
      } catch (e) {
        print("catch");
        print(e);
        return false;
      } finally {
        provider.setLoadingBtn(false);
      }
    }
  }

  Future<bool> postPlanGenerate() async {
    try {
      print("try");

      print("before post");

      var header = {
        "Authorization": "Bearer ${token}",
      };

      Response response = await post(
        Uri.parse("${urlBase}api/workerScheduleGenerate"),
        headers: header,
      );

      if (response.statusCode == 200) {
        print(jsonDecode(response.body.toString()));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("catch");
      print(e);

      return false;
    }
  }

  funcGetDate(int timeHour, int timeMinute) {
    if (timeHour < 10) {
      if (timeMinute < 10) {
        return '0${timeHour}:0${timeMinute}';
      } else {
        return '0${timeHour}:${timeMinute}';
      }
    } else {
      if (timeMinute < 10) {
        return '${timeHour}:0${timeMinute}';
      } else {
        return '${timeHour}:${timeMinute}';
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS");
    // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");

    print('SingleChildScrollView ${widget.min} ${widget.max}');

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 6,
            ),
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xffe9e9e9)),
              ),
            ),
            SizedBox(
              height: 36,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                'Start Time:',
                                style: text_18_black_500_TextStyle,
                                maxLines: 3,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              TimePickerSpinner(
                                alignment: Alignment.center,
                                highlightedTextStyle:
                                    textField_24_black_900_LabelTextStyle,
                                normalTextStyle:
                                    textField_24_black_400_LabelTextStyle,
                                spacing: 2,
                                itemHeight: 40,
                                itemWidth: 50,
                                isForce2Digits: true,
                                is24HourMode: true,
                                minutesInterval: 15,
                                isShowSeconds: false,
                                time: DateTime.parse(
                                    "2025-01-01 ${widget.min}:00"),
                                onTimeChange: (time) {
                                  print(time);
                                  print('Start Time Hour${time.hour}');
                                  print('Start Time Minute${time.minute}');
                                  setState(() {
                                    selectedStartTimeHour = time.hour;
                                    selectedStartTimeMinute = time.minute;
                                  });
                                  print(
                                      'selectedStartTimeHour ${selectedStartTimeHour}');
                                  print(
                                      'selectedStartTimeMinute ${selectedStartTimeMinute}');
                                },
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ' $selectedStartTimeHour:$selectedStartTimeMinute ',
                                style: TextStyle(
                                    color: myColors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  DashboardHelpers.getAmPm(
                                      '${selectedStartTimeHour}:${selectedStartTimeMinute}'),
                                  style: TextStyle(
                                      color: myColors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                'End Time',
                                style: text_18_black_500_TextStyle,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TimePickerSpinner(
                                alignment: Alignment.center,
                                highlightedTextStyle:
                                    textField_24_black_900_LabelTextStyle,
                                normalTextStyle:
                                    textField_24_black_400_LabelTextStyle,
                                spacing: 5,
                                itemHeight: 40,
                                itemWidth: 50,
                                isForce2Digits: true,
                                is24HourMode: true,
                                minutesInterval: 15,
                                isShowSeconds: false,
                                time: DateTime.parse(
                                    "2025-01-01 ${widget.max}:00"),
                                onTimeChange: (time) {
                                  setState(() {
                                    if (time.hour == 0 && time.minute == 0) {
                                      selectedEndTimeHour = 24;
                                      selectedEndTimeMinute = 0;
                                    } else {
                                      selectedEndTimeHour = time.hour;
                                      selectedEndTimeMinute = time.minute;
                                    }
                                  });

                                  // selectedEndTimeHour = time.hour;
                                  // selectedEndTimeMinute = time.minute;

                                  print('End Time Hour$selectedEndTimeHour');
                                  print(
                                      'End Time Minute$selectedEndTimeMinute');
                                },
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$selectedEndTimeHour:$selectedEndTimeMinute ',
                                style: TextStyle(
                                    color: myColors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  '${DashboardHelpers.getAmPm('$selectedEndTimeHour:$selectedEndTimeMinute')}',
                                  style: TextStyle(
                                      color: myColors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              //child: TimePickerSpinnerPopUp(),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: AutoSizeText(
                'Zones',
                style: text_18_black_500_TextStyle,
                maxLines: 3,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              height: 48,
              padding: const EdgeInsets.fromLTRB(20, 3, 0, 3),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: textfieldClr,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<ShiftWorkerCityModel>(
                  isExpanded: true,
                  hint: const Row(
                    children: [
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          'Select Zone',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  items: provider.workerCityLIST
                      .map<DropdownMenuItem<ShiftWorkerCityModel>>(
                          (ShiftWorkerCityModel item) {
                    return DropdownMenuItem<ShiftWorkerCityModel>(
                      value: item,
                      child: Text(
                        item.zoneTitle ?? '',
                        style: textFieldContentTextStyle,
                      ),
                    );
                  }).toList(),
                  value: selectedZoneValue,
                  onChanged: (ShiftWorkerCityModel? newValue) {
                    setState(() {
                      selectedZoneValue = newValue;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 56,
                    // width: 160,
                    padding: const EdgeInsets.only(left: 0, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      // border: Border.all(
                      //   color: Colors.black26,
                      // ),
                      color: textfieldClr,
                    ),
                    elevation: 0,
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                    ),
                    iconEnabledColor: Colors.black,
                    iconDisabledColor: Colors.grey,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: textfieldClr,
                    ),
                    offset: const Offset(0, 0),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: WidgetStateProperty.all(6),
                      thumbVisibility: WidgetStateProperty.all(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.only(left: 14, right: 14),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: AutoSizeText(
                'Duration',
                style: text_18_black_500_TextStyle,
                maxLines: 3,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 20.w),
            //   child: CustomDropdownButtonTest(
            //     hintLabel: 'Select Duration',
            //     width: 388.w,
            //     itemList: durationList,
            //     itemText: 'duration',
            //     //itemVal: 'cityTextId',
            //     itemVal: 'value',
            //     selectedValue: selectedDurationValue,
            //     dropDownClr: textfieldClr,
            //     style: textFieldContentTextStyle,
            //     funcOnChanged: (val) {
            //       selectedDurationValue = val;
            //       setModalState(() {
            //         //print(selectedZoneValue);
            //         //print(selectedZoneValue['areaTextId']);
            //       });
            //     },
            //   ),
            // ),

            Container(
              width: double.infinity,
              height: 48,
              padding: const EdgeInsets.fromLTRB(20, 3, 0, 3),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: textfieldClr,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<Map<String, dynamic>>(
                  isExpanded: true,
                  hint: const Row(
                    children: [
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          'Select Duration',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  items: durationList.map((Map<String, dynamic> item) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: item, // Use the entire map as the value
                      child: Text(
                        item['duration'],
                        style: textFieldContentTextStyle,
                      ),
                    );
                  }).toList(),
                  value: selectedDurationValue,
                  onChanged: (Map<String, dynamic>? newValue) {
                    setState(() {
                      selectedDurationValue = newValue;
                    });

                    print('newValue ${selectedDurationValue['value']}');
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 56,
                    // width: 160,
                    padding: const EdgeInsets.only(left: 0, right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      // border: Border.all(
                      //   color: Colors.black26,
                      // ),
                      color: textfieldClr,
                    ),
                    elevation: 0,
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                    ),
                    iconEnabledColor: Colors.black,
                    iconDisabledColor: Colors.grey,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: textfieldClr,
                    ),
                    offset: const Offset(0, 0),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: WidgetStateProperty.all(6),
                      thumbVisibility: WidgetStateProperty.all(true),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.only(left: 14, right: 14),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 36,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Consumer<ShiftProvider>(
                    builder: (context, provider, _) =>
                        CustomMaterialSmallButton(
                      isLoading: isButtonLoading,
                      height: 48,
                      width: double.maxFinite,
                      buttonColor: (selectedZoneValue == null ||
                                  selectedDurationValue == null) ==
                              true
                          ? buttonDisableClr
                          : buttonClr,
                      padding: EdgeInsets.fromLTRB(52, 13, 52, 13),
                      fontSize: 18,
                      label: 'Add Shift',
                      fontColor: (selectedZoneValue == null ||
                                  selectedDurationValue == null) ==
                              true
                          ? Colors.black
                          : buttonFontClr,
                      funcName: (selectedZoneValue == null ||
                                  selectedDurationValue == null) ==
                              true
                          ? () {}
                          : () async {
                              print('POST');
                              setModalState(() {
                                isButtonLoading = true;
                              });

                              // if (selectedZoneValue == null) {
                              //   showCustomSnackBar(
                              //     context,
                              //     'Select a valid City',
                              //     Colors.red,
                              //     snackBarNeutralTextStyle,
                              //     localAnimationController,
                              //   );
                              //   setModalState(() {
                              //     isButtonLoading = false;
                              //   });
                              //   Navigator.pop(context);
                              //   return;
                              // }
                              // else if (selectedDurationValue == null) {
                              //   showCustomSnackBar(
                              //     context,
                              //     'Select a valid Duration',
                              //     Colors.red,
                              //     snackBarNeutralTextStyle,
                              //     localAnimationController,
                              //   );
                              //   setModalState(() {
                              //     isButtonLoading = false;
                              //   });
                              //   Navigator.pop(context);
                              //   return;
                              // }

                              if (selectedStartTimeHour != null &&
                                  selectedEndTimeHour != null &&
                                  selectedStartTimeHour ==
                                      selectedEndTimeHour &&
                                  selectedStartTimeMinute <
                                      selectedEndTimeMinute &&
                                  isButtonLoading == false) {
                                print('POST VALID');
                                if (await postShiftConfig(
                                    funcGetDate(selectedStartTimeHour,
                                        selectedStartTimeMinute),
                                    funcGetDate(selectedEndTimeHour,
                                        selectedEndTimeMinute),
                                    selectedZoneValue ??
                                        ShiftWorkerCityModel())) {
                                  setModalState(() {
                                    isButtonLoading = false;
                                  });

                                  showCustomSnackBar(
                                    context,
                                    'Shift Successfully Added',
                                    buttonClr,
                                    snackBarNeutralTextStyle,
                                    localAnimationController,
                                  );
                                } else {
                                  setModalState(() {
                                    isButtonLoading = false;
                                  });
                                  showCustomSnackBar(
                                    context,
                                    'Shift Already Exists',
                                    Colors.red,
                                    snackBarNeutralTextStyle,
                                    localAnimationController,
                                  );
                                }
                              } else if (selectedStartTimeHour != null &&
                                  selectedEndTimeHour != null &&
                                  selectedStartTimeHour < selectedEndTimeHour) {
                                if (await postShiftConfig(
                                    funcGetDate(selectedStartTimeHour,
                                        selectedStartTimeMinute),
                                    funcGetDate(selectedEndTimeHour,
                                        selectedEndTimeMinute),
                                    selectedZoneValue ??
                                        ShiftWorkerCityModel())) {
                                  showCustomSnackBar(
                                    context,
                                    'Shift Successfully Added',
                                    buttonClr,
                                    snackBarNeutralTextStyle,
                                    localAnimationController,
                                  );
                                } else {
                                  showCustomSnackBar(
                                    context,
                                    'Shift Already Exists',
                                    Colors.red,
                                    snackBarNeutralTextStyle,
                                    localAnimationController,
                                  );
                                }
                              } else {
                                print('POST INVALID');
                                showCustomSnackBar(
                                  context,
                                  'Select a valid timeslot',
                                  Colors.red,
                                  snackBarNeutralTextStyle,
                                  localAnimationController,
                                );
                              }

                              setModalState(() {
                                isButtonLoading = false;
                              });

                              //call again to update real time
                              await provider.getWorkerScheduleInfo();
                              await provider.setShifthour(widget.day);
                              Navigator.pop(context);
                            },
                    ),
                  ),
                  SizedBox(
                    height: 45.h,
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

Future<dynamic> buildShowShiftConfigModalBottomSheet(
  BuildContext context,
  String day,
  String min,
  String max,
) {
  return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.w),
        ),
      ),
      //isScrollControlled: true,
      context: context,
      builder: (context) {
        return ShiftConfigBottomModalSheet(min: min, max: max, day: day);
      });
}
