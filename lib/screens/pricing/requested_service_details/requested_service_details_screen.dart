import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/screens/pricing/widgets/show_service_attribute_animation.dart';
import 'package:provider/provider.dart';

import '../../../helper_functions/colors.dart';
import '../../../misc/constants.dart';
import '../../../models/all_service_items.dart';
import '../../../models/pending_requested_servicelist.dart';
import '../../../provider/pricing_provider.dart';
import '../../../widgets_reuse/expandable_text.dart';
import '../../add_new_service/prefered_service_area_2.dart';
import '../../add_new_service/widgets/service_info_section.dart';
import '../../pricing/dynamic_form_pricing.dart';
import '../widgets/rejected_popup.dart';

class RequestedServiceDetailsScreen extends StatefulWidget {
  PendingRequestedServiceList serviceModel;
  RequestedServiceDetailsScreen(this.serviceModel);

  @override
  State<RequestedServiceDetailsScreen> createState() =>
      _RequestedServiceDetailsScreenState();
}

class _RequestedServiceDetailsScreenState
    extends State<RequestedServiceDetailsScreen> {
  int selectedIndex = 0;
  String selectedPlanId = '';

  @override
  void initState() {
    selectedPlanId = widget.serviceModel.firstPlanTextId ?? '';
    if (widget.serviceModel.statusId == PendingRequested.PriceRejected) {
      Future.delayed(Duration(seconds: 2), () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: RejectedPopupContent(widget.serviceModel),
            );
          },
        );
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<PricingProvider>(
            builder: (context, provider, _) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    TopSection(widget: widget),
                    ServiceInfoSection(
                      serviceModel: widget.serviceModel,
                    ),
                    PlanAndDetailsSection(provider, context),
                    MyServiceAreaSection(
                        selectedPlanId: selectedPlanId, widget: widget),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Column PlanAndDetailsSection(PricingProvider provider, BuildContext context) {
    return Column(
      children: [
        if (provider.pendingPlanArrayList.first.planTextId !=
                'AdminDefaultPlan' &&
            provider.pendingPlanArrayList.first.planTextId != 'AdminBundlePlan')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: myColors.greyBg,
              ),
              alignment: Alignment.center,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.pendingPlanArrayList.length,
                itemExtent: provider.pendingPlanArrayList.length < 3
                    ? (MediaQuery.of(context).size.width / 2) - 16
                    : (MediaQuery.of(context).size.width / 3) - 8,
                itemBuilder: (context, index) => InkWell(
                  onTap: () async {
                    setState(() {
                      selectedIndex = index;
                      selectedPlanId = provider
                              .pendingPlanArrayList[selectedIndex].planTextId ??
                          '';
                    });
                    //FOR expandable price
                    provider.setShowAreaValue2(true);
                    await provider
                        .getPlanwizeServiceAreaInfoNew(selectedPlanId ?? '');
                    provider.closeAllExpandedValue();
                    provider.setShowAreaValue(false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 2.0, horizontal: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: index == selectedIndex
                            ? Colors.white
                            : myColors.greyBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        // Use Center to reduce complexity
                        child: Text(
                          provider.pendingPlanArrayList[index].planTitle!
                                      .length >
                                  12
                              ? DashboardHelpers.truncateString(
                                  provider.pendingPlanArrayList[index]
                                          .planTitle ??
                                      '',
                                  12)
                              : provider
                                      .pendingPlanArrayList[index].planTitle ??
                                  '',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (provider.pendingPlanArrayList.first.planTextId !=
                'AdminDefaultPlan' &&
            provider.pendingPlanArrayList.first.planTextId != 'AdminBundlePlan')
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12, top: 8),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(8)),
              padding:
                  EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Text(
                      'Details:',
                      style: interText(16, Colors.black, FontWeight.w700),
                    ),
                  ),
                  ExpandText(
                    text: provider
                            .pendingPlanArrayList[selectedIndex].planDetails ??
                        '',
                    maxLines: 2,
                    position: true,
                  )
                ],
              ),
            ),
          ),
        if (provider.pendingPlanArrayList.first.planTextId == 'AdminBundlePlan')
          ShowServiceAttributes(
              provider.pricingServiceDetailsinfo!.attributes ?? []),
        SizedBox(
          height: 8,
        ),
        Container(
          color: myColors.divider,
          height: 10,
        ),
      ],
    );
  }

  bool getIfPriceIsRejected(PricingProvider provider, int index) {
    String titleId = provider.pendingPlanArrayList[index].planTextId ?? '';
    for (var e in provider.requestedServiceDetailsPricingListShow) {
      for (var a in e.requestedplanArray ?? []) {
        if (titleId == a.planTextId && a.priceStatus == 'Rejected') {
          return true; // Exit the function immediately if a match is found.
        }
      }
    }
    return false; // Return false if no match is found.
  }
}

class MyServiceAreaSection extends StatelessWidget {
  const MyServiceAreaSection({
    super.key,
    required this.selectedPlanId,
    required this.widget,
  });

  final String selectedPlanId;
  final RequestedServiceDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Consumer<PricingProvider>(
        builder: (context, provider, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'My Service Areas',
              style: interText(16, Colors.black, FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            provider.showArea
                ? provider.requestedServiceDetailsPricingListShow.isEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: Text(
                                        'No Area Found',
                                        style: interText(14, AppColors.black,
                                            FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    : Column(
                        children: provider
                            .requestedServiceDetailsPricingListShow
                            .map((data) {
                          var zone = provider
                                  .requestedServiceDetailsPricingListShow[
                              provider.requestedServiceDetailsPricingListShow
                                  .indexOf(data)];
                          var attribute = zone.requestedplanArray!.firstWhere(
                              (e) => e.planTextId == selectedPlanId);
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 1, color: Colors.white),
                                color: const Color(0XFFF7F7F7)),
                            child: ListTileTheme(
                              contentPadding: const EdgeInsets.all(4),
                              dense: true,
                              horizontalTitleGap: 0.0,
                              minLeadingWidth: 0,
                              child: ExpansionTile(
                                  // backgroundColor: _expandedTileIndex == index ? null : myColors.greenLight,
                                  textColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  iconColor: Colors.black87,
                                  leading: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Colors.black,
                                    ),
                                  ),
                                  trailing: provider.isExpanded[provider
                                          .requestedServiceDetailsPricingListShow
                                          .indexOf(data)]
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: Colors.black),
                                              child: const Icon(
                                                Icons.keyboard_arrow_up,
                                                color: Colors.white,
                                                size: 24,
                                              )),
                                        ) // Custom icon when expanded
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: Colors.black),
                                              child: const Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 24,
                                                color: Colors.white,
                                              )),
                                        ),
                                  // Custom icon when collapsed
                                  onExpansionChanged: (bool expanding) async {
                                    provider.setExpanded(
                                        provider
                                            .requestedServiceDetailsPricingListShow
                                            .indexOf(data),
                                        expanding);
                                    //provider.getAttributes(index, selectedPlan, provider.requestedServiceDetailsPricingList[index].zoneTextId);
                                  },
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      provider
                                              .requestedServiceDetailsPricingList[
                                                  provider
                                                      .requestedServiceDetailsPricingListShow
                                                      .indexOf(data)]
                                              .zoneTitle ??
                                          '',
                                      style: interText(
                                          16, Colors.black, FontWeight.bold),
                                    ),
                                  ),
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      height: 50,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              // controller: _scrollController2,
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemCount: provider
                                                  .requestedServiceDetailsPricingList[
                                                      provider
                                                          .requestedServiceDetailsPricingListShow
                                                          .indexOf(data)]
                                                  .zipWisePrice!
                                                  .length,
                                              itemBuilder:
                                                  (context, horizontalIndex) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 4),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFF7F7F7),
                                                      border: Border.all(
                                                          color: Colors.grey,
                                                          width: .1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    12.0,
                                                                vertical: 4),
                                                        child: Text(provider
                                                                .requestedServiceDetailsPricingList[
                                                                    provider
                                                                        .requestedServiceDetailsPricingListShow
                                                                        .indexOf(
                                                                            data)]
                                                                .zipWisePrice![
                                                            horizontalIndex]),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Container(
                                            width: 34,
                                            height: 34,
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 9),
                                            clipBehavior: Clip.antiAlias,
                                            decoration: ShapeDecoration(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              shadows: [
                                                BoxShadow(
                                                  color: Color(0x33000000),
                                                  blurRadius: 8,
                                                  offset: Offset(-1, 1),
                                                  spreadRadius: 0,
                                                )
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 18,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16, left: 12, right: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          // Text(
                                          //   'Pricing Status : ',
                                          //   style: interText(14, Colors.black, FontWeight.bold),
                                          // ),
                                          // Text(
                                          //   attribute.priceStatus ?? '',
                                          //   style: interText(14, attribute.priceStatus == 'Rejected' ? Colors.red : myColors.green, FontWeight.bold),
                                          // ),
                                          if (attribute.priceStatus ==
                                              'Rejected')
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              child: InkWell(
                                                  onTap: () {
                                                    DashboardHelpers
                                                        .showAnimatedDialog(
                                                            context,
                                                            attribute
                                                                    .rejectedNotes ??
                                                                '',
                                                            'Price Rejection');
                                                  },
                                                  child: Icon(
                                                    Icons.error_outline,
                                                    color: Colors.red,
                                                    size: 20,
                                                  )),
                                            )
                                        ],
                                      ),
                                    ),
                                    //...item.requestedplanArray!.firstWhere((element) => element.planTextId == selectedPlanId).requestedAttributes!.map((map) => Text('data')).toList()
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 16.0),
                                              child: Text(
                                                'Options',
                                                style: interText(
                                                    14,
                                                    AppColors.black,
                                                    FontWeight.bold),
                                              ),
                                            )),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Center(
                                                        child: Text(
                                                          'Estimated times',
                                                          style: interText(
                                                              14,
                                                              AppColors.black,
                                                              FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Price',
                                                              style: interText(
                                                                  14,
                                                                  AppColors
                                                                      .black,
                                                                  FontWeight
                                                                      .bold),
                                                            ),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const Divider(
                                          height: .2,
                                          color: Colors.grey,
                                        ),
                                        // Column(
                                        //   mainAxisSize: MainAxisSize.min,
                                        //   crossAxisAlignment: CrossAxisAlignment.start,
                                        //   children: [
                                        //     Container(
                                        //       color: Colors.white,
                                        //       child: Padding(
                                        //         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16.0),
                                        //         child: Row(
                                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //           children: [
                                        //             Text('Minimum order price'),
                                        //             Text('\${HELLO}'),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     ),
                                        //     const Divider(
                                        //       height: .2,
                                        //       color: Colors.grey,
                                        //     )
                                        //   ],
                                        // ),
                                        //...pro.requestedServiceDetailsPricingList[0].requestedplanArray!.firstWhere((element) => element.planTextId == selectedPlanId).requestedAttributes!.map((attribute) => _buildAttribute(attribute)).toList(),

                                        Row(
                                          children: [
                                            Expanded(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                      horizontal: 16.0),
                                              child: Text(
                                                widget.serviceModel.pricingBy ==
                                                        'bundle'
                                                    ? 'Bundle Service'
                                                    : 'Minimum order price',
                                                style: interText(
                                                    14,
                                                    AppColors.black,
                                                    FontWeight.bold),
                                              ),
                                            )),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Center(
                                                        child: Text(
                                                          widget.serviceModel
                                                                      .pricingBy ==
                                                                  'bundle'
                                                              ? '${attribute.estTime} min'
                                                              : '-',
                                                          style: interText(
                                                              14,
                                                              AppColors.black,
                                                              FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              '${attribute.minimumPrice}\$',
                                                              style: interText(
                                                                  14,
                                                                  AppColors
                                                                      .black,
                                                                  FontWeight
                                                                      .bold),
                                                            ),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        if (attribute.requestedAttributes !=
                                            null)
                                          ...attribute.requestedAttributes!
                                              .map((data) {
                                            return data.isPricing == 'Yes'
                                                ? data.requestedOptions!
                                                            .length >
                                                        1
                                                    ? ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: data
                                                            .requestedOptions!
                                                            .length,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, index) =>
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child:
                                                                            Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          vertical:
                                                                              2,
                                                                          horizontal:
                                                                              16.0),
                                                                      child:
                                                                          Text(
                                                                        '${data.title}(${data.requestedOptions![index].optionLabel})',
                                                                        style: interText(
                                                                            14,
                                                                            AppColors.black,
                                                                            FontWeight.bold),
                                                                      ),
                                                                    )),
                                                                    Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            4.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Expanded(
                                                                              flex: 2,
                                                                              child: Center(
                                                                                child: Text(
                                                                                  '${data.requestedOptions![index].estTime} min' ?? '',
                                                                                  style: interText(14, AppColors.black, FontWeight.bold),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                                flex: 1,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      '\$${data.requestedOptions![index].price}' ?? '',
                                                                                      style: interText(14, AppColors.black, FontWeight.bold),
                                                                                    ),
                                                                                  ],
                                                                                )),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ))
                                                    : Row(
                                                        children: [
                                                          Expanded(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 2,
                                                                    horizontal:
                                                                        16.0),
                                                            child: Text(
                                                              data.title ?? '',
                                                              style: interText(
                                                                  14,
                                                                  AppColors
                                                                      .black,
                                                                  FontWeight
                                                                      .bold),
                                                            ),
                                                          )),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        '${data.requestedOptions!.first.estTime} min' ??
                                                                            '',
                                                                        style: interText(
                                                                            14,
                                                                            AppColors.black,
                                                                            FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            '\$${data.requestedOptions!.first.price}' ??
                                                                                '',
                                                                            style: interText(
                                                                                14,
                                                                                AppColors.black,
                                                                                FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                : SizedBox();
                                          }),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              color: Colors.white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16,
                                                        horizontal: 16.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Total',
                                                      style: interText(
                                                          16,
                                                          Colors.black,
                                                          FontWeight.bold),
                                                    ),
                                                    //
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0),
                                                      child: widget.serviceModel
                                                                  .pricingBy ==
                                                              'bundle'
                                                          ? Text(
                                                              '${data.requestedplanArray!.first.minimumPrice}\$',
                                                              style: interText(
                                                                  16,
                                                                  Colors.black,
                                                                  FontWeight
                                                                      .bold),
                                                            )
                                                          : Text(
                                                              '${provider.getPrice(data.requestedplanArray!.first.requestedAttributes)}\$',
                                                              style: interText(
                                                                  16,
                                                                  Colors.black,
                                                                  FontWeight
                                                                      .bold),
                                                            ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ]),
                            ),
                          );
                        }).toList(),
                      )
                : Center(
                    child: CircularProgressIndicator(
                      color: myColors.green,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class TopSection extends StatelessWidget {
  const TopSection({
    super.key,
    required this.widget,
  });

  final RequestedServiceDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return Consumer<PricingProvider>(
      builder: (context, provider, _) => Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close)),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () async {
                        if (widget.serviceModel.statusId ==
                            PendingRequested.Area_not_add) {
                          //No Area Added;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PreferedServiceAreas2(
                                      AllServiceItems.fromJson(
                                          widget.serviceModel.toJson()))));
                        } else {
                          //Pricing Required
                          EasyLoading.show(maskType: EasyLoadingMaskType.black);
                          if (await provider.getPriceConfiguration(
                              serviceTextId: widget.serviceModel.serviceTextId,
                              plan: provider
                                  .pendingPlanArrayList.first.planTextId,
                              zone: provider
                                  .pricingZoneArrayList.first.zoneTextId,
                              type: widget.serviceModel.pricingBy,
                              categoryTextId:
                                  widget.serviceModel.categoryTextId)) {
                            EasyLoading.dismiss();
                            provider.zoneListForDropDown.clear();
                            provider.zoneListForDropDown
                                .addAll(provider.zoneList);
                            provider.planListForDropDown.clear();
                            provider.planListForDropDown
                                .addAll(provider.servicePlanList);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DynamicFromPricing(
                                        widget.serviceModel)));
                          } else {
                            EasyLoading.dismiss();
                          }
                        }
                      },
                      child: Text(
                        'Edit Pricing',
                        style: TextStyle(color: AppColors.black),
                      )),
                  SizedBox(
                    width: 6,
                  )
                ],
              ))
            ],
          ),
          Container(
            color: myColors.divider,
            height: 1,
          ),
        ],
      ),
    );
  }
}
