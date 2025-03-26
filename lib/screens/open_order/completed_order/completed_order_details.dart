import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/models/completed_order_details_model.dart';
import 'package:help_abode_worker_app_ver_2/provider/completed_order_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/open_order/completed_order/widgets/ordered_services.dart';
import 'package:provider/provider.dart';

import '../../../helper_functions/dashboard_helpers.dart';
import '../../../misc/constants.dart';
import '../../../models/worker_service_request_model.dart';
import 'before_after_image_preview.dart';

class CompletedOrderDetails extends StatefulWidget {
  OrderItems singleItem;
  bool? isCancelled;
  CompletedOrderDetails({required this.singleItem, this.isCancelled});

  @override
  State<CompletedOrderDetails> createState() => _CompletedOrderDetailsState();
}

class _CompletedOrderDetailsState extends State<CompletedOrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Text(
          'Order Details',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Consumer<CompletedOrderProvider>(
                  builder: (context, provider, _) {
                    var order = provider.completedOrderDetailsList.first;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                              widget.isCancelled == true
                                  ? 'Order Cancelled'
                                  : 'Order Complete',
                              style:
                                  interText(22, Colors.black, FontWeight.w600)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(order.order_place_time ?? '',
                              style: interText(
                                  12, Color(0xff767676), FontWeight.w500)),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        const Divider(
                          height: 1,
                          color: Color(0xffe9e9e9),
                        ),

                        // TODO:Ratings
                        if (provider.completedOrderDetailsList.first.comments !=
                            null)
                          ReviewSection(order, provider),
                        if (widget.isCancelled == true)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Reason',
                                      style: interText(
                                          18, Colors.black, FontWeight.w700),
                                    ),
                                    Text(
                                      'I changed my mind',
                                      style: interText(
                                          14, Colors.black, FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: Color(0xffe9e9e9),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Order Info',
                                  style: interText(
                                      18, Colors.black, FontWeight.w600)),
                              Text(
                                  '${provider.completedOrderDetailsList.length} Item',
                                  style: interText(
                                      14, myColors.greyTxt, FontWeight.w500)),
                            ],
                          ),
                        ),

                        Divider(
                          height: 1,
                          color: Color(0xffe9e9e9),
                        ),
                        SizedBox(
                          height: 16,
                        ),

                        // TODO: Service options/attributes
                        OrderedServicesInfo(orderInfo: order),

                        // TODO: Billing Info
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // TODO: Attachments [Before/After work proof]
                                if (provider.completedOrderDetailsList.first
                                            .afterArray !=
                                        null ||
                                    provider.completedOrderDetailsList.first
                                            .afterArray !=
                                        null)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Consumer<CompletedOrderProvider>(
                                          builder: (context, provider, _) {
                                            // Check if the list is null or empty to prevent errors
                                            final completedOrderDetails =
                                                provider
                                                    .completedOrderDetailsList;
                                            final beforeArray =
                                                completedOrderDetails.isNotEmpty
                                                    ? completedOrderDetails
                                                        .first.beforeArray
                                                    : null;
                                            final afterArray =
                                                completedOrderDetails.isNotEmpty
                                                    ? completedOrderDetails
                                                        .first.afterArray
                                                    : null;

                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (beforeArray != null &&
                                                    beforeArray.isNotEmpty) ...[
                                                  GestureDetector(
                                                    onTap: () {
                                                      provider
                                                          .setImageToPreview(
                                                              beforeArray);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ImagePreviewScreen()));
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Before Work',
                                                          style: interText(
                                                              14,
                                                              Colors.black,
                                                              FontWeight.w500),
                                                        ),
                                                        const SizedBox(
                                                            height: 6),
                                                        Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    width: 0.4,
                                                                    color: Colors
                                                                        .grey),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                child:
                                                                    ImageFiltered(
                                                                  imageFilter:
                                                                      ImageFilter.blur(
                                                                          sigmaX:
                                                                              1,
                                                                          sigmaY:
                                                                              1),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl:
                                                                        '$urlBase${beforeArray.first}',
                                                                    width: 120,
                                                                    height: 64,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            Container(
                                                                      width:
                                                                          120,
                                                                      height:
                                                                          64,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          color:
                                                                              myColors.green,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Icon(Icons
                                                                            .error),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              '${beforeArray.length}+ Photos',
                                                              style: interText(
                                                                  16,
                                                                  Colors.white,
                                                                  FontWeight
                                                                      .w600),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                ],
                                                if (afterArray != null &&
                                                    afterArray.isNotEmpty) ...[
                                                  GestureDetector(
                                                    onTap: () {
                                                      provider
                                                          .setImageToPreview(
                                                              afterArray);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ImagePreviewScreen()));
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'After Work',
                                                          style: interText(
                                                              14,
                                                              Colors.black,
                                                              FontWeight.w500),
                                                        ),
                                                        const SizedBox(
                                                            height: 6),
                                                        Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    width: 0.5,
                                                                    color: Colors
                                                                        .grey),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                child:
                                                                    ImageFiltered(
                                                                  imageFilter:
                                                                      ImageFilter.blur(
                                                                          sigmaX:
                                                                              1,
                                                                          sigmaY:
                                                                              1),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl:
                                                                        '$urlBase${afterArray.first}',
                                                                    width: 120,
                                                                    height: 64,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            Container(
                                                                      width:
                                                                          120,
                                                                      height:
                                                                          64,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          color:
                                                                              myColors.green,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Icon(Icons
                                                                            .error),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              '${afterArray.length}+ Photos',
                                                              style: interText(
                                                                  16,
                                                                  Colors.white,
                                                                  FontWeight
                                                                      .w600),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                // TODO: Address
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (widget.isCancelled != true)
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 12),
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1,
                                                strokeAlign: BorderSide
                                                    .strokeAlignCenter,
                                                color: Color(0xFFF6F6F6),
                                              ),
                                            ),
                                          ),
                                        ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Color(0xff777777),
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Address ',
                                                  style: interText(
                                                          16,
                                                          Colors.black,
                                                          FontWeight.w500)
                                                      .copyWith(
                                                          letterSpacing: 0),
                                                ),
                                                Text(
                                                    '${order.orderDeliveryAddress!.zip}, ${order.orderDeliveryAddress!.city} ${order.orderDeliveryAddress!.state}' ??
                                                        '',
                                                    // 'hello world',
                                                    style: interText(
                                                            14,
                                                            Color(0xff636366),
                                                            FontWeight.w500)
                                                        .copyWith(
                                                            letterSpacing: 0)),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    DashboardHelpers.openMap(
                                                        order
                                                            .orderDeliveryAddress!
                                                            .latitude,
                                                        order
                                                            .orderDeliveryAddress!
                                                            .longitude);
                                                  },
                                                  child: Text('Locate on map',
                                                      style: interText(
                                                              14,
                                                              myColors.green,
                                                              FontWeight.w500)
                                                          .copyWith(
                                                              letterSpacing:
                                                                  0)),
                                                ),
                                                SizedBox(
                                                  height: 6.h,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 12),
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 1,
                                              strokeAlign:
                                                  BorderSide.strokeAlignCenter,
                                              color: Color(0xFFF6F6F6),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // TODO: Schedule
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.calendar_month,
                                            color: Color(0xff777777),
                                            size: 20,
                                          ),
                                          SizedBox(width: 16),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Schedule Date',
                                                style: interText(
                                                        16,
                                                        Colors.black,
                                                        FontWeight.w500)
                                                    .copyWith(letterSpacing: 0),
                                              ),
                                              //Text('${order.scheduledDate} ${order.startTime} | ${order.endtime}'),
                                              Text('${order.order_place_time}'),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 12),
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 1,
                                              strokeAlign:
                                                  BorderSide.strokeAlignCenter,
                                              color: Color(0xFFF6F6F6),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // TODO: Duration
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.watch_later_outlined,
                                            color: Color(0xff777777),
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Duration',
                                                  style: interText(
                                                          16,
                                                          Colors.black,
                                                          FontWeight.w500)
                                                      .copyWith(
                                                          letterSpacing: 0),
                                                ),
                                                Text(
                                                    DashboardHelpers.formatDuration(
                                                        DashboardHelpers.calculateTimeDifference(
                                                                order.startTime ??
                                                                    '',
                                                                order.endtime ??
                                                                    '') ??
                                                            Duration()),
                                                    // 'hello world',
                                                    style: interText(
                                                            14,
                                                            Color(0xff636366),
                                                            FontWeight.w500)
                                                        .copyWith(
                                                            letterSpacing: 0))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 12),
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 1,
                                              strokeAlign:
                                                  BorderSide.strokeAlignCenter,
                                              color: Color(0xFFF6F6F6),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // TODO: Order ID
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.copy,
                                            color: Color(0xff777777),
                                            size: 20,
                                          ),
                                          SizedBox(width: 16),
                                          InkWell(
                                            onTap: () {
                                              DashboardHelpers.copyToClipboard(
                                                  order.orderTextId ?? '');
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Order Number: ${order.orderTextId}',
                                                  style: interText(
                                                          14,
                                                          Colors.black,
                                                          FontWeight.w500)
                                                      .copyWith(
                                                          letterSpacing: 0),
                                                ),
                                                FittedBox(
                                                  child: Text(
                                                      'Please use this ID instead of the customer name' ??
                                                          '', // 'hello world',
                                                      style: interText(
                                                              12,
                                                              Color(0xff636366),
                                                              FontWeight.w500)
                                                          .copyWith(
                                                              letterSpacing:
                                                                  0)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // TODO: Special instructions
                                // ExpansionTile(
                                //   title: Text(
                                //     'Special Instructions',
                                //     style: interText(16, Colors.black, FontWeight.w500).copyWith(letterSpacing: 0),
                                //   ),
                                //   children: <Widget>[
                                //     ListTile(
                                //       title: Text(
                                //         provider.pendingOrderInfoList.first.instructionToWorker ??
                                //             'No Instruction',
                                //         style: interText(14, Color(0xff636366), FontWeight.w500).copyWith(letterSpacing: 0),
                                //       ),
                                //     )
                                //   ],
                                //   shape: RoundedRectangleBorder(
                                //       side: BorderSide(color: Colors.transparent, width: 2)),
                                //   leading: Icon(
                                //     Icons.message,
                                //     color: Color(0xff777777),
                                //     size: 20,
                                //   ),
                                // ),
                                // TODO: End Special instructions

                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  height: 8,
                                  color: myColors.divider,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //${widget.singleItem.serviceAmount.toString()
                                      Text(
                                        'Summary',
                                        style: interText(
                                            18, Colors.black, FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Sub total',
                                            style: interText(16, Colors.black,
                                                FontWeight.w600),
                                          ),
                                          Text(
                                              '\$${provider.completedOrderDetailsList.first.serviceAmount.toString()}',
                                              style: interText(14, Colors.black,
                                                  FontWeight.bold)),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Tips',
                                            style: interText(16, Colors.black,
                                                FontWeight.w600),
                                          ),
                                          Text(
                                              '\$${provider.completedOrderDetailsList.first.tipAmount.toString()}',
                                              style: interText(14, Colors.black,
                                                  FontWeight.bold)),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        child: Divider(
                                          height: 1,
                                          color: myColors.divider,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Total',
                                            style: interText(16, Colors.black,
                                                FontWeight.w600),
                                          ),
                                          Text(
                                            '\$${DashboardHelpers.getTotal(provider.completedOrderDetailsList.first.serviceAmount, provider.completedOrderDetailsList.first.tipAmount)}',
                                            style: interText(16, Colors.black,
                                                FontWeight.w600),
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Add more widgets here as needed
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding ReviewSection(
      CompletedOrderDetailsModel order, CompletedOrderProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            'Customer Feedback',
            style: interText(18, Colors.black, FontWeight.w600),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xffF6F6F6),
                border: Border.all(color: myColors.greyBtn, width: .5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${order.userFullName}',
                  style: interText(16, Colors.black, FontWeight.w600),
                ),
                SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: FittedBox(
                        child: RatingBar.builder(
                          initialRating: double.parse(provider
                              .completedOrderDetailsList
                              .first
                              .rateForWorkerByEndUser
                              .toString()),
                          minRating: 3,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          ignoreGestures: true,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: myColors.green, // Using Dark Pink Color
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        order.reviewRatingDate ?? '',
                        style: interText(12, Colors.black, FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '${order.comments}',
                  style: interText(13, Colors.black, FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Divider(
            height: 1,
            color: Color(0xffe9e9e9),
          ),
        ],
      ),
    );
  }
}
