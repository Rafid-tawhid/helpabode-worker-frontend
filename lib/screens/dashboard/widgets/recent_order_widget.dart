import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import '../../../models/dashboardRunningServicemodel.dart';
import '../../open_order/open_order_screen.dart';
import 'home_screen_service_card.dart';

class RecentOrdersWidget extends StatelessWidget {
  RecentOrdersWidget({super.key, required this.serviceList});
  final List<DashboardRunningServicemodel> serviceList;

  CarouselSliderController csc = CarouselSliderController();

  // @override
  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = serviceList
        .map((item) => Container(
              margin: EdgeInsets.all(5.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: WorkerRunningServiceItem(
                    item: item,
                  ),
                ),
              ),
            ))
        .toList();
    return Container(
      width: MediaQuery.of(context).size.width,
      // margin: EdgeInsets.symmetric(
      //   horizontal: 14,
      //   vertical: 16,
      // ),
      decoration: BoxDecoration(
        color: Color(0XFFE7F3FF),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 8, top: 20),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/receipt.svg',
                  height: 24,
                  width: 24,
                ),
                Text(
                  ' Recent Orders',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RequestedServiceScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: myColors.green, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 12,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('see all',
                                style: interText(
                                    14, Colors.black54, FontWeight.w500)),
                            SizedBox(
                              width: 6,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Container(
              width: MediaQuery.of(context).size.width < 600
                  ? MediaQuery.of(context).size.width +
                      (Platform.isAndroid ? 16 : 24)
                  : MediaQuery.of(context).size.width + 280,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CarouselSlider(
                carouselController: csc,
                options: CarouselOptions(
                  // initialPage: 0,
                  height: 200,
                  // aspectRatio: MediaQuery.of(context).size.width < 600 ? 16/9 : 3.2,
                  viewportFraction: (MediaQuery.of(context).size.width < 600 &&
                          serviceList.length == 1)
                      ? .9
                      : (MediaQuery.of(context).size.width < 600 ? .8 : .4),
                  // viewportFraction: .8,
                  autoPlay: serviceList.length > 1 ? true : false,
                  //enlargeCenterPage: true,
                  // enlargeStrategy: CenterPageEnlargeStrategy.height,
                  onPageChanged: (index, reason) {},
                ),
                items: imageSliders,
                // items: widget.serviceList.map(
                //   (service) {
                //     return Builder(
                //       builder: (BuildContext context) {
                //         return ServiceCard1(boxMargin: null, service: service);
                //       },
                //     );
                //   },
                // ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//var provider = context.read<OrderProvider>();
//                                   provider.setRunningServiceLoading(
//                                       index, true);
//                                   if (await provider
//                                       .getWorkerPendingServiceDetails(
//                                     selectedItem.orderTimesId.toString(),
//                                     selectedItem.serviceTextId!,
//                                   )) {
//                                     // provider.setRunningServiceLoading(index, false);
//                                     Navigator.push(
//                                       context,
//                                       CupertinoPageRoute(
//                                         builder: (context) =>
//                                             PendingOrderedServiceDetailsScreen(
//                                           orderTextId:
//                                               selectedItem.orderNumber ?? '',
//                                           serviceId:
//                                               selectedItem.serviceTextId ?? '',
//                                         ),
//                                       ),
//                                     );

//class RecentOrdersWidget extends StatefulWidget {
//   final List<DashboardRunningServicemodel> runningServiceList;
//   final Function(DashboardRunningServicemodel, int) onViewDetails;
//
//   const RecentOrdersWidget({
//     Key? key,
//     required this.runningServiceList,
//     required this.onViewDetails,
//   }) : super(key: key);
//
//   @override
//   _RecentOrdersWidgetState createState() => _RecentOrdersWidgetState();
// }
//
// class _RecentOrdersWidgetState extends State<RecentOrdersWidget> {
//   late final ScrollController _scrollController;
//   late final Timer _scrollTimer;
//   int _currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     _startAutoScroll();
//   }
//
//   void _startAutoScroll() {
//     _scrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
//       if (_scrollController.hasClients && widget.runningServiceList.isNotEmpty) {
//         _currentIndex = (_currentIndex + 1) % widget.runningServiceList.length;
//         final double nextOffset = _currentIndex *
//             (MediaQuery.of(context).size.width); // Adjust width to item size
//
//         _scrollController.animateTo(
//           nextOffset,
//           duration: const Duration(milliseconds: 500),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollTimer.cancel();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.runningServiceList.isNotEmpty
//         ? SizedBox(
//       height: 220,
//       child: Container(
//         color: const Color(0XFFE7F3FF),
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 const Icon(Icons.bookmark_border_rounded),
//                 Text(
//                   ' Recent Orders',
//                   style: TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const Spacer(),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 8.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                           const RequestedServiceScreen(),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(
//                             color: Colors.green, width: 1),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 2,
//                           horizontal: 8,
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: const [
//                             Text(
//                               'see all',
//                               style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                             Icon(Icons.arrow_forward_ios, size: 12),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: ListView.builder(
//                 controller: _scrollController,
//                 scrollDirection: Axis.horizontal,
//                 itemCount: widget.runningServiceList.length,
//                 itemBuilder: (context, index) {
//                   final item = widget.runningServiceList[index];
//                   return Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: Center(
//                       child: WorkerRunningServiceItem(
//                         item: item,
//                         onViewDetails: (selectedItem) =>
//                             widget.onViewDetails(selectedItem, index),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     )
//         : const Text('');
//   }
// }
