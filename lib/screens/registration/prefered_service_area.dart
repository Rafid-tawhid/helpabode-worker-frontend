import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/models/add_new_service_model.dart';
import 'package:help_abode_worker_app_ver_2/models/search_model.dart';
import 'package:help_abode_worker_app_ver_2/provider/addnew_services_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/registration/show_my_services_screen.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_rounded_button.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/new_text_formfield.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../../provider/show_service_provider.dart';
import '../add_new_service/widgets/prefered_head.dart';
import '../add_new_service/widgets/selected_categoriese.dart';
import '../add_new_service/widgets/show_and_search_zipcodes.dart';

class PreferedServiceAreas extends StatefulWidget {
  const PreferedServiceAreas({super.key});

  static const String routeName = 'prefered_service_area';

  @override
  State<PreferedServiceAreas> createState() => _PreferedServiceAreasState();
}

class _PreferedServiceAreasState extends State<PreferedServiceAreas> {
  late AddNewServiceProvider provider;
  final searchKey = GlobalKey<FormState>();
  final zoneNameCon = TextEditingController();
  final zoneNameCon2 = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final RoundedLoadingButtonController _controller =
      RoundedLoadingButtonController();
  bool showBtn = true;

  @override
  void initState() {
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
    provider = Provider.of<AddNewServiceProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back))
                        ],
                      ),
                    ),
                    const PreferedHeader(),
                    const SizedBox(
                      height: 6,
                    ),
                    SelectedCategories(provider: provider),
                    RegistrationSelectAreaName(
                      searchKey: searchKey,
                      zoneNameCon: zoneNameCon,
                      focusNode: _focusNode,
                    ),
                    SearchAndShowZipcodes(provider: provider),
                  ],
                ),
              ),
              provider.searchSuggestionListAddedMain.isNotEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        CustomRoundedButton(
                            controller: _controller,
                            label: 'Save & Next',
                            buttonColor: myColors.green,
                            fontColor: Colors.white,
                            funcName: () async {
                              // _showBottomSheet(context);

                              if (searchKey.currentState!.validate() &&
                                  provider.selectedSearchList.isNotEmpty) {
                                _controller.start(); //start animation

                                var categories = setCategoriesTosave(
                                    provider.addNewServiceList);
                                var zipCodes = setZoneTosave(
                                    provider.searchSuggestionListAddedMain);

                                print('categories ${categories}');
                                print('zipCodes ${zipCodes}');

                                //save zones and areas
                                bool val1 =
                                    await provider.saveCategoriesAndZipCode(
                                        categories.toList(),
                                        zipCodes.toList(),
                                        zoneNameCon.text.trim());
                                bool val2 =
                                    await Provider.of<ShowServiceProvider>(
                                            context,
                                            listen: false)
                                        .getMySelectedServiceZone();
                                //and get by zones
                                if (val1 && val2) {
                                  DashboardHelpers.successStopAnimation(
                                      _controller);
                                  zoneNameCon.clear();
                                  //remove this screen
                                  Navigator.pop(context);
                                  //clear previous selected value

                                  provider.clearSelectedList();

                                  context
                                      .pushNamed(ShowMyServicesScreen.routeName)
                                      .then((value) {
                                    provider.selectedSearchList.clear();
                                  });
                                } else {
                                  DashboardHelpers.errorStopAnimation(
                                      _controller);
                                  DashboardHelpers.showAlert(
                                      msg: 'Something went wrong');
                                }
                              } else {
                                // DashboardHelpers.showAlert(msg: 'Please select an area zipcode');
                              }
                            },
                            borderRadius: 40),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        CustomRoundedButton(
                            label: 'Save & Next',
                            controller: _controller,
                            buttonColor: myColors.greyBtn,
                            fontColor: Colors.black,
                            funcName: () async {
                              DashboardHelpers.showAlert(
                                  msg: 'Select City and Area Name');
                              // _showBottomSheet(context);
                            },
                            borderRadius: 40),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
            ],
          ),
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

  List<String> setCategoriesTosave(List<AddNewServiceModel> addNewServiceList) {
    List<String> selectedItems = [];
    addNewServiceList.forEach((element) {
      if (element.isSelected == true) {
        selectedItems.add(element.textId!);
      }
    });
    // var categories = selectedItems.map((title) {
    //   return {
    //     "workerTextId": textId,
    //     "franchiseTextId": franchiseTextId,
    //     "categoryTextId": title.textId,
    //   };
    // }).toList();

    print('selectedItems.length ${selectedItems.toList()}');

    return selectedItems.toList();
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Service zone name',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  //Save Service Area

                  const SizedBox(
                    height: 6,
                  ),
                  Form(
                    key: searchKey,
                    child: NewCustomTextField(
                        fieldTextFieldController: zoneNameCon,
                        funcOnChanged: (val) {},
                        funcValidate: (value, setErrorInfo) {
                          if (value == null || value.isEmpty) {
                            setErrorInfo(true, 'Zone name is required');
                            return '';
                          }
                          if (value.length < 3) {
                            setErrorInfo(true, 'Minimum 3 character');
                            return '';
                          }
                          return null;
                        },
                        hintText: 'Set service zone name',
                        borderRadius: 8),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomRoundedButton(
                    label: 'Save',
                    buttonColor: myColors.green,
                    fontColor: Colors.white,
                    funcName: () async {
                      if (searchKey.currentState!.validate() &&
                          provider.selectedSearchList.isNotEmpty) {
                        _controller.start(); //start animation

                        var categories =
                            setCategoriesTosave(provider.addNewServiceList);
                        var zipCodes =
                            setZoneTosave(provider.selectedSearchList);

                        print('categories ${categories}');
                        print('zipCodes ${zipCodes}');

                        //save zones and areas
                        if (await provider.saveCategoriesAndZipCode(
                            categories.toList(),
                            zipCodes.toList(),
                            zoneNameCon.text.trim())) {
                          DashboardHelpers.successStopAnimation(_controller);
                          zoneNameCon.clear();
                          Navigator.pop(context);
                          context
                              .pushNamed(ShowMyServicesScreen.routeName)
                              .then((value) {
                            provider.selectedSearchList.clear();
                            provider.notifyListeners();
                          });
                        } else {
                          DashboardHelpers.errorStopAnimation(_controller);
                          DashboardHelpers.showAlert(
                              msg: 'Something went wrong');
                        }
                      } else {
                        DashboardHelpers.errorStopAnimation(_controller);
                        DashboardHelpers.showAlert(msg: 'Something went wrong');
                        // DashboardHelpers.showAlert(msg: 'Please select an area zipcode');
                      }
                    },
                    borderRadius: 10,
                    controller: _controller,
                  ),

                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class RegistrationSelectAreaName extends StatelessWidget {
  const RegistrationSelectAreaName({
    super.key,
    required this.searchKey,
    required this.zoneNameCon,
    required this.focusNode,
  });

  final GlobalKey<FormState> searchKey;
  final TextEditingController zoneNameCon;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Service Zone ',
                style: text_16_black_600_TextStyle,
              ),
              const Text(
                '*',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              )
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Form(
            key: searchKey,
            child: NewCustomTextField(
                fieldTextFieldController: zoneNameCon,
                funcOnChanged: (val) {},
                funcValidate: (value, setErrorInfo) {
                  if (value == null || value.isEmpty) {
                    setErrorInfo(true, 'Zone name is required');
                    return '';
                  }
                  if (value.length < 3) {
                    setErrorInfo(true, 'Minimum 3 character');
                    return '';
                  }
                  return null;
                },
                hintText: 'Enter service zone',
                borderRadius: 8),
          ),
        ],
      ),
    );
  }
}
