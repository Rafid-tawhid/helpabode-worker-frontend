import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:help_abode_worker_app_ver_2/api/verify_email_api.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_material_button.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_snackbar_message.dart';
import 'package:hive/hive.dart';

import '../../helper_functions/signin_signup_helpers.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailTextFormController = TextEditingController();

  final _formEmailKey = GlobalKey<FormState>();
  FocusNode focusNodeEmail = FocusNode();

  String emailText = '';

  var userBox;

  bool isButtonLoading = false;
  bool showSuffix = false;

  AnimationController? localAnimationController;

  validateFocusNode(FocusNode focusNode, GlobalKey<FormState> formKey) {
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        formKey.currentState!.validate();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userBox = Hive.box('registrationBox');
    validateFocusNode(focusNodeEmail, _formEmailKey);
    isButtonLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    var mqSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgClr,
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Forgot Password?',
                    style: textField_24_black_600_LabelTextStyle,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  const Text(
                    "Please specify your email address to receive instructions for resetting it. If an account exists with that email, we will send a password reset.",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0XFF535151)),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Email",
                    style: textFieldLabelTextStyle,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Form(
                    key: _formEmailKey,
                    child: Container(
                      width: 388.w,
                      child: TextFormField(
                        //autofocus: true,

                        scrollPadding: EdgeInsets.only(bottom: 40.h),
                        textInputAction: TextInputAction.next,
                        controller: emailTextFormController,
                        keyboardType: TextInputType.emailAddress,

                        // inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) {
                          setState(() {
                            emailText = value;
                            showSuffix = true;
                            //_formEmailKey.currentState!.validate();
                            print("onChange " + emailText);
                          });
                        },
                        style: textFieldContentTextStyle,
                        //onSubmitted: funcOnSubmitted,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Required';
                          } else if (!RegExp(r"\S+@\S+\.\S+").hasMatch(value)) {
                            return 'Enter Valid Email';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          // contentPadding: EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
                          contentPadding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                          // contentPadding: isValid == null ? null : EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
                          filled: true,
                          fillColor: textfieldClr,

                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: fontClr,
                            fontSize: 16.sp,
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.w),
                            borderSide: BorderSide(
                              color: textfieldClr,
                              width: 0.1,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.w),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.w),
                            borderSide: const BorderSide(
                              color: Colors.redAccent,
                              width: 1,
                            ),
                          ),
                          suffixIcon: (showSuffix)
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      emailTextFormController.text = '';
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: SvgPicture.asset(
                                      'assets/svg/close.svg',
                                      height: 16,
                                      width: 16,
                                    ),
                                  ))
                              : null,
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.w),
                            borderSide: const BorderSide(
                              color: Colors.redAccent,
                              width: 1,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.w),
                            borderSide: BorderSide(
                              color: textfieldClr,
                              width: 0.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  CustomMaterialButton(
                    isLoading: isButtonLoading,
                    buttonColor: buttonClr,
                    fontColor: buttonFontClr,
                    label: "Reset Password",
                    borderRadius: 50.w,
                    funcName: () async {
                      setState(() {});
                      _formEmailKey.currentState!.validate();

                      print('Email is ------ ${emailText}');

                      if (_formEmailKey.currentState!.validate()) {
                        isButtonLoading = true;
                        setState(() {});

                        if (await verifyEmailApi(emailText) == '200') {
                          isButtonLoading = false;
                          setState(() {});
                          print('Email is ------ ${emailText}');
                          await userBox.put('forgotEmail', emailText);

                          // showCustomSnackBar(
                          //   context,
                          //   'Please Check Your Email For OTP',
                          //   buttonClr,
                          //   snackBarNeutralTextStyle,
                          //   localAnimationController,
                          // );
                          context.pushNamed(
                            'otp',
                            queryParameters: {
                              'emailText': emailText,
                            },
                          );
                        } else if (await verifyEmailApi(emailText) == '404') {
                          isButtonLoading = false;
                          setState(() {});
                          print("Error");
                          showCustomSnackBar(
                            context,
                            'Enter Existing Email',
                            Colors.red,
                            snackBarNeutralTextStyle,
                            localAnimationController,
                          );
                        } else {
                          isButtonLoading = false;
                          setState(() {});
                          print("Error");
                          showCustomSnackBar(
                              context,
                              'Server Not Found',
                              Colors.red,
                              snackBarNeutralTextStyle,
                              localAnimationController);
                        }
                      } else {
                        print("Inside else");
                      }
                      emailTextFormController.clear();
                    },
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  MaterialButton(
                    elevation: 0,

                    onPressed: () {
                      Navigator.pop(context);
                    },
                    //padding: isLoading == true ? EdgeInsets.fromLTRB(0, 10, 0, 10) : EdgeInsets.fromLTRB(52.w, 13.w, 52.w, 13.w),
                    color: Color(0XFFE9E9E9),
                    minWidth: 388.w,
                    height: CurrentDevice.isAndroid() ? 48 : 54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    // padding: EdgeInsets.fromLTRB(52.w, 13.w, 52.w, 13.w),
                    child: Text('Back to Sign In',
                        style: interText(CurrentDevice.isAndroid() ? 18 : 20,
                            Colors.black, FontWeight.w500)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
