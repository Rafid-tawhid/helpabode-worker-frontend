import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/user_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/screens/explore/explore_screen.dart';

import 'package:help_abode_worker_app_ver_2/screens/registration/select_categories_screen.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_rounded_button.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_text_form_field.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../corporate/individual_team/review_team_members_submitted_documents.dart';
import '../../provider/user_provider.dart';

class SSNIdScreen2 extends StatefulWidget {
  SSNIdScreen2({
    this.workerTextId,
    this.workerStatus,
  });

  String? workerTextId;
  String? workerStatus;

  @override
  State<SSNIdScreen2> createState() => _SSNIdScreen2State();
}

class _SSNIdScreen2State extends State<SSNIdScreen2> {
  final TextEditingController ssnTextFormController = TextEditingController();
  String ssnText = '';
  final _formSSNKey = GlobalKey<FormState>();
  FocusNode focusNodeSSN = FocusNode();
  var isCheckSSN = null;
  final RoundedLoadingButtonController controller =
      RoundedLoadingButtonController();

  String workerName = '';
  // String workerTextId = '';

  var isButtonLoading = false;

  bool isLoading = false;

  Future getWorkerIdentityData() async {
    try {
      print("try");

      print(token);

      var header = {
        "Authorization": "Bearer ${token}",
      };

      print(header);

      Response response = await get(
        Uri.parse(
            "${urlBase}api/CheckWorkerForSSNUpdate/${widget.workerTextId}/${widget.workerStatus}"),
        headers: header,
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        var responseDecodeJson = jsonDecode(response.body);
        print('Response Json');

        print(responseDecodeJson);
        print('Returning Response Json');
        setState(() {
          // serviceList = responseDecodeJson['worker_data'];

          workerName = responseDecodeJson['worker_data'][0]['workerName'];

          // print(customizedCityList);

          // customizedCityList[0]['isPercent'] == false ? print('false') : print('true');
          //print(customizedCityList[0]['city_amount']);
          // print(jsonDecode(customizedCityList[0]['priceVariationJson']));
          //print(jsonDecode(customizedCityList[0]['priceVariationJson']));

          //print(serviceList);
        });
      }
    } catch (e) {
      print("catch");
      print(e);
    }
  }

  Future postSSNData() async {
    try {
      print("try");

      print("before post");

      print('#######_______INSIDE POST_______########');

      var header = {
        "Authorization": "Bearer ${token}",
      };

      print(header);

      var data = {
        "workerTextId": "${textId}",
        "workerStatus": "SSN Required",
        "ssnData": ssnTextFormController.text.replaceAll('-', '').trim(),
      };
      var body = jsonEncode(data);

      print(body);

      Response response = await post(
        Uri.parse("${urlBase}api/WorkerSSNUpdate"),
        body: body,
        headers: header,
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        var responseDecodeJson = jsonDecode(response.body);
        print('Response Json');
        print(responseDecodeJson);
        print(responseDecodeJson['worker_status']['status']);
        await userBox.put(
            'status', '${responseDecodeJson['worker_status']['status']}');
        widget.workerStatus = responseDecodeJson['worker_status']['status'];
        print(widget.workerStatus);
        print('Returning Response Json');
        SharedPreferences pref = await SharedPreferences.getInstance();
        var empType = pref.getString("employeeType");
        var workerDesignationTextId = pref.getString("workerDesignationTextId");
        if (empType == "Under Provider" ||
            empType == UserHelpers.empTypeCorporateMember) {
          UserProvider provider =
              Provider.of<UserProvider>(context, listen: false);
          if (await provider.getWorkerProfileDetailsData(textId)) {
            debugPrint('empType ${empType}');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ReviewTeamMembersSubmittedDocuments()));
          }
        } else if (empType == 'Corporate Member' &&
            workerDesignationTextId != "") {
          debugPrint('empType ${empType}');
          debugPrint('workerDesignationTextId ${workerDesignationTextId}');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExploreScreenDashboard()));
        } else {
          var empType = pref.getString("workerDesignationTextId");
          debugPrint('designationTextId ${empType}');
          context.pushReplacementNamed(SelectServicesScreen.routeName);
        }

        //context.pushNamed(PendingRegistrationProcess.routeName);

        return true;
      } else if (response.statusCode == 406) {
        print('Inside 406');
        return false;
      }
    } catch (e) {
      print("catch");
      print(e);
      return false;
    }
  }

  funcGetWorkerData() async {
    setState(() {
      isLoading = true;
    });

    await getWorkerIdentityData();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //funcGetWorkerData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: bgClr,
        body: SafeArea(
          child: Column(
            children: [
              // const CustomAppBar(label: ''),
              SizedBox(
                height: 80,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      'Welcome (${capitalize(DashboardHelpers.userModel!.firstName ?? '')})',
                      style: interText(28, Colors.black, FontWeight.w700),
                    ),
                    SizedBox(
                      height: 36,
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'SSN ',
                        style: interText(16, Colors.black, FontWeight.w600),
                        children: [
                          TextSpan(
                            text: '(Your Social Security Number)',
                            style:
                                interText(16, Colors.black87, FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 13.h,
                    ),
                    CustomTextField(
                      width: 388,
                      borderRadius: 8,
                      formKey: _formSSNKey,
                      focusNode: focusNodeSSN,
                      fieldTextFieldController: ssnTextFormController,
                      keyboard: TextInputType.number,
                      isCheck: isCheckSSN,
                      inputFormat: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(11),
                        CustomHyphenInputFormatter(),
                        FilteringTextInputFormatter.allow(RegExp(r'^[0-9-]+$')),
                      ],
                      funcOnChanged: (value) {
                        // setState(() {
                        //   ssnText = value!;
                        //   if (RegExp(r"^(?!666|000|9\d{2})\d{3}(?!00)\d{2}(?!0{4})\d{4}$").hasMatch(value!)) {
                        //     isCheckSSN = true;
                        //     _formSSNKey.currentState!.validate();
                        //   } else {
                        //     isCheckSSN = null;
                        //   }
                        //   //_formEmailKey.currentState!.validate();
                        //   print("onChange " + ssnText);
                        // });
                      },
                      funcValidate: (value) {
                        if (value!.trim().isEmpty) {
                          return 'SSN is Required';
                        } else if (!RegExp(
                                r"^(?!666|000|9\d{2})\d{3}(?!00)\d{2}(?!0{4})\d{4}$")
                            .hasMatch(value)) {
                          return 'Invalid SSN format. Please enter a valid SSN';
                        } else if (value.length < 9) {
                          return 'SSN must be 9 characters';
                        } else {
                          return null;
                        }
                      },
                      hintText: 'Enter SSN',
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      'To continue, please enter your Social Security Number',
                      style: interText(16, Colors.black, FontWeight.w400),
                    ),
                    SizedBox(
                      height: 36,
                    ),
                    CustomRoundedButton(
                      isLoading: isButtonLoading,
                      label: 'Submit Application',
                      buttonColor: buttonClr,
                      fontColor: buttonFontClr,
                      funcName: () async {
                        if (_formSSNKey.currentState!.validate()) {
                          controller.start();
                          await postSSNData();

                          // UserProvider provider = Provider.of<UserProvider>(context, listen: false);
                          // if (await provider.getWorkerProfileDetailsData(textId)) {
                          //   Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewTeamMembersSubmittedDocuments()));
                          // }

                          DashboardHelpers.successStopAnimation(controller);
                        } else {
                          print('SSN Failed');
                        }
                      },
                      borderRadius: 50,
                      controller: controller,
                    ),
                    SizedBox(
                      height: 36,
                    ),
                  ],
                ),
              )
              // isLoading == true
              //     ? Expanded(
              //         child: Center(
              //           child: CircularProgressIndicator(
              //             color: buttonClr,
              //             strokeWidth: 10,
              //           ),
              //         ),
              //       )
              //     : workerName != ''
              //         ? Container(
              //             margin: EdgeInsets.symmetric(horizontal: 20.w),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 SizedBox(
              //                   height: 25.h,
              //                 ),
              //                 Text(
              //                   'Welcome ${workerName}',
              //                   style: textField_30_black_600,
              //                 ),
              //                 SizedBox(
              //                   height: 35.h,
              //                 ),
              //                 RichText(
              //                   text: TextSpan(
              //                     text: 'SSN ',
              //                     style: text_20_black_600_TextStyle,
              //                     children: [
              //                       TextSpan(
              //                         text: '(Your Social Security Number)',
              //                         style: textField_16_TabTextStyle,
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   height: 13.h,
              //                 ),
              //                 CustomTextField(
              //                   width: 388.w,
              //                   borderRadius: 8.w,
              //                   formKey: _formSSNKey,
              //                   focusNode: focusNodeSSN,
              //                   fieldTextFieldController: ssnTextFormController,
              //                   keyboard: TextInputType.emailAddress,
              //                   isCheck: isCheckSSN,
              //                   inputFormat: <TextInputFormatter>[
              //                     FilteringTextInputFormatter.digitsOnly,
              //                     LengthLimitingTextInputFormatter(9),
              //                   ],
              //                   funcOnChanged: (value) {
              //                     setState(() {
              //                       ssnText = value!;
              //                       if (RegExp(r"^(?!666|000|9\d{2})\d{3}(?!00)\d{2}(?!0{4})\d{4}$").hasMatch(value!)) {
              //                         isCheckSSN = true;
              //                         _formSSNKey.currentState!.validate();
              //                       } else {
              //                         isCheckSSN = null;
              //                       }
              //                       //_formEmailKey.currentState!.validate();
              //                       print("onChange " + ssnText);
              //                     });
              //                   },
              //                   funcValidate: (value) {
              //                     if (value!.isEmpty) {
              //                       return 'Required';
              //                     } else if (!RegExp(r"^(?!666|000|9\d{2})\d{3}(?!00)\d{2}(?!0{4})\d{4}$").hasMatch(value!)) {
              //                       return 'Enter Valid SSN';
              //                     } else {
              //                       return null;
              //                     }
              //                   },
              //                   hintText: 'Enter SSN',
              //                 ),
              //                 SizedBox(
              //                   height: 27.h,
              //                 ),
              //                 Text(
              //                   'To continue enter your Social Security Number',
              //                   style: text_16_black_400_TextStyle,
              //                 ),
              //                 SizedBox(
              //                   height: 35.h,
              //                 ),
              //                 CustomMaterialButton(
              //                   isLoading: isButtonLoading,
              //                   label: 'Next',
              //                   buttonColor: buttonClr,
              //                   fontColor: buttonFontClr,
              //                   funcName: () async {
              //                     setState(() {});
              //                     _formSSNKey.currentState!.validate();
              //
              //                     if (_formSSNKey.currentState!.validate()) {
              //                       // Navigator.pushNamed(
              //                       //   context,
              //                       //   '/mail/?name=hello&id=10',
              //                       // );
              //
              //                       print('Inside if');
              //                       setState(() {
              //                         isButtonLoading = true;
              //                       });
              //
              //                       if (await postSSNData()) {
              //                         setState(() {
              //                           isButtonLoading = false;
              //                         });
              //                         print('SSN Success');
              //                       } else {
              //                         setState(() {
              //                           isButtonLoading = false;
              //                         });
              //                         print('SSN Failed');
              //                       }
              //                     } else {
              //                       print('SSN Failed');
              //                     }
              //                   },
              //                   borderRadius: 50.w,
              //                 ),
              //                 SizedBox(
              //                   height: 35.h,
              //                 ),
              //                 // CustomMaterialButton(
              //                 //   label: 'Exit',
              //                 //   buttonColor: buttonClr,
              //                 //   fontColor: buttonFontClr,
              //                 //   funcName: () {
              //                 //     // Navigator.of(context).pop();
              //                 //     // window.close();
              //                 //     // SystemNavigator.pop();
              //                 //     // widget.browser.close();
              //                 //     // Navigator.pop(context);
              //                 //     LaunchReview.launch(
              //                 //       androidAppId: "com.wempro.helpAbodeWorkerApp",
              //                 //       iOSAppId: "com.wempro.helpAbodeWorkerApp",
              //                 //     );
              //                 //   },
              //                 //   borderRadius: 50.w,
              //                 // ),
              //               ],
              //             ),
              //           )
              //         : Container(
              //             margin: EdgeInsets.symmetric(horizontal: 20.w),
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //               children: [
              //                 const Text(
              //                   'Invalid Worker Credentials. Please Try Again',
              //                   style: TextStyle(
              //                     fontSize: 20,
              //                   ),
              //                 ),
              //                 CustomMaterialButton(
              //                   label: 'Go Back',
              //                   buttonColor: buttonClr,
              //                   fontColor: buttonFontClr,
              //                   funcName: () {},
              //                   borderRadius: 50.w,
              //                 ),
              //               ],
              //             ),
              //           ),
            ],
          ),
        ),
      ),
    );
  }

  String capitalize(String s) {
    if (s.isEmpty) {
      return s;
    }
    return s[0].toUpperCase() + s.substring(1);
  }
}

class CustomHyphenInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text =
        newValue.text.replaceAll('-', ''); // Remove any existing dashes
    final selectionIndex = newValue.selection.end;

    final StringBuffer newTextBuffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 3 || i == 6) {
        // Insert a dash after 3rd and 6th character
        newTextBuffer.write('-');
      }
      newTextBuffer.write(text[i]);
    }

    final newText = newTextBuffer.toString();

    // Adjust the cursor position
    int cursorPosition = selectionIndex;
    if (oldValue.text.length > newValue.text.length) {
      // Backspace case
      if (selectionIndex > 0 && newText[selectionIndex - 1] == '-') {
        cursorPosition -= 1; // Move cursor before the dash
      }
    } else {
      // Adding text case
      if (selectionIndex > 0 &&
          newText.length > selectionIndex &&
          newText[selectionIndex - 1] == '-') {
        cursorPosition += 1; // Move cursor after the dash
      }
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

// class CustomHyphenInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
//     final text = newValue.text;
//     final selectionIndex = newValue.selection.end;
//
//     if (text.length == 4 || text.length == 7) {
//       // Check if the user is adding a character
//       if (oldValue.text.length < newValue.text.length) {
//         final newText = '${text.substring(0, text.length - 1)}-${text.substring(text.length - 1)}';
//         return TextEditingValue(
//           text: newText,
//           selection: TextSelection.collapsed(offset: selectionIndex + 1),
//         );
//       } else {
//         // User is deleting a character
//         final newText = text.replaceAll('-', '');
//         return TextEditingValue(
//           text: newText,
//           selection: TextSelection.collapsed(offset: selectionIndex - 1),
//         );
//       }
//     }
//     return newValue;
//   }
// }
