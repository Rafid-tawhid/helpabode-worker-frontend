import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/models/search_model.dart';
import 'package:help_abode_worker_app_ver_2/provider/addnew_services_provider.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../custom_packages/extensions/custom_material_button.dart';
import '../../models/add_new_service_model.dart';
import '../../models/service_according_category_model.dart';
import '../../widgets_reuse/custom_rounded_button.dart';
import '../../widgets_reuse/new_text_formfield.dart';
import '../../widgets_reuse/search_shimmer.dart';

class AreaZipSearchScreen extends StatefulWidget {
  static const String routeName = 'area_zip_search_screen';
  final String? editModal;

  const AreaZipSearchScreen({Key? key, this.editModal}) : super(key: key);

  @override
  State<AreaZipSearchScreen> createState() => _AreaZipSearchScreenState();
}

class _AreaZipSearchScreenState extends State<AreaZipSearchScreen> {
  final searchKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _controller =
      RoundedLoadingButtonController();
  late AddNewServiceProvider provider;
  TextEditingController zoneNameCon = TextEditingController();
  TextEditingController areaNameCon = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void didChangeDependencies() {
    provider = Provider.of(context, listen: false);
    super.didChangeDependencies();
  }

  //this function will call after 1 second

  void _onTextChanged(AddNewServiceProvider pro, String value) {
    pro.isLoadingSearch(true);
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () async {
      // Call your function here after 1 second of inactivity
      await pro.searchByCityAndZip(areaNameCon.text);
      pro.isLoadingSearch(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'tag1',
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Consumer<AddNewServiceProvider>(
            builder: (context, provider, _) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Consumer<AddNewServiceProvider>(
                        builder: (context, pro, _) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0XFFE9E9E9),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: TextFormField(
                              controller: areaNameCon,
                              decoration: InputDecoration(
                                hintText: 'Search by city or zip code',
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
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                          margin: const EdgeInsets.all(8),
                                          height: 32,
                                          width: 32,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.white),
                                          child: const Icon(
                                            Icons.arrow_back,
                                            size: 26,
                                          )),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                suffixIcon: areaNameCon.text.isNotEmpty
                                    ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            areaNameCon.clear();
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
                              onChanged: (val) async {
                                if (areaNameCon.text.length >= 2) {
                                  _onTextChanged(pro, areaNameCon.text);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: provider.isloadingSearch
                      ? ShimmerEffect()
                      : _buildContent(provider),
                ),
                if (provider.searchSuggestionListAddedMain
                    .any((element) => element.isSelected == true))
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomMaterialButton(
                        label: 'Save',
                        buttonColor: myColors.green,
                        fontColor: Colors.white,
                        funcName: () {
                          provider.addSelected(
                              provider.searchSuggestionListAddedMain);
                          //only for update zip code
                          if (widget.editModal == 'edit') {
                            provider.addDummyList();
                          }
                          Navigator.pop(context);
                        },
                        borderRadius: 40),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(AddNewServiceProvider provider) {
    if (provider.searchSuggestionListMain.isEmpty) {
      // Show a center text if the list is empty
      return Center(
          child: provider.isloadingSearchNew == true
              ? CircularProgressIndicator(
                  color: myColors.green,
                )
              : Text('No results found.'));
    } else {
      // Show the ListView.builder if there are items in the list
      return ListView.builder(
        itemCount: provider.searchSuggestionListMain.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final items = provider.searchSuggestionListMain[index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                    '${items.zip}, ${items.cityTextId}, ${items.stateShortName} ${items.countryShortName}'),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  decoration: BoxDecoration(
                      color: provider.searchSuggestionListAddedMain
                              .any((element) => element.id == items.id)
                          ? myColors.green
                          : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: myColors.green, width: .3)),
                  child: provider.searchSuggestionListAddedMain
                          .any((element) => element.id == items.id)
                      ? const Text(
                          'Added',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        )
                      : Text(
                          'Add',
                          style: TextStyle(
                            color: myColors.green,
                            fontSize: 10,
                          ),
                        ),
                ),
                onTap: () {
                  // print('ITEM ADDED OR NOT ${provider.getIfItemIsAlreadyAddedInSelectedList(items)}');
                  provider.setSelectedvalueMain(
                      provider.searchSuggestionListMain[index],
                      provider.searchSuggestionListMain[index].id);
                  //provider.setSelected(provider.searchSuggestionListMain[index].id);
                  // provider.searchSuggestionList.clear();
                  // provider.notifyListeners();
                  // Navigator.pop(context, items.toJson());
                },
              ),
              const Divider()
            ],
          );
        },
      );
    }
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
                  Consumer<AddNewServiceProvider>(
                    builder: (context, provider, _) => CustomRoundedButton(
                      label: 'Save',
                      buttonColor: myColors.green,
                      fontColor: Colors.white,
                      funcName: () async {
                        if (searchKey.currentState!.validate()) {
                          _controller.start(); //start animation

                          var services =
                              setServiceToSave(provider.serviceCategoryList);
                          var zipCodes =
                              setZoneTosave(provider.selectedSearchList);

                          print('services ${services}');
                          print('zipCodes ${zipCodes}');

                          //save zones and areas
                          // if (await provider.saveCategoriesAndZipCode2(widget.service.categoryTextId ?? '', services.toList(), zipCodes.toList(), zoneNameCon.text.trim())) {
                          //   DashboardHelpers.successStopAnimation(_controller);
                          //   zoneNameCon.clear();
                          //   Navigator.pop(context);
                          //
                          //   context.pushNamed('show_my_services2').then((value) {
                          //     provider.selectedSearchList.clear();
                          //     provider.notifyListeners();
                          //   });
                          // } else {
                          //   DashboardHelpers.errorStopAnimation(_controller);
                          //   DashboardHelpers.showAlert(msg: 'Something went wrong');
                          // }
                        } else {
                          // DashboardHelpers.errorStopAnimation(_controller);
                          // DashboardHelpers.showAlert(msg: 'Something went wrong');
                          // DashboardHelpers.showAlert(msg: 'Please select an area zipcode');
                        }
                      },
                      borderRadius: 10,
                      controller: _controller,
                    ),
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

  List<String> setZoneTosave(List<SearchModel> selectedSearchLst) {
    List<String> zipCodes = [];

    selectedSearchLst.forEach((element) {
      zipCodes.add(element.zip!);
    });
    print('zipCodes.length ${zipCodes.toList()}');
    return zipCodes;
  }

  List<String> setServiceToSave(
      List<ServiceAccordingCategoryModel> selectedServiceList) {
    List<String> serviceList = [];
    selectedServiceList.forEach((element) {
      print(element.toString());
      print('---------------------');
      if (element.isSelected == true) {
        serviceList.add(element.textId ?? '');
      }
    });

    print('serviceList.length ${serviceList.toList()}');
    return serviceList;
  }

  List<String> setCategoriesTosave(List<AddNewServiceModel> addNewServiceList) {
    List<String> selectedItems = [];
    addNewServiceList.forEach((element) {
      if (element.isSelected == true) {
        selectedItems.add(element.textId!);
      }
    });

    print('selectedItems.length ${selectedItems.toList()}');

    return selectedItems.toList();
  }
}
