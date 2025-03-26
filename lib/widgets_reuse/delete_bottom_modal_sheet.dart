import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/models/shift_config_worker_plan.dart';
import 'package:help_abode_worker_app_ver_2/provider/dashboard_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/shift_config_provider.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_small_material_button.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../api/delete_worker_service_zone.dart';

class DeleteBottomModalSheet extends StatelessWidget {
  DeleteBottomModalSheet({
    super.key,
    //required this.selectedDurationValue,
    required this.responseList,
    required this.index,
    required this.apiUrl,
  });

  //final selectedDurationValue;
  final responseList;
  final index;
  final apiUrl;

  var isButtonLoading = false;
  // AnimationController? localAnimationController;

  Future deleteData(String id) async {
    try {
      print("try");

      print("before delete 1");

      var header = {
        "Authorization": "Bearer ${token}",
      };

      Response response = await delete(
        Uri.parse("${urlBase}api/$apiUrl/$id"),
        headers: header,
      );

      if (response.statusCode == 200) {
        var responseDecodeJson = jsonDecode(response.body);
        print('Response Json');
        print(responseDecodeJson);

        print('Returning Response Json');
        return true;
      }
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'Something went wrong.');
      print("catch");
      print(e);
      return false;
    }
  }

  Future deleteShiftConfigData(
    String dayOfWeek,
    String startTime,
    String endTime,
  ) async {
    try {
      print("try ");

      print("before delete 2 $dayOfWeek/${startTime}/${endTime}");

      var header = {
        "Authorization": "Bearer ${token}",
      };

      Response response = await delete(
        Uri.parse("${urlBase}api/$apiUrl/$dayOfWeek/$startTime/$endTime/"),
        headers: header,
      );

      print('${urlBase}api/$apiUrl/$dayOfWeek/$startTime/$endTime/');

      if (response.statusCode == 200) {
        var responseDecodeJson = jsonDecode(response.body);

        print('Response Json');
        print(responseDecodeJson);
        print('Returning Response Json');
        return true;
      }
    } catch (e) {
      print("catch");
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // SizedBox(
            //   height: 15.h,
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 20.w),
            //   child: AutoSizeText(
            //     apiUrl == 'workerShiftConfigurationDelete' ? 'Remove Shift ?' : 'Remove Item ?',
            //     style: textField_24_TabTextStyle,
            //     maxLines: 3,
            //   ),
            // ),
            SizedBox(
              height: 25.h,
            ),
            Align(
              alignment: Alignment.center,
              child: AutoSizeText(
                'Are you sure you want to delete this event?',
                style: textField_16_TabTextStyle,
                maxLines: 3,
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Divider(),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Consumer<ShiftProvider>(
                    builder: (context, provider, _) =>
                        CustomMaterialSmallButton(
                      isLoading: isButtonLoading,
                      height: 50.0,
                      width: 388.w,
                      elevation: 0,
                      padding: EdgeInsets.fromLTRB(52.w, 13.w, 52.w, 13.w),
                      fontSize: 20.sp,
                      label: 'Remove Item',
                      fontColor: Colors.black,
                      buttonColor: myColors.greyBtn,
                      funcName: () async {
                        var info = ClmData.fromJson(responseList[0]).timeSlot;
                        var day = responseList[1];
                        setModalState(() {
                          isButtonLoading = true;
                        });
                        if (apiUrl == 'workerShiftConfigurationDelete') {
                          await deleteShiftConfigData(
                            day,
                            info.toString().substring(0, 5),
                            info
                                .toString()
                                .substring(info.toString().length - 5),
                          );
                        } else {
                          await deleteData(
                              apiUrl == 'workerShiftConfigurationDelete'
                                  ? responseList[index]['dayOfWeek'].toString()
                                  : responseList[index]['id'].toString());
                        }

                        //get full day response again
                        if (await provider.getWorkerScheduleInfo()) {
                          provider.setShifthour(day);
                        }

                        setModalState(() {
                          isButtonLoading = false;
                        });
                        //responseList.removeAt(index);
                        //print(responseList[index]['id']);

                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  CustomMaterialSmallButton(
                    height: 50.0,
                    width: 388.w,
                    padding: EdgeInsets.fromLTRB(52.w, 13.w, 52.w, 13.w),
                    fontSize: 20.sp,
                    label: 'Cancel',
                    elevation: 0,
                    fontColor: Colors.black,
                    buttonColor: Colors.white,
                    funcName: () {
                      setModalState(() {
                        Navigator.pop(context);
                      });
                    },
                  ),
                  SizedBox(
                    height: 25.h,
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

Future<dynamic> buildShowDeleteModalBottomSheet(
    BuildContext context, int index, dynamic deleteInfo, String apiUrl) {
  return showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        // side: BorderSide(
        //   color: borderClr,
        //   width: 2,
        // ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.w),
        ),
      ),
      //isScrollControlled: true,
      context: context,
      builder: (context) {
        return DeleteBottomModalSheet(
          //selectedDurationValue: selectedDurationValue,
          responseList: deleteInfo,
          index: index,
          apiUrl: apiUrl,
        );
      });
}

Future<dynamic> deleteServiceArea(BuildContext context, String workerId,
    String zipcode, String apiUrl, DashboardProvider provider) {
  return showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        // side: BorderSide(
        //   color: borderClr,
        //   width: 2,
        // ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.w),
        ),
      ),
      //isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 35.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: AutoSizeText(
                  'Remove Item',
                  style: textField_24_TabTextStyle,
                  maxLines: 3,
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: AutoSizeText(
                  'Are you sure you want to delete this event?.',
                  style: textField_16_TabTextStyle,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    CustomMaterialSmallButton(
                      // isLoading: isButtonLoading,
                      height: 50.0,
                      width: 388.w,
                      padding: EdgeInsets.fromLTRB(52.w, 13.w, 52.w, 13.w),
                      fontSize: 20.sp,
                      label: 'Remove Item',
                      fontColor: Colors.black,
                      buttonColor: myColors.greyBtn,
                      funcName: () async {
                        print('--------');
                        // EasyLoading.show(maskType: EasyLoadingMaskType.black);

                        deleteCityAreaData(workerId, zipcode)
                            .then((value) async {
                          if (value) {
                            await provider.getWorkersCityModels();
                          }
                        });

                        EasyLoading.dismiss();

                        setModalState(() {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomMaterialSmallButton(
                      height: 50.0,
                      width: 388.w,
                      padding: EdgeInsets.fromLTRB(52.w, 13.w, 52.w, 13.w),
                      fontSize: 20.sp,
                      label: 'Cancel',
                      fontColor: Colors.black,
                      buttonColor: Color(0XFFE8E9E9),
                      funcName: () {
                        setModalState(() {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    SizedBox(
                      height: 65.h,
                    ),
                  ],
                ),
              )
            ],
          );
        });
      });
}
