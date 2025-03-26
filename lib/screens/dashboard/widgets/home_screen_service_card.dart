import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/loading_indicator.dart';
import 'package:provider/provider.dart';
import '../../../helper_functions/colors.dart';
import '../../../misc/constants.dart';
import '../../../models/dashboardRunningServicemodel.dart';
import '../../../provider/order_provider.dart';
import '../../../widgets_reuse/custom_dashed_widgets.dart';
import '../../open_order/ordered_service_details_screen.dart';

class WorkerRunningServiceItem extends StatefulWidget {
  final DashboardRunningServicemodel item;

  const WorkerRunningServiceItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<WorkerRunningServiceItem> createState() =>
      _WorkerRunningServiceItemState();
}

class _WorkerRunningServiceItemState extends State<WorkerRunningServiceItem> {
  bool isLoading = false;

  void handleClick() async {
    setState(() {
      isLoading = true;
    });

    try {
      var provider = context.read<OrderProvider>();

      if (await provider.getWorkerPendingServiceDetails(
        widget.item.orderTimesId.toString(),
        widget.item.serviceTextId!,
      )) {
        // provider.setRunningServiceLoading(index, false);
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => OrderedServiceDetailsScreen(
              orderTextId: widget.item.orderNumber ?? '',
              serviceId: widget.item.serviceTextId ?? '',
            ),
          ),
        );
      }
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'Something went wrong');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : handleClick,
      child: Container(
        width: MediaQuery.sizeOf(context).width / 1.25,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Color(0xFFF2F2F2),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0C11111A),
              blurRadius: 32,
              offset: Offset(0, 8),
            ),
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    height: 72,
                    width: 72,
                    image: NetworkImage('${widget.item.serviceImage}'),
                    placeholder: const NetworkImage(
                      'https://images.theconversation.com/files/270592/original/file-20190424-19297-1dn85pe.jpg',
                    ),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        'https://images.theconversation.com/files/270592/original/file-20190424-19297-1dn85pe.jpg',
                        fit: BoxFit.cover,
                        height: 72,
                        width: 72,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DashboardHelpers.truncateString(
                            widget.item.serviceTitle ?? '', 16),
                        style: interText(16, Colors.black, FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            DashboardHelpers.getDateFormatCard(
                                    widget.item.scheduledDate) ??
                                'No Date',
                            style: text_16_black_400_TextStyle,
                          ),
                          Text(' | '),
                          Text(
                            DashboardHelpers.getTimeFormatCart(
                                    widget.item.scheduledStartTime,
                                    widget.item.scheduleEndtime) ??
                                '',
                            style: text_16_black_400_TextStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time_filled_rounded,
                            size: 16,
                            color: myColors.green,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.item.serviceStatus ?? '',
                            style:
                                interText(12, myColors.green, FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            CustomPaint(
              painter: DashedLinePainter(
                  dashWidth: 6, dashSpace: 2, color: myColors.greyBg),
              size: const Size(double.infinity, 2),
            ),
            SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${widget.item.serviceAmount}',
                  style: interText(16, myColors.green, FontWeight.w700),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFDFF2E1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Center(
                    child: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 100,
                            child: LoadingIndicatorWidget(
                              color: myColors.green,
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View Details ',
                                textAlign: TextAlign.center,
                                style: interText(
                                    14, myColors.green, FontWeight.w500),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: myColors.green,
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
