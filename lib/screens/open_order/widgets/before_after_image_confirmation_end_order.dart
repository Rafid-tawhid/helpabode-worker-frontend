import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shimmer/shimmer.dart';

import '../../../helper_functions/dashboard_helpers.dart';
import '../../../widgets_reuse/custom_rounded_button.dart';
import '../../dashboard/dashboard_screen.dart';
import '../completed_order/widgets/service_attribute.dart';

// class BeforeAfterImageAndEndOrder extends StatefulWidget {
//   @override
//   _BeforeAfterImageAndEndOrderState createState() =>
//       _BeforeAfterImageAndEndOrderState();
// }
//
// class _BeforeAfterImageAndEndOrderState
//     extends State<BeforeAfterImageAndEndOrder> {
//   // final List<String> beforeImages = [
//   //   'https://hips.hearstapps.com/hmg-prod/images/sarah-storms-photo-by-brian-wetzel-01-76-6682ea910395c.jpg?crop=0.668xw:1.00xh;0.159xw,0&resize=640:*',
//   //   'https://hips.hearstapps.com/hmg-prod/images/sarah-storms-photo-by-brian-wetzel-01-76-6682ea910395c.jpg?crop=0.668xw:1.00xh;0.159xw,0&resize=640:*',
//   //   'https://hips.hearstapps.com/hmg-prod/images/sarah-storms-photo-by-brian-wetzel-01-76-6682ea910395c.jpg?crop=0.668xw:1.00xh;0.159xw,0&resize=640:*',
//   //   'https://hips.hearstapps.com/hmg-prod/images/sarah-storms-photo-by-brian-wetzel-01-76-6682ea910395c.jpg?crop=0.668xw:1.00xh;0.159xw,0&resize=640:*',
//   //   'https://hips.hearstapps.com/hmg-prod/images/sarah-storms-photo-by-brian-wetzel-01-76-6682ea910395c.jpg?crop=0.668xw:1.00xh;0.159xw,0&resize=640:*',
//   //   'https://hips.hearstapps.com/hmg-prod/images/sarah-storms-photo-by-brian-wetzel-01-76-6682ea910395c.jpg?crop=0.668xw:1.00xh;0.159xw,0&resize=640:*',
//   // ];
//   //
//   // final List<String> afterImages = [
//   //   'https://hips.hearstapps.com/hmg-prod/images/sarah-storms-photo-by-brian-wetzel-01-76-6682ea910395c.jpg?crop=0.668xw:1.00xh;0.159xw,0&resize=640:*',
//   //   'https://hips.hearstapps.com/hmg-prod/images/sarah-storms-photo-by-brian-wetzel-01-76-6682ea910395c.jpg?crop=0.668xw:1.00xh;0.159xw,0&resize=640:*',
//   //   'https://hips.hearstapps.com/hmg-prod/images/sarah-storms-photo-by-brian-wetzel-01-76-6682ea910395c.jpg?crop=0.668xw:1.00xh;0.159xw,0&resize=640:*',
//   // ];
//
//   void openImageGallery(List<String> images, int index) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             FullScreenImageGallery(images: images, initialIndex: index),
//       ),
//     );
//   }
//
//   Widget buildImageList(List<String> images) {
//     return SizedBox(
//       height: 130,
//       child: images.isNotEmpty
//           ? ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: images.length,
//         itemBuilder: (context, index) {
//           return GestureDetector(
//             onTap: () => openImageGallery(images, index),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: CachedNetworkImage(
//                   imageUrl: '${urlBase}${images[index]}',
//                   width: 160,
//                   height: 130,
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) => Shimmer.fromColors(
//                     baseColor: Colors.grey[300]!,
//                     highlightColor: Colors.grey[100]!,
//                     child: Container(
//                       width: 160,
//                       height: 130,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                   errorWidget: (context, url, error) => Container(
//                     width: 160,
//                     height: 130,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       color: Colors.grey[200],
//                     ),
//                     child: Icon(Icons.error, color: Colors.red),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       )
//           : Center(child: Text('No Images Found')),
//     );
//   }
//
//
//
//
//   RoundedLoadingButtonController _bottomBtnController =
//       RoundedLoadingButtonController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Consumer<OrderProvider>(builder: (context,provider,_)=>Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             IconButton(onPressed: () {}, icon: Icon(Icons.close)),
//             Expanded(
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'No-contact service',
//                           style: interText(22, Colors.black, FontWeight.bold),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Text('Take after photo',
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold)),
//                         Text('Follow the guidelines below to show how you done your job. your photo will be shared with the customer.'),
//                         SizedBox(height: 10),
//                         buildImageList(provider.afterImages),
//                         //ImageSlider(images: provider.afterImages, urlBase: urlBase),
//                         SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     height: 10,
//                     color: myColors.devider,
//                     width: MediaQuery.sizeOf(context).width,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16.0, vertical: 16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Before photo',
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold)),
//                         SizedBox(height: 10),
//                        // ImageSlider(images: provider.beforeImage, urlBase: urlBase),
//                         buildImageList(provider.beforeImage),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: CustomRoundedButton(
//                 buttonColor: myColors.green,
//                 funcName: () async {
//                   // var provider = context.read<OrderProvider>();
//                   // _bottomBtnController.start();
//                   // await provider.postMultipleImageAfterStartWork(
//                   //     provider.pendingOrderInfoList.first.orderItemId
//                   //         .toString(),
//                   //     provider.pendingOrderInfoList.first.orderTextId,
//                   //     provider.cameraBeforeImageList);
//                   // await provider.saveWorkerStatus(
//                   //     provider.pendingOrderInfoList.first.orderTextId,
//                   //     'Completed',
//                   //     textId,
//                   //     provider.pendingOrderInfoList.first.serviceTextId
//                   //         .toString(),
//                   //     provider.pendingOrderInfoList.first.orderItemId
//                   //             .toString() ??
//                   //         '');
//                   // //clear image list
//                   // provider.clearImage();
//                   // //get order values again
//                   // await provider.getOpenOrderInfo();
//                   // //set status
//                   // provider.setPendingDetailsScreenServiceStatus(
//                   //     JobStatus.completed);
//                   // provider.mapJobStatusToOrderStatus(JobStatus.completed);
//                   // provider
//                   //     .getPendingDetailsScreenButtonText(JobStatus.completed);
//                   // DashboardHelpers.successStopAnimation(_bottomBtnController);
//                   _showJobCompletedSheet(context);
//                 },
//                 controller: _bottomBtnController,
//                 label: 'Confirm',
//                 fontColor: Colors.white,
//                 borderRadius: 40,
//               ),
//             ),
//           ],
//         )),
//       ),
//     );
//   }
//
//   void _showJobCompletedSheet(BuildContext context) {
//     RoundedLoadingButtonController _bottomBtnController = RoundedLoadingButtonController();
//     showModalBottomSheet(
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       context: context,
//       builder: (context) {
//         return showJobEndConfirmationAlert(context, _bottomBtnController);
//       },
//     );
//   }
//
//   Container showJobEndConfirmationAlert(BuildContext context, RoundedLoadingButtonController _bottomBtnController) {
//     return Container(
//         height: MediaQuery.sizeOf(context).height / 1.1,
//         child: SingleChildScrollView(
//           child: Consumer<OrderProvider>(
//               builder: (context, provider, _) => Container(
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         topRight: Radius.circular(20))),
//                 padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context).viewInsets.bottom,
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Align(
//                       alignment: Alignment.center,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 12),
//                         child: Text(
//                           'Job complete!',
//                           style: interText(
//                               24, Colors.black, FontWeight.w700),
//                         ),
//                       ),
//                     ),
//                     //Save Service Area
//                     Divider(thickness: 1, color: Color(0xffe9e9e9)),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 12),
//                         child: Text(
//                           'Service Details',
//                           style: interText(
//                               16, Colors.black, FontWeight.w700),
//                         ),
//                       ),
//                     ),
//                     Divider(thickness: 1, color: Color(0xffe9e9e9)),
//                     SizedBox(height: 8),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8.0),
//                             child: FadeInImage(
//                               fit: BoxFit.cover,
//                               height: 64,
//                               width: 64,
//                               image: NetworkImage(
//                                   '$urlBase${provider.pendingOrderInfoList.first.serviceImage}'),
//                               placeholder: const AssetImage(
//                                   'images/placeholder.jpg'),
//                               imageErrorBuilder:
//                                   (context, error, stackTrace) {
//                                 return Image.asset(
//                                   'assets/svg/Selfie.png',
//                                   fit: BoxFit.cover,
//                                   height: 64,
//                                   width: 64,
//                                 );
//                               },
//                             ),
//                           ),
//                           SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment:
//                               CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   provider.pendingOrderInfoList.first
//                                       .serviceTitle ??
//                                       'Service Name',
//                                   style: interText(
//                                       16, Colors.black, FontWeight.w600),
//                                 ),
//                                 SizedBox(height: 8),
//                                 Row(
//                                   children: [
//                                     if (provider.pendingOrderInfoList
//                                         .first.servicePlan !=
//                                         'Admin Bundle Plan' &&
//                                         provider.pendingOrderInfoList
//                                             .first.servicePlan !=
//                                             'Admin Default Plan')
//                                       Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                           BorderRadius.circular(20),
//                                           color: myColors.primaryStroke,
//                                         ),
//                                         child: Padding(
//                                           padding:
//                                           const EdgeInsets.symmetric(
//                                               vertical: 6,
//                                               horizontal: 12),
//                                           child: Text(
//                                             provider.pendingOrderInfoList
//                                                 .first.servicePlan ??
//                                                 'Basic',
//                                             style: interText(
//                                                 12,
//                                                 Colors.black,
//                                                 FontWeight.w500),
//                                           ),
//                                         ),
//                                       ),
//                                     Expanded(child: Container()),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 20.0),
//                     ),
//                     Column(
//                       children: [
//                         Container(
//                           margin: EdgeInsets.symmetric(horizontal: 20.w),
//                           child: Column(
//                             children: [
//                               const SizedBox(
//                                 height: 10,
//                               ),
//                               ServiceAttribute(
//                                 serviceJsonList: provider
//                                     .pendingOrderInfoList
//                                     .first
//                                     .serviceJson!,
//                               )
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding:
//                           const EdgeInsets.symmetric(horizontal: 16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Divider(
//                                   thickness: 1, color: Color(0xffe9e9e9)),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 6),
//                                 child: Row(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment.start,
//                                   children: [
//                                     Icon(
//                                       Icons.location_on,
//                                       size: 20,
//                                     ),
//                                     SizedBox(
//                                       width: 16,
//                                     ),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             'Billing Address : ',
//                                             style: interText(
//                                                 16,
//                                                 Colors.black,
//                                                 FontWeight.w600)
//                                                 .copyWith(
//                                                 letterSpacing: 0),
//                                           ),
//                                           Text(
//                                             '${provider.pendingOrderInfoList.first.orderDeliveryAddress!.zip}, ${provider.pendingOrderInfoList.first.orderDeliveryAddress!.city} ${provider.pendingOrderInfoList.first.orderDeliveryAddress!.state}' ??
//                                                 '',
//                                             // 'hello world',
//                                             style: interText(16, hintClr,
//                                                 FontWeight.w400),
//                                           ),
//                                           SizedBox(
//                                             height: 8,
//                                           ),
//                                           Text(
//                                             'Locate on map',
//                                             style: interText(
//                                                 14,
//                                                 myColors.green,
//                                                 FontWeight.bold),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Divider(
//                                   thickness: 1, color: Color(0xffe9e9e9)),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding:
//                           const EdgeInsets.symmetric(horizontal: 16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 6),
//                                 child: Row(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       'Date : ',
//                                       style: interText(16, Colors.black,
//                                           FontWeight.w600)
//                                           .copyWith(letterSpacing: 0),
//                                     ),
//                                     Consumer<OrderProvider>(
//                                       builder: (context, provider, _) =>
//                                           Text(
//                                             DashboardHelpers.convertDateTime(
//                                                 provider
//                                                     .pendingOrderInfoList
//                                                     .first
//                                                     .orderDate ??
//                                                     '') ??
//                                                 '',
//                                             // 'hello world',
//                                             style: interText(16, Colors.black,
//                                                 FontWeight.w600)
//                                                 .copyWith(letterSpacing: 0),
//                                           ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Divider(
//                                   thickness: 1, color: Color(0xffe9e9e9)),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding:
//                           const EdgeInsets.symmetric(horizontal: 16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 6),
//                                 child: Row(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment.center,
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text('Duration',
//                                         style: interText(16, Colors.black,
//                                             FontWeight.w600)
//                                             .copyWith(letterSpacing: 0)),
//                                     Consumer<OrderProvider>(
//                                       builder: (context, provider, _) =>
//                                           Text(
//                                             '${DashboardHelpers.convertDecimalToHoursMinutes(double.parse(provider.pendingOrderInfoList.first.workHour.toString()))}',
//                                             style: interText(16, Colors.black,
//                                                 FontWeight.w600)
//                                                 .copyWith(letterSpacing: 0),
//                                           ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Divider(
//                                   thickness: 1, color: Color(0xffe9e9e9)),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding:
//                           const EdgeInsets.symmetric(horizontal: 16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 6),
//                                 child: Row(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment.center,
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text('Total Bill',
//                                         style: interText(20, Colors.black,
//                                             FontWeight.bold)
//                                             .copyWith(letterSpacing: 0)),
//                                     Consumer<OrderProvider>(
//                                         builder: (context, provider, _) =>
//                                             Text(
//                                               '\$${provider.pendingOrderInfoList.first.serviceAmount}',
//                                               style: TextStyle(
//                                                   fontSize: 20,
//                                                   color: myColors.green,
//                                                   fontWeight:
//                                                   FontWeight.bold),
//                                             )),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 24,
//                     ),
//                     Padding(
//                       padding:
//                       const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: CustomRoundedButton(
//                         label: 'Close',
//                         buttonColor: myColors.green,
//                         fontColor: Colors.white,
//                         funcName: () async {
//                           Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) =>
//                                       DashboardScreen()));
//                         },
//                         borderRadius: 10,
//                         controller: _bottomBtnController,
//                       ),
//                     ),
//
//                     const SizedBox(height: 16.0),
//                   ],
//                 ),
//               )),
//         ),
//       );
//   }
// }
//
// class FullScreenImageGallery extends StatefulWidget {
//   final List<String> images;
//   final int initialIndex;
//
//   FullScreenImageGallery({required this.images, required this.initialIndex});
//
//   @override
//   _FullScreenImageGalleryState createState() => _FullScreenImageGalleryState();
// }
//
// class _FullScreenImageGalleryState extends State<FullScreenImageGallery> {
//   late PageController _pageController;
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: widget.initialIndex);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(backgroundColor: Colors.black,leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close,color: Colors.white,)),),
//       body: PageView.builder(
//         controller: _pageController,
//         itemCount: widget.images.length,
//         itemBuilder: (context, index) {
//           return Center(
//             child: InteractiveViewer(
//               child: Image.network(
//                 '${urlBase}${widget.images[index]}',
//                 fit: BoxFit.contain,
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child; // Show image when loaded
//
//                   return Center(
//                     child: CircularProgressIndicator(
//                       value: loadingProgress.expectedTotalBytes != null
//                           ? loadingProgress.cumulativeBytesLoaded /
//                           (loadingProgress.expectedTotalBytes ?? 1)
//                           : null, // Show indeterminate progress if total size is unknown
//                     ),
//                   );
//                 },
//                 errorBuilder: (context, error, stackTrace) {
//                   return Center(
//                     child: Text("Failed to load image", style: TextStyle(color: Colors.red)),
//                   );
//                 },
//               ),
//             )
//             ,
//           );
//         },
//       ),
//     );
//   }
// }
