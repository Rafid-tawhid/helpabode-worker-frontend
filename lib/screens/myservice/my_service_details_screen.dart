import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/models/pending_price_view_details_model.dart';
import 'package:help_abode_worker_app_ver_2/screens/myservice/widgets/zip_update_modal.dart';
import 'package:help_abode_worker_app_ver_2/screens/pricing/widgets/show_service_attribute_animation.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/circular_image_with_shimmer.dart';
import 'package:provider/provider.dart';

import '../../helper_functions/colors.dart';
import '../../misc/constants.dart';
import '../../models/get_my_selected_services.dart';
import '../../models/pending_requested_servicelist.dart';
import '../../provider/pricing_provider.dart';
import '../../widgets_reuse/custom_elevated_button.dart';
import '../../widgets_reuse/expandable_text.dart';
import '../add_new_service/my_service_add_zone_screen.dart';
import '../pricing/dynamic_form_pricing.dart';

class MyServiceDetailsScreen extends StatefulWidget {
  PendingRequestedServiceList serviceModel;

  MyServiceDetailsScreen(this.serviceModel);

  @override
  State<MyServiceDetailsScreen> createState() => _MyServiceDetailsScreenState();
}

class _MyServiceDetailsScreenState extends State<MyServiceDetailsScreen> {
  int selectedIndex = 0;
  bool showAttribute = false;
  int? maxLines = 3;
  bool isExpanded = false;

//if(showAttribute&&widget.serviceModel.pricingBy=='Bundle') ShowServiceAttributeAnimation(showAttribute, widget.serviceModel)
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<PricingProvider>(
            builder: (context, provider, _) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    TopSection(widget: widget),
                    ServiceInfoSection(widget, showAttribute),

                    //  Padding(
                    //    padding: const EdgeInsets.only(left: 16.0),
                    //    child: Align(
                    //      alignment: Alignment.bottomLeft,
                    //      child: InkWell(
                    //        onTap: () {
                    //          setState(() {
                    //            showAttribute = !showAttribute;
                    //            if (maxLines == 3) {
                    //              maxLines = null;
                    //            } else {
                    //              maxLines = 3;
                    //            }
                    //          });
                    //        },
                    //        child: Row(
                    //          mainAxisSize: MainAxisSize.min,
                    //          children: [
                    //            Text(
                    //              showAttribute ? 'Show Less' : 'Show More',
                    //              style: interText(14, myColors.green, FontWeight.w500),
                    //            ),
                    //            Icon(
                    //              showAttribute ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_sharp,
                    //              color: myColors.green,
                    //            )
                    //          ],
                    //        ),
                    //      ),
                    //    ),
                    //  ),
                    SizedBox(height: 10),
                    if (provider.pendingPlanArrayList.first.planTextId != 'AdminDefaultPlan' && provider.pendingPlanArrayList.first.planTextId != 'AdminBundlePlan')
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: myColors.greyBtn,
                          ),
                          alignment: Alignment.center,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: provider.pendingPlanArrayList.length,
                            itemExtent: provider.pendingPlanArrayList.length < 3 ? (MediaQuery.of(context).size.width / 2) - 16 : (MediaQuery.of(context).size.width / 3) - 8,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: index == selectedIndex ? Colors.white : myColors.greyBtn,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    // Use Center to reduce complexity
                                    child: Text(
                                      provider.pendingPlanArrayList[index].planTitle!.length > 12 ? DashboardHelpers.truncateString(provider.pendingPlanArrayList[index].planTitle ?? '', 12) : provider.pendingPlanArrayList[index].planTitle ?? '',
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
                    if (provider.pendingPlanArrayList.first.planTextId != 'AdminBundlePlan' && provider.pendingPlanArrayList.first.planTextId != 'AdminDefaultPlan')
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ExpandText(
                                text: DashboardHelpers.removeSpecialCharacters(provider.pendingPlanArrayList[selectedIndex].planDetails ?? ''),
                                maxLines: 3,
                                position: true,
                              )
                            ],
                          ),
                        ),
                      ),
                    if (widget.serviceModel.pricingBy == 'Bundle' || widget.serviceModel.pricingBy == 'bundle') ShowServiceAttributes(provider.pricingServiceDetailsinfo!.attributes ?? []),

                    MyServiceAreaZones(widget: widget),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class MyServiceAreaZones extends StatelessWidget {
  const MyServiceAreaZones({
    super.key,
    required this.widget,
  });

  final MyServiceDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Service Areas',
                style: interText(20, Colors.black, FontWeight.w600),
              ),
              Container(
                height: 36,
                child: CustomElevatedButton(
                    color: myColors.greyBtn,
                    borderRadius: 8,
                    style: interText(14, Colors.black, FontWeight.w600),
                    title: 'Add+',
                    onPressed: () {
                      var pp = context.read<PricingProvider>();
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => MyServiceAddZoneScreen(service: pp.pricingServiceDetailsinfo!)));
                    }),
              ),
            ],
          ),
        ),
        Consumer<PricingProvider>(
          builder: (context, provider, _) => ListView.builder(
            itemCount: provider.pricingZoneArrayList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              PricingZoneArray e = provider.pricingZoneArrayList[index];
              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: InkWell(
                  onTap: () {
                    show_zip_update_modal(context, e, widget.serviceModel);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(8),
                      color: Color(0xffF7F7F7),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.location_on,
                              color: Colors.black,
                            )),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            '${e.zoneTitle}',
                            style: interText(16, Colors.black, FontWeight.w600),
                          ),
                        )),
                        IconButton(
                            onPressed: () {
                              // provider.pricingZoneArrayList.forEach((element) => debugPrint(element.zoneTextId));
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.black,
                            )),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class TopSection extends StatelessWidget {
  const TopSection({
    super.key,
    required this.widget,
  });

  final MyServiceDetailsScreen widget;

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
                  icon: Icon(
                    Icons.close,
                    size: 20,
                  )),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //  Text('Pause', style: interText(14, Colors.black, FontWeight.w600)),
                  SizedBox(width: 6),
                  TextButton(
                      onPressed: () async {
                        EasyLoading.show(maskType: EasyLoadingMaskType.black);
                        //crutial change here nov 4
                        // await provider.getPriceConfiguration(serviceTextId: widget.serviceModel.serviceTextId, plan: provider.pendingPlanArrayList.first.planTextId, zone: provider.pricingZoneArrayList.first.zoneTextId, type: widget.serviceModel.pricingBy,categoryTextId: provider.serviceInfo.categoryTextId
                        try {
                          if (provider.pendingPlanArrayList.isNotEmpty && provider.pricingZoneArrayList.isNotEmpty) {
                            bool isConfigured = await provider.getPriceConfiguration(
                              serviceTextId: widget.serviceModel.serviceTextId,
                              plan: provider.pendingPlanArrayList.first.planTextId,
                              zone: provider.pricingZoneArrayList.first.zoneTextId,
                              type: widget.serviceModel.pricingBy,
                              categoryTextId: widget.serviceModel.categoryTextId,
                            );

                            debugPrint('isConfigured ${isConfigured}');

                            if (isConfigured) {
                              EasyLoading.dismiss();
                              provider.zoneListForDropDown.clear();
                              provider.zoneListForDropDown.addAll(provider.zoneList);
                              provider.planListForDropDown.clear();
                              provider.planListForDropDown.addAll(provider.servicePlanList);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DynamicFromPricing(widget.serviceModel),
                                ),
                              );
                            }
                          } else {
                            EasyLoading.dismiss();
                            DashboardHelpers.showAlert(msg: 'Something went wrong');
                            // Optionally show an error message here if lists are empty
                            print('Required data is missing: Plan or Zone array is empty.');
                          }
                        } catch (e) {
                          EasyLoading.dismiss();
                          print('Error: $e'); // Log the error for debugging
                        }
                      },
                      child: Text(
                        provider.pricingServiceDetailsinfo!.status == JobStatus.pending ? 'Add Pricing' : 'Edit Pricing',
                        style: interText(14, Colors.black, FontWeight.w600),
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

class ServiceInfoSection extends StatelessWidget {
  final MyServiceDetailsScreen widget;
  bool showAttribute;

  ServiceInfoSection(this.widget, this.showAttribute);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: Column(
              children: [
                Consumer<PricingProvider>(
                    builder: (context, provider, _) => Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomCircleShimmerImage(
                                  imageUrl: '$urlBase${widget.serviceModel.image}',
                                  placeholder: 'images/placeholder.jpg',
                                  size: 72,
                                  borderRadius: 4,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.serviceModel.serviceTitle ?? '',
                                          style: interText(16, AppColors.black, FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.check_circle, color: myColors.green, size: 20),
                                              SizedBox(width: 4),
                                              Text(provider.pricingServiceDetailsinfo!.status ?? '', textAlign: TextAlign.center, style: interText(12, myColors.green, FontWeight.w500)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.grey.shade400,
                                              size: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 2.0),
                                              child: Text(provider.pricingServiceDetailsinfo!.avgRating.toString()),
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Icon(
                                              Icons.thumb_up_alt,
                                              color: Colors.grey.shade400,
                                              size: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0),
                                              child: Text(provider.pricingServiceDetailsinfo!.totalLike.toString()),
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Text('Total orders : ${0}')
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            ExpandText(
                              text: DashboardHelpers.removeSpecialCharacters('${provider.pricingServiceDetailsinfo!.shortDescription}' ?? ''),
                              maxLines: 3,
                              position: true,
                              pricingBy: provider.pricingServiceDetailsinfo!.pricingBy,
                              pendingAttributes: provider.pricingServiceDetailsinfo!.attributes,
                            )
                          ],
                        )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Row HeaderSection(BuildContext context, Services serviceModel) {
  return Row(
    children: [
      InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.close)),
      Expanded(
        child: Text(
          serviceModel.serviceTitle ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Icon(
        Icons.close,
        color: Colors.transparent,
      ),
    ],
  );
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PricingProvider>(context);
    final attributes = provider.pricingServiceDetailsinfo!.attributes!;
    final visibleAttributes = _showAll ? attributes : attributes.take(4).toList();

    return Visibility(
      visible: provider.pricingServiceDetailsinfo != null,
      child: Column(
        children: [
          SizedBox(
            height: _showAll ? 150 : (attributes.length <= 2 ? 50 : (attributes.length <= 4 ? 100 : 150)),
            child: GridView.builder(
              itemCount: visibleAttributes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of items per row
                crossAxisSpacing: 10.0, // Spacing between each item horizontally
                mainAxisSpacing: 10.0, // Spacing between each row vertically
                childAspectRatio: 5, // Aspect ratio of each item
              ),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey, // Replace with your color
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                    child: Text(
                      visibleAttributes[index].title ?? '',
                      maxLines: 1,
                      style: GoogleFonts.inter(),
                    ),
                  ),
                );
              },
            ),
          ),
          if (attributes.length > 4)
            TextButton(
              onPressed: () {
                setState(() {
                  _showAll = !_showAll;
                });
              },
              child: Text(_showAll ? 'See Less' : 'See More'),
            ),
        ],
      ),
    );
  }
}
