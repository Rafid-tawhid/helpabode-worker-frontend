import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/corporate/views/dropdown.dart';
import 'package:help_abode_worker_app_ver_2/corporate/views/text_field.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/models/corporate_review_data_model.dart';
import 'package:help_abode_worker_app_ver_2/provider/corporate_provider.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../helper_functions/colors.dart';
import '../../../misc/constants.dart';
import '../../../models/corporate_roles_model.dart';
import '../../../models/corporation_type_model.dart';
import '../../../models/state_model.dart';
import '../../../provider/working_service_provider.dart';
import '../screens/registration/mailing_address_screen_2.dart';
import 'corporate_documents.dart';
import 'corporate_review_details_tracker.dart';

class CorporationDetaiils extends StatefulWidget {
  CorporateReviewDataModel? corporateReviewDataModel;

  CorporationDetaiils({this.corporateReviewDataModel});

  @override
  State<CorporationDetaiils> createState() => _CorporationDetaiilsState();
}

class _CorporationDetaiilsState extends State<CorporationDetaiils> {
  // Form keys
  final _formKey = GlobalKey<FormState>();

  // Controllers for Text Fields
  final TextEditingController _nameCon = TextEditingController();
  final TextEditingController _dvaNameCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _contactNoCon = TextEditingController();
  final TextEditingController _taxCon = TextEditingController();
  final TextEditingController address1TextFormController =
      TextEditingController();
  final TextEditingController address1TextFormController2 =
      TextEditingController();
  final TextEditingController address2TextFormController =
      TextEditingController();
  final TextEditingController address2TextFormController2 =
      TextEditingController();
  final TextEditingController cityTextFormController = TextEditingController();
  final TextEditingController zipTextFormController = TextEditingController();
  final TextEditingController zipTextFormController2 = TextEditingController();

  // Address, City, and Zip Variables
  String address1Text = '';
  String address2Text = '';
  String cityText = '';
  String cityText2 = '';
  String zipText = '';
  String zipText2 = '';
  var isCheckAddress1 = null;
  var isCheckAddress2 = null;
  var isCheckCity;
  var isCheckZip;

  StateModel? selectedState;
  StateModel? selectedState2;
  StateModel? selectedCity;
  StateModel? selectedCity2;
  String? selectedStateTextId;

  // Role and Corporation
  CorporateRolesModel? selectedRole;
  CorporationTypeModel? selectedCorporation;
  List<String> items = ['LLC', 'INC', 'Partnership'];
  Set<int> selectedIndexes = {};

  // Miscellaneous
  final RoundedLoadingButtonController _controller =
      RoundedLoadingButtonController();
  File? selelctedFile;
  String selected = '';
  String? selectedAffilationId;
  var isButtonLoading = false;
  bool isDone = false;
  bool callOnce = true;
  bool checkVal = false;
  bool showRoleError = false;
  bool showCorporationError = false;
  bool showAdd1StateError = false;
  bool showAdd2StateError = false;
  late WorkingServiceProvider provider;
  List<StateModel> stateModelList = [];

  @override
  void initState() {
    stateModelList.clear();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of(context);
    if (callOnce) {
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
      provider.getStateByIsoCode().then((v) {
        EasyLoading.dismiss();
        setStateList();
        if (widget.corporateReviewDataModel != null) {
          provider
              .getCityNameByStateTxtId(
                  widget.corporateReviewDataModel!.salesStateTextId ?? '')
              .then((v) {
            Future.microtask(() {
              setPreviousValues(widget.corporateReviewDataModel, context);
            });
          });
        }
      });
      callOnce = false;
    }
    super.didChangeDependencies();
  }

  // Dispose method to clean up resources
  @override
  void dispose() {
    // Dispose all TextEditingControllers
    _nameCon.dispose();
    _dvaNameCon.dispose();
    _emailCon.dispose();
    _contactNoCon.dispose();
    _taxCon.dispose();
    address1TextFormController.dispose();
    address1TextFormController2.dispose();
    address2TextFormController.dispose();
    address2TextFormController2.dispose();
    cityTextFormController.dispose();
    zipTextFormController.dispose();
    zipTextFormController2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2,
                            color: myColors.green,
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Colors.white,
                          ),
                          flex: 4,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Corporation \nDetails',
                            style: interText(24, Colors.black, FontWeight.bold),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            'Provide your corporation\'s address for enhanced service accuracy.',
                            style: interText(
                                14, myColors.greyTxt, FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 12,
                                ),
                                Consumer<CorporateProvider>(
                                  builder: (context, provider, _) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Role',
                                          style: interText(16, Colors.black,
                                              FontWeight.w500)),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomDropdown<
                                                CorporateRolesModel>(
                                              items: provider.affiliationList,
                                              selectedItem: selectedRole,
                                              hint: 'Select Role',
                                              errorMessage:
                                                  'Please select role',
                                              isError: showRoleError,
                                              itemLabel:
                                                  (CorporateRolesModel item) =>
                                                      item.title ?? '',
                                              onChanged:
                                                  (CorporateRolesModel? value) {
                                                setState(() {
                                                  selectedRole = value;
                                                  showRoleError = false;
                                                });
                                                print(
                                                    'Selected Role: ${value?.title}');
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Consumer<CorporateProvider>(
                                  builder: (context, provider, _) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Types of Corporation',
                                          style: interText(16, Colors.black,
                                              FontWeight.w500)),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomDropdown<
                                                CorporationTypeModel>(
                                              items:
                                                  provider.corporationTypeList,
                                              selectedItem: selectedCorporation,
                                              hint: 'Select Corporation',
                                              errorMessage:
                                                  'Please select corporation',
                                              isError: showCorporationError,
                                              itemLabel:
                                                  (CorporationTypeModel item) =>
                                                      item.title ?? '',
                                              onChanged: (CorporationTypeModel?
                                                  value) {
                                                setState(() {
                                                  selectedCorporation = value;
                                                  showCorporationError = false;
                                                });
                                                print(
                                                    'Selected Corporation: ${value?.title}');
                                              },
                                            ),
                                          ),
                                        ],
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
                              'Corporate Name/Name - as shown on Federal Tax Return *',
                              style:
                                  interText(16, Colors.black, FontWeight.w500),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: CustomTextFormField(
                                hintText: 'Corporation name',
                                controller: _nameCon,
                                textInputFormatter: [
                                  FilteringTextInputFormatter.allow(RegExp(
                                      r'[a-zA-Z0-9\s.,]')), // Correctly allows specific characters
                                ],
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter company name'; // Return error message if input is empty
                                  }
                                  return null; // Return null if input is valid
                                },
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Alternate Name/DBA',
                              style:
                                  interText(16, Colors.black, FontWeight.w500),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: CustomTextFormField(
                                hintText: 'Enter alternate name',
                                controller: _dvaNameCon,
                                textInputFormatter: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z0-9\s.,]')),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your alternate name';
                                  }
                                  // if (value.length < 6) {
                                  //   return 'Password must be at least 6 characters long';
                                  // }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Tax ID - FEIN or SSN*',
                              style:
                                  interText(16, Colors.black, FontWeight.w500),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: CustomTextFormField(
                                hintText: 'Enter tax id or ssn',
                                controller: _taxCon,
                                textInputFormatter: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z0-9\s.,]')),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter tax id or ssn';
                                  }
                                  // if (value.length < 6) {
                                  //   return 'Password must be at least 6 characters long';
                                  // }
                                  return null;
                                },
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: Container(
                                        height: 2,
                                        color: myColors.greyBtn,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      child: Text('Address',
                                          style: interText(18, Colors.black,
                                              FontWeight.w500)),
                                    ),
                                    Text(
                                      'Address Line 1*',
                                      style: interText(
                                          16, Colors.black, FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    CustomTextFormField(
                                      hintText: 'Address 1',
                                      controller: address1TextFormController,
                                      textInputFormatter: [
                                        LengthLimitingTextInputFormatter(40),
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[a-zA-Z0-9\s.,]')),
                                      ],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your address';
                                        } else if (value.length < 4) {
                                          return 'Please enter valid address';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      'Address Line 2',
                                      style: interText(
                                          16, Colors.black, FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    CustomTextFormField(
                                      hintText: 'Address 2',
                                      textInputFormatter: [
                                        LengthLimitingTextInputFormatter(40),
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[a-zA-Z0-9\s.,]')),
                                      ],
                                      controller: address2TextFormController,
                                      validator: (value) {
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      'State',
                                      style: interText(
                                          16, Colors.black, FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (provider
                                            .stateModelList.isNotEmpty) {
                                          showModalBottomSheet<StateModel>(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return TopCurvedBottomSheet(
                                                dataList:
                                                    provider.stateModelList,
                                                isState: true,
                                              );
                                            },
                                          ).then(
                                            (value) async {
                                              if (value != null) {
                                                print(
                                                    'Selected Corporation: ${value.title}');
                                                EasyLoading.show(
                                                    maskType:
                                                        EasyLoadingMaskType
                                                            .black);
                                                setState(() {
                                                  selectedCity = null;
                                                  selectedState = value;
                                                  showAdd1StateError = false;
                                                });
                                                print(selectedState!.textId!);
                                                provider.cityModelList.clear();
                                                await provider
                                                    .getCityNameByStateTxtId(
                                                        selectedState!.textId ??
                                                            '');
                                                EasyLoading.dismiss();
                                              }
                                            },
                                          );
                                        } else {
                                          DashboardHelpers.showAlert(
                                              msg: 'Please wait');
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 50,
                                        padding:
                                            EdgeInsets.only(left: 12, right: 8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white),
                                        alignment: Alignment.centerLeft,
                                        child: selectedState == null
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Select State',
                                                    style: TextStyle(
                                                        color: myColors.greyTxt,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Icon(
                                                      Icons.keyboard_arrow_down)
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    selectedState!.title ?? '',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Icon(
                                                      Icons.keyboard_arrow_down)
                                                ],
                                              ),

                                        // child: DropdownButtonHideUnderline(
                                        //   child: DropdownButton2<StateModel>(
                                        //     isExpanded: true,
                                        //     hint: const Row(
                                        //       children: [
                                        //         SizedBox(
                                        //           width: 4,
                                        //         ),
                                        //         Expanded(
                                        //           child: Text(
                                        //             'Select city',
                                        //             style: TextStyle(
                                        //               fontSize: 14,
                                        //               fontWeight: FontWeight.bold,
                                        //               color: Colors.black,
                                        //             ),
                                        //             overflow: TextOverflow.ellipsis,
                                        //           ),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //     items: provider.cityModelList
                                        //         .map((StateModel item) => DropdownMenuItem<StateModel>(
                                        //               value: item,
                                        //               child: Text(
                                        //                 item.title ?? '',
                                        //                 style: const TextStyle(
                                        //                   fontSize: 14,
                                        //                   fontWeight: FontWeight.bold,
                                        //                   color: Colors.black,
                                        //                 ),
                                        //                 overflow: TextOverflow.ellipsis,
                                        //               ),
                                        //             ))
                                        //         .toList(),
                                        //     value: selectedCity,
                                        //     onChanged: (value) {
                                        //       setState(() {
                                        //         selectedCity = value;
                                        //       });
                                        //     },
                                        //     buttonStyleData: ButtonStyleData(
                                        //       height: 56.h,
                                        //       // width: 160,
                                        //       padding: const EdgeInsets.only(left: 0, right: 14),
                                        //       decoration: BoxDecoration(
                                        //         borderRadius: BorderRadius.circular(8),
                                        //         // border: Border.all(
                                        //         //   color: Colors.black26,
                                        //         // ),
                                        //         color: textfieldClr,
                                        //       ),
                                        //       elevation: 0,
                                        //     ),
                                        //     iconStyleData: const IconStyleData(
                                        //       icon: Icon(
                                        //         Icons.arrow_drop_down_sharp,
                                        //       ),
                                        //       iconSize: 40,
                                        //       iconEnabledColor: Colors.black,
                                        //       iconDisabledColor: Colors.grey,
                                        //     ),
                                        //     dropdownStyleData: DropdownStyleData(
                                        //       maxHeight: 300,
                                        //       decoration: BoxDecoration(
                                        //         borderRadius: BorderRadius.circular(8),
                                        //         color: textfieldClr,
                                        //       ),
                                        //       offset: const Offset(0, 0),
                                        //       scrollbarTheme: ScrollbarThemeData(
                                        //         radius: const Radius.circular(40),
                                        //         thickness: MaterialStateProperty.all(6),
                                        //         thumbVisibility: MaterialStateProperty.all(true),
                                        //       ),
                                        //     ),
                                        //     menuItemStyleData: const MenuItemStyleData(
                                        //       height: 40,
                                        //       padding: EdgeInsets.only(left: 14, right: 14),
                                        //     ),
                                        //   ),
                                        // ),
                                      ),
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Expanded(
                                    //       child: CustomDropdown<StateModel>(
                                    //         items: stateModelList,
                                    //         selectedItem: selectedState,
                                    //         hint: 'Select State',
                                    //         errorMessage: 'Please select state',
                                    //         isError: showAdd1StateError,
                                    //         itemLabel: (StateModel item) =>
                                    //             item.title ?? '',
                                    //         onChanged:
                                    //             (StateModel? value) async {
                                    //           print(
                                    //               'Selected Corporation: ${value?.title}');
                                    //           EasyLoading.show(
                                    //               maskType: EasyLoadingMaskType
                                    //                   .black);
                                    //           setState(() {
                                    //             selectedCity = null;
                                    //             selectedState = value;
                                    //             showAdd1StateError = false;
                                    //           });
                                    //           print(selectedState!.textId!);
                                    //           provider.cityModelList.clear();
                                    //           await provider
                                    //               .getCityNameByStateTxtId(
                                    //                   selectedState!.textId ??
                                    //                       '');
                                    //           EasyLoading.dismiss();
                                    //         },
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    const SizedBox(
                                      height: 12,
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
                                                'City',
                                                style: interText(
                                                    16,
                                                    Colors.black,
                                                    FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              CitySelection(context),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Zip',
                                                style: interText(
                                                    14,
                                                    Colors.black,
                                                    FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 6,
                                              ),
                                              CustomTextFormField(
                                                hintText: 'Enter Zip',
                                                controller:
                                                    zipTextFormController,
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'zipcode required';
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
                                      height: 16,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Mailing Address (If different from above)',
                                  style: interText(
                                      14, Colors.black, FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Checkbox(
                                          value: !checkVal,
                                          activeColor: myColors.green,
                                          onChanged: (val) {
                                            setState(() {
                                              checkVal = !checkVal;
                                              // if (checkVal) {
                                              //   address1TextFormController2.text = address1TextFormController.text;
                                              //   address2TextFormController2.text = address2TextFormController.text;
                                              //   selectedCity2 = selectedCity;
                                              //   selectedState2 = selectedState;
                                              // } else {
                                              //   address1TextFormController2.text = '';
                                              //   address2TextFormController2.text = '';
                                              //   zipTextFormController.text = '';
                                              //   selectedCity2 = null;
                                              //   selectedState2 = null;
                                              // }
                                            });
                                          }),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Same as before'),
                                  ],
                                ),
                                if (!checkVal)
                                  SizedBox(
                                    height: 60,
                                  ),
                                if (checkVal) SameAsBeforeWidget(context),
                                SizedBox(
                                  height: 16,
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
            Container(
              padding: EdgeInsets.only(left: 12, right: 12, top: 12),
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
              child: CustomRoundedButton(
                  height: 50.h,
                  width: 388.w,
                  controller: _controller,
                  label: 'Save & Next',
                  buttonColor: myColors.green,
                  fontColor: Colors.white,
                  funcName: () async {
                    // Check if any of the required fields are null and show corresponding errors
                    setState(() {
                      showRoleError = selectedRole == null;
                      showCorporationError = selectedCorporation == null;
                      showAdd1StateError = selectedState == null;
                    });
                    // If the form is valid and none of the essential fields are null, proceed
                    if (_formKey.currentState!.validate() &&
                        selectedRole != null &&
                        selectedCorporation != null &&
                        selectedState != null) {
                      // Prepare the default and secondary addresses
                      final defaultAddress = {
                        "addressLine1Data":
                            address1TextFormController.text.trim(),
                        "addressLine2Data":
                            address2TextFormController.text.trim(),
                        "cityData": selectedCity?.title ?? '',
                        "stateData": selectedState?.title ?? '',
                        "zipData": zipTextFormController.text.trim(),
                        "type": "Default Address"
                      };

                      final secondaryAddress = checkVal
                          ? {
                              "addressLine1":
                                  address1TextFormController2.text.trim(),
                              "addressLine2":
                                  address2TextFormController2.text.trim(),
                              "cityData": selectedCity2?.title ?? '',
                              "stateData": selectedState2?.title ?? '',
                              "zipData": zipTextFormController2.text.trim(),
                              "type": "Secondary Address"
                            }
                          : {
                              "addressLine1":
                                  address1TextFormController.text.trim(),
                              "addressLine2":
                                  address2TextFormController.text.trim(),
                              "cityData": selectedCity?.title ?? '',
                              "stateData": selectedState?.title ?? '',
                              "zipData": zipTextFormController.text.trim(),
                              "type": "Secondary Address"
                            };

                      final address = [defaultAddress, secondaryAddress];

                      // Prepare the data payload
                      var data = {
                        "roleTextId": selectedRole!.textId,
                        "corporationTypeTextId": selectedCorporation!.textId,
                        "corporationName": _nameCon.text,
                        "alternateName": _dvaNameCon.text,
                        "taxId": _taxCon.text,
                        "corporateAddress": address,
                      };

                      // Debug the data (or make the API call)
                      debugPrint('Send Data: $data');
                      var cp = context.read<CorporateProvider>();

                      _controller.start();
                      if (await cp.setCorporationAddress(data)) {
                        DashboardHelpers.successStopAnimation(_controller);
                        if (widget.corporateReviewDataModel != null) {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CorporateReviewDetailsTracker()))
                              .then((v) {
                            setState(() {
                              selectedState = null;
                              selectedCity = null;
                            });
                          });
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CorporateDocuments())).then((v) {
                            setState(() {
                              selectedState = null;
                              selectedCity = null;
                            });
                          });
                        }
                      }
                      DashboardHelpers.errorStopAnimation(_controller);
                    }
                  },
                  borderRadius: 8),
            )
          ],
        ),
      ),
    );
  }

  Column SameAsBeforeWidget(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          'Address Line 1*',
          style: interText(14, Colors.black, FontWeight.w500),
        ),
        const SizedBox(
          height: 6,
        ),
        CustomTextFormField(
          hintText: 'Address',
          textInputFormatter: [
            LengthLimitingTextInputFormatter(40),
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s.,]')),
          ],
          controller: address1TextFormController2,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your address';
            } else if (value.length < 4) {
              return 'Please enter valid address';
            }
            return null;
          },
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          'Address Line 2',
          style: interText(14, Colors.black, FontWeight.w500),
        ),
        const SizedBox(
          height: 6,
        ),
        CustomTextFormField(
          hintText: 'Address',
          controller: address2TextFormController2,
          textInputFormatter: [
            LengthLimitingTextInputFormatter(40),
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s.,]')),
          ],
          validator: (value) {
            return null;
          },
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          'State',
          style: interText(14, Colors.black, FontWeight.w500),
        ),
        const SizedBox(
          height: 2,
        ),
        InkWell(
          onTap: () {
            if (provider.stateModelList.isNotEmpty) {
              showModalBottomSheet<StateModel>(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return TopCurvedBottomSheet(
                    dataList: provider.stateModelList,
                    isState: true,
                  );
                },
              ).then(
                (value) async {
                  if (value != null) {
                    print('Selected Corporation: ${value.title}');
                    EasyLoading.show(maskType: EasyLoadingMaskType.black);
                    setState(() {
                      selectedCity2 = null;
                      selectedState2 = value;
                      showAdd2StateError = false;
                    });
                    print(selectedState2!.textId!);
                    provider.cityModelList.clear();
                    await provider
                        .getCityNameByStateTxtId(selectedState2!.textId ?? '');
                    EasyLoading.dismiss();
                  }
                },
              );
            } else {
              DashboardHelpers.showAlert(msg: 'Please wait');
            }
          },
          child: Container(
            width: double.infinity,
            height: 50,
            padding: EdgeInsets.only(left: 12, right: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: Colors.white),
            alignment: Alignment.centerLeft,
            child: selectedState2 == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select State',
                        style: TextStyle(
                            color: myColors.greyTxt,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      Icon(Icons.keyboard_arrow_down)
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedState2!.title ?? '',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      Icon(Icons.keyboard_arrow_down)
                    ],
                  ),

            // child: DropdownButtonHideUnderline(
            //   child: DropdownButton2<StateModel>(
            //     isExpanded: true,
            //     hint: const Row(
            //       children: [
            //         SizedBox(
            //           width: 4,
            //         ),
            //         Expanded(
            //           child: Text(
            //             'Select city',
            //             style: TextStyle(
            //               fontSize: 14,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.black,
            //             ),
            //             overflow: TextOverflow.ellipsis,
            //           ),
            //         ),
            //       ],
            //     ),
            //     items: provider.cityModelList
            //         .map((StateModel item) => DropdownMenuItem<StateModel>(
            //               value: item,
            //               child: Text(
            //                 item.title ?? '',
            //                 style: const TextStyle(
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.bold,
            //                   color: Colors.black,
            //                 ),
            //                 overflow: TextOverflow.ellipsis,
            //               ),
            //             ))
            //         .toList(),
            //     value: selectedCity,
            //     onChanged: (value) {
            //       setState(() {
            //         selectedCity = value;
            //       });
            //     },
            //     buttonStyleData: ButtonStyleData(
            //       height: 56.h,
            //       // width: 160,
            //       padding: const EdgeInsets.only(left: 0, right: 14),
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(8),
            //         // border: Border.all(
            //         //   color: Colors.black26,
            //         // ),
            //         color: textfieldClr,
            //       ),
            //       elevation: 0,
            //     ),
            //     iconStyleData: const IconStyleData(
            //       icon: Icon(
            //         Icons.arrow_drop_down_sharp,
            //       ),
            //       iconSize: 40,
            //       iconEnabledColor: Colors.black,
            //       iconDisabledColor: Colors.grey,
            //     ),
            //     dropdownStyleData: DropdownStyleData(
            //       maxHeight: 300,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(8),
            //         color: textfieldClr,
            //       ),
            //       offset: const Offset(0, 0),
            //       scrollbarTheme: ScrollbarThemeData(
            //         radius: const Radius.circular(40),
            //         thickness: MaterialStateProperty.all(6),
            //         thumbVisibility: MaterialStateProperty.all(true),
            //       ),
            //     ),
            //     menuItemStyleData: const MenuItemStyleData(
            //       height: 40,
            //       padding: EdgeInsets.only(left: 14, right: 14),
            //     ),
            //   ),
            // ),
          ),
        ),
        // Row(
        //   children: [
        //     Expanded(
        //       child: CustomDropdown<StateModel>(
        //         items: provider.stateModelList,
        //         selectedItem: selectedState2,
        //         hint: 'Select State',
        //         errorMessage: 'Please select state',
        //         isError: showAdd2StateError,
        //         itemLabel: (StateModel item) => item.title ?? '',
        //         onChanged: (StateModel? value) async {
        //           print('Selected Corporation: ${value?.title}');
        //           EasyLoading.show(maskType: EasyLoadingMaskType.black);
        //           setState(() {
        //             selectedCity2 = null;
        //             selectedState2 = value;
        //             showAdd2StateError = false;
        //           });
        //           print(selectedState2!.textId!);
        //           provider.cityModelList.clear();
        //           await provider.getCityNameByStateTxtId(selectedState2!.textId ?? '');
        //           EasyLoading.dismiss();
        //         },
        //       ),
        //     ),
        //   ],
        // ),
        const SizedBox(
          height: 12,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'City',
                    style: interText(14, Colors.black, FontWeight.w500),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  FormField<StateModel>(
                    validator: (value) {
                      if (selectedState2 == null) {
                        return 'city required';
                      }
                      return null;
                    },
                    builder: (FormFieldState<StateModel> state) {
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: InkWell(
                              onTap: () {
                                if (selectedState2 != null) {
                                  showModalBottomSheet<StateModel>(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return TopCurvedBottomSheet(
                                          dataList: provider.cityModelList);
                                    },
                                  ).then(
                                    (value) {
                                      setState(() {
                                        selectedCity2 = value;
                                      });
                                    },
                                  );
                                } else {
                                  DashboardHelpers.showAlert(
                                      msg: 'Please select a State');
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                padding: EdgeInsets.only(left: 12, right: 8),
                                decoration: BoxDecoration(
                                  color: state.hasError
                                      ? Colors.red.shade50
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: state.hasError
                                        ? Colors.red
                                        : Colors
                                            .transparent, // Red border if there's an error
                                    width: 1.0, // Thickness of the border
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                                child: selectedCity2 == null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Select City',
                                            style: TextStyle(
                                                color: myColors.greyTxt,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Icon(Icons.keyboard_arrow_down)
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            selectedCity2!.title ?? '',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Icon(Icons.keyboard_arrow_down)
                                        ],
                                      ),
                              ),
                            ),
                          ),
                          if (state.hasError)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 14.0, top: 8),
                              child: Row(
                                children: [
                                  Text(
                                    state.errorText!,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zip',
                    style: interText(14, Colors.black, FontWeight.w500),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  CustomTextFormField(
                    hintText: 'Enter Zip',
                    controller: zipTextFormController2,
                    textInputFormatter: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'zipcode required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  FormField<StateModel> CitySelection(BuildContext context) {
    return FormField<StateModel>(
      validator: (value) {
        if (selectedCity == null) {
          return 'City required'; // Return error if city is not selected
        }
        return null; // No error if city is selected
      },
      builder: (FormFieldState<StateModel> state) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              child: InkWell(
                onTap: () {
                  if (selectedState != null) {
                    showModalBottomSheet<StateModel>(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return TopCurvedBottomSheet(
                            dataList: provider.cityModelList);
                      },
                    ).then((value) {
                      if (value != null) {
                        debugPrint('RETURN VALUE ${value}');

                        // Update both selectedCity and the FormField's state
                        setState(() {
                          selectedCity = value;
                          state.validate();
                        });

                        // Update the FormField's internal state and remove the error
                        state.didChange(value);
                      }
                    });
                  } else {
                    DashboardHelpers.showAlert(msg: 'Please select a State');
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  padding: EdgeInsets.only(left: 12, right: 8),
                  decoration: BoxDecoration(
                    color: state.hasError ? Colors.red.shade50 : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: state.hasError
                          ? Colors.red
                          : Colors
                              .transparent, // Red border if there's an error
                      width: 1.0, // Thickness of the border
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  child: selectedCity == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select City',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            Icon(Icons.keyboard_arrow_down),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedCity!.title ?? '',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 14.0, top: 8),
                child: Row(
                  children: [
                    Text(
                      state.errorText ?? '',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  void setPreviousValues(CorporateReviewDataModel? corporateReviewDataModel,
      BuildContext context) async {
    var cp = context.read<CorporateProvider>();
    var wp = context.read<WorkingServiceProvider>();
    _nameCon.text = widget.corporateReviewDataModel!.corporationName ?? '';
    _dvaNameCon.text = widget.corporateReviewDataModel!.alternateName ?? '';
    _taxCon.text = widget.corporateReviewDataModel!.salesStateTaxId ?? '';
    address1TextFormController.text =
        widget.corporateReviewDataModel!.address!.first.addressLine1Data ?? '';
    address2TextFormController.text =
        widget.corporateReviewDataModel!.address!.first.addressLine2Data ?? '';
    zipTextFormController.text =
        widget.corporateReviewDataModel!.address!.first.zipData ?? '';
    selectedRole = cp.affiliationList.firstWhere((e) =>
        e.title == widget.corporateReviewDataModel!.corporationRoleTextId);
    selectedCorporation = cp.corporationTypeList.firstWhere((e) =>
        e.title == widget.corporateReviewDataModel!.corporationTypeTextId);

    address1TextFormController2.text =
        widget.corporateReviewDataModel!.address!.last.addressLine1Data ?? '';
    address2TextFormController2.text =
        widget.corporateReviewDataModel!.address!.last.addressLine2Data ?? '';
    zipTextFormController2.text =
        widget.corporateReviewDataModel!.address!.last.zipData ?? '';

    setState(() {
      selectedState = wp.stateModelList.isNotEmpty
          ? wp.stateModelList.first // Default to the first state
          : null;
      //
      debugPrint('selectedState ${selectedState!.title}');

      selectedState2 = wp.stateModelList.isNotEmpty
          ? wp.stateModelList.last // Default to the first state
          : null;
      selectedCity = wp.cityModelList.isNotEmpty
          ? wp.cityModelList.first // Default to the first state
          : null;
      selectedCity2 = wp.cityModelList.isNotEmpty
          ? wp.cityModelList.last // Default to the first state
          : null;
    });
  }

  void setStateList() {
    setState(() {
      stateModelList = provider.stateModelList;
    });
  }
}

// SizedBox(height: 24.0),
//                             InkWell(
//                               onTap: () async {
//                                 FilePickerResult? result = await FilePicker.platform.pickFiles(
//                                   type: FileType.custom,
//                                   allowedExtensions: ['png', 'jpg', 'pdf', 'doc', 'docx'],
//                                 );
//                                 if (result != null) {
//                                   setState(() {
//                                     selelctedFile = File(result.files.single.path!);
//                                   });
//                                 } else {
//                                   // User canceled the picker
//                                 }
//                               },
//                               child: DottedBorderContainer(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(12.0),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Container(
//                                         child: Padding(padding: const EdgeInsets.all(12.0), child: SvgPicture.asset('assets/svg/upload_icon.svg')),
//                                         decoration: BoxDecoration(shape: BoxShape.circle, color: myColors.greyBg),
//                                       ),
//                                       SizedBox(
//                                         width: 12,
//                                       ),
//                                       selelctedFile == null
//                                           ? Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   'Upload Article of Incorporation',
//                                                   style: interText(14, Colors.black, FontWeight.w400),
//                                                 ),
//                                                 Text(
//                                                   'Click or drag to upload',
//                                                   style: interText(12, myColors.green, FontWeight.w400),
//                                                 ),
//                                               ],
//                                             )
//                                           : Expanded(child: Text(selelctedFile!.path.length > 40 ? selelctedFile!.path.substring(selelctedFile!.path.length - 40) : selelctedFile!.path))
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
