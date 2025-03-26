import 'package:country_picker/country_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/user_helpers.dart';
import 'package:help_abode_worker_app_ver_2/provider/corporate_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../../helper_functions/colors.dart';
import '../../../../misc/constants.dart';
import '../../../../models/corporate_roles_model.dart';
import '../views/text_field.dart';

class AddTeamMembersDashboard extends StatefulWidget {
  const AddTeamMembersDashboard({super.key});

  @override
  State<AddTeamMembersDashboard> createState() =>
      _AddTeamMembersDashboardState();
}

class _AddTeamMembersDashboardState extends State<AddTeamMembersDashboard> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController fnameCon = TextEditingController();
  TextEditingController lnameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  CorporateRolesModel? role;
  String countryCodeText = '';
  String countryCodeNumber = '';
  FocusNode focusNodePhone = FocusNode();
  final TextEditingController phoneTextFormController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  var isCheckPhone = null;
  String phoneText = '';

  @override
  void initState() {
    countryCodeText = 'US';
    countryCodeNumber = '1';
    var cp = context.read<CorporateProvider>();
    role = cp.affiliationList.first;
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
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    var cp = context.read<CorporateProvider>();
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
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
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Add team member',
                                    style: interText(
                                        26, Colors.black, FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    'Enter the details of each team member to add them to your team.',
                                    style: interText(16, myColors.greyTxt,
                                            FontWeight.w400)
                                        .copyWith(letterSpacing: 0),
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'First Name',
                                            style: interText(16, Colors.black,
                                                FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          CustomTextFormField(
                                            hintText: 'Enter first Name',
                                            hintStyle: interText(
                                                14,
                                                Color(0xff535151),
                                                FontWeight.w400),
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
                                            style: interText(16, Colors.black,
                                                FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          CustomTextFormField(
                                            hintText: 'Enter last Name',
                                            hintStyle: interText(
                                                14,
                                                Color(0xff535151),
                                                FontWeight.w400),
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
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    'Member Email',
                                    style: interText(
                                        16, Colors.black, FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  CustomTextFormField(
                                    hintText: 'Enter member email',
                                    hintStyle: interText(
                                        14, Color(0xff535151), FontWeight.w400),
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
                                    'Phone Number',
                                    style: interText(
                                        16, Colors.black, FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 4,
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
                                                    textStyle: TextStyle(
                                                        fontSize: 16,
                                                        color: myColors.green),
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
                                              hintStyle: interText(
                                                  14,
                                                  Color(0xff535151),
                                                  FontWeight.w400),
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
                                  if (UserHelpers.empType ==
                                      UserHelpers.empTypeCorporate)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Member Role',
                                          style: text_16_black_600_TextStyle,
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton2<
                                              CorporateRolesModel>(
                                            isExpanded: true,
                                            hint: Text(
                                              'Select Role',
                                              style: TextStyle(
                                                color: myColors.greyTxt,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            items: cp.affiliationList.map(
                                                (CorporateRolesModel role) {
                                              return DropdownMenuItem<
                                                  CorporateRolesModel>(
                                                value: role,
                                                child: Text(
                                                  role.title ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              );
                                            }).toList(),
                                            value: role,
                                            onChanged: (value) async {
                                              setState(() {
                                                role = value;
                                              });
                                              print(
                                                  "Selected Role ID: ${role?.title}");
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              height: 58.h,
                                              padding: const EdgeInsets.only(
                                                  left: 0, right: 14),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.white,
                                              ),
                                              elevation: 0,
                                            ),
                                            iconStyleData: const IconStyleData(
                                              icon: Icon(
                                                Icons.keyboard_arrow_down,
                                              ),
                                              iconEnabledColor: Colors.black,
                                              iconDisabledColor: Colors.grey,
                                            ),
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              maxHeight: 300,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: textfieldClr,
                                              ),
                                              offset: const Offset(0, 0),
                                              scrollbarTheme:
                                                  ScrollbarThemeData(
                                                radius:
                                                    const Radius.circular(40),
                                                thickness:
                                                    WidgetStateProperty.all(6),
                                                thumbVisibility:
                                                    WidgetStateProperty.all(
                                                        true),
                                              ),
                                            ),
                                            menuItemStyleData:
                                                MenuItemStyleData(
                                              height: 40,
                                              padding: EdgeInsets.only(
                                                  left: 14, right: 14),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                      ],
                                    )
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
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
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
                      label: 'Add Member',
                      buttonColor: myColors.green,
                      fontColor: Colors.white,
                      funcName: () async {
                        debugPrint(
                            '_formKey.currentState!.validate() ${_formKey.currentState!.validate()}');
                        if (_formKey.currentState!.validate()) {
                          var data = {
                            "firstName": fnameCon.text.trim(),
                            "designationTextId": role!.title,
                            "lastName": lnameCon.text.trim(),
                            "email": emailCon.text.trim(),
                            "phone": phoneTextFormController.text.trim(),
                            "countryCode": countryCodeText
                          };

                          FocusScope.of(context).unfocus();
                          _btnController.start();
                          if (await provider.addNewMemberToIndividual(
                              data, null)) {
                            Navigator.pop(context);
                          }
                          _btnController.stop();
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
