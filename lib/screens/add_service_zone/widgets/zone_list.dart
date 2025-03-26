import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/screens/add_service_zone/widgets/zone_update_bottom_Sheet.dart';
import 'package:provider/provider.dart';
import '../../../corporate/views/custom_bottom_button.dart';
import '../../../models/search_model.dart';
import '../../../provider/addnew_services_provider.dart';
import 'add_new_area_bottom_sheet.dart';

class ZoneListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Consumer<AddNewServiceProvider>(builder: (context, pro, _) {
              if (pro.isLoadingArea) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (pro.filterserviceAreaWithInfoList.isEmpty) {
                return const Center(
                  child: Text('No Service Areas Available'),
                );
              }
              return ListView.builder(
                itemCount: pro.filterserviceAreaWithInfoList.length,
                itemBuilder: (context, index) {
                  final zone = pro.filterserviceAreaWithInfoList[index];
                  return GestureDetector(
                    onTap: () async {
                      EasyLoading.show(maskType: EasyLoadingMaskType.black);
                      await pro.getDetailsInfoByZoneId(zone.zoneTextId);
                      EasyLoading.dismiss();
                      //Added zip list of a zone to my next search zip list as selected
                      pro.searchSuggestionListAddedMain.clear();
                      pro.zipInfoModelList.forEach((e) {
                        pro.searchSuggestionListAddedMain
                            .add(SearchModel.fromJson(e.toJson()));
                      });
                      //show edit bottom sheet

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => ZoneUpdateBottomSheet(
                            zoneName: zone.zoneTitle ?? '',
                            zoneId: zone.zoneTextId ?? ''),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x72E9E9E9), // Correct color format
                              blurRadius: 48,
                              offset: Offset(0, 12),
                              spreadRadius: 0,
                            ),
                          ],
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: Color(0xffe9e9e9),
                          )),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  zone.zoneTitle ?? '',
                                  style: interText(
                                      14, Colors.black, FontWeight.w600),
                                ),
                                const SizedBox(width: 12),
                                // const Icon(Icons.edit_location_outlined, size: 22),
                                SvgPicture.asset(
                                  'assets/svg/Edit.svg',
                                  width: 20,
                                )
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Row 2: Zip Code and Total Service
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        size: 16, color: Colors.black),
                                    const SizedBox(width: 4),
                                    Text('${zone.totalZip} zip codes',
                                        style: interText(
                                            13, Colors.black, FontWeight.w400)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.business_center,
                                        size: 16, color: Colors.black),
                                    const SizedBox(width: 4),
                                    Text('${zone.totalService} services',
                                        style: interText(
                                            13, Colors.black, FontWeight.w400)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
        Consumer<AddNewServiceProvider>(
          builder: (context, pro, _) => pro.selectedService != null
              ? CustomBottomButton(
                  btnText: 'Add New Area',
                  onpressed: () {
                    //add new zone only
                    pro.setSingleSelectedService();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => NewZoneAddBottomSheet(),
                    );
                  })
              : SizedBox.shrink(),
        )
      ],
    );
  }
}
