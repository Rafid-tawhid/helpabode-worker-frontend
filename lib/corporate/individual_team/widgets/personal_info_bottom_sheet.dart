import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../../helper_functions/colors.dart';
import '../../../../../misc/constants.dart';
import '../../../../../models/user_model.dart';
import '../../../../../provider/user_provider.dart';
import '../../../../../widgets_reuse/custom_rounded_button.dart';
import '../../views/text_field.dart';

Future<dynamic> personalInformationModalBottomSheet(
    BuildContext context, UserModel user) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return PersonalInformationForm(user);
    },
  );
}

class PersonalInformationForm extends StatefulWidget {
  UserModel usermodel;

  PersonalInformationForm(this.usermodel);

  @override
  _PersonalInformationFormState createState() =>
      _PersonalInformationFormState();
}

class _PersonalInformationFormState extends State<PersonalInformationForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController fnameCon = TextEditingController();
  TextEditingController lnameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  String? role;
  String countryCodeText = 'US';
  String countryCodeNumber = '1';
  final TextEditingController phoneTextFormController = TextEditingController();
  RoundedLoadingButtonController controller = RoundedLoadingButtonController();

  @override
  void initState() {
    // TODO: implement initState
    fnameCon.text = widget.usermodel.firstName ?? '';
    lnameCon.text = widget.usermodel.lastName ?? '';
    emailCon.text = widget.usermodel.email ?? '';
    phoneTextFormController.text = widget.usermodel.phone ?? '';
    countryCodeText = widget.usermodel.countryCode ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Stack(
        children: [
          DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Enter Your Information',
                                        style: interText(
                                            18, Colors.black, FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 20,
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
                                                style:
                                                    text_16_black_600_TextStyle,
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              CustomTextFormField(
                                                hintText: 'Enter first Name',
                                                controller: fnameCon,
                                                fillColor: Colors.grey.shade50,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Enter first name';
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
                                                style:
                                                    text_16_black_600_TextStyle,
                                              ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              CustomTextFormField(
                                                hintText: 'Enter last Name',
                                                controller: lnameCon,
                                                fillColor: Colors.grey.shade50,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Enter last name';
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
                                                        searchTextStyle:
                                                            TextStyle(
                                                                color: Colors
                                                                    .black),
                                                        textStyle:
                                                            const TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .blueGrey),
                                                        bottomSheetHeight: 500,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  20.0),
                                                        ),
                                                        //Optional. Styles the search field.

                                                        inputDecoration:
                                                            InputDecoration(
                                                          fillColor:
                                                              Color(0xFFE9E9E9),
                                                          filled: true,
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          0),
                                                          hintText:
                                                              'Start typing to search',
                                                          // prefixIcon: const Icon(Icons.search),
                                                          prefixIcon: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 12,
                                                                    left: 10),
                                                            child:
                                                                GestureDetector(
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
                                                                  Icons
                                                                      .arrow_back,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 24,
                                                                ),
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40),
                                                            borderSide:
                                                                const BorderSide(
                                                              width: 1.5,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40),
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
                                                                    .circular(
                                                                        40),
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
                                                        setState(() {
                                                          countryCodeText =
                                                              country
                                                                  .countryCode;
                                                          countryCodeNumber =
                                                              country.phoneCode;
                                                        });
                                                      });
                                                },
                                                child: Container(
                                                  //height: double.maxFinite,
                                                  padding: EdgeInsets.fromLTRB(
                                                      12, 11, 12, 11),
                                                  // padding: EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
                                                  // padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                                                  //EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      FittedBox(
                                                        child: Text(
                                                          '+${countryCodeNumber} (${countryCodeText}) ',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                      Icon(
                                                        // fill: 1,
                                                        Icons
                                                            .keyboard_arrow_down,
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
                                                  fillColor:
                                                      Colors.grey.shade50,
                                                  textInputFormatter: [
                                                    LengthLimitingTextInputFormatter(
                                                        10)
                                                  ],
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.trim().isEmpty) {
                                                      return 'Phone number is required';
                                                    }
                                                    if (value.length != 10) {
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
                                        readOnly: true,
                                        fillColor: Colors.grey.shade50,
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
                                        height: 30,
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
                          // Add more content here
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
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
                      label: 'Save & Update',
                      buttonColor: myColors.green,
                      fontColor: Colors.white,
                      funcName: () async {
                        if (_formKey.currentState!.validate()) {
                          var data = {
                            "textId": textId,
                            "firstName": fnameCon.text.trim(),
                            "lastName": lnameCon.text.trim(),
                            "phone": phoneTextFormController.text.trim(),
                            "countryCode": countryCodeText,
                          };

                          FocusScope.of(context).unfocus();
                          controller.start();
                          await provider.updatePersonalInfo(
                              data, emailCon.text.trim());
                          controller.stop();
                          Navigator.pop(context);
                        }
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => PendingRegistrationProcess()));
                      },
                      borderRadius: 8,
                      controller: controller,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
