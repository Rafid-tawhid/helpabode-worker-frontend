import 'package:country_picker/country_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/corporate/views/text_field.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/provider/corporate_provider.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../../../custom_packages/extensions/custom_material_button.dart';
import '../../../helper_functions/colors.dart';
import '../../../misc/constants.dart';
import '../../../models/corporate_roles_model.dart';
import '../screens/registration/select_idcard_type_screen.dart';

class Employee {
  final String name;
  final String designation;
  final String department;

  Employee(
      {required this.name,
      required this.designation,
      required this.department});
}

class TeamMemberDetails extends StatefulWidget {
  const TeamMemberDetails({super.key});

  @override
  State<TeamMemberDetails> createState() => _TeamMemberDetailsState();
}

class _TeamMemberDetailsState extends State<TeamMemberDetails> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameCon = TextEditingController();
  TextEditingController lastnameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();
  CorporateRolesModel? role;
  List<Employee> nameList = [];
  String countryCodeText = 'US';
  String countryCodeNumber = '1';
  RoundedLoadingButtonController _controller = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: SafeArea(
        child: Consumer<CorporateProvider>(
          builder: (context, provider, _) => Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back))
                ],
              ),
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Team member details',
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
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
                                              hintText: 'Enter name',
                                              controller: nameCon,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Name required';
                                                }
                                                return null;
                                              },
                                            ),
                                          ],
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
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
                                              hintText: 'Enter name',
                                              controller: lastnameCon,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Name required';
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
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      } else if (!RegExp(r"\S+@\S+\.\S+")
                                          .hasMatch(value)) {
                                        return 'Please enter valid email';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 12,
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
                                                  12, 11, 12, 11),
                                              // padding: EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
                                              // padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                                              //EdgeInsets.fromLTRB(15.w, 12.h, 15.w, 12.h),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8.w),
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
                                            Container(
                                              child: CustomTextFormField(
                                                hintText: 'Enter phone number',
                                                controller: phoneCon,
                                                textInputFormatter: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                                keyboardType:
                                                    TextInputType.phone,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'phone number is required';
                                                  } else if (value.length <
                                                      10) {
                                                    return 'invalid phone number';
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
                                    height: 8,
                                  ),
                                  Text(
                                    'Member Designation',
                                    style: text_16_black_600_TextStyle,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton2<CorporateRolesModel>(
                                      isExpanded: true,
                                      hint: Text(
                                        'please select Designation',
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      items: provider.affiliationList
                                          .map((CorporateRolesModel role) {
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
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                      value: role,
                                      onChanged: (value) {
                                        setState(() {
                                          role = value;
                                        });
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        height: 48,
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
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        iconEnabledColor: Colors.black,
                                        iconDisabledColor: Colors.grey,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        maxHeight: 300,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                        ),
                                        offset: const Offset(0, 0),
                                        scrollbarTheme: ScrollbarThemeData(
                                          radius: const Radius.circular(40),
                                          thickness: WidgetStateProperty.all(6),
                                          thumbVisibility:
                                              WidgetStateProperty.all(true),
                                        ),
                                      ),
                                      menuItemStyleData: MenuItemStyleData(
                                        height: 40,
                                        padding: const EdgeInsets.only(
                                            left: 14, right: 14),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: myColors.greyBtn),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          if (role != null) {
                                            EasyLoading.show(
                                                maskType:
                                                    EasyLoadingMaskType.black);
                                            var data = {
                                              "firstName": nameCon.text.trim(),
                                              "lastName":
                                                  lastnameCon.text.trim(),
                                              "email": emailCon.text.trim(),
                                              "phone": phoneCon.text.trim(),
                                              "countryCode": countryCodeText,
                                              "designationTextId": role!.textId
                                            };
                                            await provider
                                                .addNewCorporateMember(data);
                                            EasyLoading.dismiss();
                                          } else {
                                            DashboardHelpers.showAlert(
                                                msg: 'Select Role');
                                          }
                                        }
                                      },
                                      child: Text(
                                        'Add Member',
                                        style: interText(
                                            12, Colors.black, FontWeight.w600),
                                      )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  if (provider.teamMemberArrayList.length > 0)
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Invited team members',
                                            style: interText(16, Colors.black,
                                                FontWeight.bold),
                                          ),
                                          ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: provider
                                                .teamMemberArrayList.length,
                                            itemBuilder: (context, index) {
                                              var item = provider
                                                  .teamMemberArrayList[index];
                                              return Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: myColors
                                                                .divider,
                                                            width: 1))),
                                                child: ListTile(
                                                  title: Text(
                                                    '${item.firstName} ${item.lastName}',
                                                    style: interText(
                                                        14,
                                                        Colors.black,
                                                        FontWeight.w600),
                                                  ),
                                                  subtitle:
                                                      Text('${item.email}'),
                                                  leading: Container(
                                                    height: 50,
                                                    width: 50,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: myColors.green,
                                                    ),
                                                    child: Text(
                                                      DashboardHelpers
                                                          .getFirstCharacterCombinationName(
                                                              item.firstName ??
                                                                  '',
                                                              item.lastName ??
                                                                  ''),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  trailing: Text(
                                                      item.employeeType ?? ''),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomMaterialButton(
                          height: 44,
                          width: 180.w,
                          label: 'Skip for now',
                          buttonColor: myColors.greyBtn,
                          fontColor: Colors.black,
                          funcName: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SelectIdCardTypeScreen(
                                          from: 'corporate',
                                        )));
                          },
                          borderRadius: 8),
                      CustomRoundedButton(
                        height: 44,
                        width: 180.w,
                        label: 'Next',
                        buttonColor: myColors.green,
                        fontColor: Colors.white,
                        funcName: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectIdCardTypeScreen(
                                        from: 'corporate',
                                      )));
                        },
                        borderRadius: 8,
                        controller: _controller,
                      ),
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
}
