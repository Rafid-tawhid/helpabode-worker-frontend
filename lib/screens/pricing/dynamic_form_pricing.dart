import 'dart:convert';
import 'dart:core';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/pricing_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/pricing/pricing_preview.dart';
import 'package:provider/provider.dart';

import '../../models/pending_requested_servicelist.dart';
import '../../models/pricing_attribute_model_new.dart';
import '../../models/pricing_model_attributes.dart';
import '../../widgets_reuse/bordered_textfield.dart';
import '../../widgets_reuse/expandable_text.dart';
import '../myservice/my_services_screen.dart';
import 'dynamic_form_widgets/list_item_field.dart';
import 'dynamic_form_widgets/text_field_area.dart';

GlobalKey<FormState> _formKeyDynamicAttributeStyleSystemView = GlobalKey<FormState>();

void resetKey() {
  debugPrint('_formKeyDynamicAttributeStyleSystemView ${_formKeyDynamicAttributeStyleSystemView}');
  _formKeyDynamicAttributeStyleSystemView = GlobalKey<FormState>();
}

class DynamicFromPricing extends StatefulWidget {
  final PendingRequestedServiceList service;

  DynamicFromPricing(this.service);

  @override
  State<DynamicFromPricing> createState() => _DynamicFromPricingState();
}

class _DynamicFromPricingState extends State<DynamicFromPricing> {
  List<GlobalKey<FormState>> formKeyList = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  late PricingProvider provider;
  bool callOnce = true;
  String selectedHour = '0';
  String selectedPlan = 'Basic';
  String planTextId = 'Basic';
  String minimumPrice = '';
  String description = '';
  ZoneList? selectedZone;
  int selectedIndex = 0;
  String rank = '';
  TextEditingController bundlePriceCon = TextEditingController();
  TextEditingController bundleDurationCon = TextEditingController();
  TextEditingController minimumPriceCon = TextEditingController();
  List<TextEditingController> attributePricingController = [];
  List<TextEditingController> durationController = [];
  List<FocusNode> focusNodeList = [];
  late FocusNode _focusNode;
  final GlobalKey myWidgetKey = GlobalKey();
  List<PricingAttribute> pricingAttributeList = [];
  PageController _pageController = PageController();

  @override
  void dispose() {
    _focusNode.dispose();
    attributePricingController.forEach((element) {
      element.dispose();
    });
    durationController.forEach((element) {
      element.dispose();
    });
    _scrollController.dispose();
    _pageController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // _scrollController.addListener(_handleScroll);
    _focusNode = FocusNode();
    //changed the key for multiple key ambgious error
    resetKey();
    //for selecting dropdown initially jan 29
    WidgetsBinding.instance.addPostFrameCallback((v) {
      selectDropdownInitially();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (callOnce) {
      provider = context.read<PricingProvider>();
      // //create controller
      // attributePricingController = List.generate(provider.attributeList.length, (_) => TextEditingController());
      focusNodeList = List.generate(provider.attributeList.length, (_) => FocusNode());
      // durationController = List.generate(provider.attributeList.length, (_) => TextEditingController());
      formKeyList = List.generate(provider.zoneNameList.length, (index) => GlobalKey<FormState>());
      // //define first rank
      rank = provider.planListForDropDown.first.rank.toString();
      selectedPlan = provider.planListForDropDown.first.planTitle ?? '';
      planTextId = provider.planListForDropDown.first.planTextId ?? '';
      //clear value map data
      provider.attributeListTesting.clear();
      callOnce = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    description = provider.planListForDropDown[0].servicePlanDescription ?? '';
    return WillPopScope(
      onWillPop: () async {
        // Disable the back button
        return true;
      },
      child: Scaffold(
        backgroundColor: CupertinoColors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            focusNodeList.forEach((element) {
              element.unfocus();
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: MediaQuery.of(context).padding.top + 10,
                    color: myColors.green,
                  ),
                  Container(
                    color: myColors.green,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 8),
                      child: Row(
                        children: [
                          InkWell(
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 28,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          Expanded(
                            child: Text(
                              provider.serviceInfo.serviceName ?? 'Service Pricing',
                              style: interText(18, Colors.white, FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isKeyboardOpen) HeaderInfo(context, provider),
                  if (provider.planListForDropDown.first.planTextId != 'AdminDefaultPlan' && provider.planListForDropDown.first.planTextId != 'AdminBundlePlan') HorizontalPlanList(provider, context),
                ],
              ),
              // if(planListForDropDown.first.planTextId=='AdminBundlePlan')ServiceAttribute(serviceJsonList: widget.service)
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Form(
                    key: _formKey,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //LEVEL Details is separated for scrolling problem
                          if (!isKeyboardOpen)
                            if (provider.planListForDropDown.first.planTextId != 'AdminDefaultPlan')
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8),
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  decoration: BoxDecoration(color: myColors.greyBg, borderRadius: BorderRadius.circular(8)),
                                  padding: EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ExpandText(
                                        text: provider.planListForDropDown[selectedIndex].servicePlanDescription ?? '',
                                        maxLines: 4,
                                        position: true,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8, bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Select Zone For Pricing',
                                  style: interText(16, Colors.black, FontWeight.bold),
                                ),
                                if (selectedZone == null)
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0, top: 8),
                                        child: Image.asset(
                                          'assets/svg/arrow.gif',
                                          color: myColors.green,
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: null,
                                          icon: Icon(
                                            Icons.compare_arrows_sharp,
                                            color: Colors.transparent,
                                          ))
                                    ],
                                    mainAxisSize: MainAxisSize.min,
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Expanded(child: SelectZoneDropdown()),
                              if (provider.serviceInfo.pricingBy != 'Bundle')
                                IconButton(
                                    onPressed: () {
                                      if (selectedZone != null) {
                                        _showBottomSheet(context, selectedZone!.zoneTitle!, selectedPlan, _updateCurrentZone);
                                      }
                                    },
                                    icon: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: myColors.greyBtn, width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6),
                                          child: Text('Same as'),
                                        )))
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          // if (selectedZone != null) provider.serviceInfo.pricingBy == 'Bundle' ? BundleServiceWidget(provider, context) : DynamicFromBuilder(provider, context)
                          if (selectedZone != null)
                            provider.serviceInfo.pricingBy == 'Bundle'
                                ? BundleServiceWidget(provider, context)
                                : provider.showLoadingTextFields
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: myColors.green,
                                        ),
                                      )
                                    : DynamicAttributeStyleSystemView()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container HeaderInfo(BuildContext context, PricingProvider provider) {
    return Container(
      color: myColors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: myColors.green,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Pricing by: ',
                            style: interText(16, Colors.white, FontWeight.bold),
                            children: [
                              TextSpan(
                                text: '(${provider.getTopPricingValue(provider.serviceInfo.pricingBy)})',
                                style: interText(16, Colors.white, FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        DashboardHelpers.showServiceDetailsBottomSheet(context: context, service: widget.service, serviceInfo: provider.serviceInfo, attributeList: provider.attributeList);
                      },
                      //Area/Size
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 14),
                          child: Text(
                            'View Details',
                            style: interText(14, Colors.black, FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // AnimatedOpacity(
                //   duration: Duration(milliseconds: 300), // Smooth fade duration
                //   opacity: _widgetOpacity,
                //   child: ExpandText(text:'Details: ${widget.service.shortDescription}', maxLines: 3,txtColor: Colors.white,seeMoreColor: Colors.white,showOpacity: false,end: 'end',),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding BundleServiceWidget(PricingProvider provider, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bundle Options',
                style: interText(16, Colors.black, FontWeight.bold),
              ),
              if (provider.pricingStatus == 'Rejected')
                InkWell(
                  onTap: () {
                    DashboardHelpers.showAnimatedDialog(context, provider.rejectedNotes, 'Price Rejected');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      'Rejected',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 6.0),
                      child: Text('Enter Price'),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    TextFieldBordered(
                      hintText: 'Price',
                      keyboard: TextInputType.numberWithOptions(decimal: true),
                      fieldTextFieldController: bundlePriceCon,
                      inputFormat: [
                        //FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*$')),
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                      ],
                      funcValidate: (value, setErrorInfo) {
                        if (value == null || value.isEmpty) {
                          setErrorInfo(true, 'price is required');
                          return '';
                        } else {
                          return null;
                        }
                      },
                      funcOnChanged: (String? val) {},
                      borderRadius: 6,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 6.0),
                      child: Text('Est. Time'),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    TextFieldBordered(
                      hintText: 'ex. 33 min',
                      keyboard: TextInputType.numberWithOptions(decimal: true),
                      fieldTextFieldController: bundleDurationCon,
                      inputFormat: [
                        //FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*$')),
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                      ],
                      funcValidate: (value, setErrorInfo) {
                        if (value == null || value.isEmpty) {
                          setErrorInfo(true, 'required');
                          return '';
                        } else {
                          return null;
                        }
                      },
                      funcOnChanged: (String? val) {},
                      borderRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(''),
              // InkWell(
              //   onTap: () async {
              //     goToPricingViewDetailsScreen(provider.serviceInfo, provider.planListForDropDown[selectedIndex]);
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Container(
              //         decoration: BoxDecoration(
              //           color: Color(0xffE9E9E9),
              //           borderRadius: BorderRadius.circular(6),
              //         ),
              //         padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              //         child: const Text(
              //           'Preview',
              //           style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
              //         )),
              //   ),
              // ),
              InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    dynamic planSet = [];
                    String price = bundlePriceCon.text.trim();
                    String duration = bundleDurationCon.text.trim();
                    planSet.add({"price": price, "estTime": duration});
                    //make a json to save dynamic data
                    var data = {
                      "pricingZones": [
                        {
                          "areaName": "${selectedZone!.zoneTitle}",
                          "areaTextId": "${selectedZone!.zoneTextId}",
                          // "duration": "${selectedHour}",
                          "planSet": [
                            {
                              "planName": "$planTextId",
                              "planTextId": "${planTextId}",
                              "rank": "${rank}",
                              "minimumPrice": price,
                              "priceStatus": provider.pricingStatus,
                              "rejectedNotes": "",
                              "rejectedDate": "",
                              "providerPricing": provider.getTopPricingValue(provider.serviceInfo.pricingBy) == 'Area/Size' ? 'Sqft' : provider.getTopPricingValue(provider.serviceInfo.pricingBy),
                              "estTime": duration
                            }
                          ],
                        }
                      ]
                    };
                    var item = '${jsonEncode(data)}';
                    // print('planSet $item');
                    EasyLoading.show(maskType: EasyLoadingMaskType.black);
                    if (await provider.savePricingByZone(item, provider.serviceInfo.serviceTextId, planTextId, selectedZone!.zoneTextId ?? '', provider.serviceInfo.categoryTextId ?? '', context)) {
                      // //go to next step after for last service plan item
                      //because bundle have only one plan
                      //move to my service
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyServicesScreen()));

                      // if (selectedIndex + 1 == planListForDropDown.length) {
                      //   EasyLoading.show(maskType: EasyLoadingMaskType.black);
                      //   debugPrint('provider.loadingList 1 ${provider.loadingList}');
                      //   if (await provider.getPricingServiceViewDetails(provider.serviceInfo.serviceTextId, 'Requested')) {
                      //     // provider.isLoadingViewDetails(index, false);
                      //
                      //     provider.getPlanwizeServiceAreaInfoNew(planTextId ?? '');
                      //     EasyLoading.dismiss();
                      //     debugPrint('provider.loadingList 2${provider.loadingList}');
                      //     // Navigator.push(context, MaterialPageRoute(builder: (context) => RequestedServiceDetailsScreen(provider.requestedListFinal.first)));
                      //   } else {
                      //     EasyLoading.dismiss();
                      //   }
                      // }
                    }
                    EasyLoading.dismiss();
                  } else {
                    print('All fields are required');
                    DashboardHelpers.showAlert(msg: 'All fields are required');
                  }

                  ///
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Color(0xffE9E9E9),
                      color: myColors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: Consumer<PricingProvider>(
                      builder: (context, pro, _) => Text(
                        pro.pricingScreenButtonStatus,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              height: 10,
              color: const Color(0xffF6F6F6),
            ),
          ),
        ],
      ),
    );
  }

  Padding SelectZoneDropdown() {
    var pp = context.read<PricingProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
        decoration: BoxDecoration(
          color: textfieldClr,
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<ZoneList>(
            isExpanded: true,
            hint: const Row(
              children: [
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    'Select Zone',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: pp.zoneListForDropDown
                .toSet()
                .toList()
                .map((ZoneList item) => DropdownMenuItem<ZoneList>(
                      value: item,
                      child: Text(
                        item.zoneTitle ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            value: selectedZone,
            onChanged: (value) async {
              var provider = context.read<PricingProvider>();
              setState(() {
                selectedZone = value;
              });
              // Clear attribute list and fetch price configuration
              provider.showLoadingFields(true);

              await provider.getPriceConfiguration(
                serviceTextId: provider.serviceInfo.serviceTextId,
                plan: planTextId,
                zone: selectedZone!.zoneTextId,
                type: provider.serviceInfo.pricingBy,
                categoryTextId: provider.serviceInfo.categoryTextId,
              );
              provider.showLoadingFields(false);

              // Handle 'bundle' type pricing

              if (provider.serviceInfo.pricingBy!.toLowerCase() == 'bundle') {
                setState(() {
                  bundlePriceCon.text = provider.minimumPrice;
                  bundleDurationCon.text = provider.estTime == "null" ? '' : provider.estTime;
                });
              }
              // Handle other pricing types
              else {
                if (provider.minimumPrice.isNotEmpty || provider.minimumPrice == "") {
                  setState(() {
                    minimumPriceCon.text = provider.minimumPrice;
                  });
                }
              }
            },
            buttonStyleData: ButtonStyleData(
              height: 56.h,
              // width: 160,
              padding: const EdgeInsets.only(left: 0, right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                // border: Border.all(
                //   color: Colors.black26,
                // ),
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
            dropdownStyleData: DropdownStyleData(
              maxHeight: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: textfieldClr,
              ),
              offset: const Offset(0, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: WidgetStateProperty.all(6),
                thumbVisibility: WidgetStateProperty.all(true),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.only(left: 14, right: 14),
            ),
          ),
        ),
      ),
    );
  }

  //planListForDropDown.any((element) => element.planTitle!.length>10)?null:
  Container HorizontalPlanList(PricingProvider provider, BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Select Level',
              style: interText(16, Colors.black, FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(color: myColors.greyBtn, borderRadius: BorderRadius.circular(8)),
              alignment: Alignment.center,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.planListForDropDown.length,
                itemExtent: provider.planListForDropDown.length < 3 ? (MediaQuery.of(context).size.width / 2) - 16 : (MediaQuery.of(context).size.width / 3) - 8,
                itemBuilder: (context, index) => InkWell(
                  onTap: () async {
                    setState(() {
                      selectedZone = null;
                      rank = provider.planListForDropDown[index].rank.toString();
                      selectedIndex = index;
                      selectedPlan = provider.planListForDropDown[index].planTitle ?? '';
                      planTextId = provider.planListForDropDown[index].planTextId ?? '';
                      description = provider.planListForDropDown[index].servicePlanDescription ?? '';
                    });

                    debugPrint('selectedPlan 0${selectedPlan}');
                    debugPrint('planTextId 0${planTextId}');

                    // //get previous pricing values

                    //after selecting zone from dropdown
                    if (selectedZone != null) {
                      //get previse value and set
                      if (provider.serviceInfo.pricingBy == 'Bundle') {
                        provider.getBundlePreviousValue(selectedZone!, selectedPlan);
                        setState(() {
                          bundlePriceCon.text = provider.minimumPrice.toString();
                          bundleDurationCon.text = provider.bundleEstTime.toString();
                        });
                      } else {
                        //get previous pricing values
                        provider.getPreviousValue(selectedZone, planTextId);
                        //set previous pricing values
                        setPreviousValuesToTextfields();
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: index == selectedIndex ? Colors.white : myColors.greyBtn,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                provider.planListForDropDown[index].planTitle!.length > 12 ? truncateString(provider.planListForDropDown[index].planTitle ?? '') : provider.planListForDropDown[index].planTitle ?? '',
                                textAlign: TextAlign.center,
                                maxLines: 1, // Ensure that the text is displayed on a single line
                                overflow: TextOverflow.ellipsis, // Display "..." if the text overflows
                                style: GoogleFonts.inter(
                                  color: index == selectedIndex ? Colors.black : Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  dynamic _updateCurrentZone(ZoneList zone) async {
    provider.showLoadingFields(true);
    await provider.getPriceConfiguration(serviceTextId: provider.serviceInfo.serviceTextId, plan: planTextId, zone: zone.zoneTextId, type: 'Regular', categoryTextId: provider.serviceInfo.categoryTextId);
    provider.showLoadingFields(false);

    //set minimum value
    if (provider.minimumPrice.isNotEmpty || provider.minimumPrice == "") {
      setState(() {
        minimumPriceCon.text = provider.minimumPrice;
      });
    }
  }

  void _showBottomSheet(BuildContext context, String currentZone, String selectedPlan, _updateCurrentZone) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        final List<GetPlanList> planList = [];
        planList.addAll(provider.planListForDropDown);
        planList.removeWhere((e) => e.planTitle == selectedPlan);
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Same as price',
                    style: textField_16_black_bold_LabelTextStyle,
                    // Style as needed
                  ),

                  //this is for multiple zone
                  // Expanded(
                  //   child: ListView.builder(
                  //     itemCount: zoneListForDropDown.length,
                  //     itemBuilder: (context, index) {
                  //       return Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Card(
                  //           color: Colors.white,
                  //           child: ListTile(
                  //             onTap: () async {
                  //               //EasyLoading.show(maskType: EasyLoadingMaskType.black);
                  //               // await provider.getPriceConfiguration(
                  //               //   provider.serviceInfo.serviceTextId,
                  //               //   planTextId,
                  //               //   zoneListForDropDown[index].zoneTextId,
                  //               // );
                  //               // EasyLoading.dismiss();
                  //               // setState(() {
                  //               //   currentZone = zoneListForDropDown[index].zoneTitle ?? '';
                  //               //   selectedZone = zoneListForDropDown[index];
                  //               // });
                  //               _updateCurrentZone(zoneListForDropDown[index]);
                  //               Navigator.pop(context);
                  //             },
                  //             title: Text(
                  //               zoneListForDropDown[index].zoneTitle ?? '',
                  //               style: TextStyle(fontSize: 18.h),
                  //             ),
                  //             trailing: Container(
                  //               height: 20,
                  //               width: 20,
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(50),
                  //                 border: Border.all(color: Colors.grey),
                  //               ),
                  //               child: Container(
                  //                 height: 20,
                  //                 width: 20,
                  //                 padding: const EdgeInsets.all(2),
                  //                 decoration: BoxDecoration(
                  //                   color: zoneListForDropDown[index].zoneTitle == currentZone ? myColors.green : Colors.grey,
                  //                   borderRadius: BorderRadius.circular(50),
                  //                   border: Border.all(color: Colors.grey),
                  //                 ),
                  //               ),
                  //             ),
                  //             shape: RoundedRectangleBorder(
                  //               side: BorderSide(
                  //                 color: zoneListForDropDown[index].zoneTitle == currentZone ? myColors.green : myColors.greyBg,
                  //                 width: 0.5,
                  //               ),
                  //               borderRadius: BorderRadius.circular(8.0),
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  //upper is for multiple zone

                  Expanded(
                    child: ListView.builder(
                      itemCount: planList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.white,
                            child: ListTile(
                              onTap: () async {
                                var provider = context.read<PricingProvider>();

                                // Clear attribute list and fetch price configuration
                                provider.showLoadingFields(true);

                                await provider.getPriceConfiguration(
                                  serviceTextId: provider.serviceInfo.serviceTextId,
                                  plan: planList[index].planTextId,
                                  zone: selectedZone!.zoneTextId,
                                  type: provider.serviceInfo.pricingBy,
                                  categoryTextId: provider.serviceInfo.categoryTextId,
                                );
                                provider.showLoadingFields(false);

                                // Handle 'bundle' type pricing
                                if (provider.serviceInfo.pricingBy!.toLowerCase() == 'bundle') {
                                  setState(() {
                                    bundlePriceCon.text = provider.minimumPrice;
                                    bundleDurationCon.text = provider.estTime == "null" ? '' : provider.estTime;
                                  });
                                }
                                // Handle other pricing types
                                else {
                                  if (provider.minimumPrice.isNotEmpty || provider.minimumPrice == "") {
                                    setState(() {
                                      minimumPriceCon.text = provider.minimumPrice;
                                    });
                                  }
                                }
                                Navigator.pop(context);
                              },
                              title: Text(
                                planList[index].planTitle ?? '',
                                style: TextStyle(fontSize: 18.h),
                              ),
                              trailing: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: myColors.greyBtn,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void setPreviousValuesToTextfields() {
    setState(() {
      minimumPriceCon.text = provider.minimumPrice;
    });
  }

  String truncateString(String text) {
    if (text.length <= 12) {
      return text;
    } else {
      return text.substring(0, 12) + "..";
    }
  }

  Consumer DynamicAttributeStyleSystemView() {
    return Consumer<PricingProvider>(
      builder: (context, provider, _) => Column(
        children: [
          Form(
            key: _formKeyDynamicAttributeStyleSystemView,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 6.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Minimum Price',
                          style: interText(16, Colors.black, FontWeight.w500),
                        ),
                        Spacer(),
                        if (provider.pricingStatus == 'Rejected')
                          InkWell(
                            onTap: () {
                              DashboardHelpers.showAnimatedDialog(context, provider.rejectedNotes, 'Price Rejected');
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                'Rejected',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFieldBordered(
                    keyboard: TextInputType.numberWithOptions(decimal: true),
                    fieldTextFieldController: minimumPriceCon,
                    keys: '$selectedPlan${selectedZone!.zoneTextId}',
                    inputFormat: [
                      //FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*$')),
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                    ],
                    funcValidate: (value, setErrorInfo) {
                      if (value == null || value.isEmpty) {
                        setErrorInfo(true, 'Minimum Price is required');

                        //focusNodeEmail.requestFocus();
                        return '';
                      } else
                        return null;
                    },
                    funcOnChanged: (String? val) {
                      minimumPrice = val.toString();
                    },
                    borderRadius: 12,
                  ),
                  ListView.builder(
                    itemCount: provider.attributeList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final attribute = provider.attributeList[index];
                      if ((attribute.labelType == 'textarea' || attribute.labelType == 'number') && attribute.isPricing == 'Yes') {
                        return TextFieldArea(attribute, index, '${selectedZone!.zoneTextId ?? ''}${attribute.labelType}${selectedPlan}${attribute.textId}', selectedZone!, selectedPlan, provider);
                      } else if (attribute.labelType == 'listItem' && attribute.isPricing == 'Yes') {
                        //add a form key for validation
                        return ListItemField(attribute, index, '${selectedZone!.zoneTextId ?? ''}${attribute.labelType}${selectedPlan}${attribute.textId}}');
                      } else if (attribute.labelType == 'selectNumber' && attribute.isPricing == 'Yes') {
                        //add a form key for validation
                        return TextFieldArea(attribute, index, '${selectedZone!.zoneTextId ?? ''}${attribute.labelType}${selectedPlan}${attribute.textId}}', selectedZone!, selectedPlan, provider);
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Color(0xfff6f6f6), borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    attribute.title ?? '',
                                    style: interText(16, Colors.black, FontWeight.bold),
                                  ),
                                  if (attribute.options!.first.optionLabel != '')
                                    SizedBox(
                                      height: 6,
                                    ),
                                  if (attribute.options!.first.optionLabel != '')
                                    Container(
                                      height: 20,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) => Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [Text('${attribute.options![index].optionLabel}'), attribute.options!.length > 1 ? Text(' | ') : SizedBox()],
                                        ),
                                        itemCount: attribute.options!.length,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(''),
                // ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: myColors.greyBg,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(6.0), // Adjust the radius as needed
                //       ),
                //     ),
                //     onPressed: () async {
                //       goToPricingViewDetailsScreen(provider.serviceInfo, provider.planListForDropDown[selectedIndex]);
                //     },
                //     child: Text(
                //       'Preview',
                //       style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
                //     )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myColors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0), // Adjust the radius as needed
                      ),
                    ),
                    onPressed: () async {
                      // prepare data for sending

                      if (_formKeyDynamicAttributeStyleSystemView.currentState!.validate()) {
                        // var attributesValueMap = provider.attributesValueMap;
                        //
                        // List finalDataList = [];
                        //
                        // for (var item in provider.attributeList) {
                        //   var itemJson = item.toJson();
                        //   if (item.options!.length == 1) {
                        //     String mapKey = item.textId ?? '';
                        //     if (attributesValueMap.containsKey(mapKey)) {
                        //       itemJson["options"] = [attributesValueMap[mapKey]];
                        //     }
                        //     finalDataList.add(itemJson);
                        //   } else {
                        //     for (var i = 0; i < item.options!.length; i++) {
                        //       String mapKey = item.textId! + item.options![i].optionLabel!.toLowerCase().replaceAll(' ', '');
                        //       if (attributesValueMap.containsKey(mapKey)) {
                        //         itemJson["options"][i] = attributesValueMap[mapKey];
                        //       }
                        //     }
                        //     itemJson.forEach((key, value) {});
                        //     finalDataList.add(itemJson);
                        //   }
                        // }
                        var send_data = {
                          "pricingZones": [
                            {
                              "areaName": "${selectedZone!.zoneTitle}",
                              "areaTextId": "${selectedZone!.zoneTextId}",
                              // "duration": "${selectedHour}",
                              "planSet": [
                                {
                                  "planName": "$selectedPlan",
                                  "planTextId": "${planTextId}",
                                  "rank": "${rank}",
                                  "priceStatus": provider.pricingStatus,
                                  "rejectedNotes": "",
                                  "rejectedDate": "",
                                  "minimumPrice": minimumPriceCon.text.trim(),
                                  "providerPricing": provider.getTopPricingValue(provider.serviceInfo.pricingBy) == 'Area/Size' ? 'Sqft' : provider.getTopPricingValue(provider.serviceInfo.pricingBy),
                                  // "attributes": finalDataList,
                                  "attributes": provider.attributeListTesting,
                                }
                              ],
                            }
                          ]
                        };

                        //save date for something else
                        // provider.setPricingDataElse(finalDataList);

                        var send = '${jsonEncode(send_data)}';
                        // debugPrint('finalDataList ${send}');

                        EasyLoading.show(maskType: EasyLoadingMaskType.black);

                        if (await provider.savePricingByZone(send, provider.serviceInfo.serviceTextId, planTextId, selectedZone!.zoneTextId ?? '', provider.serviceInfo.categoryTextId ?? '', context)) {

                          //changed the key for multiple key ambgious error
                          setState(() {
                            resetKey();
                          });

                          // //go to next step after for last service plan item
                          if (selectedIndex + 1 == provider.planListForDropDown.length) {
                            //go to pricing view details screen
                            //goToPricingViewDetailsScreen(provider.serviceInfo,planListForDropDown[selectedIndex]);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyServicesScreen()));
                          } else {
                            //automatic select next level and other things
                            setState(() {
                              rank = provider.planListForDropDown[selectedIndex + 1].rank.toString();
                              selectedIndex = selectedIndex + 1;
                              selectedPlan = provider.planListForDropDown[selectedIndex].planTitle ?? '';
                              planTextId = provider.planListForDropDown[selectedIndex].planTextId ?? '';
                              description = provider.planListForDropDown[selectedIndex].servicePlanDescription ?? '';
                            });
                          }
                        }
                        EasyLoading.dismiss();
                      } else {
                        print('All fields are required');
                        DashboardHelpers.showAlert(msg: 'All fields are required');
                        scrollToTop();
                      }
                    },
                    child: Consumer<PricingProvider>(
                      builder: (context, pro, _) => Text(
                        pro.pricingScreenButtonStatus,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  void goToPricingViewDetailsScreen(ServiceInfo serviceInfo, GetPlanList planListForDropDown) async {
    var pp = context.read<PricingProvider>();
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await pp.getPricingServiceViewDetails(serviceInfo.serviceTextId, 'Requested', serviceInfo.categoryTextId);
    EasyLoading.dismiss();
    provider.getPlanwizeServiceAreaInfoNew(planTextId);
    Navigator.push(context, CupertinoPageRoute(builder: (context) => PricingPreview(serviceInfo)));
  }

  Future<void> selectDropdownInitially() async {
    Future.delayed((Duration.zero), () async {
      var provider = context.read<PricingProvider>();
      setState(() {
        selectedZone = provider.zoneList.first;
      });
      // Clear attribute list and fetch price configuration
      provider.showLoadingFields(true);

      await provider.getPriceConfiguration(
        serviceTextId: provider.serviceInfo.serviceTextId,
        plan: planTextId,
        zone: selectedZone!.zoneTextId,
        type: provider.serviceInfo.pricingBy,
        categoryTextId: provider.serviceInfo.categoryTextId,
      );
      provider.showLoadingFields(false);

      // Handle 'bundle' type pricing

      if (provider.serviceInfo.pricingBy!.toLowerCase() == 'bundle') {
        setState(() {
          bundlePriceCon.text = provider.minimumPrice;
          bundleDurationCon.text = provider.estTime == "null" ? '' : provider.estTime;
        });
      }
      // Handle other pricing types
      else {
        if (provider.minimumPrice.isNotEmpty || provider.minimumPrice == "") {
          setState(() {
            minimumPriceCon.text = provider.minimumPrice;
          });
        }
      }
    });
  }
}

class ReversedTrianglePainter extends CustomPainter {
  int index;
  int selectedIndex;

  ReversedTrianglePainter(this.index, this.selectedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = index == selectedIndex ? Colors.white : Color(0xFF1A9562)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = index == selectedIndex ? Colors.white : Color(0xFF1A9562)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.0;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
