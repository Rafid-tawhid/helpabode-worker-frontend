import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/signin_signup_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_appbar.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_material_button.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/new_text_formfield.dart';
import 'package:intl/intl.dart';

import '../registration/select_idcard_type_screen.dart';
import 'driving_license_submit_screen.dart';

class SelectPendingIdCardTypeScreen extends StatefulWidget {
  const SelectPendingIdCardTypeScreen({super.key});
  @override
  State<SelectPendingIdCardTypeScreen> createState() =>
      _SelectPendingIdCardTypeScreenState();
}

class _SelectPendingIdCardTypeScreenState
    extends State<SelectPendingIdCardTypeScreen> {
  List<String> idLists = [
    'Driving License',
    'State ID',
    'Passport',
    'Passport Card'
  ];
  String? selectedId;
  bool showBody = false;
  DateTime? selectedDateTime;
  String selectedDate = 'dd-MM-yyyy';
  String selectedDateText = 'mm-dd-yyyy';
  final _idCon = TextEditingController();
  final form_key = GlobalKey<FormState>();

  @override
  void dispose() {
    _idCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(label: ''),
            // Text('Verify your\nDriving License',style: interText(20, Colors.black, FontWeight.w500),textAlign: TextAlign.center,),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Text(
                    'Select a Photo ID to capture',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    'We require a photo of a government-issued ID to verify your identity.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: hintClr,
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Text(
                    'ID TYPE',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    padding: EdgeInsets.fromLTRB(4, 3, 13, 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                    child: DropdownButton2<String>(
                      value: selectedId,
                      isExpanded: true,
                      underline: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                      hint: Text(
                        'Driver’s License',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: fontClr,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onChanged: null,
                      items: idLists.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),

                  Form(
                    key: form_key,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ID No.',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.h,
                                  ),
                                  NewCustomTextField(
                                      funcOnChanged: (val) {},
                                      fieldTextFieldController: _idCon,
                                      inputFormat: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(40),
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r'[^\w\d]'))
                                      ],
                                      funcValidate: (value, setErrorInfo) {
                                        if (value == null || value.isEmpty) {
                                          setErrorInfo(
                                              true, 'ID number is required');
                                          //focusNodeFirstName.requestFocus();
                                          return '';
                                        }
                                        if (value.length < 4) {
                                          setErrorInfo(true,
                                              'Please provide a valid ID');
                                          //focusNodeFirstName.requestFocus();
                                          return '';
                                        }
                                        return null;
                                      },
                                      hintText: 'XXXXXXXXXX',
                                      borderRadius: 8.h),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expiration Date',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: textfieldClr,
                                      borderRadius: BorderRadius.circular(6)),
                                  padding: EdgeInsets.only(left: 12),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          selectedDateTime = await DatePicker
                                              .showSimpleDatePicker(
                                            context,
                                            backgroundColor: Colors.white,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2050),
                                            dateFormat: "dd-MM-yyyy",
                                            locale: DateTimePickerLocale.en_us,
                                            looping: true,
                                          );
                                          if (selectedDateTime != null) {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());

                                            setState(() {
                                              selectedDate = SignInSignUpHelpers
                                                  .formatDate(
                                                      selectedDateTime!);
                                              String formattedDateTime =
                                                  DateFormat('MM-dd-yyyy')
                                                      .format(
                                                          selectedDateTime!);
                                              selectedDateText =
                                                  formattedDateTime;
                                            });
                                          }
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6),
                                          width: CurrentDevice.isAndroid()
                                              ? null
                                              : 240,
                                          height: CurrentDevice.isAndroid()
                                              ? 50.h
                                              : 62.h,
                                          decoration: BoxDecoration(
                                              color: textfieldClr,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                selectedDateText ?? '',
                                                style: GoogleFonts.roboto(
                                                    color: myColors.grey),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons.date_range_sharp,
                                                color: myColors.grey,
                                                size: 20,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Text(
                          'Scan your Driving License',
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'We’ll verify your identity',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: hintClr,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        PrivacyPolicyText(),
                        SizedBox(
                          height: 25.h,
                        ),
                        CustomMaterialButton(
                            label: 'Next',
                            buttonColor: myColors.green,
                            fontColor: Colors.white,
                            funcName: () {
                              //navigationToNextScreenById(selectedId);
                              //set ids item to use in next screen
                              if (form_key.currentState!.validate()) {
                                if (_idCon.text.trim().isNotEmpty &&
                                    selectedDateText != 'mm-dd-yyyy') {
                                  DateTime parsedDate =
                                      DateFormat('dd-MMMM-yyyy')
                                          .parse(selectedDate);
                                  // Format the date as 'YYYY-MM-DD'
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(parsedDate);

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DrivingLicenseSubmitScreen(
                                                  idNo: _idCon.text.trim(),
                                                  date: formattedDate)));
                                } else {
                                  DashboardHelpers.showAlert(
                                      msg: 'Please select Expiration date');
                                }
                              } else {
                                DashboardHelpers.showAlert(
                                    msg:
                                        'Please select ID No and Expiration date');
                              }
                            },
                            borderRadius: 8)
                      ],
                    ),
                  ),

                  // OptionBox(
                  //   funcName: () {
                  //     // context.push(MaterialPageRoute(
                  //     //           builder: (context) => TermsPhotoIdScreen(
                  //     //                 photoIdLabel: 'Driver’s License',
                  //     //               )));
                  //     context.pushNamed('terms', queryParameters: {
                  //       'photoIdLabel': 'Driver’s License',
                  //     });
                  //   },
                  //   label: 'Driver’s License',
                  // ),
                  // OptionBox(
                  //   funcName: () {
                  //     // context.push(MaterialPageRoute(
                  //     //           builder: (context) => TermsPhotoIdScreen(
                  //     //                 photoIdLabel: 'State ID',
                  //     //               )));
                  //     context.pushNamed('terms', queryParameters: {
                  //       'photoIdLabel': 'State ID',
                  //     });
                  //   },
                  //   label: 'State ID',
                  // ),
                  // OptionBox(
                  //   funcName: () {
                  //     // context.push(MaterialPageRoute(
                  //     //           builder: (context) => TermsPhotoIdScreen(
                  //     //                 photoIdLabel: 'Passport',
                  //     //               )));
                  //     context.pushNamed('terms', queryParameters: {
                  //       'photoIdLabel': 'Passport',
                  //     });
                  //   },
                  //   label: 'Passport',
                  // ),
                  // OptionBox(
                  //   funcName: () {
                  //     // context.push(MaterialPageRoute(
                  //     //           builder: (context) => TermsPhotoIdScreen(
                  //     //                 photoIdLabel: 'Passport',
                  //     //               )));
                  //     context.pushNamed('terms', queryParameters: {
                  //       'photoIdLabel': 'Passport',
                  //     });
                  //   },
                  //   label: 'Passport Card',
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
