import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/models/state_model.dart';
import 'package:help_abode_worker_app_ver_2/provider/working_service_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/select_idcard_type_screen.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_rounded_button.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/new_text_formfield.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/auth_screen.dart';

class MailingAddressScreen2 extends StatefulWidget {
  MailingAddressScreen2({
    this.workerTextId,
    this.workerStatus,
  });

  String? workerTextId;
  String? workerStatus;

  @override
  State<MailingAddressScreen2> createState() => _MailingAddressScreen2State();
}

class _MailingAddressScreen2State extends State<MailingAddressScreen2> {
  final TextEditingController address1TextFormController =
      TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  String address1Text = '';
  final _formAddress1Key = GlobalKey<FormState>();
  FocusNode focusNodeAddress1 = FocusNode();
  var isCheckAddress1 = null;

  final TextEditingController address2TextFormController =
      TextEditingController();
  String address2Text = '';
  final _formAddress2Key = GlobalKey<FormState>();
  FocusNode focusNodeAddress2 = FocusNode();
  var isCheckAddress2 = null;

  final TextEditingController cityTextFormController = TextEditingController();
  String cityText = '';
  final _formCityKey = GlobalKey<FormState>();
  FocusNode focusNodeCity = FocusNode();
  var isCheckCity;

  final TextEditingController zipTextFormController = TextEditingController();
  String zipText = '';
  final _formKey = GlobalKey<FormState>();

  late WorkingServiceProvider provider;
  var isCheckZip;

  var selectedStateValue;
  StateModel? selectedState;
  StateModel? selectedCity;
  String? selectedStateTextId;

  var isButtonLoading = false;

  bool isDone = false;
  bool callOnce = true;

  var stateList = [
    {'textId': 'California', 'title': 'California'},
    {'textId': 'New York', 'title': 'New York'},
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    address1TextFormController.dispose();
    focusNodeAddress1.dispose();
    focusNodeCity.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of(context);
    if (callOnce) {
      provider.getStateByIsoCode();
      callOnce = false;
    }
    super.didChangeDependencies();
  }

  Future postMailingAddressData(
      RoundedLoadingButtonController btnController) async {
    try {
      print('#######_______INSIDE POST_______########');

      print(token);

      var header = {
        "Authorization": "Bearer ${token}",
      };

      print(header);

      var data = {
        "workerTextId": "${textId}",
        "workerStatus": "${status}",
        "cityData": selectedCity!.title, //"${selectedCity!.textId}",
        "stateData": selectedState!.title, //"${selectedState!.textId}",
        "addressLine1Data": "${address1Text}",
        "addressLine2Data": "${address2Text}",
        "zipData": "${zipTextFormController.text}",
      };
      var body = jsonEncode(data);

      print(body);

      Response response = await post(
        Uri.parse("${urlBase}api/WorkerMailingAddressUpdate"),
        body: body,
        headers: header,
      );

      print('FULL RESPONSE ${jsonDecode(response.body)}');

      print(response.statusCode);

      if (response.statusCode == 200) {
        DashboardHelpers.successStopAnimation(btnController);
        var responseDecodeJson = jsonDecode(response.body);
        print('Response Json : ${responseDecodeJson}');
        await userBox.put(
            'status', '${responseDecodeJson['worker_status']['status']}');
        print('Returning Response Json');

        return true;
      } else if (response.statusCode == 406) {
        DashboardHelpers.errorStopAnimation(btnController);
        print('Inside 406');
        print('RESPONSE 1 ${response}');
        return false;
      }
    } catch (e) {
      print("catch");
      DashboardHelpers.errorStopAnimation(btnController);
      print('RESPONSE 2 ${e}');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgClr,
      body: PopScope(
        canPop: false,
        child: GestureDetector(
          onTap: () {
            // This ensures that when you tap outside the text field, it unfocuses
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 8),
                      child: InkWell(
                        onTap: () {
                          // Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: myColors.divider,
                              borderRadius: BorderRadius.circular(8)),
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
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
                              flex: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            'Mailing Address',
                            style: text_20_black_600_TextStyle,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            'Address Line 1*',
                            style: text_16_black_600_TextStyle,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          NewCustomTextField(
                            width: 388.w,
                            borderRadius: 8.w,
                            formKey: _formAddress1Key,
                            focusNode: focusNodeAddress1,
                            fieldTextFieldController:
                                address1TextFormController,
                            inputFormat: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(40),
                            ],
                            // keyboard: TextInputType.emailAddress,
                            isCheck: isCheckAddress1,
                            funcOnChanged: (value) {
                              setState(() {
                                address1Text = value!;
                                //_formEmailKey.currentState!.validate();
                                print("onChange " + address1Text);
                              });
                            },
                            funcValidate: (value, setErrorInfo) {
                              if (value == null || value.trim().isEmpty) {
                                setErrorInfo(true, 'Address is required');
                                //focusNodeFirstName.requestFocus();
                                return '';
                              } else if (value.length < 4) {
                                setErrorInfo(
                                    true, 'Please provide a valid address');
                                //focusNodeFirstName.requestFocus();
                                return '';
                              }
                              return null;
                            },
                            hintText: 'Enter Address Line 1',
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Address Line 2',
                            style: text_16_black_600_TextStyle,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          NewCustomTextField(
                            width: 388.w,
                            inputFormat: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(40),
                            ],
                            borderRadius: 8.w,
                            formKey: _formAddress2Key,
                            focusNode: focusNodeAddress2,
                            fieldTextFieldController:
                                address2TextFormController,
                            // keyboard: TextInputType.emailAddress,
                            isCheck: isCheckAddress2,
                            funcOnChanged: (value) {
                              setState(() {
                                address2Text = value!;
                                //_formEmailKey.currentState!.validate();
                                print("onChange " + address2Text);
                              });
                            },
                            funcValidate: (value, setErrorInfo) {
                              return null;
                            },
                            hintText: 'Enter Address Line 2',
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            'State',
                            style: text_16_black_600_TextStyle,
                          ),
                          const SizedBox(
                            height: 12,
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
                                      EasyLoading.show(
                                          maskType: EasyLoadingMaskType.black);
                                      setState(() {
                                        selectedCity = null;
                                        selectedState = value;
                                      });
                                      print(selectedState!.textId!);
                                      provider.cityModelList.clear();
                                      await provider.getCityNameByStateTxtId(
                                          selectedState!.textId ?? '');
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
                                  borderRadius: BorderRadius.circular(8),
                                  color: myColors.greyBg),
                              alignment: Alignment.centerLeft,
                              child: selectedState == null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          selectedState!.title ?? '',
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

                          // Container(
                          //   width: double.infinity,
                          //   height: 50,
                          //   padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                          //   decoration: BoxDecoration(
                          //     color: textfieldClr,
                          //     borderRadius: BorderRadius.circular(8),
                          //   ),
                          //   child: DropdownButtonHideUnderline(
                          //     child: DropdownButton2<StateModel>(
                          //       isExpanded: true,
                          //       hint: const Row(
                          //         children: [
                          //           SizedBox(
                          //             width: 4,
                          //           ),
                          //           Expanded(
                          //             child: Text(
                          //               'Select State',
                          //               style: TextStyle(
                          //                 fontSize: 14,
                          //                 fontWeight: FontWeight.bold,
                          //                 color: Colors.black,
                          //               ),
                          //               overflow: TextOverflow.ellipsis,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //       items: provider.stateModelList.map((StateModel item) => DropdownMenuItem<StateModel>(
                          //                 value: item,
                          //                 child: Text(
                          //                   item.title ?? '',
                          //                   style: const TextStyle(
                          //                     fontSize: 14,
                          //                     fontWeight: FontWeight.bold,
                          //                     color: Colors.black,
                          //                   ),
                          //                   overflow: TextOverflow.ellipsis,
                          //                 ),
                          //               ))
                          //           .toList(),
                          //       value: selectedState,
                          //       onChanged: (value) async {
                          //         EasyLoading.show(maskType: EasyLoadingMaskType.black);
                          //         setState(() {
                          //           selectedCity = null;
                          //           selectedState = value;
                          //         });
                          //         print(selectedState!.textId!);
                          //         provider.cityModelList.clear();
                          //         await provider.getCityNameByStateTxtId(selectedState!.textId ?? '');
                          //         EasyLoading.dismiss();
                          //       },
                          //       buttonStyleData: ButtonStyleData(
                          //         height: 56.h,
                          //         // width: 160,
                          //         padding: const EdgeInsets.only(left: 0, right: 14),
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(8),
                          //           color: textfieldClr,
                          //         ),
                          //         elevation: 0,
                          //       ),
                          //       iconStyleData: const IconStyleData(
                          //         icon: Icon(
                          //           Icons.keyboard_arrow_down,
                          //         ),
                          //         iconEnabledColor: Colors.black,
                          //         iconDisabledColor: Colors.grey,
                          //       ),
                          //       dropdownStyleData: DropdownStyleData(
                          //         maxHeight: 300,
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(8),
                          //           color: textfieldClr,
                          //         ),
                          //         offset: const Offset(0, 0),
                          //         scrollbarTheme: ScrollbarThemeData(
                          //           radius: const Radius.circular(40),
                          //           thickness: WidgetStateProperty.all(6),
                          //           thumbVisibility: WidgetStateProperty.all(true),
                          //         ),
                          //       ),
                          //       menuItemStyleData: MenuItemStyleData(
                          //         height: 40,
                          //         padding: EdgeInsets.only(left: 14, right: 14),
                          //       ),
                          //     ),
                          //   ),
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
                                      style: text_16_black_600_TextStyle,
                                    ),
                                    SizedBox(
                                      height: 13.h,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (selectedState != null) {
                                          showModalBottomSheet<StateModel>(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return TopCurvedBottomSheet(
                                                  dataList:
                                                      provider.cityModelList);
                                            },
                                          ).then(
                                            (value) {
                                              setState(() {
                                                selectedCity = value;
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
                                        padding:
                                            EdgeInsets.only(left: 12, right: 8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: myColors.greyBg),
                                        alignment: Alignment.centerLeft,
                                        child: selectedCity == null
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Select City',
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
                                                    selectedCity!.title ?? '',
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
                                      style: text_16_black_600_TextStyle,
                                    ),
                                    SizedBox(
                                      height: 13.h,
                                    ),
                                    NewCustomTextField(
                                      width: 185.w,
                                      inputFormat: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(5),
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r'[^\w\d]'))
                                      ],
                                      borderRadius: 8.w,
                                      fieldTextFieldController:
                                          zipTextFormController,
                                      keyboard: TextInputType.number,
                                      isCheck: isCheckZip,
                                      funcOnChanged: (value) {
                                        setState(() {
                                          zipText = value!;
                                        });
                                      },
                                      funcValidate: (value, setErrorInfo) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          setErrorInfo(
                                              true, 'Zipcode required');
                                          //focusNodeFirstName.requestFocus();
                                          return '';
                                        }
                                        if (value.length < 4) {
                                          setErrorInfo(true, 'Invalid zipcode');
                                          //focusNodeFirstName.requestFocus();
                                          return '';
                                        }
                                        return null;
                                      },
                                      hintText: 'Enter Zip',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 35.h,
                          ),
                          CustomRoundedButton(
                            isLoading: isButtonLoading,
                            controller: _btnController,
                            funcName: () async {
                              address1Text.trimLeft();
                              address1Text.trim();
                              address2Text.trimLeft();
                              address2Text.trim();
                              zipText.trimLeft();
                              zipText.trim();
                              if (_formKey.currentState!.validate()) {
                                if (selectedState != null &&
                                    selectedCity != null) {
                                  print('selectedCity $selectedCity');
                                  _btnController.start();
                                  if (await postMailingAddressData(
                                      _btnController)) {
                                    print('After SnackBar');
                                    print(
                                        'Save selected city for future search');
                                    DashboardHelpers.successStopAnimation(
                                        _btnController);
                                    SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    pref.setString(
                                        "city", selectedCity!.title.toString());

                                    context.pushNamed(
                                        SelectIdCardTypeScreen.routeName);
                                  } else {
                                    DashboardHelpers.errorStopAnimation(
                                        _btnController);
                                    DashboardHelpers.showAlert(
                                        msg: 'Something went wrong');
                                    // showCustomSnackBar(context, 'Sign Up Unsuccessful', Colors.red, snackBarNeutralTextStyle, localAnimationController);
                                  }
                                } else {
                                  DashboardHelpers.errorStopAnimation(
                                      _btnController);
                                  DashboardHelpers.showAlert(
                                      msg: 'Please select state and city');
                                }
                              }
                            },
                            label: 'Next',
                            buttonColor: buttonClr,
                            fontColor: buttonFontClr,
                            borderRadius: 50,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TopCurvedBottomSheet extends StatefulWidget {
  @override
  _TopCurvedBottomSheetState createState() => _TopCurvedBottomSheetState();

  List<StateModel> dataList = [];
  bool? isState;

  TopCurvedBottomSheet({super.key, required this.dataList, this.isState});
}

class _TopCurvedBottomSheetState extends State<TopCurvedBottomSheet> {
  final TextEditingController _searchController = TextEditingController();

  //List<String> items = ['Apple', 'Banana', 'Cherry', 'Date', 'Fig', 'Grape', 'Kiwi', 'Lemon', 'Mango', 'Orange'];
  List<StateModel> filteredItems = [];

  @override
  void initState() {
    filteredItems.addAll(widget.dataList);
    super.initState();
  }

  void _search(String query) {
    setState(() {
      filteredItems = widget.dataList
          .where((item) =>
              item.title.toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height / 1.5,
      padding: EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0XFFE9E9E9),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _search,
                decoration: InputDecoration(
                  hintText: widget.isState == true
                      ? 'Search your state...'
                      : 'Search your city...',
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          margin: const EdgeInsets.all(8),
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white),
                          child: const Icon(
                            Icons.arrow_back,
                            size: 26,
                          )),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              _searchController.clear();
                              filteredItems = widget.dataList;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: SvgPicture.asset(
                              'assets/svg/close.svg',
                              height: 16,
                              width: 16,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height / 1.5,
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  if (filteredItems.length > 0) {
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context, filteredItems[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              filteredItems[index].title ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 0.0, top: 12, left: 3, right: 3),
                              child: Container(
                                height: 1,
                                color: myColors.greyBg,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text('No City Found'),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
