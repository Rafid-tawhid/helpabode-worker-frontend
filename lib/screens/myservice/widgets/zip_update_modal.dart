import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/models/search_model.dart';
import 'package:help_abode_worker_app_ver_2/provider/addnew_services_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/pricing_provider.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../../helper_functions/colors.dart';
import '../../../models/pending_price_view_details_model.dart';
import '../../../models/pending_requested_servicelist.dart';

Future<dynamic> show_zip_update_modal(BuildContext context,
    PricingZoneArray zone, PendingRequestedServiceList service) {
  bool enableEdit = false;
  String areaName = zone.zoneTitle ?? '';
  TextEditingController _conAreaName = TextEditingController();
  PricingProvider pricingProvider =
      Provider.of<PricingProvider>(context, listen: false);
  AddNewServiceProvider serviceProvider =
      Provider.of<AddNewServiceProvider>(context, listen: false);

  final _formKey = GlobalKey<FormState>();
  //set area name
  _conAreaName.text = zone.zoneTitle ?? '';
  // serviceProvider.clearEditSearchAreaList();
  serviceProvider.setSelectedSearchAreaList(pricingProvider, zone);

  serviceProvider.setSelectedListForAnotherUse();

  final RoundedLoadingButtonController _controller =
      RoundedLoadingButtonController();

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true, // This allows the bottom sheet to take more space
    builder: (context) => Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        // Initial size (0.0 to 1.0)
        minChildSize: 0.5,
        // Minimum size (0.0 to 1.0)
        maxChildSize: 0.95,
        // Maximum size (0.0 to 1.0)
        builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Consumer<AddNewServiceProvider>(
              builder: (context, pro, _) => Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close)),
                        //Edit Service Areas
                        Expanded(
                            child: Text(
                          'Service Zipcodes',
                          textAlign: TextAlign.center,
                          style: interText(16, Colors.black, FontWeight.w600),
                        )),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.close,
                              color: Colors.transparent,
                            )),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          'Service Area Name',
                          style: interText(14, Colors.black, FontWeight.w500),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.red,
                          size: 10,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Consumer<PricingProvider>(
                        builder: (context, provider, _) => Container(
                          decoration: BoxDecoration(
                              color: myColors.greyBg,
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _conAreaName,
                                  enabled: provider.editButton,
                                  onChanged: (val) {
                                    areaName = val;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      borderSide:
                                          BorderSide.none, // Remove the border
                                    ),
                                    filled: true,
                                    fillColor: myColors
                                        .greyBg, // Optional: background color
                                  ),
                                  validator: (val) {
                                    if (val == null ||
                                        val.isEmpty ||
                                        val.length < 3) {
                                      return 'Name is Required';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              // IconButton(
                              //   onPressed: () {
                              //     debugPrint('PRESSED ${provider.editButton}');
                              //     provider.showEditButton(!provider.editButton);
                              //   },
                              //   icon: Icon(Icons.edit),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    //   child: Hero(
                    //     tag: 'tag1',
                    //     child: Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    //         child: Container(
                    //           padding: const EdgeInsets.all(12.0),
                    //           decoration: BoxDecoration(
                    //             color: myColors.greyBg,
                    //             borderRadius: BorderRadius.circular(20.0),
                    //             border: Border.all(color: Colors.transparent, width: 1),
                    //           ),
                    //           child: Row(
                    //             children: [
                    //               const Icon(
                    //                 Icons.search,
                    //                 color: Colors.black,
                    //               ),
                    //               const SizedBox(width: 8.0),
                    //               Expanded(
                    //                   child: Consumer<AddNewServiceProvider>(
                    //                 builder: (context, provider, _) => GestureDetector(
                    //                   onTap: () async {
                    //                     provider.isLoadingSearch2(true);
                    //                     provider.searchByCityAndZip('945').then((val) {
                    //                       provider.isLoadingSearch2(false);
                    //                     });
                    //                     Navigator.push(
                    //                         context,
                    //                         PageRouteBuilder(
                    //                           pageBuilder: (context, animation, secondaryAnimation) {
                    //                             return FadeScaleTransition(
                    //                               animation: animation,
                    //                               child: const AreaZipSearchScreen(
                    //                                 editModal: 'edit',
                    //                               ),
                    //                             );
                    //                           },
                    //                           transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    //                             const begin = 0.0;
                    //                             const end = 1.0;
                    //                             const curve = Curves.easeIn;
                    //                             var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    //                             var fadeScaleTween = Tween(begin: 0.2, end: 1.0).chain(CurveTween(curve: curve));
                    //                             var offsetAnimation = animation.drive(tween);
                    //                             var fadeScaleAnimation = animation.drive(fadeScaleTween);
                    //
                    //                             return FadeScaleTransition(
                    //                               animation: fadeScaleAnimation,
                    //                               child: SlideTransition(
                    //                                 position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).animate(offsetAnimation),
                    //                                 child: child,
                    //                               ),
                    //                             );
                    //                           },
                    //                         ));
                    //                   },
                    //                   child: Text(
                    //                     'Search by City or Zip Code',
                    //                     style: TextStyle(
                    //                       color: fontClr,
                    //                       fontSize: CurrentDevice.isAndroid() ? 16 : 20,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               )),
                    //             ],
                    //           ),
                    //         )),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 16,
                    // ),
                    Container(
                      height: 10,
                      color: myColors.devider,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    //Add / Remove City or Zip
                    if (pro.selectedSearchList.length > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Available Zip codes',
                          style: interText(14, Colors.black, FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    SizedBox(
                      height: 6,
                    ),
                    //Dont remove
                    //searchSuggestionListAddedMain
                    Consumer<AddNewServiceProvider>(
                      builder: (context, provider, _) => Column(
                        // shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        children: provider.selectedSearchList
                            .map((e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 10),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: myColors.greyBg,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0, top: 8, bottom: 8),
                                            child: Text(
                                              '${e.zip}, ${e.cityTextId}, ${e.stateShortName} ${e.countryShortName}',
                                              style: interText(14, Colors.black,
                                                  FontWeight.w500),
                                            ),
                                          )),
                                          // IconButton(
                                          //     onPressed: () {
                                          //       provider.deleteSearchList(e);
                                          //     },
                                          //     icon: Icon(Icons.close)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),

                    Consumer<AddNewServiceProvider>(
                      builder: (context, provider, _) =>
                          provider.selectedSearchList.isNotEmpty
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    // CustomRoundedButton(
                                    //     controller: _controller,
                                    //     label: 'Save Service Area',
                                    //     buttonColor: myColors.green,
                                    //     fontColor: Colors.white,
                                    //     funcName: () async {
                                    //       if (_formKey.currentState!.validate()) {
                                    //         pro.setShowLoadingEdit(true);
                                    //         _controller.start();
                                    //         provider.selectedSearchList.forEach((e) {
                                    //           debugPrint('zipCodes ${e.zip}');
                                    //         });
                                    //         var body = {"workerTextId": textId, "franchiseTextId": franchiseTextId, "serviceTextId": service.serviceTextId, "newZoneTitle": _conAreaName.text.trim(), "oldZoneTextId": zone.zoneTextId, "zipArray": convertToMapList(provider.selectedSearchList)};
                                    //
                                    //         dynamic response = await provider.updateServiceZoneWithZipcode(jsonEncode(body), pricingProvider, '');
                                    //         if (response is bool) {
                                    //           pro.setShowLoadingEdit(false);
                                    //           _controller.stop();
                                    //           Navigator.pop(context);
                                    //         } else {
                                    //           //if its not true thats mean zip is already exists
                                    //           pro.setShowLoadingEdit(false);
                                    //           _controller.stop();
                                    //
                                    //           showCustomBottomSheet(context,
                                    //               message: response['message'],
                                    //               button1Text: 'Keep Exist',
                                    //               button1Function: () {
                                    //                 // Navigator.pop(context);
                                    //               },
                                    //               button2Text: 'Save & Update',
                                    //               button2Function: () async {
                                    //                 provider.showLoadingZipUpdateButton(true);
                                    //                 //get existing zip and send for update
                                    //                 //
                                    //                 //get existing zip
                                    //                 List<String> selectedList = convertToMapList(provider.selectedSearchList);
                                    //                 List<String> existsList = List<String>.from(response['exist_zip_store']);
                                    //
                                    //                 selectedList.removeWhere((e) => existsList.contains(e));
                                    //
                                    //                 debugPrint('selectedList after $selectedList');
                                    //                 debugPrint('existsList $existsList');
                                    //
                                    //                 var body = {"workerTextId": textId, "franchiseTextId": franchiseTextId, "serviceTextId": service.serviceTextId, "newZoneTitle": _conAreaName.text.trim(), "oldZoneTextId": zone.zoneTextId, "zipArray": selectedList};
                                    //                 await provider.updateServiceZoneWithZipcode(jsonEncode(body), pricingProvider, 'update').then((v) {
                                    //                   Navigator.pop(context);
                                    //                 });
                                    //                 provider.showLoadingZipUpdateButton(false);
                                    //               });
                                    //         }
                                    //       }
                                    //     },
                                    //     borderRadius: 40),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                )
                              : Text(''),
                    ),
                  ],
                ),
              ),
            )),
      ),
    ),
  );
}

List<String> convertToMapList(List<SearchModel> searchModelList) {
  List<String> data = [];
  searchModelList.forEach((e) {
    data.add(e.zip ?? '');
  });
  return data;
}

List<String> setZoneTosave(List<SearchModel> selectedSearchLst) {
  List<String> zipCodes = [];

  selectedSearchLst.forEach((element) {
    zipCodes.add(element.zip!);
  });
  print('zipCodes.length ${zipCodes.toList()}');
  return zipCodes;
}
