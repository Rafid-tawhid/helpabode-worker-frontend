import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/screens/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';
import '../../corporate/views/custom_bottom_button.dart';
import '../../helper_functions/colors.dart';
import '../../misc/constants.dart';
import '../../models/pricing_attribute_model_new.dart';
import '../../provider/pricing_provider.dart';
import '../../widgets_reuse/expandable_text.dart';
import '../../widgets_reuse/reverse_triangle.dart';

class PricingPreview extends StatefulWidget {
  final ServiceInfo serviceInfo;

  PricingPreview(this.serviceInfo);

  @override
  State<PricingPreview> createState() => _PricingPreviewState();
}

class _PricingPreviewState extends State<PricingPreview> {
  String? selectedPlan;
  String? selectedPlanTextId;
  String description = '';
  String imageUrl = '';
  int selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  late PricingProvider pro;

  @override
  void initState() {
    super.initState();
    pro = Provider.of<PricingProvider>(context, listen: false);
    description = pro.servicePlanList[0].servicePlanDescription ?? '';
    selectedPlan = pro.servicePlanList.first.planTitle ?? '';
    //pro.getPlanwizeServiceAreaInfo(selectedPlan ?? '');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<PricingProvider>(builder: (context, provider, _) {
        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.serviceInfo.serviceName ?? '',
                                  style: interText(
                                      14, Colors.black, FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Preview',
                                  style: interText(
                                      14, Colors.black, FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          ],
                        )),
                        IconButton(
                            onPressed: () {
                              //   Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.transparent,
                            )),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 4,
                      color: Colors.grey.shade200,
                    ),
                    Container(
                      color: myColors.green,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer<PricingProvider>(
                            builder: (context, pro, _) => Container(
                              height: 50,
                              color: myColors.green,
                              alignment: Alignment.center,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: pro.pendingPlanArrayList.length,
                                itemExtent: pro.pendingPlanArrayList.length < 3
                                    ? MediaQuery.of(context).size.width / 2
                                    : MediaQuery.of(context).size.width / 3,
                                itemBuilder: (context, index) => InkWell(
                                  onTap: () async {
                                    setState(() {
                                      selectedIndex = index;
                                      selectedPlanTextId = pro
                                          .pendingPlanArrayList[index]
                                          .planTextId;
                                      selectedPlan = pro
                                          .pendingPlanArrayList[index]
                                          .planTitle;
                                      pro.getPlanwizeServiceAreaInfoNew(pro
                                              .pendingPlanArrayList[index]
                                              .planTextId ??
                                          '');
                                    });
                                  },
                                  child: Container(
                                    // duration: const Duration(milliseconds: 000), // Animation duration
                                    decoration: BoxDecoration(
                                      color: index == selectedIndex
                                          ? const Color(0XFF007A48)
                                          : const Color(0xFF1A9562),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(2),
                                              height: 16,
                                              width: 16,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 1),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: index == selectedIndex
                                                      ? Colors.white
                                                      : const Color(0xFF1A9562),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            // Use FittedBox to automatically adjust font size to fit the available space
                                            Text(
                                              pro.pendingPlanArrayList[index]
                                                          .planTitle!.length >
                                                      12
                                                  ? DashboardHelpers.truncateString(
                                                      pro
                                                              .pendingPlanArrayList[
                                                                  index]
                                                              .planTitle ??
                                                          '',
                                                      12)
                                                  : pro
                                                          .pendingPlanArrayList[
                                                              index]
                                                          .planTitle ??
                                                      '',
                                              textAlign: TextAlign.center,
                                              maxLines:
                                                  1, // Ensure that the text is displayed on a single line
                                              overflow: TextOverflow
                                                  .ellipsis, // Display "..." if the text overflows
                                              style: GoogleFonts.inter(
                                                color: index == selectedIndex
                                                    ? Colors.white
                                                    : Colors.white70,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Container(
                                          color: index == selectedIndex
                                              ? const Color(0XFF007A48)
                                              : const Color(0xFF1A9562),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomPaint(
                                                size: const Size(22, 12),
                                                painter:
                                                    ReversedTrianglePainter(
                                                        index, selectedIndex),
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
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          'My Service Areas',
                          style: textField_16_black_bold_LabelTextStyle,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      // decoration: const BoxDecoration(color: Color(0xFFF7F7F7)),
                      decoration: const BoxDecoration(color: Colors.white),
                      padding: EdgeInsets.only(left: 12, right: 12, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Details:',
                            style: interText(16, Colors.black, FontWeight.w500),
                          ),
                          ExpandText(
                            text: provider.planListForDropDown[selectedIndex]
                                    .servicePlanDescription ??
                                '',
                            maxLines: 2,
                          )
                        ],
                      ),
                    ),
                    provider.showArea
                        ? provider
                                .requestedServiceDetailsPricingListShow.isEmpty
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
                                                style: interText(
                                                    14,
                                                    AppColors.black,
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
                                      provider
                                          .requestedServiceDetailsPricingListShow
                                          .indexOf(data)];
                                  var attribute = zone.requestedplanArray!
                                      .firstWhere(
                                          (e) => e.planTextId == selectedPlan);
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            width: 1, color: Colors.white),
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
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          iconColor: Colors.black87,
                                          leading: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: const Icon(
                                              Icons.location_on,
                                              color: Colors.black,
                                            ),
                                          ),
                                          trailing: provider.isExpanded[provider
                                                  .requestedServiceDetailsPricingList
                                                  .indexOf(data)]
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          color: Colors.black),
                                                      child: const Icon(
                                                        Icons.keyboard_arrow_up,
                                                        color: Colors.white,
                                                        size: 24,
                                                      )),
                                                ) // Custom icon when expanded
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Container(
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          color: Colors.black),
                                                      child: const Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                        size: 24,
                                                        color: Colors.white,
                                                      )),
                                                ),
                                          // Custom icon when collapsed
                                          onExpansionChanged:
                                              (bool expanding) async {
                                            provider.setExpanded(
                                                provider
                                                    .requestedServiceDetailsPricingListShow
                                                    .indexOf(data),
                                                expanding);
                                            //provider.getAttributes(index, selectedPlan, provider.requestedServiceDetailsPricingList[index].zoneTextId);
                                          },
                                          title: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              provider
                                                      .requestedServiceDetailsPricingList[
                                                          provider
                                                              .requestedServiceDetailsPricingListShow
                                                              .indexOf(data)]
                                                      .zoneTitle ??
                                                  '',
                                              style: interText(16, Colors.black,
                                                  FontWeight.bold),
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
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      shrinkWrap: true,
                                                      itemCount: provider
                                                          .requestedServiceDetailsPricingList[
                                                              provider
                                                                  .requestedServiceDetailsPricingListShow
                                                                  .indexOf(
                                                                      data)]
                                                          .zipWisePrice!
                                                          .length,
                                                      itemBuilder: (context,
                                                          horizontalIndex) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 8.0,
                                                                  horizontal:
                                                                      4),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFFF7F7F7),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: .1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: Center(
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12.0,
                                                                    vertical:
                                                                        4),
                                                                child: Text(provider
                                                                    .requestedServiceDetailsPricingList[provider
                                                                        .requestedServiceDetailsPricingListShow
                                                                        .indexOf(
                                                                            data)]
                                                                    .zipWisePrice![horizontalIndex]),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      // _scrollToNextItem();
                                                    },
                                                    child: Container(
                                                      width: 34,
                                                      height: 34,
                                                      alignment:
                                                          Alignment.center,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 9),
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration:
                                                          ShapeDecoration(
                                                        color: Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                        ),
                                                        shadows: [
                                                          BoxShadow(
                                                            color: Color(
                                                                0x33000000),
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(-1, 1),
                                                            spreadRadius: 0,
                                                          )
                                                        ],
                                                      ),
                                                      child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 18,
                                                      ),
                                                    ),
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
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16,
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
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child: Center(
                                                                child: Text(
                                                                  'Estimated times',
                                                                  style: interText(
                                                                      14,
                                                                      AppColors
                                                                          .black,
                                                                      FontWeight
                                                                          .bold),
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
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 16,
                                                          horizontal: 16.0),
                                                      child: Text(
                                                        'Minimum order price',
                                                        style: interText(
                                                            14,
                                                            AppColors.black,
                                                            FontWeight.bold),
                                                      ),
                                                    )),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child: Center(
                                                                child: Text(
                                                                  '-',
                                                                  style: interText(
                                                                      14,
                                                                      AppColors
                                                                          .black,
                                                                      FontWeight
                                                                          .bold),
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
                                                                      attribute
                                                                              .minimumPrice ??
                                                                          '',
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
                                                if (attribute
                                                        .requestedAttributes !=
                                                    null)
                                                  ...attribute
                                                      .requestedAttributes!
                                                      .map((data) {
                                                    return data.isPricing ==
                                                            'Yes'
                                                        ? data.requestedOptions!
                                                                    .length >
                                                                1
                                                            ? ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount: data
                                                                    .requestedOptions!
                                                                    .length,
                                                                physics:
                                                                    NeverScrollableScrollPhysics(),
                                                                itemBuilder:
                                                                    (context,
                                                                            index) =>
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                                child: Padding(
                                                                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16.0),
                                                                              child: Text(
                                                                                '${data.title}(${data.requestedOptions![index].optionLabel})',
                                                                                style: interText(14, AppColors.black, FontWeight.bold),
                                                                              ),
                                                                            )),
                                                                            Expanded(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(4.0),
                                                                                child: Row(
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
                                                                      child:
                                                                          Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            2,
                                                                        horizontal:
                                                                            16.0),
                                                                    child: Text(
                                                                      data.title ??
                                                                          '',
                                                                      style: interText(
                                                                          14,
                                                                          AppColors
                                                                              .black,
                                                                          FontWeight
                                                                              .bold),
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
                                                                            flex:
                                                                                2,
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                '${data.requestedOptions!.first.estTime} min' ?? '',
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
                                                                                    '\$${data.requestedOptions!.first.price}' ?? '',
                                                                                    style: interText(14, AppColors.black, FontWeight.bold),
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      color: Colors.white,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 16,
                                                                horizontal:
                                                                    16.0),
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
                                                                  FontWeight
                                                                      .bold),
                                                            ),
                                                            //
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          8.0),
                                                              child: widget
                                                                          .serviceInfo
                                                                          .pricingBy ==
                                                                      'bundle'
                                                                  ? Text(
                                                                      '${data.requestedplanArray!.first.minimumPrice}\$',
                                                                      style: interText(
                                                                          16,
                                                                          Colors
                                                                              .black,
                                                                          FontWeight
                                                                              .bold),
                                                                    )
                                                                  : Text(
                                                                      '${provider.getPrice(data.requestedplanArray!.first.requestedAttributes)}\$',
                                                                      style: interText(
                                                                          16,
                                                                          Colors
                                                                              .black,
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
              CustomBottomButton(
                btnText: 'Close',
                onpressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                },
              )
            ],
          ),
        );
      }),
    );
  }

  Column BundleServicePreview(PricingProvider provider) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(color: Color(0xFFF7F7F7)),
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.black,
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                  child: Text(
                provider.priceConfigrationModelList.first.zoneTitle ?? '',
                style: interText(14, Colors.black, FontWeight.w500),
              ))
            ],
          ),
        ),
        SizedBox(
          height: 50,
          child: Row(
            children: [
              ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: provider
                    .priceConfigrationPreviewList.first.zipWisePrice!.length,
                itemBuilder: (context, horizontalIndex) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: .1),
                          borderRadius: BorderRadius.circular(8)),
                      width: MediaQuery.sizeOf(context).height / 5,
                      child: Center(
                        child: Text(provider.priceConfigrationPreviewList.first
                            .zipWisePrice![horizontalIndex]),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        ListView.builder(
          itemCount: provider.bundleAttributeList.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Container(
            // color: provider.getPlanattributeList.indexOf(entry.value) == provider.getPlanattributeList.length - 1 ? Colors.grey.shade300 : null,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(provider.bundleAttributeList[index].title),
                          Text(
                              '\$${provider.bundleAttributeList[index].option[''].toString()}'),
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      if (provider.bundleAttributeList.length != index + 1)
                        const Divider(
                          height: .2,
                          color: Colors.grey,
                        ),
                    ],
                  ),
                ),
                if (provider.bundleAttributeList.length == index + 1)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 2,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Minimum order price'),
                            Text(
                                '\$${provider.priceConfigrationModelList.first.planArray!.first.minimumPrice}'),
                          ],
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.header,
    required this.children,
  });

  String expandedValue;
  String header;
  List<String> children;
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool isExpanded2 = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: isExpanded2 ? 2 : widget.maxLines,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.justify,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded2 = !isExpanded2;
            });
          },
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isExpanded2 ? 'See More' : 'See Less',
                    style: TextStyle(
                      color: myColors.green,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  isExpanded2
                      ? Icon(
                          Icons.arrow_drop_down_sharp,
                          color: myColors.green,
                        )
                      : Icon(
                          Icons.arrow_drop_up,
                          color: myColors.green,
                        )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ReadMoreText extends StatefulWidget {
  final String text;
  final int maxLines;

  ReadMoreText({required this.text, required this.maxLines});

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}
