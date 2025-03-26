import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/corporate/views/text_field.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../helper_functions/dashboard_helpers.dart';
import '../../../misc/constants.dart';
import '../../../models/state_model.dart';
import '../../../provider/working_service_provider.dart';
import '../screens/registration/mailing_address_screen_2.dart';

class CorporateMailingAddress extends StatefulWidget {
  const CorporateMailingAddress({super.key});

  @override
  State<CorporateMailingAddress> createState() =>
      _CorporateMailingAddressState();
}

class _CorporateMailingAddressState extends State<CorporateMailingAddress> {
  final TextEditingController address1TextFormController =
      TextEditingController();
  final TextEditingController address1TextFormController2 =
      TextEditingController();

  String address1Text = '';
  final _formAddress1Key = GlobalKey<FormState>();
  FocusNode focusNodeAddress1 = FocusNode();
  var isCheckAddress1 = null;

  final TextEditingController address2TextFormController =
      TextEditingController();
  final TextEditingController address2TextFormController2 =
      TextEditingController();
  String address2Text = '';
  final _formAddress2Key = GlobalKey<FormState>();
  FocusNode focusNodeAddress2 = FocusNode();
  var isCheckAddress2 = null;

  final TextEditingController cityTextFormController = TextEditingController();
  String cityText = '';
  String cityText2 = '';
  final _formCityKey = GlobalKey<FormState>();
  FocusNode focusNodeCity = FocusNode();
  var isCheckCity;

  final TextEditingController zipTextFormController = TextEditingController();
  final TextEditingController zipTextFormController2 = TextEditingController();
  String zipText = '';
  String zipText2 = '';
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  late WorkingServiceProvider provider;
  var isCheckZip;

  var selectedStateValue;
  StateModel? selectedState;
  StateModel? selectedState2;
  StateModel? selectedCity;
  StateModel? selectedCity2;
  String? selectedStateTextId;

  var isButtonLoading = false;

  bool isDone = false;
  bool callOnce = true;
  bool checkVal = false;

  RoundedLoadingButtonController _controller = RoundedLoadingButtonController();

  void dispose() {
    // TODO: implement dispose
    address1TextFormController.dispose();
    address1TextFormController2.dispose();
    address2TextFormController.dispose();
    address2TextFormController2.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
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
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 2,
                    color: myColors.green,
                  ),
                  flex: 2,
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
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Container(
                            color: Color(0xFFF7F7F7),
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Corporation \nAddress',
                                  style: interText(
                                      24, Colors.black, FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Provide your corporation\'s address for enhanced service accuracy.',
                                  style: interText(
                                      14, myColors.greyTxt, FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Address Line 1*',
                                  style: text_16_black_600_TextStyle,
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                CustomTextFormField(
                                  hintText: 'Address',
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
                                  style: text_16_black_600_TextStyle,
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                CustomTextFormField(
                                  hintText: 'Address',
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
                                  style: text_16_black_600_TextStyle,
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                FormField<StateModel>(
                                  validator: (value) {
                                    if (selectedState == null) {
                                      return 'Please select a state';
                                    }
                                    return null;
                                  },
                                  builder: (FormFieldState<StateModel> state) {
                                    return Container(
                                      width: double.infinity,
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                      decoration: BoxDecoration(
                                        color: textfieldClr,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child:
                                                  DropdownButton2<StateModel>(
                                                isExpanded: true,
                                                hint: Row(
                                                  children: [
                                                    SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        'Select State',
                                                        style: TextStyle(
                                                          color:
                                                              myColors.greyTxt,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                items: provider.stateModelList
                                                    .map((StateModel item) =>
                                                        DropdownMenuItem<
                                                            StateModel>(
                                                          value: item,
                                                          child: Text(
                                                            item.title ?? '',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ))
                                                    .toList(),
                                                value: selectedState,
                                                onChanged: (value) async {
                                                  EasyLoading.show(
                                                      maskType:
                                                          EasyLoadingMaskType
                                                              .black);
                                                  setState(() {
                                                    selectedCity = null;
                                                    selectedState = value;
                                                  });
                                                  print(selectedState!.textId!);
                                                  provider.cityModelList
                                                      .clear();
                                                  await provider
                                                      .getCityNameByStateTxtId(
                                                          selectedState!
                                                                  .textId ??
                                                              '');
                                                  EasyLoading.dismiss();
                                                  state.didChange(
                                                      value); // Notify the FormField about the change
                                                },
                                                buttonStyleData:
                                                    ButtonStyleData(
                                                  height: 58.h,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0, right: 14),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: Colors.white,
                                                  ),
                                                  elevation: 0,
                                                ),
                                                iconStyleData:
                                                    const IconStyleData(
                                                  icon: Icon(Icons
                                                      .keyboard_arrow_down),
                                                  iconEnabledColor:
                                                      Colors.black,
                                                  iconDisabledColor:
                                                      Colors.grey,
                                                ),
                                                dropdownStyleData:
                                                    DropdownStyleData(
                                                  maxHeight: 300,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color: textfieldClr,
                                                  ),
                                                  offset: const Offset(0, 0),
                                                  scrollbarTheme:
                                                      ScrollbarThemeData(
                                                    radius:
                                                        const Radius.circular(
                                                            40),
                                                    thickness:
                                                        WidgetStateProperty.all(
                                                            6),
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
                                              decoration: BoxDecoration(
                                                color: textfieldClr,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: state.hasError
                                                      ? Colors.red
                                                      : Colors
                                                          .transparent, // Red border if there's an error
                                                  width:
                                                      1.0, // Thickness of the border
                                                ),
                                              ),
                                            ),
                                            if (state.hasError)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 14.0, top: 8),
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
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'City',
                                            style: text_16_black_600_TextStyle,
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          FormField<StateModel>(
                                            validator: (value) {
                                              if (selectedCity == null) {
                                                return 'City required';
                                              }
                                              return null;
                                            },
                                            builder: (FormFieldState<StateModel>
                                                state) {
                                              return Column(
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (selectedState !=
                                                            null) {
                                                          showModalBottomSheet<
                                                              StateModel>(
                                                            context: context,
                                                            isScrollControlled:
                                                                true,
                                                            builder: (context) {
                                                              return TopCurvedBottomSheet(
                                                                  dataList: provider
                                                                      .cityModelList);
                                                            },
                                                          ).then((value) {
                                                            // Update the FormField's internal state after city selection
                                                            if (value != null) {
                                                              setState(() {
                                                                selectedCity =
                                                                    value;
                                                                state.didChange(
                                                                    value);
                                                              });
                                                              // This removes the error state if a city is selected
                                                            }
                                                          });
                                                        } else {
                                                          DashboardHelpers
                                                              .showAlert(
                                                                  msg:
                                                                      'Please select a State');
                                                        }
                                                      },
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 50,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 12,
                                                                right: 8),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                            color: state
                                                                    .hasError
                                                                ? Colors.red
                                                                : Colors
                                                                    .transparent, // Red border if there's an error
                                                            width:
                                                                1.0, // Thickness of the border
                                                          ),
                                                        ),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child:
                                                            selectedCity == null
                                                                ? Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        'Select City',
                                                                        style: TextStyle(
                                                                            color:
                                                                                myColors.greyTxt,
                                                                            fontWeight: FontWeight.w500),
                                                                      ),
                                                                      Icon(Icons
                                                                          .keyboard_arrow_down),
                                                                    ],
                                                                  )
                                                                : Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        selectedCity!.title ??
                                                                            '',
                                                                        style: TextStyle(
                                                                            color:
                                                                                myColors.greyTxt,
                                                                            fontWeight: FontWeight.w500),
                                                                      ),
                                                                      Icon(Icons
                                                                          .keyboard_arrow_down),
                                                                    ],
                                                                  ),
                                                      ),
                                                    ),
                                                  ),
                                                  if (state.hasError)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 14.0,
                                                              top: 8),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Zip',
                                            style: text_16_black_600_TextStyle,
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          CustomTextFormField(
                                            hintText: 'Enter Zip',
                                            controller: zipTextFormController,
                                            keyboardType: TextInputType.number,
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
                          ),
                        ),
                        Container(
                          height: 10,
                          color: Colors.white,
                        ),
                        Container(
                          color: Color(0xFFF7F7F7),
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: Form(
                            key: _formKey2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                    Text('Same as before')
                                  ],
                                ),
                                if (checkVal)
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Address Line 1*',
                                        style: text_16_black_600_TextStyle,
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      CustomTextFormField(
                                        hintText: 'Address',
                                        textInputFormatter: [
                                          LengthLimitingTextInputFormatter(40),
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[a-zA-Z0-9\s.,]')),
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
                                        style: text_16_black_600_TextStyle,
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      CustomTextFormField(
                                        hintText: 'Address',
                                        controller: address2TextFormController2,
                                        textInputFormatter: [
                                          LengthLimitingTextInputFormatter(40),
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'[a-zA-Z0-9\s.,]')),
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
                                        style: text_16_black_600_TextStyle,
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      FormField<StateModel>(
                                        validator: (value) {
                                          if (selectedState == null) {
                                            return 'Please select a state';
                                          }
                                          return null;
                                        },
                                        builder:
                                            (FormFieldState<StateModel> state) {
                                          return Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 3, 0, 3),
                                            decoration: BoxDecoration(
                                              color: textfieldClr,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: DropdownButton2<
                                                        StateModel>(
                                                      isExpanded: true,
                                                      hint: Row(
                                                        children: [
                                                          SizedBox(width: 4),
                                                          Expanded(
                                                            child: Text(
                                                              'Select State',
                                                              style: TextStyle(
                                                                color: myColors
                                                                    .greyTxt,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      items: provider
                                                          .stateModelList
                                                          .map((StateModel
                                                                  item) =>
                                                              DropdownMenuItem<
                                                                  StateModel>(
                                                                value: item,
                                                                child: Text(
                                                                  item.title ??
                                                                      '',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ))
                                                          .toList(),
                                                      value: selectedState2,
                                                      onChanged: (value) async {
                                                        EasyLoading.show(
                                                            maskType:
                                                                EasyLoadingMaskType
                                                                    .black);
                                                        setState(() {
                                                          selectedCity2 = null;
                                                          selectedState2 =
                                                              value;
                                                        });
                                                        print(selectedState2!
                                                            .textId!);
                                                        provider.cityModelList
                                                            .clear();
                                                        await provider
                                                            .getCityNameByStateTxtId(
                                                                selectedState!
                                                                        .textId ??
                                                                    '');
                                                        EasyLoading.dismiss();
                                                        state.didChange(
                                                            value); // Notify the FormField about the change
                                                      },
                                                      buttonStyleData:
                                                          ButtonStyleData(
                                                        height: 58.h,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 0,
                                                                right: 14),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          color: Colors.white,
                                                        ),
                                                        elevation: 0,
                                                      ),
                                                      iconStyleData:
                                                          const IconStyleData(
                                                        icon: Icon(Icons
                                                            .keyboard_arrow_down),
                                                        iconEnabledColor:
                                                            Colors.black,
                                                        iconDisabledColor:
                                                            Colors.grey,
                                                      ),
                                                      dropdownStyleData:
                                                          DropdownStyleData(
                                                        maxHeight: 300,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          color: textfieldClr,
                                                        ),
                                                        offset:
                                                            const Offset(0, 0),
                                                        scrollbarTheme:
                                                            ScrollbarThemeData(
                                                          radius: const Radius
                                                              .circular(40),
                                                          thickness:
                                                              WidgetStateProperty
                                                                  .all(6),
                                                          thumbVisibility:
                                                              WidgetStateProperty
                                                                  .all(true),
                                                        ),
                                                      ),
                                                      menuItemStyleData:
                                                          MenuItemStyleData(
                                                        height: 40,
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 14,
                                                                right: 14),
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: textfieldClr,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        color: state.hasError
                                                            ? Colors.red
                                                            : Colors
                                                                .transparent, // Red border if there's an error
                                                        width:
                                                            1.0, // Thickness of the border
                                                      ),
                                                    ),
                                                  ),
                                                  if (state.hasError)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 14.0,
                                                              top: 8),
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
                                              ),
                                            ),
                                          );
                                        },
                                      ),
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
                                                  style:
                                                      text_16_black_600_TextStyle,
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                FormField<StateModel>(
                                                  validator: (value) {
                                                    if (selectedState2 ==
                                                        null) {
                                                      return 'city required';
                                                    }
                                                    return null;
                                                  },
                                                  builder: (FormFieldState<
                                                          StateModel>
                                                      state) {
                                                    return Column(
                                                      children: [
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: InkWell(
                                                            onTap: () {
                                                              if (selectedState2 !=
                                                                  null) {
                                                                showModalBottomSheet<
                                                                    StateModel>(
                                                                  context:
                                                                      context,
                                                                  isScrollControlled:
                                                                      true,
                                                                  builder:
                                                                      (context) {
                                                                    return TopCurvedBottomSheet(
                                                                        dataList:
                                                                            provider.cityModelList);
                                                                  },
                                                                ).then(
                                                                  (value) {
                                                                    setState(
                                                                        () {
                                                                      selectedCity2 =
                                                                          value;
                                                                    });
                                                                  },
                                                                );
                                                              } else {
                                                                DashboardHelpers
                                                                    .showAlert(
                                                                        msg:
                                                                            'Please select a State');
                                                              }
                                                            },
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              height: 50,
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 12,
                                                                      right: 8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                border:
                                                                    Border.all(
                                                                  color: state
                                                                          .hasError
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .transparent, // Red border if there's an error
                                                                  width:
                                                                      1.0, // Thickness of the border
                                                                ),
                                                              ),
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child:
                                                                  selectedCity2 ==
                                                                          null
                                                                      ? Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              'Select City',
                                                                              style: TextStyle(color: myColors.greyTxt, fontWeight: FontWeight.w500),
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
                                                                              style: TextStyle(color: myColors.greyTxt, fontWeight: FontWeight.w500),
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
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 14.0,
                                                                    top: 8),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  state
                                                                      .errorText!,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        12,
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Zip',
                                                  style:
                                                      text_16_black_600_TextStyle,
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                CustomTextFormField(
                                                  hintText: 'Enter Zip',
                                                  controller:
                                                      zipTextFormController2,
                                                  textInputFormatter: [
                                                    LengthLimitingTextInputFormatter(
                                                        10),
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp(r'[0-9]')),
                                                  ],
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
                                    ],
                                  ),
                                SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
              child: CustomRoundedButton(
                  height: 44,
                  controller: _controller,
                  label: 'Next',
                  buttonColor: myColors.green,
                  fontColor: Colors.white,
                  funcName: () async {
                    final data = [
                      {
                        "addressLine1": address1TextFormController.text.trim(),
                        "addressLine2": address2TextFormController.text.trim(),
                        "cityData": selectedCity!.title,
                        "stateData": selectedState!.title,
                        "zipData": zipTextFormController.text.trim(),
                        "type": "Default Address"
                      },
                      {
                        "addressLine1": checkVal
                            ? address1TextFormController2.text.trim()
                            : address1TextFormController.text.trim(),
                        "addressLine2": checkVal
                            ? address2TextFormController2.text.trim()
                            : address2TextFormController.text.trim(),
                        "cityData": checkVal
                            ? selectedCity2!.title
                            : selectedCity!.title,
                        "stateData": checkVal
                            ? selectedState2!.title
                            : selectedState!.title,
                        "zipData": checkVal
                            ? zipTextFormController2.text.trim()
                            : zipTextFormController.text.trim(),
                        "type": "Secondary Address"
                      },
                    ];
                    debugPrint(data.toString());
                  },
                  borderRadius: 8),
            ),
          ],
        ),
      ),
    );
  }
}
