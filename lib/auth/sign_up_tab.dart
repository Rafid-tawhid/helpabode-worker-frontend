// ignore_for_file: prefer_const_constructors

import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:help_abode_worker_app_ver_2/auth/sign_in_tab.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/signup_api.dart';
import '../helper_functions/colors.dart';
import '../helper_functions/dashboard_helpers.dart';
import '../helper_functions/signin_signup_helpers.dart';
import '../misc/constants.dart';
import '../models/user_model.dart';
import '../provider/navbar_provider.dart';
import '../widgets_reuse/custom_rounded_button.dart';
import 'auth_providers.dart';
import 'custom_textfield_min.dart';

class SignUpTab extends StatefulWidget {
  const SignUpTab(this.widget, {super.key});

  final Widget widget;

  @override
  State<SignUpTab> createState() => _SignUpTabState();
}

class _SignUpTabState extends State<SignUpTab> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  MaskedTextController phoneNumber = MaskedTextController(mask: '000-000-0000');
  TextEditingController password = TextEditingController();
  FocusNode focusNodeFirstName = FocusNode();
  FocusNode focusNodeLastName = FocusNode();
  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodePhoneNumber = FocusNode();
  FocusNode focusNodePassword = FocusNode();
  bool empTypeSelect = true;

  RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  Future fetchData() async {}

  @override
  Widget build(BuildContext context) {
    var authProvider = context.watch<AuthProvider>();
    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipPath(
                clipper: CarvedContainerClipper(),
                child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 15.w, right: 15.w, top: 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 195.w,
                                          height: 45,
                                          color: Colors.white,
                                          child: Focus(
                                            onFocusChange: (val) {
                                              if (val == false &&
                                                  firstName.text.trim().isEmpty) {
                                                authProvider
                                                    .changeFieldEmpty(true);
                                              } else {
                                                authProvider
                                                    .changeFieldEmpty(false);
                                              }
                                            },
                                            child: CustomTextFieldMin(
                                              controller: firstName,
                                              focusNode: focusNodeFirstName,
                                              inputType: TextInputType.text,
                                              // fillColor: authProvider.isFieldEmpty
                                              //     ? AppColors.lightRed
                                              //     : AppColors.boxColor,
                                              borderRadius: 8,
                                              fontSize: 14,
                                              inputAction: TextInputAction.next,
                                              hintText: 'First Name',
                                              horizontalSize: 12,
                                              fillColor: authProvider.isFieldEmpty
                                                  ? AppColors
                                                      .invalidTextFieldColor
                                                  : Color(0xFFF6F6F6),
                                              focusBorderColor: Colors.black,
                                              focusBorderWidth: 1.5,
                                              isShowBorder:
                                                  authProvider.isFieldEmpty,
                                              enabledBorderWidth: 1,
                                              isErrorBox: true,
                                              enabledBorderColor: authProvider
                                                      .isFieldEmpty
                                                  ? AppColors
                                                      .invalidTextFieldBorderColor
                                                  : Colors.transparent,
                                              // isShowBorder:
                                              //     authProvider.isFieldEmpty,
                                              // enabledBorderWidth: 1,
                                              // isErrorBox: true,
                                              // enabledBorderColor:
                                              //     Colors.transparent,
                                              validation: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return authProvider
                                                      .changeLastName(true);
                                                }
                                                return authProvider
                                                    .changeLastName(false);
                                              },
                                              onFieldSubmitted: (value) {
                                                focusNodeFirstName.unfocus();
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        focusNodeLastName);
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        authProvider.isFieldEmpty
                                            ? Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 2,
                                                  ),
                                                  SvgPicture.asset(
                                                    "assets/svg/validation_icon.svg",
                                                    width: 12,
                                                  ),
                                                  const SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    "First name is required ",
                                                    style: interText(
                                                        12,
                                                        myColors.errRedTextColor,
                                                        FontWeight.w500),
                                                  )
                                                ],
                                              )
                                            : const SizedBox.shrink()
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 195.w,
                                          height: 45,
                                          decoration: BoxDecoration(
                                              color: authProvider.isLastName
                                                  ? AppColors.lightRed
                                                  : AppColors.boxColor,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Focus(
                                            onFocusChange: (val) {
                                              if (val == false &&
                                                  lastName.text.trim().isEmpty) {
                                                authProvider.changeLastName(true);
                                              } else {
                                                authProvider
                                                    .changeLastName(false);
                                              }
                                            },
                                            child: CustomTextFieldMin(
                                              controller: lastName,
                                              focusNode: focusNodeLastName,
                                              inputType: TextInputType.text,
                                              borderRadius: 8,
                                              fontSize: 14,
                                              inputAction: TextInputAction.next,
                                              hintText: 'Last Name',
                                              horizontalSize: 12,
                                              fillColor: authProvider.isLastName
                                                  ? AppColors
                                                      .invalidTextFieldColor
                                                  : Color(0xFFF6F6F6),
                                              focusBorderColor: Colors.black,
                                              focusBorderWidth: 1.5,
                                              isShowBorder:
                                                  authProvider.isLastName,
                                              enabledBorderWidth: 1,
                                              isErrorBox: true,
                                              enabledBorderColor:
                                                  authProvider.isLastName
                                                      ? AppColors
                                                          .invalidTextFieldBorderColor
                                                      : Colors.transparent,
                                              validation: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return authProvider
                                                      .changeLastName(true);
                                                }
                                                return authProvider
                                                    .changeLastName(false);
                                              },
                                              onFieldSubmitted: (value) {
                                                focusNodeLastName.unfocus();
                                                FocusScope.of(context)
                                                    .requestFocus(focusNodeEmail);
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        authProvider.isLastName
                                            ? Row(
                                                children: [
                                                  const SizedBox(width: 2),
                                                  SvgPicture.asset(
                                                    "assets/svg/validation_icon.svg",
                                                    width: 12,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "Last name is required ",
                                                    style: interText(
                                                        12,
                                                        myColors.errRedTextColor,
                                                        FontWeight.w500),
                                                  )
                                                ],
                                              )
                                            : const SizedBox.shrink()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15.w, right: 15.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Focus(
                                      onFocusChange: (val) {
                                        if (val == false &&
                                            email.text.isEmpty) {
                                          authProvider.changeEmail(true);
                                          authProvider.changeRongMail(false);
                                          authProvider.changeEmailCheck(false);
                                        } else {
                                          authProvider.changeEmail(false);
                                        }
                                        if (email.text.isNotEmpty) {
                                          if (RegExp(r"^[a-zA-Z0-9.a-zA-Z\d.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                  .hasMatch(email.text) ==
                                              false) {
                                            authProvider.changeRongMail(true);
                                          } else {
                                            authProvider.changeRongMail(false);
                                          }
                                          if (RegExp(r"^[a-zA-Z0-9.a-zA-Z\d.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                  .hasMatch(email.text) ==
                                              true) {
                                            authProvider.changeEmailCheck(true);
                                          } else {
                                            authProvider
                                                .changeEmailCheck(false);
                                          }
                                        } else {
                                          authProvider.changeRongMail(false);
                                          authProvider.changeEmailCheck(false);
                                        }
                                      },
                                      child: CustomTextFieldMin(
                                        controller: email,
                                        focusNode: focusNodeEmail,
                                        inputType: TextInputType.emailAddress,
                                        borderRadius: 8,
                                        fontSize: 14,
                                        inputAction: TextInputAction.next,
                                        hintText: 'Email Address',
                                        horizontalSize: 12,
                                        fillColor: (authProvider.isEmail ||
                                                    authProvider.rongMail) &&
                                                !focusNodeEmail.hasFocus
                                            ? AppColors.invalidTextFieldColor
                                            : Color(0xFFF6F6F6),
                                        focusBorderColor: Colors.black,
                                        focusBorderWidth: 1.5,
                                        isShowBorder: authProvider.isEmail ||
                                            authProvider.rongMail,
                                        enabledBorderWidth: 1,
                                        isErrorBox: true,
                                        enabledBorderColor:
                                            authProvider.isEmail ||
                                                    authProvider.rongMail
                                                ? AppColors
                                                    .invalidTextFieldBorderColor
                                                : Colors.transparent,
                                        validation: (value) {
                                          if (value == null || value.isEmpty) {
                                            authProvider
                                                .changeEmailCheck(false);
                                            return authProvider
                                                .changeEmail(true);
                                          } else if (RegExp(
                                                      r"^[a-zA-Z0-9.a-zA-Z\d.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                  .hasMatch(value) ==
                                              false) {
                                            return authProvider
                                                .changeEmail(false);
                                          }
                                          return null;
                                        },
                                        isShowSuffixWidget:
                                            !authProvider.rongMail &&
                                                email.text.isNotEmpty,
                                        suffixWidget: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 12,
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.green,
                                            size: 15,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          authProvider.setMailExist(false);
                                          authProvider.changeEmailCheck(false);
                                          if (RegExp(r"^[a-zA-Z0-9.a-zA-Z\d.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                  .hasMatch(email.text) ==
                                              false) {
                                            authProvider.changeRongMail(true);
                                          } else {
                                            authProvider.changeRongMail(false);
                                          }
                                          if (RegExp(r"^[a-zA-Z0-9.a-zA-Z\d.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                  .hasMatch(email.text) ==
                                              true) {
                                            authProvider.changeEmailCheck(true);
                                          } else {
                                            authProvider
                                                .changeEmailCheck(false);
                                          }
                                          return null;
                                        },
                                        onFieldSubmitted: (value) {
                                          focusNodeEmail.unfocus();
                                          FocusScope.of(context).requestFocus(
                                              focusNodePhoneNumber);
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  authProvider.isEmail &&
                                          !FocusScope.of(context).hasFocus
                                      ? Row(
                                          children: [
                                            const SizedBox(width: 2),
                                            SvgPicture.asset(
                                              "assets/svg/validation_icon.svg",
                                              width: 12,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "Email is required",
                                            ),
                                          ],
                                        )
                                      : authProvider.rongMail &&
                                              !FocusScope.of(context).hasFocus
                                          ? Row(
                                              children: [
                                                const SizedBox(width: 2),
                                                SvgPicture.asset(
                                                  "assets/svg/validation_icon.svg",
                                                  width: 12,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  "Invalid email",
                                                ),
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                            SizedBox(height: 6),
                            Padding(
                              padding: EdgeInsets.only(left: 15.w, right: 15.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          authProvider.pickupCountry(context);
                                        },
                                        child: Container(
                                            width: 105,
                                            height: 47,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: AppColors.boxColor,
                                              // border: Border.all(
                                              //     color: Colors.black, width: 1)
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    authProvider.code,
                                                  ),
                                                  const Spacer(),
                                                  const Icon(
                                                    Icons
                                                        .keyboard_arrow_down_outlined,
                                                    color: Colors.black,
                                                    size: 20,
                                                  )
                                                ],
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Container(
                                      //     // height: 45,
                                      //     width: double.infinity,
                                      //     color: Colors.red,
                                      //     child: Text('data')),
                                      Container(
                                        height: 45,
                                        width: 270,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: AppColors.boxColor,
                                        ),
                                        child: Focus(
                                          onFocusChange: (val) {
                                            if (val == false &&
                                                phoneNumber.text.isEmpty) {
                                              authProvider.checkPhone(false);
                                              authProvider.changePhone(true);
                                            } else {
                                              authProvider.changePhone(false);
                                            }

                                            if (phoneNumber.text.isNotEmpty) {
                                              if (phoneNumber.text.length !=
                                                  12) {
                                                authProvider
                                                    .checkPnNumbervalue(true);
                                              } else {
                                                authProvider
                                                    .checkPnNumbervalue(false);
                                              }
                                              if (phoneNumber.text.length ==
                                                  12) {
                                                authProvider.checkPhone(true);
                                              } else {
                                                authProvider.checkPhone(false);
                                              }
                                            }
                                          },
                                          child: CustomTextFieldMin(
                                            controller: phoneNumber,
                                            focusNode: focusNodePhoneNumber,
                                            inputType: TextInputType.number,
                                            borderRadius: 8,
                                            fontSize: 14,
                                            inputAction: TextInputAction.next,
                                            hintText: 'Phone Number',
                                            horizontalSize: 12,
                                            fillColor: !focusNodePhoneNumber
                                                        .hasFocus &&
                                                    (authProvider.isPhone ||
                                                        authProvider.pnNumber)
                                                ? AppColors
                                                    .invalidTextFieldColor
                                                : Color(0xFFF6F6F6),
                                            focusBorderColor: Colors.black,
                                            focusBorderWidth: 1.5,
                                            isShowBorder: !focusNodePhoneNumber
                                                        .hasFocus &&
                                                    authProvider.isPhone ||
                                                authProvider.pnNumber,
                                            enabledBorderWidth: 1,
                                            isErrorBox: true,
                                            enabledBorderColor: authProvider
                                                        .isPhone ||
                                                    authProvider.pnNumber
                                                ? AppColors
                                                    .invalidTextFieldBorderColor
                                                : Colors.transparent,
                                            isShowSuffixWidget:
                                                phoneNumber.text.length >= 12,
                                            suffixWidget: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 12,
                                              ),
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.green,
                                                size: 15,
                                              ),
                                            ),
                                            validation: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return authProvider
                                                    .changePhone(true);
                                              } else if (RegExp(
                                                          r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)')
                                                      .hasMatch(value) ==
                                                  false) {
                                                return authProvider
                                                    .changePhone(false);
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              authProvider.setPhoneExist(false);
                                              authProvider
                                                  .checkPnNumbervalue(false);
                                              authProvider.checkPhone(false);
                                              return null;
                                            },
                                            onFieldSubmitted: (value) {
                                              focusNodePhoneNumber.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      focusNodePassword);
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: authProvider.isPhone
                                  ? Row(
                                      children: [
                                        const SizedBox(width: 2),
                                        SvgPicture.asset(
                                          "assets/svg/validation_icon.svg",
                                          width: 12,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Phone number is required",
                                          style: interText(
                                              12,
                                              myColors.errRedTextColor,
                                              FontWeight.w500),
                                        )
                                      ],
                                    )
                                  : authProvider.pnNumber
                                      ? Row(
                                          children: [
                                            const SizedBox(width: 2),
                                            SvgPicture.asset(
                                              "assets/svg/validation_icon.svg",
                                              width: 12,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              "Phone number is invalid",
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                            ),
                            SizedBox(height: 6),
                            Padding(
                              padding: EdgeInsets.only(left: 15.w, right: 15.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                        color: AppColors.boxColor,
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Focus(
                                      onFocusChange: (val) {
                                        if ((val == false &&
                                                password.text.trim().isEmpty) ||
                                            password.text.length < 8) {
                                          authProvider.changePassword(true);
                                        } else {
                                          authProvider.changePassword(false);
                                        }
                                        if (password.text.isNotEmpty) {
                                          if (password.text.length < 8) {
                                            // ignore: void_checks
                                            return authProvider
                                                .changePassword(true);
                                          } else {
                                            authProvider.changePassword(false);
                                          }
                                        }
                                      },
                                      child: CustomTextFieldMin(
                                        controller: password,
                                        focusNode: focusNodePassword,
                                        inputType: TextInputType.text,
                                        // fillColor: authProvider.isPassword &&
                                        //         !focusNodePassword.hasFocus
                                        //     ? AppColors.lightRed
                                        //     : AppColors.boxColor,
                                        borderRadius: 8,
                                        fontSize: 14,
                                        inputAction: TextInputAction.next,
                                        hintText:
                                            'Password (At least 8 characters)',
                                        horizontalSize: 12,
                                        // isShowBorder: authProvider.isPassword &&
                                        //     !focusNodePassword.hasFocus,
                                        // enabledBorderWidth: 1,
                                        // isErrorBox: true,
                                        // enabledBorderColor: Colors.transparent,
                                        fillColor: Color(0xFFF6F6F6),
                                        focusBorderColor: Colors.black,
                                        focusBorderWidth: 1.5,
                                        // isShowBorder: authProvider.isPassword &&
                                        //     !focusNodePassword.hasFocus,
                                        enabledBorderWidth: 0,
                                        // isErrorBox: false,
                                        enabledBorderColor: Colors.transparent,
                                        isPassword: _obscureText,
                                        isShowSuffixWidget:
                                            password.text.isNotEmpty
                                                ? true
                                                : false,
                                        suffixWidget: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 16),
                                          child: SizedBox(
                                            width: 60,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  onTap: _toggle,
                                                  child: Text(
                                                    !_obscureText
                                                        ? 'Hide'
                                                        : 'Show',
                                                  ),
                                                  // child: Icon(
                                                  //     !_obscureText
                                                  // ? Icons.visibility_off
                                                  // : Icons.visibility,
                                                  // color: AppColors.grey,
                                                  // size: 23),
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                password.text.length >= 8
                                                    ? Icon(
                                                        Icons.check,
                                                        color: Colors.green,
                                                        size: 15,
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                          ),
                                        ),
                                        validation: (value) {
                                          if (value == null || value.isEmpty) {
                                            return authProvider
                                                .changePassword(true);
                                          } else if (value.length < 8) {
                                            return authProvider
                                                .changePassword(true);
                                          } else {
                                            authProvider.changePassword(false);
                                            return null;
                                          }
                                        },
                                        onChanged: (value) {
                                          authProvider
                                              .checkPnNumbervalue(false);
                                          authProvider.checkPhone(false);
                                          return null;
                                        },
                                        onFieldSubmitted: (value) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 13,
                                  ),
                                  (authProvider.isPassword &&
                                              !focusNodePassword.hasFocus) ||
                                          authProvider.mailExist ||
                                          authProvider.phoneExist
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Color(0xFFFFBDBD),
                                                ),
                                                child: Center(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Icon(
                                                        Icons.warning,
                                                        color: AppColors
                                                            .invalidTextFieldBorderColor,
                                                      ),
                                                      SizedBox(
                                                        width: 14,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          password.text
                                                                  .trim()
                                                                  .isEmpty
                                                              ? "Password is required"
                                                              : password.text
                                                                          .length <
                                                                      8
                                                                  ? 'Password must contain at least 8 characters'
                                                                  : authProvider
                                                                          .mailExist
                                                                      ? 'The email address you entered is already exist. Sign in to your account or enter a different email to create a new account.'
                                                                      : authProvider
                                                                              .phoneExist
                                                                          ? 'The phone number you entered is already exist. Sign in to your account or enter a different phone number to create a new account.'
                                                                          : 'invalid',
                                                          style: interText(
                                                              12,
                                                              Colors.black,
                                                              FontWeight.w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        empTypeSelect = !empTypeSelect;
                                      });
                                      debugPrint(
                                          'empTypeSelect ${empTypeSelect}');
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
                                                        BorderRadius.circular(
                                                            20),
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
                                                          BorderRadius.circular(
                                                              50)),
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
                                              'Individual service provider')
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

                                      debugPrint(
                                          'empTypeSelect ${empTypeSelect}');
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
                                                        BorderRadius.circular(
                                                            20),
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
                                                          BorderRadius.circular(
                                                              50)),
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
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 15.w, right: 15.w, top: 6, bottom: 10),
                              child: InkWell(
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate() &&
                                      !authProvider.isLoading) {
                                    validationCheck();
                                  }
                                },
                                child: CustomRoundedButton(
                                  buttonColor: buttonClr,
                                  fontColor: buttonFontClr,
                                  label: "Continue to Sign Up",
                                  borderRadius: 50.w,
                                  funcName: () async {
                                    if (_formKey.currentState!.validate()) {
                                      validationCheck();
                                    }
                                  },
                                  controller: _btnController,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  validationCheck() async {
    bool fNotValid = firstName.text.trim().isEmpty;
    bool lNotValid = lastName.text.trim().isEmpty;
    bool emailNotValid =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z\d.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(email.text) ==
            false;
    bool phoneNotValid =
        RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)')
                .hasMatch(phoneNumber.text) ==
            false;
    bool passNotValid = password.text.isEmpty || password.text.length < 8;
    var authProvider = context.read<AuthProvider>();

    if (fNotValid) {
      authProvider.changeFieldEmpty(true);
    } else if (lNotValid) {
      authProvider.changeLastName(true);
    } else if (emailNotValid) {
      authProvider.changeEmailCheck(true);
    } else if (phoneNotValid) {
      authProvider.checkPnNumbervalue(true);
    } else if (passNotValid) {
      authProvider.changePassword(true);
    } else {
      if (_formKey.currentState!.validate()) {
        authProvider.changeFieldEmpty(false);
        authProvider.changeLastName(false);
        authProvider.changeEmail(false);
        authProvider.changePhone(false);
        authProvider.changePassword(false);

        //save email for congratulations message
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("uid", email.text.trim());

        _btnController.start();
        var apiResponse = await signUpApi(
            firstName.text.trim(),
            lastName.text.trim(),
            email.text.trim(),
            phoneNumber.text.trim(),
            authProvider.code,
            password.text.trim(),
            empTypeSelect ? 'Individual' : 'Corporate',
            context);

        print('apiResponse ${apiResponse}');
        if (apiResponse != null) {
          if (apiResponse == '201') {
            //save user info
            DashboardHelpers.userModel = UserModel(
                firstName: firstName.text.trim(),
                lastName: lastName.text.trim(),
                email: email.text.trim(),
                phone: phoneNumber.text);
            DashboardHelpers.successStopAnimation(_btnController);
            print('STATUS ${status}');
            SignInSignUpHelpers.navigationAfterSignUp(context, status);

            //set tab to default

            var topTabControllerProvider =
                context.read<TabControllerProvider>();
            await topTabControllerProvider.loginTabControl(0);
          } else {
            DashboardHelpers.errorStopAnimation(_btnController);
          }
        } else {
          DashboardHelpers.errorStopAnimation(_btnController);
        }
      }
    }
  }

  TextStyle textFormFieldStyle = const TextStyle(color: Colors.black);

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
