import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/models/search_model.dart';
import 'package:help_abode_worker_app_ver_2/provider/addnew_services_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/add_new_service/widgets/service_area_name.dart';
import 'package:help_abode_worker_app_ver_2/screens/add_new_service/widgets/show_and_search_zipcodes.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_appbar.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_rounded_button.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/show_custom_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../../models/all_service_items.dart';
import '../../models/service_according_category_model.dart';
import '../../provider/show_service_provider.dart';
import '../pricing/pricing_screen.dart';

class PreferedServiceAreas2 extends StatefulWidget {
  PreferedServiceAreas2(this.service, {super.key});

  final AllServiceItems service;

  @override
  State<PreferedServiceAreas2> createState() => _PreferedServiceAreas2State();
}

class _PreferedServiceAreas2State extends State<PreferedServiceAreas2> {
  late AddNewServiceProvider provider;
  final searchKey = GlobalKey<FormState>();
  final zoneNameCon = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final RoundedLoadingButtonController _controller =
      RoundedLoadingButtonController();
  bool showBtn = true;

  @override
  void initState() {
    var cp = context.read<AddNewServiceProvider>();

    Future.microtask(() {
      cp.setLoadingArea(true);
      cp.getMyAllServiceArea();
      cp.deleteAllSelectedSearch();
      cp.setSelection(false);
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    zoneNameCon.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(label: 'Preferred Service Areas'),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(
                    height: 6,
                  ),
                  SelectedCategories2(provider: provider),
                  SelectAreaName(
                      searchKey: searchKey, zoneNameCon: zoneNameCon),
                  provider.selectedAreaIsDropdown
                      ? ShowDropDownZipCodes(provider)
                      : SearchAndShowZipcodes(provider: provider)
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 5,
                ),
                CustomRoundedButton(
                    controller: _controller,
                    label: 'Save Service Area',
                    buttonColor:
                        provider.searchSuggestionListAddedMain.isNotEmpty ||
                                provider.selectedAreaIsDropdown == true
                            ? myColors.green
                            : Colors.grey,
                    fontColor: Colors.white,
                    funcName:
                        (provider.searchSuggestionListAddedMain.isNotEmpty ||
                                provider.selectedAreaIsDropdown == true)
                            ? () async {
                                // Unfocus the keyboard
                                FocusScope.of(context).unfocus();
                                if (searchKey.currentState!.validate()) {
                                  _handleValidInput(context);
                                }
                              }
                            : () {
                                DashboardHelpers.showAlert(
                                    msg: 'Select city or Zipcode');
                              },
                    borderRadius: 40),
                const SizedBox(
                  height: 10,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  List<String> setZoneTosave(List<SearchModel> selectedSearchLst) {
    List<String> zipCodes = [];

    selectedSearchLst.forEach((element) {
      zipCodes.add(element.zip!);
    });
    print('zipCodes.length ${zipCodes.toList()}');
    return zipCodes;
  }

  List<String> setCategoriesTosave(
      List<ServiceAccordingCategoryModel> serviceCategorySelectedList) {
    List<String> selectedItems = [];
    serviceCategorySelectedList.forEach((element) {
      if (element.isSelected == true) {
        selectedItems.add(element.textId!);
      }
    });
    return selectedItems.toList();
  }

  Future<void> _handleValidInput(BuildContext context) async {
    _controller.start(); // start animation

    //  var services = setServiceToSave(provider.serviceCategoryList);
    var zipCodes = setZoneTosave(provider.searchSuggestionListAddedMain);
    //change services.toList() to getValueMapOfSaveService
    List<String> splitList = [];
    if (provider.selectedAreaIsDropdown) {
      splitList = provider.filtteredZipcodeListByZone
          .map((sentence) => sentence.split(" ")[0])
          .toList();
    }
    //here widget.service.textId == parent textid
    var api1 = await provider.saveCategoriesAndZipCode2(
        widget.service.attributeGroupTextId ?? '',
        provider.getValueMapOfSaveService.toList(),
        provider.selectedAreaIsDropdown ? splitList : zipCodes.toList(),
        zoneNameCon.text.trim(),
        '',
        [],
        null);

    var api2 = await Provider.of<ShowServiceProvider>(context, listen: false)
        .getWorkerSelectedZoneInfo();

    if (api1 is bool) {
      await _handleApi1BoolResponse(context, api1, api2);
    } else {
      _controller.stop();
      showCustomBottomSheet(
        context,
        message: api1['message'] ?? api1.toString(),
        button1Text: 'Replace & Save',
        button1Function: () async {
          debugPrint(api1.toString());
          provider.showLoadingZipUpdateButton(true);
          await provider
              .saveCategoriesAndZipCode2(
                  widget.service.attributeGroupTextId ?? '',
                  provider.getValueMapOfSaveService.toList(),
                  zipCodes.toList(),
                  zoneNameCon.text.trim(),
                  'update',
                  [],
                  'Replace')
              .then((val) async {
            if (val == true) {
              var api2 =
                  await Provider.of<ShowServiceProvider>(context, listen: false)
                      .getWorkerSelectedZoneInfo();
              if (api2) {
                Navigator.pop(context);
                DashboardHelpers.successStopAnimation(_controller);
                await _showPricingBottomSheet(context);
              } else {
                DashboardHelpers.errorStopAnimation(_controller);
              }
            }
          });
          provider.showLoadingZipUpdateButton(false);
          Navigator.pop(context);
        },
        button2Text: 'Keep Exist',
        button2Function: () async {
          debugPrint(api1.toString());
          provider.showLoadingZipUpdateButton(true);
          debugPrint('api1[existZipCodes] ${api1['existZipCodes']}');
          await provider
              .saveCategoriesAndZipCode2(
                  widget.service.attributeGroupTextId ?? '',
                  provider.getValueMapOfSaveService.toList(),
                  zipCodes.toList(),
                  zoneNameCon.text.trim(),
                  'update',
                  api1['existZipCodes'] ?? [],
                  'Keep')
              .then((val) async {
            if (val == true) {
              var api2 =
                  await Provider.of<ShowServiceProvider>(context, listen: false)
                      .getWorkerSelectedZoneInfo();
              if (api2) {
                Navigator.pop(context);
                DashboardHelpers.successStopAnimation(_controller);
                await _showPricingBottomSheet(context);
              } else {
                DashboardHelpers.errorStopAnimation(_controller);
              }
            }
          });
          provider.showLoadingZipUpdateButton(false);
          Navigator.pop(context);
        },
      );
    }
  }

  Future<void> _handleApi1BoolResponse(
      BuildContext context, bool api1, bool api2) async {
    if (api1 && api2) {
      DashboardHelpers.successStopAnimation(_controller);
      await _showPricingBottomSheet(context);
    } else {
      DashboardHelpers.errorStopAnimation(_controller);
    }
  }

  Future<void> _showPricingBottomSheet(BuildContext context) async {
    //deleteAllSelectedSearch
    var sp = context.read<AddNewServiceProvider>();
    sp.deleteAllSelectedSearch();
    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (BuildContext context) {
        return ShowPricingAndHomeBottomSheet(zoneNameCon.text);
      },
    ).then((value) {
      zoneNameCon.clear();
    });
  }
}

class ReusableInputBottomSheet extends StatefulWidget {
  final Function(String userInput) onSubmit;
  final String title;
  final String hintText;

  ReusableInputBottomSheet({
    required this.onSubmit,
    this.title = 'Service Area Name',
    this.hintText = 'Service zone name',
  });

  @override
  _ReusableInputBottomSheetState createState() =>
      _ReusableInputBottomSheetState();
}

class _ReusableInputBottomSheetState extends State<ReusableInputBottomSheet> {
  double height = 0;
  TextEditingController zoneNameCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Form(
              child: InkWell(
                onTap: () {
                  setState(() {
                    height = MediaQuery.of(context).size.height / 3;
                  });
                },
                child: TextFormField(
                  controller: zoneNameCon,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Zone name is required';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

class ShowPricingAndHomeBottomSheet extends StatelessWidget {
  final RoundedLoadingButtonController _controller =
      RoundedLoadingButtonController();

  final String zoneName;

  ShowPricingAndHomeBottomSheet(this.zoneName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: myColors.green,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: myColors.green,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SvgPicture.asset('assets/svg/check.svg'),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Area name saved successfully',
                  style: interText(18, Colors.white, FontWeight.w600)
                      .copyWith(letterSpacing: 0),
                ),
                Text(
                  'you can use this area for pricing',
                  style: interText(14, Colors.white, FontWeight.w400),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Consumer<AddNewServiceProvider>(
                builder: (context, provider, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: [
                              Text(
                                'Service Zone: ',
                                style: interText(
                                    16, Colors.black, FontWeight.w500),
                              ),
                              Text(
                                zoneName,
                                style: interText(
                                    16, Colors.black, FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: CustomRoundedButton(
                                funcName: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  provider.clearSelectedList();
                                  // Navigator.pushAndRemoveUntil(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => DashboardScreen()),
                                  //   (Route<dynamic> route) => false,
                                  // );

                                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
                                },
                                label: 'I\'ll do It Later',
                                buttonColor: myColors.greyBtn,
                                fontColor: Colors.black,
                                borderRadius: 40,
                                controller: _controller,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: CustomRoundedButton(
                                funcName: () {
                                  provider.clearSelectedList();
                                  // Navigator.pop(context);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PricingScreen())).then((value) {
                                    provider.selectedSearchList.clear();
                                  });
                                },
                                label: 'Pricing',
                                buttonColor: myColors.green,
                                fontColor: Colors.white,
                                borderRadius: 40,
                                controller: _controller,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
          ),
        ],
      ),
    );
  }
}

class ShowDropDownZipCodes extends StatelessWidget {
  final AddNewServiceProvider provider;

  ShowDropDownZipCodes(this.provider);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            debugPrint(
                'Available Zipcodes ${provider.filtteredZipcodeListByZone.length}');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Available Zipcodes',
              style: interText(16, Colors.black, FontWeight.w600),
            ),
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Container(
          height: 6,
          color: myColors.greyBg,
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: ListView.builder(
            itemCount: provider.filtteredZipcodeListByZone.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: myColors.greyBg,
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        provider.filtteredZipcodeListByZone[index],
                        style: interText(14, Colors.black, FontWeight.w500),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
