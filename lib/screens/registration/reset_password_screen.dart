import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/api/reset_password_api.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_material_button.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_password_text_form_field.dart';
import 'package:hive/hive.dart';

import '../../widgets_reuse/reset_pass_sucess.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController newPasswordTextFormController =
      TextEditingController();
  final TextEditingController confirmNewPasswordTextFormController =
      TextEditingController();

  String newPasswordText = '';
  String confirmNewPasswordText = '';

  // final _formNewPasswordKey = GlobalKey<FormState>();
  // final _formConfirmPasswordKey = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();

  bool isVisible = false;
  bool isVisible2 = false;

  String emailSaved = '';

  bool isButtonLoading = false;

  var userBox;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userBox = Hive.box('registrationBox');
    emailSaved = userBox.get('forgotEmail');
    isButtonLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgClr,
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reset Your Password?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0, top: 6),
                    child: Text(
                      'Please enter your new password below to complete the process.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey5,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 35,
                    ),
                    Text(
                      "New Password",
                      style: textFieldLabelTextStyle,
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    CustomPasswordTextField(
                      height: 50,
                      width: 388.w,
                      borderRadius: 8.w,
                      fieldTextFieldController: newPasswordTextFormController,
                      keyboard: TextInputType.emailAddress,
                      funcOnChanged: (value) {
                        setState(() {
                          newPasswordText = value!;
                          print("onChange " + newPasswordText);
                        });
                      },
                      isVisible: isVisible,
                      funcVisible: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      funcValidate: (value, setErrorInfo) {
                        if (value == null || value.isEmpty) {
                          setErrorInfo(true, 'Password is required');

                          // focusNodePassword.requestFocus();
                          return '';
                        } else if (value.length < 8) {
                          setErrorInfo(
                              true, 'Password must be at least 8 character');
                          return '';
                        }
                        return null;
                      },
                      hintText: 'New Password',
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    Text(
                      "Confirm New Password",
                      style: textFieldLabelTextStyle,
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    CustomPasswordTextField(
                      height: 50,
                      width: 388.w,
                      borderRadius: 8.w,
                      fieldTextFieldController:
                          confirmNewPasswordTextFormController,
                      keyboard: TextInputType.emailAddress,
                      funcOnChanged: (value) {
                        setState(() {
                          confirmNewPasswordText = value!;
                          print("onChange " + confirmNewPasswordText);
                        });
                      },
                      funcValidate: (value, setErrorInfo) {
                        if (value == null || value.isEmpty) {
                          setErrorInfo(true, 'Password is required');

                          // focusNodePassword.requestFocus();
                          return '';
                        } else if (value != newPasswordText) {
                          setErrorInfo(true, 'These two fields don’t match');
                          return '';
                        }
                        return null;
                      },
                      isVisible: isVisible2,
                      funcVisible: () {
                        setState(() {
                          isVisible2 = !isVisible2;
                        });
                      },
                      hintText: 'Confirm New Password',
                    ),
                    const SizedBox(
                      height: 31,
                    ),
                    CustomMaterialButton(
                      isLoading: isButtonLoading,
                      buttonColor: buttonClr,
                      fontColor: buttonFontClr,
                      label: "Reset Password",
                      borderRadius: 50.w,
                      funcName: () async {
                        if (_formKey5.currentState!.validate()) {
                          setState(() {
                            isButtonLoading = true;
                          });
                          if (await resetPasswordApi(
                                  emailSaved, confirmNewPasswordText) ==
                              true) {
                            setState(() {
                              isButtonLoading = false;
                            });
                            userBox.delete('token');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ResetPasswordSuccess()));
                          } else {
                            setState(() {
                              isButtonLoading = false;
                            });
                            print("Error");
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
