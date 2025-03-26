import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/signin_signup_helpers.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/user_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/select_photos_of_id_screen_new.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_appbar.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_material_button.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/new_text_formfield.dart';
import 'package:intl/intl.dart';

import '../../widgets_reuse/in_app_webview.dart';

class SelectIdCardTypeScreen extends StatefulWidget {
  static const String routeName = 'select_photo_id';

  String? from;
  bool? hasPreviousData;
  String? cardNo;
  String? prevDate;
  String? cardType;

  SelectIdCardTypeScreen(
      {this.from,
      this.hasPreviousData,
      this.cardNo,
      this.prevDate,
      this.cardType});

  @override
  State<SelectIdCardTypeScreen> createState() => _SelectIdCardTypeScreenState();
}

class _SelectIdCardTypeScreenState extends State<SelectIdCardTypeScreen> {
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
  String selectedDateText = 'MM-DD-YYYY';
  final _idCon = TextEditingController();
  final form_key = GlobalKey<FormState>();

  @override
  void dispose() {
    _idCon.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.hasPreviousData == true) {
      showBody = true;
      selectedId = idLists.contains(widget.cardType)
          ? widget.cardType
          : 'Driver’s License';
      _idCon.text = widget.cardNo ?? '';
      //convert date

      // Format the date as 'YYYY-MM-DD'parsedDate

      selectedDateText = DashboardHelpers.formmatDate2(widget.prevDate ?? '');
      selectedDateTime = DateFormat('yyyy-MM-dd')
          .parse(DashboardHelpers.formmatDate2(widget.prevDate ?? ''));
      selectedDate = DashboardHelpers.formatDate3(widget.prevDate ?? '');
    }
    debugPrint('CARD NO: ${widget.cardNo}');
    debugPrint('DATE: ${widget.prevDate}');
    debugPrint('TYPE: ${widget.cardType}');
    debugPrint('selectedId: ${selectedId}');
    debugPrint('FORMAT DATE: ${selectedDate}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(label: ''),
            Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                color: Colors.white,
                height: 2,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: myColors.green,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                      ),
                      flex: UserHelpers.empType == 'Corporate' ? 2 : 4,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
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
                    'We require a photo of a government-issued ID to verify your identity..',
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
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                    child: DropdownButton2<String>(
                      value: widget.hasPreviousData == true
                          ? idLists.contains(widget.cardType)
                              ? widget.cardType
                              : selectedId
                          : selectedId,
                      iconStyleData: selectedId == null
                          ? IconStyleData(
                              icon: Icon(Icons.keyboard_arrow_down_sharp))
                          : IconStyleData(
                              icon: Icon(Icons.keyboard_arrow_up_sharp)),
                      isExpanded: true,
                      underline: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                      hint: Text(
                        'Choose ID',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: fontClr,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        offset: Offset(0, -10),
                        // Move the dropdown menu 10 pixels down
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        elevation: 2,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          showBody = true;
                          selectedId = newValue ?? 'Driver’s License';
                        });
                        print(newValue);
                      },
                      items: idLists.toSet().toList().map(
                        (String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  if (selectedId != null)
                    Form(
                      key: form_key,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 6,
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
                                        hintText: 'A1234567',
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
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1, horizontal: 12),
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
                                              locale:
                                                  DateTimePickerLocale.en_us,
                                              looping: true,
                                            );
                                            if (selectedDateTime != null) {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());

                                              setState(() {
                                                selectedDate =
                                                    SignInSignUpHelpers
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
                            'Scan your ${selectedId}',
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
                              label: 'Save & Scan Your ID',
                              buttonColor: myColors.green,
                              fontColor: Colors.white,
                              funcName: () {
                                //navigationToNextScreenById(selectedId);

                                //set ids item to use in next screen
                                if (form_key.currentState!.validate()) {
                                  if (_idCon.text.trim().isNotEmpty &&
                                      selectedDateText != 'MM-DD-YYYY') {
                                    debugPrint('NOTHING ${selectedDate}');

                                    DateTime parsedDate =
                                        DateFormat('dd-MMMM-yyyy')
                                            .parse(selectedDate);
                                    // Format the date as 'YYYY-MM-DD'
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(parsedDate);

                                    if (widget.from != null) {
                                      DashboardHelpers.setIdInformation(
                                          selectedId!.trim(),
                                          _idCon.text.trim(),
                                          formattedDate.trim());
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SelectPhotoIdScreenNew(
                                                    form: 'corporate',
                                                  )));
                                    } else {
                                      //set data to get from other screen
                                      DashboardHelpers.setIdInformation(
                                          selectedId!.trim(),
                                          _idCon.text.trim(),
                                          formattedDate.trim());
                                      //add service instruction
                                      context.pushNamed(
                                          SelectPhotoIdScreenNew.routeName);
                                    }
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigationToNextScreenById(String? selectId) {
    switch (selectId) {
      case 'Driving License':
        // context.pushNamed('terms', queryParameters: {
        //   'photoIdLabel': 'Driver’s License',
        // });

        context.pushNamed(SelectPhotoIdScreenNew.routeName, queryParameters: {
          'level': selectedId,
        });

        break;

      case 'State ID':
        context.pushNamed(SelectPhotoIdScreenNew.routeName, queryParameters: {
          'level': selectedId,
        });
        break;

      case 'Passport':
        context.pushNamed(SelectPhotoIdScreenNew.routeName, queryParameters: {
          'level': selectedId,
        });
        break;

      case 'Passport Card':
        context.pushNamed(SelectPhotoIdScreenNew.routeName, queryParameters: {
          'level': selectedId,
        });
        break;

      default:
        context.pushNamed(SelectPhotoIdScreenNew.routeName, queryParameters: {
          'level': 'Driver’s License',
        });

      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => PhotoIdScreen(
      //           isFrontTemp: true,
      //           photoIdLabel: selectedId,
      //         )));
    }
  }
}

class PrivacyPolicyText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: hintClr,
          ),
          text:
              'By continuing, you agree that your biometric data will be collected and stored by Help Abode or its vendors for purposes of identity verification. Your data will be permanently deleted from the system after it is no longer necessary.',
          children: [
            TextSpan(
              text: ' For more information, please see our Privacy Policy',
              style: TextStyle(color: myColors.green),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Replace with your method to open URL
                  //DashboardHelpers.openUrl('https://helpabode.com/privacy-policy.html');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WebViewExample(
                                conditionsUrl:
                                    'https://helpabode.com/privacy-policy.html',
                                title: 'Privacy & Policies',
                              )));
                },
            ),
          ],
        ),
      ),
    );
  }
}
