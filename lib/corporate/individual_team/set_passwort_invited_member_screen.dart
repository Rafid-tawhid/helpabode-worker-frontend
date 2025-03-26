import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/user_helpers.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../helper_functions/colors.dart';
import '../../../../misc/constants.dart';
import '../../../../models/user_model.dart';
import '../../../../provider/user_provider.dart';
import '../../../../widgets_reuse/custom_rounded_button.dart';
import '../views/text_field.dart';

class SetPasswortInvitedMemberScreen extends StatefulWidget {
  const SetPasswortInvitedMemberScreen({super.key});

  @override
  State<SetPasswortInvitedMemberScreen> createState() =>
      _SetPasswortInvitedMemberScreenState();
}

class _SetPasswortInvitedMemberScreenState
    extends State<SetPasswortInvitedMemberScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController fnameCon = TextEditingController();

  TextEditingController lnameCon = TextEditingController();

  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  TextEditingController confirmPassCon = TextEditingController();
  bool showPass = true;
  bool showConPass = true;

  String? role;

  String countryCodeText = '';

  String countryCodeNumber = '';

  FocusNode focusNodePhone = FocusNode();

  final TextEditingController phoneTextFormController = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  var isCheckPhone = null;

  String phoneText = '';

  UserModel? userModel;

  @override
  void initState() {
    userModel = DashboardHelpers.userModel;

    fnameCon.text = userModel!.firstName ?? '';
    lnameCon.text = userModel!.lastName ?? '';
    emailCon.text = userModel!.email ?? '';
    phoneTextFormController.text = userModel!.phone ?? '';
    countryCodeText = userModel!.countryCode ?? '';
    countryCodeNumber = '1';
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    fnameCon.dispose();
    lnameCon.dispose();
    emailCon.dispose();
    phoneTextFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8),
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
                      flex: 4,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Consumer<UserProvider>(
                      builder: (context, provider, _) => Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'General Information',
                                    style: interText(
                                        24, Colors.black, FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Enter the details of each team member to add them to your team.',
                                    style: interText(
                                        14, myColors.greyTxt, FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  if (UserHelpers.empType ==
                                      UserHelpers.empTypeCorporate)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Designation :',
                                            style: interText(18, Colors.black,
                                                FontWeight.bold),
                                          ),
                                          Text(
                                            ' ${userModel!.employeeType}',
                                            style: interText(16, Colors.black,
                                                FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'First Name',
                                            style: text_16_black_600_TextStyle,
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          CustomTextFormField(
                                            hintText: 'Enter first Name',
                                            controller: fnameCon,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your name';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      )),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Last Name',
                                            style: text_16_black_600_TextStyle,
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          CustomTextFormField(
                                            hintText: 'Enter last Name',
                                            controller: lnameCon,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your name';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    'Phone Number',
                                    style: text_16_black_600_TextStyle,
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              //show picker
                                              showCountryPicker(
                                                  context: context,
                                                  countryListTheme:
                                                      CountryListThemeData(
                                                    flagSize: 20,

                                                    backgroundColor:
                                                        Colors.white,
                                                    searchTextStyle: TextStyle(
                                                        color: Colors.black),
                                                    textStyle: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.blueGrey),
                                                    bottomSheetHeight: 500,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20.0),
                                                      topRight:
                                                          Radius.circular(20.0),
                                                    ),
                                                    //Optional. Styles the search field.

                                                    inputDecoration:
                                                        InputDecoration(
                                                      fillColor:
                                                          Color(0xFFE9E9E9),
                                                      filled: true,
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 0),
                                                      hintText:
                                                          'Start typing to search',
                                                      // prefixIcon: const Icon(Icons.search),
                                                      prefixIcon: Container(
                                                        margin: EdgeInsets.only(
                                                            right: 12,
                                                            left: 10),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            // Handle icon click here
                                                            print(
                                                                'Icon clicked');
                                                          },
                                                          child:
                                                              const CircleAvatar(
                                                            radius: 16,
                                                            child: Icon(
                                                              Icons.arrow_back,
                                                              color:
                                                                  Colors.black,
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
                                                            BorderRadius
                                                                .circular(40),
                                                        borderSide:
                                                            const BorderSide(
                                                          width: 1.5,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                        ),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors
                                                              .transparent,
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
                                              padding: EdgeInsets.fromLTRB(
                                                  12, 12, 12, 12),
                                              // padding: EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
                                              // padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                                              //EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: textfieldClr,
                                                  width: 2,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomTextFormField(
                                              hintText: 'Phone Number',
                                              controller:
                                                  phoneTextFormController,
                                              keyboardType:
                                                  TextInputType.number,
                                              textInputFormatter: [
                                                LengthLimitingTextInputFormatter(
                                                    10)
                                              ],
                                              // funcOnChanged: (value) {
                                              //   setState(() {
                                              //     phoneText = value!;
                                              //     if (RegExp(r"^[0-9]{10}$").hasMatch(value)) {
                                              //       isCheckPhone = true;
                                              //       // _formPhoneKey.currentState!.validate();
                                              //     } else {
                                              //       isCheckPhone = null;
                                              //     }
                                              //     //_formPhoneKey.currentState!.validate();
                                              //     print("onChange " + phoneText);
                                              //   });
                                              // },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  //setErrorInfo(true, 'Phone number is required');
                                                  //focusNodePhone.requestFocus();
                                                  return 'Phone number is required';
                                                }
                                                if (value.length != 10) {
                                                  // setErrorInfo(true, 'Please provide a valid number');
                                                  //focusNodePhone.requestFocus();
                                                  return 'Please provide a valid number';
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    'Member Email',
                                    style: text_16_black_600_TextStyle,
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  CustomTextFormField(
                                    hintText: 'Enter member email',
                                    controller: emailCon,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      } else if (!RegExp(r"\S+@\S+\.\S+")
                                          .hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    'Password',
                                    style: text_16_black_600_TextStyle,
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  CustomTextFormField(
                                    hintText: 'Password',
                                    controller: passCon,
                                    obscureText: showPass,
                                    suffixIcon: showPass
                                        ? IconButton(
                                            onPressed: () {
                                              setState(() {
                                                showPass = !showPass;
                                              });
                                            },
                                            icon: Icon(Icons.visibility))
                                        : IconButton(
                                            onPressed: () {
                                              setState(() {
                                                showPass = !showPass;
                                              });
                                            },
                                            icon: Icon(Icons.visibility_off)),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter password';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    'Confirm Password',
                                    style: text_16_black_600_TextStyle,
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  CustomTextFormField(
                                    hintText: 'Confirm Password',
                                    controller: confirmPassCon,
                                    obscureText: showConPass,
                                    suffixIcon: showConPass
                                        ? IconButton(
                                            onPressed: () {
                                              setState(() {
                                                showConPass = !showConPass;
                                              });
                                            },
                                            icon: Icon(Icons.visibility))
                                        : IconButton(
                                            onPressed: () {
                                              setState(() {
                                                showConPass = !showConPass;
                                              });
                                            },
                                            icon: Icon(Icons.visibility_off)),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter password';
                                      } else if (value != passCon.text.trim()) {
                                        return 'password doesn\'t matched';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 80,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  // border: Border(top: BorderSide(color: AppColors.grey)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0C000000),
                      blurRadius: 8,
                      offset: Offset(0, -4),
                      spreadRadius: 0,
                    )
                  ]),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Consumer<UserProvider>(
                    builder: (context, provider, _) => CustomRoundedButton(
                      height: 44,
                      label: 'Submit',
                      buttonColor: myColors.green,
                      fontColor: Colors.white,
                      funcName: () async {
                        if (_formKey.currentState!.validate()) {
                          var data = {
                            "firstName": fnameCon.text.trim(),
                            "lastName": lnameCon.text.trim(),
                            "email": emailCon.text.trim(),
                            "phone": phoneTextFormController.text.trim(),
                            "countryCode": countryCodeText,
                            "password": passCon.text.trim(),
                            "textId": textId
                          };

                          debugPrint('SEND DATA ${data}');
                          FocusScope.of(context).unfocus();
                          _btnController.start();

                          if (await provider
                              .submitPendingMemberDetailsInfo(data)) {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => SelectIdCardTypeScreen(
                            //               from: 'corporate',
                            //             )));
                            context.pushNamed(
                              'mail',
                              pathParameters: {
                                'workerTextId': '${userBox.get('textId')}',
                                'workerStatus': '${userBox.get('status')}',
                              },
                            );

                            debugPrint('HELLO ${userBox.get('textId')}');
                            debugPrint('HELLO ${userBox.get('status')}');
                          }
                          _btnController.stop();
                          //  Navigator.pop(context);
                        }
                      },
                      borderRadius: 8,
                      controller: _btnController,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
