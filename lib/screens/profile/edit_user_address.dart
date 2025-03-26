import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../helper_functions/colors.dart';
import '../../helper_functions/dashboard_helpers.dart';
import '../../models/state_model.dart';
import '../../provider/working_service_provider.dart';
import '../../widgets_reuse/bordered_textfield.dart';
import '../../widgets_reuse/custom_rounded_button.dart';
import '../registration/mailing_address_screen_2.dart';

class EditUserAddress extends StatefulWidget {
  const EditUserAddress({super.key});

  @override
  State<EditUserAddress> createState() => _EditUserAddressState();
}

class _EditUserAddressState extends State<EditUserAddress> {
  final _formKey = GlobalKey<FormState>(); // Form key to handle validation
  final TextEditingController _add1 = TextEditingController();
  final TextEditingController _add2 = TextEditingController();
  final TextEditingController _zipCon = TextEditingController();
  var selectedStateValue;
  StateModel? selectedState;
  StateModel? selectedCity;
  String? selectedStateTextId;
  late WorkingServiceProvider provider;
  bool callOnce = true;
  RoundedLoadingButtonController _controller = RoundedLoadingButtonController();

  @override
  void initState() {
    getAllData();
    super.initState();
  }

  @override
  void dispose() {
    _add1.dispose();
    _add2.dispose();
    _zipCon.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of(context, listen: false);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Address',
          style: interText(18, Colors.black, FontWeight.bold),
        ),
        surfaceTintColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Expanded(
              child: Consumer<WorkingServiceProvider>(
                builder: (context, pro, _) => pro.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: myColors.green,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 6.0, bottom: 6),
                                                  child: Text(
                                                    'Address Line 1',
                                                    style: interText(
                                                        16,
                                                        Colors.black,
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                                TextFieldBordered(
                                                  hintText: 'Address Line 1',
                                                  keyboard: TextInputType.text,
                                                  fieldTextFieldController:
                                                      _add1,
                                                  fillColor: textfieldClr,
                                                  inputFormat: [
                                                    //FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*$')),
                                                    // FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                                                  ],
                                                  funcValidate:
                                                      (value, setErrorInfo) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      setErrorInfo(true,
                                                          'address is required');
                                                      return '';
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                  funcOnChanged: (String? val) {
                                                    pro.updateAddressListDirectly(
                                                        {'line1': val});
                                                  },
                                                  borderRadius: 6,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 6.0, bottom: 6),
                                                  child: Text(
                                                    'Address Line 2',
                                                    style: interText(
                                                        16,
                                                        Colors.black,
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                                TextFieldBordered(
                                                  hintText: 'Address Line 2',
                                                  keyboard: TextInputType.text,
                                                  fieldTextFieldController:
                                                      _add2,
                                                  fillColor: textfieldClr,
                                                  inputFormat: [
                                                    //FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*$')),
                                                  ],
                                                  funcValidate:
                                                      (value, setErrorInfo) {
                                                    return null;

                                                    // if (value == null || value.isEmpty) {
                                                    //   setErrorInfo(true, 'price is required');
                                                    //   return '';
                                                    // } else {
                                                    //   return null;
                                                    // }
                                                  },
                                                  funcOnChanged: (String? val) {
                                                    pro.updateAddressListDirectly(
                                                        {'line2': val});
                                                  },
                                                  borderRadius: 6,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 6.0, bottom: 6),
                                        child: Text(
                                          'State',
                                          style: interText(16, Colors.black,
                                              FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 50,
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 3, 0, 3),
                                        decoration: BoxDecoration(
                                          color: textfieldClr,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2<StateModel>(
                                            isExpanded: true,
                                            hint: const Row(
                                              children: [
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Select State',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ))
                                                .toList(),
                                            value: selectedState,
                                            onChanged: (value) async {
                                              EasyLoading.show(
                                                  maskType: EasyLoadingMaskType
                                                      .black);
                                              setState(() {
                                                selectedCity = null;
                                                selectedState = value;
                                              });
                                              print(selectedState!.textId!);
                                              provider.cityModelList.clear();
                                              await provider
                                                  .getCityNameByStateTxtId(
                                                      selectedState!.textId ??
                                                          '');
                                              EasyLoading.dismiss();

                                              pro.updateAddressListDirectly({
                                                'state': selectedState!.title
                                              });
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              height: 56.h,
                                              // width: 160,
                                              padding: const EdgeInsets.only(
                                                  left: 0, right: 14),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: textfieldClr,
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
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 6.0, bottom: 6),
                                                  child: Text(
                                                    'City',
                                                    style: interText(
                                                        16,
                                                        Colors.black,
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    if (selectedState != null) {
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
                                                      ).then(
                                                        (value) {
                                                          setState(() {
                                                            selectedCity =
                                                                value;
                                                          });
                                                          pro.updateAddressListDirectly({
                                                            'city':
                                                                selectedCity!
                                                                    .title
                                                          });
                                                        },
                                                      );
                                                    } else {
                                                      DashboardHelpers.showAlert(
                                                          msg:
                                                              'Please select a State');
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 46,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8),
                                                    decoration: BoxDecoration(
                                                        color: textfieldClr,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                            color: Color(
                                                                0xFFE9E9E9),
                                                            width: 1)),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child: selectedCity ==
                                                                    null
                                                                ? Text(
                                                                    'Select City')
                                                                : Text(selectedCity!
                                                                        .title ??
                                                                    '')),
                                                        Icon(Icons
                                                            .keyboard_arrow_down_outlined),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 6.0, bottom: 6),
                                                  child: Text(
                                                    'Zip',
                                                    style: interText(
                                                        16,
                                                        Colors.black,
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                                TextFieldBordered(
                                                  hintText: 'Zipcode',
                                                  keyboard: TextInputType
                                                      .numberWithOptions(
                                                          decimal: true),
                                                  fieldTextFieldController:
                                                      _zipCon,
                                                  fillColor: textfieldClr,
                                                  inputFormat: [
                                                    //FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*$')),
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'^\d*\.?\d*$')),
                                                  ],
                                                  funcValidate:
                                                      (value, setErrorInfo) {
                                                    if (value == null ||
                                                        value.isEmpty ||
                                                        value.length < 4) {
                                                      setErrorInfo(
                                                          true, 'required');
                                                      return '';
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                  funcOnChanged: (String? val) {
                                                    pro.updateAddressListDirectly(
                                                        {'zip': val});
                                                  },
                                                  borderRadius: 6,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
            Consumer<WorkingServiceProvider>(
              builder: (context, provider, _) => Container(
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
                    funcName: provider.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              if (selectedCity != null) {
                                _controller.start();
                                var data = await provider.updateWorkerAddress();
                                if (data != null) {
                                  Navigator.pop(context);
                                }
                                _controller.stop();
                              } else {
                                DashboardHelpers.showAlert(
                                    msg: 'Please select city');
                              }
                            }
                          },
                    borderRadius: 8),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> setSelectedAddress(WorkingServiceProvider provider) async {
    provider.stateModelList.forEach((e) async {
      if (e.title == provider.workerAddressList.first.stateData) {
        setState(() {
          selectedState = e;
          _add1.text = provider.workerAddressList.first.addressLine1Data ?? '';
          _add2.text = provider.workerAddressList.first.addressLine2Data ?? '';
          _zipCon.text = provider.workerAddressList.first.zipData ?? '';
        });
        await provider.getCityNameByStateTxtId(selectedState!.textId ?? '');
        provider.cityModelList.forEach((e) {
          if (e.title == provider.workerAddressList.first.cityData) {
            setState(() {
              selectedCity = e;
            });
          }
        });
      }
    });

    debugPrint('provider.workerAddressList.first.addressLine1 ${selectedCity}');
  }

  void getAllData() async {
    var pro = context.read<WorkingServiceProvider>();
    pro.setLoading(true);
    pro.getWorkerAddressToUpdate().then((e) async {
      await pro.getStateByIsoCode();
      await setSelectedAddress(provider);
      pro.setLoading(false);
    });
  }
}
