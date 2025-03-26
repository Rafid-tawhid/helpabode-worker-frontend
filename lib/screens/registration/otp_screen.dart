import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_material_button.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_snackbar_message.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/message_registration.dart';
import 'package:http/http.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper_functions/signin_signup_helpers.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({required this.emailText});

  String emailText;

  @override
  State<OTPScreen> createState() => _OTPScreenState(emailSaved: emailText);
}

class _OTPScreenState extends State<OTPScreen> {
  _OTPScreenState({required this.emailSaved});

  final TextEditingController otpTextFormController = TextEditingController();

  String emailSaved;

  String otpText = '';

  AnimationController? localAnimationController;

  bool isButtonLoading = false;
  bool isLoading = false;
  static const int initialTime = 2 * 60; // 3 minutes in seconds
  int remainingTime = initialTime;
  Timer? _timer;
  String _userName = '';

  //var userBox;

  Future<String> resendOtpData() async {
    try {
      print("try");

      print("before post");

      var data = {
        "email": "${emailSaved}",
      };
      var body = jsonEncode(data);

      Response response = await post(
        Uri.parse("${urlBase}api/workerResendOtpCode"),
        body: body,
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        var responseDecodeJson = jsonDecode(response.body);
        print('Response Json : ${responseDecodeJson}');
        print(responseDecodeJson);
        showCustomSnackBar(
          context,
          responseDecodeJson['message'],
          buttonClr,
          snackBarNeutralTextStyle,
          localAnimationController,
        );
        return '200';
      } else {
        var responseDecodeJson = jsonDecode(response.body);
        // showCustomSnackBar(
        //   context,
        //   responseDecodeJson['message'],
        //   Colors.red,
        //   snackBarNeutralTextStyle,
        //   localAnimationController,
        // );
        return '404';
      }
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'Something Went Wrong');
      print("catch");
      print(e);
      return '500';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(emailSaved);
    // userBox = Hive.box('registrationBox');
    // userBox.get('forgotEmail');
    isButtonLoading = false;
    isLoading = false;
    startTimer();
    getName();
    Provider.of<UserProvider>(context, listen: false).setErrorMsg(false);
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        _timer?.cancel();
        setState(() {});
      }
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgClr,
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MessageRegistration(),
              Consumer<UserProvider>(
                builder: (context, provider, _) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 24,
                      ),
                      AutoSizeText(
                        'Please enter the 6-digit code we sent to you at ${emailSaved}. This code will expire in 30 mins.',
                        style: textField_14_black_500_LabelTextStyle,
                        maxLines: 3,
                      ),
                      SizedBox(
                        height: 42,
                      ),
                      SizedBox(
                        height: 50,
                        child: Pinput(
                          controller: otpTextFormController,
                          length: 6,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          onChanged: (value) {
                            setState(() {
                              otpText = value;
                              print(value);
                            });
                            provider.setPinPutBg(false);
                          },
                          focusedPinTheme: PinTheme(
                            height: 50.h,
                            width: 50.h,
                            textStyle: textField_14_black_500_LabelTextStyle,
                            decoration: BoxDecoration(
                              color: textfieldClr,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: Colors
                                      .black), // Border color when focused
                            ),
                          ),
                          defaultPinTheme: PinTheme(
                            height: 50.h,
                            width: 50.h,
                            textStyle: textField_14_black_500_LabelTextStyle,
                            decoration: BoxDecoration(
                              color: provider.showErrorMsg
                                  ? Color(0xFFFFF1F1)
                                  : textfieldClr,
                              border: Border.all(
                                  color: provider.showErrorMsg
                                      ? Color(0xffC40606)
                                      : Colors.transparent),
                              // Change color based on error state
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onCompleted: (value) async {
                            setState(() {
                              isButtonLoading = true;
                            });

                            bool res =
                                await provider.sendOTPApi(emailSaved, otpText);
                            if (res) {
                              // showCustomSnackBar(
                              //   context,
                              //   'OTP Matched Successfully',
                              //   myColors.green,
                              //   snackBarNeutralTextStyle,
                              //   localAnimationController,
                              // );

                              context.pushNamed('reset');
                            }
                            setState(() {
                              isButtonLoading = false;
                            });
                          },
                        ),
                      ),
                      if (provider.showErrorMsg)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info,
                              color: Color(0xffC40606),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                provider.errorMsgText,
                                style: interText(
                                    12, Color(0xffC40606), FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                      SizedBox(
                        height: 26,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Didn’t get it? ',
                                    style: interText(
                                        14, Colors.black, FontWeight.w600),
                                  ),
                                  isLoading == true
                                      ? SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: myColors.greyTxt,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () async {
                                            if (remainingTime <= 0) {
                                              otpTextFormController.clear();
                                              setState(() {
                                                isLoading = true;
                                              });
                                              if (await resendOtpData() ==
                                                  '200') {
                                                setState(() {
                                                  remainingTime = 120;
                                                  startTimer();
                                                });
                                              }
                                              isLoading = false;
                                              setState(() {});
                                            }
                                          },
                                          child: Text('Resend code',
                                              style: interText(
                                                  14,
                                                  remainingTime > 0
                                                      ? myColors.greyTxt
                                                      : myColors.green,
                                                  FontWeight.w600))),
                                ],
                              ),
                            ],
                          ),
                          remainingTime > 0
                              ? Text(formatTime(remainingTime),
                                  style: interText(
                                      14, Colors.red, FontWeight.w500))
                              : Text('',
                                  style: interText(
                                      14, myColors.greyTxt, FontWeight.w500)),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      if (_userName != '')
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Not $_userName? ',
                              style:
                                  interText(14, Colors.black, FontWeight.w600),
                              children: [
                                TextSpan(
                                  text: 'Switch Account',
                                  style: GoogleFonts.inter(
                                    decoration: TextDecoration.underline,
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            print(_userName);
                          },
                          child: Text(
                            'Switch Account',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 16.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 31,
                      ),
                      CustomMaterialButton(
                        isLoading: isButtonLoading,
                        buttonColor: buttonClr,
                        fontColor: buttonFontClr,
                        label: "Verify OTP",
                        borderRadius: 50.w,
                        funcName: () async {
                          print('SUBMIT');
                          setState(() {
                            isButtonLoading = true;
                          });

                          bool res =
                              await provider.sendOTPApi(emailSaved, otpText);
                          // if (res) {
                          //   showCustomSnackBar(
                          //     context,
                          //     'OTP Matched Successfully',
                          //     myColors.green,
                          //     snackBarNeutralTextStyle,
                          //     localAnimationController,
                          //   );
                          //
                          //   context.pushNamed('reset');
                          // }
                          setState(() {
                            isButtonLoading = false;
                          });
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.pushNamed('home');
                            },
                            child: Text(
                              "Use password instead",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Color(0XFF008951),
                                fontSize: CurrentDevice.isAndroid() ? 16 : 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var name = await pref.getString("f_name") ?? '';
    setState(() {
      _userName = name;
    });
  }
}
