import 'package:cached_network_image/cached_network_image.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/pricing_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/dashboard/dashboard_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/myservice/my_service_details_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/pricing/requested_service_details/requested_service_details_screen.dart';
import 'package:help_abode_worker_app_ver_2/screens/pricing/widgets/pricing_next_button.dart';
import 'package:help_abode_worker_app_ver_2/screens/pricing/widgets/rejected_popup.dart';
import 'package:provider/provider.dart';
import '../../widgets_reuse/custom_dashed_widgets.dart';

class PricingScreen extends StatefulWidget {
  PricingScreen({super.key});

  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  late PricingProvider serviceProvider;

  @override
  void didChangeDependencies() {
    serviceProvider = Provider.of(context, listen: false);
    serviceProvider.getAllServicesOfUser().then((value) {
      // serviceProvider.getPendingRequestedPricingService(false);
      debugPrint('requestedListFinal ${serviceProvider.requestedListFinal.length}');
      debugPrint('pendingListFinal ${serviceProvider.pendingListFinal.length}');
    });

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    setLoading();
    super.dispose();
  }

  void setLoading() {
    serviceProvider.isLoadingPrices(true);
  }

  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => MyServicesScreen()));
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back)),
                Expanded(
                    child: Text(
                  'Pricing',
                  style: interText(16, Colors.black, FontWeight.w600),
                  textAlign: TextAlign.center,
                )),
                IconButton(
                    onPressed: () {
                      //  Navigator.pop(context);
                      //debugPrint('HELLO');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                    },
                    icon: Icon(
                      Icons.home,
                    )),
              ],
            ),
            Consumer<PricingProvider>(
              builder: (context, provider, _) => Expanded(
                child: ContainedTabBarView(
                  tabBarProperties: TabBarProperties(
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 4.0,
                        color: myColors.green,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      insets: const EdgeInsets.symmetric(
                        horizontal: 0.0,
                      ),
                    ),
                    labelColor: myColors.green,
                    indicatorColor: myColors.green,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                  tabs: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('PENDING'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('REQUESTED'),
                    ),
                  ],
                  views: [PendingPricingCard(), RequestedPricingCard()],
                  onChange: (index) {
                    // if (index == 0) {
                    //   provider.getPendingRequestedPricingService(false);
                    // }
                    // if (index == 1) {
                    //   provider.getPendingRequestedPricingService(true);
                    // }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PendingPricingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<PricingProvider>(
          builder: (context, pro, _) => Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 12),
            child: pro.pendingListFinal.length > 0 ? Text('Select Services below to provide pricing') : Text(''),
          ),
        ),
        Expanded(child: Consumer<PricingProvider>(
          builder: (context, provider, _) {
            if (provider.isloadingPrices) {
              return Center(
                child: CircularProgressIndicator(
                  color: myColors.green,
                ),
              );
            } else if (provider.pendingListFinal.isEmpty) {
              return const Center(
                child: Text('No Service Found'),
              );
            } else {
              //provider.generateBooleanListForLoading(provider.pendingListFinal.length);
              return ListView.builder(
                itemCount: provider.pendingListFinal.length,
                itemBuilder: (context, index) {
                  var service = provider.pendingListFinal[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8.0),
                    child: Card(
                      elevation: 0.0, // Remove default elevation if needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // Adjust corner radius as desired
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x0C11111A),
                              // Inner shadow color with slight transparency
                              blurRadius: 32.0,
                              // Adjust blur radius for softness
                              offset: Offset(0.0, 8.0), // Move shadow slightly downwards
                            ),
                            BoxShadow(
                              color: Color(0x0C000000),
                              // Outer shadow color (black with transparency)
                              blurRadius: 16.0,
                              // Adjust blur radius for outer shadow
                              offset: Offset(0.0, 4.0), // Move outer shadow slightly downwards
                            ),
                          ],
                        ),
                        child: Consumer<PricingProvider>(
                          builder: (context, provider, _) => Column(
                            children: [
                              service.pricingBy == 'bundle' ? BundleServiceTopDesign() : SizedBox(),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: CachedNetworkImage(
                                              imageUrl: '$urlBase${service.image}',
                                              placeholder: (context, url) => Image.asset(
                                                'images/placeholder.jpg',
                                                // Replace with your placeholder image URL
                                                // Adjust the width as needed
                                                height: 72,
                                                width: 72,
                                                // Adjust the height as needed
                                                fit: BoxFit.cover,
                                              ),
                                              // Placeholder widget while loading
                                              errorWidget: (context, url, error) => Image.asset(
                                                'images/placeholder.jpg',
                                                // Replace with your placeholder image URL
                                                // Adjust the width as needed
                                                height: 72,
                                                width: 72,
                                                // Adjust the height as needed
                                                fit: BoxFit.cover,
                                              ),
                                              height: 72,
                                              width: 72,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            child: Padding(
                                          padding: const EdgeInsets.only(left: 16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${service.serviceTitle}',
                                                style: interText(16, Colors.black, FontWeight.w600),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                '(${service.categoryTitle})',
                                                style: TextStyle(fontSize: 12, color: myColors.grey),
                                              ),
                                              Text(
                                                service.status ?? '',
                                                style: interText(12, Colors.red, FontWeight.w600),
                                              )
                                            ],
                                          ),
                                        )),
                                      ],
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: FittedBox(
                                                    child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                  child: CustomPaint(
                                                    size: Size(MediaQuery.sizeOf(context).width / .9, 1),
                                                    // Adjust height if needed
                                                    painter: DashedLinePainter(
                                                      dashWidth: 5.0,
                                                      // Length of each dash
                                                      dashSpace: 2.0,
                                                      // Space between dashes
                                                      color: Color(0xffe9e9e9), // Color of the dashes
                                                    ),
                                                  ),
                                                )),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          child: Consumer<PricingProvider>(
                                            builder: (context, pro, _) => Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Color(0XFFE9E9E9),
                                                  )),
                                              child: Text(
                                                'View Details',
                                                style: interText(14, Colors.black, FontWeight.w500),
                                              ),
                                              height: 40,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(horizontal: 16),
                                            ),
                                          ),
                                          onTap: () async {
                                            // provider.isLoadingViewDetails(index, true);
                                            EasyLoading.show(maskType: EasyLoadingMaskType.black);
                                            if (await provider.getPricingServiceViewDetails(service.serviceTextId, 'Pending', service.categoryTextId)) {
                                              // provider.isLoadingViewDetails(index, false);
                                              EasyLoading.dismiss();
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => MyServiceDetailsScreen(service)));
                                            } else {
                                              EasyLoading.dismiss();
                                            }
                                          },
                                        ),
                                        AddPriceButton(service)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ))
      ],
    );
  }
}

class BundleServiceTopDesign extends StatelessWidget {
  const BundleServiceTopDesign({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0),
          topLeft: Radius.circular(10.0),
        ),
        color: Color(0xffdff2e1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: SvgPicture.asset(
              'assets/svg/diamond.svg',
              width: 32,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8,
              ),
              Text(
                'Fixed Service',
                style: interText(14, Color(0xff1b5e20), FontWeight.w700),
              ),
              Text(
                'High pay service!',
                style: interText(12, Color(0xff1b5e20), FontWeight.w500),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          )
        ],
      ),
      width: double.maxFinite,
    );
  }
}

class RequestedPricingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<PricingProvider>(
          builder: (context, pro, _) => Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 12),
            child: pro.requestedListFinal.length > 0 ? Text('Select Services below to provide pricing') : Text(''),
          ),
        ),
        Expanded(child: Consumer<PricingProvider>(
          builder: (context, provider, _) {
            if (provider.isloadingPrices) {
              return Center(
                child: CircularProgressIndicator(
                  color: myColors.green,
                ),
              );
            } else if (provider.requestedListFinal.isEmpty) {
              return const Center(
                child: Text('No Service Found'),
              );
            } else {
              return ListView.builder(
                // physics: NeverScrollableScrollPhysics(),
                itemCount: provider.requestedListFinal.length,
                itemBuilder: (context, index) {
                  var service = provider.requestedListFinal[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8.0),
                    child: Card(
                      elevation: 0.0, // Remove default elevation if needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // Adjust corner radius as desired
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x0C11111A),
                              blurRadius: 32.0,
                              offset: Offset(0.0, 8.0),
                            ),
                            BoxShadow(
                              color: Color(0x0C000000),
                              blurRadius: 16.0,
                              offset: Offset(0.0, 4.0),
                            ),
                          ],
                        ),
                        child: Consumer<PricingProvider>(
                          builder: (context, provider, _) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              service.pricingBy == 'bundle' ? BundleServiceTopDesign() : SizedBox(),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl: '$urlBase${service.image}',
                                          placeholder: (context, url) => Image.asset(
                                            'images/placeholder.jpg',
                                            // Replace with your placeholder image URL
                                            // Adjust the width as needed
                                            height: 72,
                                            width: 72,
                                            // Adjust the height as needed
                                            fit: BoxFit.cover,
                                          ),
                                          // Placeholder widget while loading
                                          errorWidget: (context, url, error) => Image.asset(
                                            'images/placeholder.jpg',
                                            height: 72,
                                            width: 72,
                                            // Adjust the height as needed
                                            fit: BoxFit.cover,
                                          ),
                                          height: 72,
                                          width: 72,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            service.serviceTitle ?? '',
                                            style: interText(16, Colors.black, FontWeight.w600),
                                          ),
                                          Text(
                                            service.shortDescription ?? '',
                                            style: interText(12, myColors.greyTxt, FontWeight.w400),
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    )),
                                    // subtitle: Text(service.serviceTextId ?? ''),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: FittedBox(
                                            child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: CustomPaint(
                                            size: Size(MediaQuery.sizeOf(context).width / .9, 1),
                                            // Adjust height if needed
                                            painter: DashedLinePainter(
                                              dashWidth: 5.0,
                                              dashSpace: 2.0,
                                              color: Color(0xffe9e9e9), // Color of the dashes
                                            ),
                                          ),
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.white,
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 2.0),
                                              child: Icon(
                                                Icons.check_circle,
                                                color: myColors.green,
                                                size: 18,
                                              ),
                                            ),
                                            Text(
                                              service.status ?? '',
                                              style: interText(13, myColors.green, FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        height: 40,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                      ),
                                      onTap: () {
                                        // _showServiceDetails(context, service);
                                        if (service.statusId == PendingRequested.PriceRejected) {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    content: RejectedPopupContent(service),
                                                  ));
                                        }
                                      },
                                    ),
                                    InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              width: 1,
                                              color: Color(0XFFE9E9E9),
                                            )),
                                        child: Text(
                                          'View Details',
                                          style: interText(14, Colors.black, FontWeight.w500),
                                        ),
                                        height: 40,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                      ),
                                      onTap: () async {
                                        // _showServiceDetails(context, service);
                                        //have to remove this later
                                        EasyLoading.show(maskType: EasyLoadingMaskType.black);
                                        debugPrint('provider.loadingList 1 ${provider.loadingList}');
                                        if (await provider.getPricingServiceViewDetails(service.serviceTextId, service.status ?? '', service.categoryTextId)) {
                                          // provider.isLoadingViewDetails(index, false);
                                          provider.getPlanwizeServiceAreaInfoNew(service.firstPlanTextId ?? '');
                                          EasyLoading.dismiss();
                                          debugPrint('provider.loadingList 2${provider.loadingList}');

                                          //change today 11feb
                                          // Navigator.push(context, CupertinoPageRoute(builder: (context) => PendinServiceDetailsScreen(service)));
                                          Navigator.push(context, CupertinoPageRoute(builder: (context) => RequestedServiceDetailsScreen(service)));
                                        } else {
                                          EasyLoading.dismiss();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ))
      ],
    );
  }

  Icon? getIcon(String? status, String? statusId) {
    if (status == 'Approved') {
      return Icon(
        Icons.monetization_on_outlined,
        color: Colors.white,
      );
    } else if (statusId == PendingRequested.PriceRejected) {
      return Icon(
        Icons.info_outline,
        color: Colors.white,
        size: 18,
      );
    } else
      return null;
  }

// void _showServiceDetails(BuildContext context, WorkerServiceModel serviceModel) {
//   showModalBottomSheet(
//     context: context,
//     builder: (BuildContext context) {
//       return SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Title
//               Text(
//                 serviceModel.serviceTitle ?? '',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Image
//               // FloatColumn(
//               //   children: [
//               //     Floatable(
//               //       float: FCFloat.start,
//               //       padding: EdgeInsets.only(right: 8),
//               //       child: Container(
//               //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
//               //         child: ClipRRect(
//               //           borderRadius: BorderRadius.circular(8),
//               //           child: Image.network(
//               //             '$urlBase${serviceModel.image}' ?? '', // Adjust the width as needed
//               //             height: 100.h, // Adjust the height as needed
//               //             fit: BoxFit.cover,
//               //             errorBuilder: (context, error, stackTrace) {
//               //               return Image.asset(
//               //                 'images/placeholder.jpg', // Replace with your placeholder image URL
//               //                 // Adjust the width as needed
//               //                 height: 100.h, // Adjust the height as needed
//               //                 fit: BoxFit.cover,
//               //               );
//               //             },
//               //           ),
//               //         ),
//               //       ),
//               //     ),
//               //     Floatable(
//               //       float: FCFloat.right,
//               //       clear: FCClear.right,
//               //       clearMinSpacing: 20,
//               //       padding: EdgeInsets.only(left: 8),
//               //       child: Html(
//               //         data: serviceModel.shortDescription ?? '',
//               //       ),
//               //     ),
//               //   ],
//               // ),
//
//               FloatColumn(
//                 children: [
//                   Floatable(
//                     float: FCFloat.start,
//                     padding: EdgeInsets.only(right: 8),
//                     child: Container(
//                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.network(
//                           '$urlBase${serviceModel.image}' ?? '', // Adjust the width as needed
//                           height: 100.h, // Adjust the height as needed
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Image.asset(
//                               'images/placeholder.jpg', // Replace with your placeholder image URL
//                               // Adjust the width as needed
//                               height: 100.h, // Adjust the height as needed
//                               fit: BoxFit.cover,
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                   WrappableText(text: TextSpan(text: serviceModel.shortDescription)),
//                 ],
//               ),
//               InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Align(
//                   alignment: Alignment.bottomRight,
//                   child: Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text('Close'),
//                   ),
//                 ),
//               )
//               // Close Button
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
}
