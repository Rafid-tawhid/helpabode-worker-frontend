import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/provider/order_provider.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/dotted_line.dart';
import 'package:provider/provider.dart';

import '../../helper_functions/colors.dart';
import '../../helper_functions/dashboard_helpers.dart';
import '../../misc/constants.dart';
import '../../models/worker_service_request_model.dart';
import '../../provider/completed_order_provider.dart';
import '../../widgets_reuse/loading_indicator.dart';
import '../../widgets_reuse/message_no_service.dart';
import '../pricing/pricing_screen.dart';
import 'completed_order/completed_order_details.dart';
import 'open_order_screen.dart';

class RejectedOrderList extends StatelessWidget {
  const RejectedOrderList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Rejected Order'),
      ),
      body: FutureBuilder(
        future: context.read<OrderProvider>().getRejectedOrderList(),
        builder: (context, snapshot) {
          return Consumer<OrderProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (provider.rejectedOrderList.isEmpty) {
                return Center(
                  child: Text('No Rejected Order Found'),
                );
              }

              return ListView.builder(
                itemCount: provider.rejectedOrderList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return RejectedOrderCard(
                      singleItems:
                          provider.rejectedOrderList[index].orderItems!.first);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class RejectedOrderCard extends StatefulWidget {
  final OrderItems singleItems;
  // final CompletedServiceModel orderInfo;
  RejectedOrderCard({required this.singleItems});

  @override
  State<RejectedOrderCard> createState() => _RejectedOrderCardState();
}

class _RejectedOrderCardState extends State<RejectedOrderCard> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: myColors.divider, width: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.singleItems.pricingBy!.toLowerCase() == 'bundle'
                ? BundleServiceTopDesign()
                : SizedBox(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '\$${widget.singleItems.serviceAmount.toString()}',
                        style: cardPriceTextStyle,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Paid')
                    ],
                  ),
                  Text('${widget.singleItems.orderPlaceTime}',
                      style: interText(12, Color(0xff767676), FontWeight.w500)),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 2),
                    child: DottedLine(
                      dotColor: myColors.divider,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.w),
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          height: 64,
                          width: 64,
                          image: NetworkImage(
                              '$urlBase${widget.singleItems.serviceImage}'),
                          placeholder: const NetworkImage(
                              'https://images.theconversation.com/files/270592/original/file-20190424-19297-1dn85pe.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=675.0&fit=crop'),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              'https://images.theconversation.com/files/270592/original/file-20190424-19297-1dn85pe.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=675.0&fit=crop',
                              fit: BoxFit.cover,
                              height: 64,
                              width: 64,
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.singleItems.serviceTitle ?? '',
                              style:
                                  interText(16, Colors.black, FontWeight.w600),
                            ),
                            // FittedBox(
                            //   child: Text(
                            //     '${widget.singleItems.endUserDeliveryAddress!.city},${widget.singleItems.endUserDeliveryAddress!.state} ${widget.singleItems.endUserDeliveryAddress!.zip} ${widget.singleItems.endUserDeliveryAddress!.countryIso2Code}',
                            //     style: interText(14, Colors.black, FontWeight.w400),
                            //   ),
                            // ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              'Scheduled: ${widget.singleItems.scheduledDate} ${widget.singleItems.scheduledStartTime} | ${widget.singleItems.scheduleEndtime}',
                              style: interText(
                                  14, Colors.black54, FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: DottedLine(
                      dotColor: myColors.divider,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            widget.singleItems.serviceStatus ?? '',
                            style: interText(14, Colors.red, FontWeight.w600),
                          ),
                        ],
                      ),
                      Expanded(child: SizedBox()),
                      InkWell(
                        onTap: () async {
                          var provider = context.read<CompletedOrderProvider>();
                          if (!provider.clicked) {
                            setState(() {
                              isLoading = true;
                            });
                            if (await provider.getSelectedCompletedOrderDetails(
                                widget.singleItems.orderTimesId.toString() ??
                                    '',
                                widget.singleItems.serviceTextId ?? '')) {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          CompletedOrderDetails(
                                            singleItem: widget.singleItems,
                                            isCancelled: true,
                                          )));
                            }
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: Container(
                          width: 120,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4)),
                          alignment: Alignment.center,
                          child: isLoading
                              ? Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade100, width: 1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  width: 120,
                                  height: 40,
                                  child: LoadingIndicatorWidget(
                                    color: myColors.green,
                                  ),
                                )
                              : Text(
                                  'View Details',
                                  style: TextStyle(color: Colors.black),
                                ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
