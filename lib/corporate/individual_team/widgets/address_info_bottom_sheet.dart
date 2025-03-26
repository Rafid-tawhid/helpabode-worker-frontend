import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/models/address_verification.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../../../../../helper_functions/colors.dart';
import '../../../../../helper_functions/dashboard_helpers.dart';
import '../../../../../misc/constants.dart';
import '../../../../../models/state_model.dart';
import '../../../../../provider/user_provider.dart';
import '../../../../../provider/working_service_provider.dart';
import '../../../../../widgets_reuse/custom_rounded_button.dart';
import '../../../screens/registration/mailing_address_screen_2.dart';
import '../../views/text_field.dart';

Future<dynamic> addressInformationModalBottomSheet(
    BuildContext context, AddressVerification addessInfo) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return AddressInformationForm(addessInfo);
    },
  );
}

class AddressInformationForm extends StatefulWidget {
  AddressVerification addessInfo;

  AddressInformationForm(this.addessInfo);

  @override
  _AddressInformationFormState createState() => _AddressInformationFormState();
}

class _AddressInformationFormState extends State<AddressInformationForm> {
  final TextEditingController address1TextFormController =
      TextEditingController();
  final TextEditingController address2TextFormController =
      TextEditingController();
  final TextEditingController cityTextFormController = TextEditingController();
  final TextEditingController zipTextFormController = TextEditingController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();

  StateModel? selectedState;
  StateModel? selectedCity;

  late WorkingServiceProvider provider;
  bool callOnce = true;

  @override
  void initState() {
    address1TextFormController.text = widget.addessInfo.addressLine1Data ?? '';
    address2TextFormController.text = widget.addessInfo.addressLine2Data ?? '';
    zipTextFormController.text = widget.addessInfo.zipData ?? '';
    selectedCity = StateModel(
        textId: widget.addessInfo.cityData, title: widget.addessInfo.cityData);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of<WorkingServiceProvider>(context);
    if (callOnce) {
      // Set the initial selected state based on widget.addessInfo.stateData
      if (widget.addessInfo.stateData != null) {
        var matchingState = provider.stateModelList.firstWhere(
          (e) => e.title == widget.addessInfo.stateData,
          orElse: () => StateModel(textId: '', title: 'Select State'),
        );
        debugPrint('Select 2 ${matchingState.textId}');

        if (matchingState.textId!.isNotEmpty) {
          selectedState = matchingState;
          //selectedCity = matchingState;
        }
      }
      callOnce = false;
    }
    super.didChangeDependencies();
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
            maxChildSize: 1,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 24),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mailing Address',
                                style: text_20_black_600_TextStyle),
                            const SizedBox(height: 24),
                            Text('Address Line 1*',
                                style: text_16_black_600_TextStyle),
                            const SizedBox(height: 12),
                            CustomTextFormField(
                              controller: address1TextFormController,
                              fillColor: Colors.grey.shade50,
                              hintText: 'Enter Address Line 1',
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Address is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            Text('Address Line 2',
                                style: text_16_black_600_TextStyle),
                            const SizedBox(height: 12),
                            CustomTextFormField(
                              controller: address2TextFormController,
                              fillColor: Colors.grey.shade50,
                              hintText: 'Enter Address Line 2',
                            ),
                            const SizedBox(height: 12),
                            Text('State', style: text_16_black_600_TextStyle),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              height: 50,
                              padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<StateModel>(
                                  isExpanded: true,
                                  hint: const Row(
                                    children: [
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          'Select State',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  items: provider.stateModelList
                                      .map((StateModel item) =>
                                          DropdownMenuItem<StateModel>(
                                            value: item,
                                            child: Text(
                                              item.title ?? '',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedState,
                                  onChanged: (value) async {
                                    EasyLoading.show(
                                        maskType: EasyLoadingMaskType.black);
                                    setState(() {
                                      selectedCity = null;
                                      selectedState = value;
                                    });
                                    await provider.getCityNameByStateTxtId(
                                        selectedState!.textId ?? '');
                                    EasyLoading.dismiss();
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 56.h,
                                    padding: const EdgeInsets.only(
                                        left: 0, right: 14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey.shade50,
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
                                      borderRadius: BorderRadius.circular(8),
                                      color: textfieldClr,
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
                                    padding:
                                        EdgeInsets.only(left: 14, right: 14),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('City',
                                          style: text_16_black_600_TextStyle),
                                      SizedBox(height: 13.h),
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
                                            ).then((value) {
                                              setState(() {
                                                selectedCity = value;
                                              });
                                            });
                                          } else {
                                            DashboardHelpers.showAlert(
                                                msg: 'Please select a State');
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 50,
                                          padding: EdgeInsets.only(
                                              left: 12, right: 8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.grey.shade50,
                                          ),
                                          alignment: Alignment.centerLeft,
                                          child: selectedCity == null
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text('Select City',
                                                        style: TextStyle(
                                                            color: myColors
                                                                .greyTxt,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
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
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
                                                    Icon(Icons
                                                        .keyboard_arrow_down),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Zip',
                                          style: text_16_black_600_TextStyle),
                                      SizedBox(height: 13.h),
                                      CustomTextFormField(
                                        controller: zipTextFormController,
                                        fillColor: Colors.grey.shade50,
                                        hintText: 'Enter Zip',
                                        validator: (val) {
                                          if (val == null || val.isEmpty) {
                                            return 'Zipcode is required';
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
                      ),
                    ],
                  ),
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
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 8,
                    offset: Offset(0, -4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Consumer<UserProvider>(
                  builder: (context, provider, _) => CustomRoundedButton(
                    height: 44,
                    label: 'Save & Update',
                    buttonColor: myColors.green,
                    fontColor: Colors.white,
                    funcName: () async {
                      if (_formKey.currentState!.validate() &&
                          selectedCity != null &&
                          selectedState != null) {
                        // Handle save and update logic here

                        _btnController.start();
                        debugPrint(
                            'Address 1 ${address1TextFormController.text}');
                        debugPrint(
                            'Address 2 ${address2TextFormController.text}');
                        debugPrint('Zip ${zipTextFormController.text}');
                        debugPrint('selectedCity ${selectedCity!.title}');
                        debugPrint('selectedState ${selectedState!.title}');

                        var data = {
                          "textId": textId,
                          "zipData": zipTextFormController.text,
                          "addressLine1Data": address1TextFormController.text,
                          "addressLine2Data": address2TextFormController.text,
                          "cityData": selectedCity!.title ?? '',
                          "stateData": selectedState!.title ?? '',
                        };

                        provider.updateMailingInfo(data).then((val) {
                          _btnController.stop();
                          Navigator.pop(context);
                        });
                      } else {
                        DashboardHelpers.showAlert(
                            msg: 'PLease select state and city');
                      }
                    },
                    borderRadius: 8,
                    controller: _btnController,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
