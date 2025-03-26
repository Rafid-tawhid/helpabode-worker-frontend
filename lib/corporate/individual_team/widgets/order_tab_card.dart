import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:provider/provider.dart';

import '../../../helper_functions/colors.dart';
import '../../../misc/constants.dart';
import '../../../models/worker_service_request_model.dart';
import '../../../provider/completed_order_provider.dart';
import '../../../screens/open_order/completed_order/completed_order_details.dart';
import '../../../widgets_reuse/loading_indicator.dart';

class OrderCard2 extends StatefulWidget {
  final OrderItems order;

  OrderCard2({required this.order});

  @override
  State<OrderCard2> createState() => _OrderCard2State();
}

class _OrderCard2State extends State<OrderCard2> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      margin: EdgeInsets.all(12),
      child: Stack(
        children: [
          if (widget.order.serviceStatus == JobStatus.completed)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: myColors.green,
                  borderRadius: const BorderRadius.only(
                    topRight:
                        Radius.circular(8), // Only top-right corner is curved
                    bottomLeft:
                        Radius.circular(8), // Only top-right corner is curved
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                  child: Text(
                    'Completed',
                    style: interText(12, Colors.white, FontWeight.w600),
                  ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      '\$${widget.order.serviceAmount.toString()}',
                      style: cardPriceTextStyle,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Guaranteed'),
                  ],
                ),
                Text(
                    '${DashboardHelpers.convertDateTime(widget.order.orderPlaceTime ?? '')}',
                    style: interText(12, Color(0xff767676), FontWeight.w500)),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 2),
                  child: Divider(
                    thickness: .5,
                    height: .5,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.w),
                      child: FadeInImage(
                        fit: BoxFit.cover,
                        height: 70,
                        width: 70,
                        image: NetworkImage(
                            '$urlBase${widget.order.serviceImage}'),
                        placeholder: const NetworkImage(
                            'https://images.theconversation.com/files/270592/original/file-20190424-19297-1dn85pe.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=675.0&fit=crop'),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            'https://images.theconversation.com/files/270592/original/file-20190424-19297-1dn85pe.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=675.0&fit=crop',
                            fit: BoxFit.cover,
                            height: 70,
                            width: 70,
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
                            widget.order.serviceTitle ?? '',
                            style: interText(16, Colors.black, FontWeight.w600),
                          ),
                          FittedBox(
                            child: Text(
                              '${widget.order.endUserDeliveryAddress!.city},${widget.order.endUserDeliveryAddress!.state} ${widget.order.endUserDeliveryAddress!.zip}',
                              style:
                                  interText(14, Colors.black, FontWeight.w400),
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          FittedBox(
                            child: Text(
                              '${widget.order.scheduledDate} ${widget.order.scheduledStartTime} | ${widget.order.scheduleEndtime}',
                              style: text_16_black_400_TextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (widget.order.serviceStatus != JobStatus.completed)
                  StatusTimeline(widget.order),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: .5,
                    height: .5,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          var provider = context.read<CompletedOrderProvider>();
                          if (!provider.clicked) {
                            setState(() {
                              isLoading = true;
                            });

                            if (await provider.getSelectedCompletedOrderDetails(
                                widget.order.orderTimesId.toString() ?? '',
                                widget.order.serviceTextId ?? '')) {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          CompletedOrderDetails(
                                            singleItem: widget.order,
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
                              color: myColors.greyBg,
                              borderRadius: BorderRadius.circular(4)),
                          alignment: Alignment.center,
                          child: isLoading
                              ? LoadingIndicatorWidget(
                                  color: myColors.green,
                                )
                              : Text(
                                  'View Details',
                                  style: interText(
                                      14, Colors.black, FontWeight.w700),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDetailsButton extends StatefulWidget {
  final String orderTimesId;
  final String serviceTextId;
  final dynamic order; // Replace with actual order model type

  const OrderDetailsButton({
    Key? key,
    required this.orderTimesId,
    required this.serviceTextId,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderDetailsButton> createState() => _OrderDetailsButtonState();
}

class _OrderDetailsButtonState extends State<OrderDetailsButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<CompletedOrderProvider>(
      builder: (context, provider, _) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: myColors.green,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextButton(
          onPressed: provider.clicked
              ? null // Disable button when loading
              : () async {
                  setState(() {
                    loading = true;
                  });
                  if (await provider.getSelectedCompletedOrderDetails(
                      widget.orderTimesId, widget.serviceTextId)) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => CompletedOrderDetails(
                                singleItem: widget.order,
                              )),
                    );
                    setState(() {
                      loading = false;
                    });
                  }
                },
          child: loading
              ? const LoadingIndicatorWidget(color: Colors.white)
              : const Text(
                  'View Order Details',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}

class StatusTimeline extends StatelessWidget {
  OrderItems orderItems;

  StatusTimeline(this.orderItems);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTimelineStep(
            isCompleted: true,
            icon: Icons.store_mall_directory,
            title: 'In transited',
            time: orderItems.scheduledStartTime ?? '',
            isFirst: true,
          ),
          _buildTimelineStep(
            isCompleted: true,
            icon: Icons.store_mall_directory,
            title: orderItems.serviceStatus ?? '',
            time: '${orderItems.scheduledStartTime}',
          ),
          _buildTimelineStep(
            isCompleted: false,
            icon: Icons.check,
            title: "Completed",
            time: "${orderItems.scheduleEndtime}",
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required bool isCompleted,
    required IconData icon,
    required String title,
    required String time,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                children: [
                  if (!isFirst)
                    Expanded(
                      child: Container(
                        height: 4,
                        color: isCompleted ? Colors.green : Colors.grey[300],
                      ),
                    ),
                  if (isFirst) const SizedBox(width: 16),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        height: 4,
                        color: isCompleted ? myColors.green : Colors.grey[300],
                      ),
                    ),
                ],
              ),
              CircleAvatar(
                radius: 20,
                backgroundColor:
                    isCompleted ? myColors.green : Colors.grey[300],
                child: Icon(
                  icon,
                  color: isCompleted ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
