import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/seemore_text.dart';
import 'package:provider/provider.dart';

import '../helper_functions/colors.dart';
import '../misc/constants.dart';
import '../models/bundle_attribute_model.dart';
import '../models/pending_requested_servicelist.dart';
import '../models/pricing_attribute_model_new.dart';
import '../provider/pricing_provider.dart';

void serviceInfoBottomSheet(
    BuildContext context,
    ServiceInfo serviceInfo,
    PendingRequestedServiceList service,
    List<PriceConfigaruatinAttr> attributeList) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows full-screen height
    backgroundColor: Colors.transparent, // Ensures rounded corners are visible
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.9, // 50% of the screen
        minChildSize: 0.3, // Minimum size
        maxChildSize: 0.9, // Maximum size
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            height: MediaQuery.sizeOf(context).height * .8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        '$urlBase${service.image}',
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Container(
                              height: 160,
                              width: double.infinity,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: myColors.green,
                                ),
                              ),
                            );
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'images/placeholder.jpg',
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  // Name
                  Text(
                    service.serviceTitle ?? '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Details
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ReadMoreText(
                      text: serviceInfo.shortDescription ?? '',
                      maxLines: 100,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Attributes
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Attributes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Consumer<PricingProvider>(
                    builder: (context, pro, _) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16),
                      child: serviceInfo.pricingBy!.toLowerCase() == 'bundle'
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: pro.bundleAttributeList.length,
                              itemBuilder: (context, index) {
                                var attribute = pro.bundleAttributeList[index];
                                // Options opt=Options.fromJson(pro.bundleAttributeList[index].option);
                                return Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 12,
                                        width: 12,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: myColors.green,
                                                width: 1)),
                                        alignment: Alignment.center,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: myColors.green),
                                          height: 4,
                                          width: 4,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              attribute.title ?? '',
                                              style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            attribute.option
                                                    is List<BundleOption>
                                                ? Text(
                                                    attribute.option
                                                        .firstWhere((e) =>
                                                            e.isActive == true)
                                                        .title,
                                                    style: GoogleFonts.inter(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      print(attribute.option
                                                          .firstWhere((e) =>
                                                              e.isActive ==
                                                              true));
                                                    },
                                                    child: Text(attribute.option
                                                        .toString())),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: pro.attributeList.length,
                              itemBuilder: (context, index) {
                                var attribute = pro.attributeList[index];
                                //ajira
                                return Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 12,
                                        width: 12,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: myColors.green,
                                                width: 1)),
                                        alignment: Alignment.center,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: myColors.green),
                                          height: 4,
                                          width: 4,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              attribute.title ?? '',
                                              style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Expanded(
                                                child: Text(
                                              attribute.options![0].optionLabel
                                                  .toString(),
                                              textAlign: TextAlign.end,
                                            )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Close Button
                  CupertinoButton(
                    child: Text(
                      'Close',
                      style: TextStyle(color: myColors.green),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
  String? getFirstActiveTitle(List<Map<String, dynamic>> items) {
    return items.firstWhere((item) => item['isActive'] == true)['title']
        as String?;
  }
}
