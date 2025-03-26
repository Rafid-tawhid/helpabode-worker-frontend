import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_abode_worker_app_ver_2/api/signup_api.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/models/user_model.dart';

import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_password_text_form_field.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_rounded_button.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helper_functions/dashboard_helpers.dart';
import '../../helper_functions/signin_signup_helpers.dart';
import '../../misc/constants.dart';
import '../../widgets_reuse/new_text_formfield.dart';

class SignUpScreen3 extends StatefulWidget {
  const SignUpScreen3({Key? key}) : super(key: key);

  @override
  State<SignUpScreen3> createState() => _SignUpScreen3State();
}

class _SignUpScreen3State extends State<SignUpScreen3> {
  final TextEditingController firstNameTextFormController =
      TextEditingController();
  final TextEditingController lastNameTextFormController =
      TextEditingController();
  final TextEditingController emailTextFormController = TextEditingController();
  final TextEditingController countryCodeTextFormController =
      TextEditingController();
  final TextEditingController phoneTextFormController = TextEditingController();
  final TextEditingController passwordTextFormController =
      TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  String firstNameText = '';
  String lastNameText = '';
  String emailText = '';
  String countryCodeText = '';
  String countryCodeNumber = '';
  String phoneText = '';
  String passwordText = '';
  String empType = 'Individual service provider';
  bool empTypeSelect = true;
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNodeFirstName = FocusNode();
  FocusNode focusNodeLastName = FocusNode();
  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodePhone = FocusNode();
  FocusNode focusNodePassword = FocusNode();

  final GlobalKey<FormState> focusNodeFirstNameKey = GlobalKey<FormState>();

  bool isVisible = false;
  var isCheckEmail = null;
  var isCheckPhone = null;
  var isCheckPassword = null;

  bool isButtonLoading = false;
  bool showPassFieldError = false;
  String passBoxErrorText = 'Password is required';

  Color? fillColor;
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    firstNameTextFormController.dispose();
    lastNameTextFormController.dispose();
    emailTextFormController.dispose();
    countryCodeTextFormController.dispose();
    phoneTextFormController.dispose();
    passwordTextFormController.dispose();
    focusNodeFirstName.dispose();
    focusNodeLastName.dispose();
    focusNodeEmail.dispose();
    focusNodePhone.dispose();
    focusNodePassword.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isButtonLoading = false;
    countryCodeText = 'US';
    countryCodeNumber = '1';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: DashboardHelpers.isKeyboardOpen(context)
                      ? null
                      : MediaQuery.sizeOf(context).height / 2.1,
                  child: Column(
                    children: [
                      if (DashboardHelpers.isKeyboardOpen(context)) Text(''),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          children: [
                            // SizedBox(
                            //   height: DashboardHelpers.isKeyboardOpen(context) ? 10.h : 20.h,
                            // ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    NewCustomTextField(
                                      width: 186.w,
                                      height: 44,
                                      borderRadius: 8.w,
                                      formKey: focusNodeFirstNameKey,
                                      focusNode: focusNodeFirstName,
                                      fieldTextFieldController:
                                          firstNameTextFormController,
                                      hintText: "First Name",
                                      keyboard: TextInputType.text,
                                      inputFormat: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(12),
                                      ],
                                      funcOnChanged: (value) {
                                        setState(() {
                                          firstNameText = value!;
                                          //_formFirstNameKey.currentState!.validate();

                                          print("onChange " + firstNameText);
                                        });
                                      },
                                      funcValidate: (value, setErrorInfo) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          setErrorInfo(
                                              true, 'First name is required');
                                          //focusNodeFirstName.requestFocus();
                                          return '';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    NewCustomTextField(
                                      width: 186.w,
                                      height: 44,
                                      borderRadius: 8.w,
                                      focusNode: focusNodeLastName,
                                      fieldTextFieldController:
                                          lastNameTextFormController,
                                      hintText: "Last Name",
                                      inputFormat: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(12),
                                      ],
                                      funcOnChanged: (value) {
                                        setState(() {
                                          lastNameText = value!;
                                          //_formLastNameKey.currentState!.validate();
                                          print("onChange " + lastNameText);
                                        });
                                      },
                                      funcValidate: (value, setErrorInfo) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          setErrorInfo(
                                              true, 'Last name is required');

                                          //focusNodeLastName.requestFocus();
                                          return '';
                                        }

                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            NewCustomTextField(
                              width: 388.w,
                              height: 44,
                              borderRadius: 8.w,
                              keyboard: TextInputType.emailAddress,
                              inputFormat: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(50),
                              ],
                              // formKey: _formEmailKey,
                              focusNode: focusNodeEmail,
                              isCheck: isCheckEmail,
                              funcOnChanged: (value) {
                                setState(() {
                                  emailText = value!;
                                  if (RegExp(r"\S+@\S+\.\S+").hasMatch(value)) {
                                    isCheckEmail = true;
                                  } else {
                                    isCheckEmail = null;
                                  }
                                  //_formEmailKey.currentState!.validate();
                                  print("onChange " + emailText);
                                });
                              },
                              funcValidate: (value, setErrorInfo) {
                                if (value == null || value.trim().isEmpty) {
                                  setErrorInfo(true, 'Email is required');

                                  //focusNodeEmail.requestFocus();
                                  return '';
                                } else if (!RegExp(r"\S+@\S+\.\S+")
                                    .hasMatch(value)) {
                                  setErrorInfo(true, 'Enter Valid Email');
                                  focusNodeEmail.requestFocus();
                                  return 'Enter Valid Email';
                                }
                                return null;
                              },
                              hintText: 'Email',
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        //show picker
                                        showCountryPicker(
                                            context: context,
                                            countryListTheme:
                                                CountryListThemeData(
                                              flagSize: 20,

                                              backgroundColor: Colors.white,
                                              searchTextStyle: TextStyle(
                                                  color: Colors.black),
                                              textStyle: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.blueGrey),
                                              bottomSheetHeight: 500,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(20.0),
                                                topRight: Radius.circular(20.0),
                                              ),
                                              //Optional. Styles the search field.

                                              inputDecoration: InputDecoration(
                                                fillColor: Color(0xFFE9E9E9),
                                                filled: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 0),
                                                hintText:
                                                    'Start typing to search',
                                                // prefixIcon: const Icon(Icons.search),
                                                prefixIcon: Container(
                                                  margin: EdgeInsets.only(
                                                      right: 12, left: 10),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      // Handle icon click here
                                                      print('Icon clicked');
                                                    },
                                                    child: const CircleAvatar(
                                                      radius: 16,
                                                      child: Icon(
                                                        Icons.arrow_back,
                                                        color: Colors.black,
                                                        size: 24,
                                                      ),
                                                      backgroundColor:
                                                          Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  borderSide: const BorderSide(
                                                    width: 1.5,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  borderSide: const BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  borderSide: const BorderSide(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onSelect: (
                                              Country country,
                                            ) {
                                              countryCodeText =
                                                  country.countryCode;
                                              countryCodeNumber =
                                                  country.phoneCode;
                                              print(country.countryCode);
                                              setState(() {});
                                            });
                                      },
                                      child: Container(
                                        //height: double.maxFinite,
                                        padding:
                                            EdgeInsets.fromLTRB(12, 11, 12, 11),
                                        // padding: EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
                                        // padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                                        //EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
                                        decoration: BoxDecoration(
                                          color: textfieldClr,
                                          borderRadius:
                                              BorderRadius.circular(8.w),
                                          border: Border.all(
                                            color: textfieldClr,
                                            width: 2,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            FittedBox(
                                              child: Text(
                                                '+${countryCodeNumber} (${countryCodeText}) ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              // fill: 1,
                                              Icons.keyboard_arrow_down,
                                              color: Colors.black,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        child: NewCustomTextField(
                                          borderRadius: 8.w,
                                          inputFormat: <TextInputFormatter>[
                                            DashNumberFormatter()
                                            // LengthLimitingTextInputFormatter(12),
                                            // CustomSpaceInputFormatter(),
                                          ],
                                          focusNode: focusNodePhone,
                                          fieldTextFieldController:
                                              phoneTextFormController,
                                          keyboard: TextInputType.number,
                                          hintText: "Phone Number",
                                          isCheck: isCheckPhone,
                                          funcOnChanged: (value) {
                                            setState(() {
                                              phoneText = value!;
                                              if (RegExp(r"^[0-9]{10}$")
                                                  .hasMatch(value)) {
                                                isCheckPhone = true;
                                                // _formPhoneKey.currentState!.validate();
                                              } else {
                                                isCheckPhone = null;
                                              }
                                              //_formPhoneKey.currentState!.validate();
                                              print("onChange " + phoneText);
                                            });
                                          },
                                          funcValidate: (value, setErrorInfo) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              setErrorInfo(true,
                                                  'Phone number is required');
                                              //focusNodePhone.requestFocus();
                                              return '';
                                            }
                                            if (value.length != 12) {
                                              setErrorInfo(true,
                                                  'Please provide a valid number');
                                              //focusNodePhone.requestFocus();
                                              return '';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            CustomPasswordTextField(
                              width: 388.w,
                              height: 44,
                              borderRadius: 8.w,
                              // formKey: _formPasswordKey,
                              focusNode: focusNodePassword,
                              fieldTextFieldController:
                                  passwordTextFormController,
                              keyboard: TextInputType.text,
                              isCheck: isCheckPassword,
                              isVisible: isVisible,
                              funcVisible: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              funcOnChanged: (value) {
                                setState(() {
                                  showPassFieldError = false;
                                });

                                if (value!.length >= 8) {
                                  setState(() {
                                    isCheckPassword = true;
                                    fillColor = null;
                                  });
                                } else {
                                  setState(() {
                                    isCheckPassword = null;
                                    fillColor = null;
                                  });
                                }
                                passwordText = value;

                                //_formPasswordKey.currentState!.validate();
                                print("onChange " + passwordText);
                              },
                              funcValidate: (value, setErrorInfo) {
                                if (value == null || value.trim().isEmpty) {
                                  setState(() {
                                    showPassFieldError = true;
                                    passBoxErrorText = 'Password is required';
                                  });
                                  return '';
                                } else if (value.length < 8) {
                                  setState(() {
                                    showPassFieldError = true;
                                    passBoxErrorText =
                                        'Password must contain at least 8 characters';
                                  });
                                  return '';
                                }
                                return null;
                              },

                              hintText: 'Password (At least 8 characters)',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  empTypeSelect = !empTypeSelect;
                                });
                                debugPrint('empTypeSelect ${empTypeSelect}');
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: empTypeSelect
                                      ? const Color(0xffDEF0E8)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3.0),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: myColors.green,
                                                  width: 1.5),
                                            ),
                                            height: 24,
                                            width: 24,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: empTypeSelect
                                                    ? myColors.green
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            height: 14,
                                            width: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text('Individual service provider')
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  empTypeSelect = !empTypeSelect;
                                });

                                debugPrint('empTypeSelect ${empTypeSelect}');
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: empTypeSelect
                                      ? Colors.white
                                      : const Color(0xffDEF0E8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3.0),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: myColors.green,
                                                  width: 1.5),
                                            ),
                                            height: 24,
                                            width: 24,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: empTypeSelect
                                                    ? Colors.white
                                                    : myColors.green,
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            height: 14,
                                            width: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                        'Corporation Officer/Representative')
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            if (showPassFieldError)
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: myColors.errorRed,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      SvgPicture.asset(
                                          'assets/svg/error_icon.svg'),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Flexible(
                                          child: Text(
                                        passBoxErrorText,
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500),
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                CustomRoundedButton(
                  controller: _btnController,
                  isLoading: isButtonLoading,
                  buttonColor: buttonClr,
                  fontColor: buttonFontClr,
                  label: "Sign Up",
                  borderRadius: 50.w,
                  funcName: () async {
                    FocusScope.of(context).unfocus();
                    firstNameText.trim();
                    lastNameText.trim();
                    emailText.trim();
                    final phone = phoneText.replaceAll("-", "").trim();
                    countryCodeText.trim();
                    passwordText.trim();
                    firstNameText.trimLeft();
                    lastNameText.trimLeft();
                    emailText.trimLeft();
                    phoneText.trimLeft();
                    countryCodeText.trimLeft();
                    passwordText.trimLeft();

                    if (_formKey.currentState!.validate()) {
                      //save email for congratulations message
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.setString("uid", emailText.trim());

                      _btnController.start();
                      var apiResponse = await signUpApi(
                          firstNameText,
                          lastNameText,
                          emailText,
                          phone,
                          countryCodeText,
                          passwordText,
                          empTypeSelect ? 'Individual' : 'Corporate',
                          context);

                      print('apiResponse ${apiResponse}');
                      if (apiResponse != null) {
                        if (apiResponse == '201') {
                          ////save user info
                          DashboardHelpers.userModel = UserModel(
                              firstName:
                                  firstNameTextFormController.text.trim(),
                              lastName: lastNameTextFormController.text.trim(),
                              email: emailTextFormController.text.trim());
                          DashboardHelpers.successStopAnimation(_btnController);

                          print('STATUS ${status}');
                          SignInSignUpHelpers.navigationAfterSignUp(
                              context, status);
                        } else {
                          DashboardHelpers.errorStopAnimation(_btnController);
                        }
                      } else {
                        DashboardHelpers.errorStopAnimation(_btnController);
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    final selectionIndex = newValue.selection.end;

    if (text.length == 4 || text.length == 8) {
      // Check if the user is adding a character
      if (oldValue.text.length < newValue.text.length) {
        final newText =
            '${text.substring(0, text.length - 1)}-${text.substring(text.length - 1)}';
        return TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: selectionIndex + 1),
        );
      } else {
        // User is deleting a character
        final newText = text.replaceAll(' ', '');
        return TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: selectionIndex - 1),
        );
      }
    }
    return newValue;
  }
}

class DashNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = newValue.text
        .replaceAll(RegExp(r'[^0-9]'), ''); // Remove non-digit characters

    // Truncate if digits exceed 10 (12 characters total with dashes)
    final truncated =
        digitsOnly.length > 10 ? digitsOnly.substring(0, 10) : digitsOnly;

    final buffer = StringBuffer();

    for (int i = 0; i < truncated.length; i++) {
      if (i == 3 || i == 7) {
        // Dash after 3rd and 7th digits
        buffer.write('-');
      }
      buffer.write(truncated[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
