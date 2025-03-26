import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/models/worker_service_request_model.dart';
import 'package:help_abode_worker_app_ver_2/provider/order_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/dashboard/dashboard_screen.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/loading_indicator.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/message_no_service.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'ordered_service_details_screen.dart';

class RequestedServiceScreen extends StatefulWidget {
  const RequestedServiceScreen({super.key});

  @override
  State<RequestedServiceScreen> createState() => _RequestedServiceScreenState();
}

class _RequestedServiceScreenState extends State<RequestedServiceScreen> {
  AnimationController? localAnimationController;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  void initState() {
    Provider.of<OrderProvider>(context, listen: false).getOpenOrderInfo();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _btnController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 60,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(color: Color(0xfff7f7f7), width: 1))),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back)),
                  Expanded(
                    child: Text(
                      'Open orders',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashboardScreen()));
                          debugPrint(textId);
                          debugPrint(token);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: SvgPicture.asset(
                            'images/court_house.svg',
                            height: 20,
                            width: 20,
                            color: Colors.black,
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () {
                  return Provider.of<OrderProvider>(context, listen: false)
                      .getOpenOrderInfo();
                },
                child: Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Consumer<OrderProvider>(
                    builder: (context, provider, _) => ContainedTabBarView(
                      initialIndex: provider.orderIndex,
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '  PENDING  ',
                            style: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'IN PROGRESS',
                            style: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                      views: [PendingOrders(), UpcomingAcceptedOrders()],
                      onChange: (index) => print(index),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column PendingOrders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: Consumer<OrderProvider>(
            builder: (context, provider, _) => provider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: myColors.green,
                    ),
                  )
                : provider.workerServiceRequestList.isEmpty
                    ? const Center(
                        child: Text('No Order Found'),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          Provider.of<OrderProvider>(context, listen: false)
                              .getOpenOrderInfo();
                        },
                        child: ListView.builder(
                          itemCount: provider.workerServiceRequestList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return provider.workerServiceRequestList.isEmpty
                                ? NoServiceMessage(
                                    label: 'Request',
                                  )
                                : OrderServiceCard(
                                    orderItems: provider
                                            .workerServiceRequestList[index]
                                            .orderItems ??
                                        [],
                                    from: "pending");
                          },
                        ),
                      ),
          ),
        ),
      ],
    );
  }

  Column UpcomingAcceptedOrders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: Consumer<OrderProvider>(
            builder: (context, provider, _) => provider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: myColors.green,
                    ),
                  )
                : provider.workerAcceptedServiceList.isEmpty
                    ? const Center(
                        child: Text('No Order Found'),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          Provider.of<OrderProvider>(context, listen: false)
                              .getOpenOrderInfo();
                        },
                        child: ListView.builder(
                          itemCount: provider.workerAcceptedServiceList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return provider.workerAcceptedServiceList.isEmpty
                                ? NoServiceMessage(
                                    label: 'Request',
                                  )
                                : OrderServiceCard(
                                    orderItems: provider
                                            .workerAcceptedServiceList
                                            .first
                                            .orderItems ??
                                        [],
                                    from: 'in-progress');
                          },
                        ),
                      ),
          ),
        ),
      ],
    );
  }
}

class ViewDetailsButton extends StatefulWidget {
  const ViewDetailsButton({
    super.key,
    required this.e,
    this.item,
    this.fullWidth = false, // Option to make the button full width
    required this.borderColor, // Option to customize the border color
    required this.bgColor, // Background color customization
    required this.textClr, // Text color customization
    required this.btnText, // Text color customization
    required this.loadingIndicatorColor, // Loading indicator color
  });

  final WorkerServiceRequestModel? item; // Optional
  final OrderItems e;
  final bool fullWidth;
  final Color borderColor;
  final Color bgColor;
  final Color textClr;
  final Color loadingIndicatorColor;
  final String btnText;

  @override
  State<ViewDetailsButton> createState() => _ViewDetailsButtonState();
}

class _ViewDetailsButtonState extends State<ViewDetailsButton> {
  bool clicked = false;

  onClicked() async {
    var provider = context.read<OrderProvider>();

    setState(() {
      clicked = true;
    });

    if (await provider.getWorkerPendingServiceDetails(
        widget.e.orderTimesId.toString(), widget.e.serviceTextId.toString())) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderedServiceDetailsScreen(
            orderTextId: widget.item?.orderNumber ?? widget.e.orderNumber ?? '',
            serviceId: widget.e.serviceTextId ?? '',
          ),
        ),
      );
      setState(() {
        clicked = false;
      });
    } else {
      setState(() {
        clicked = false;
      });
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<OrderProvider>();

    return InkWell(
      onTap: () async {
        provider.getServiceDetailsLoading ? null : onClicked();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: widget.bgColor,
          border: Border.all(color: widget.borderColor, width: 1),
        ),
        child: provider.getServiceDetailsLoading && clicked
            ? LoadingIndicatorWidget(
                color: widget.loadingIndicatorColor,
                height: 24,
                strokeWidth: 10,
              )
            : Text(
                widget.btnText,
                style: interText(14, widget.textClr, FontWeight.w500)
                    .copyWith(letterSpacing: 0),
              ),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 7, dashSpace = 3, startX = 0;
    final paint = Paint()
      ..color = const Color(0XFFD9D9D9)
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class OrderServiceCard extends StatelessWidget {
  final List<OrderItems> orderItems;
  final bool isPending;
  final String? from;

  const OrderServiceCard({
    Key? key,
    required this.orderItems,
    required this.from,
    this.isPending = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0C11111A),
              blurRadius: 32,
              offset: Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 16,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          children: orderItems.asMap().entries.map((entry) {
            final itemIndex = entry.key;
            final item = entry.value;
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${item.serviceAmount.toString()}',
                            style:
                                interText(24, myColors.green, FontWeight.w700),
                          ),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              isPending
                                  ? item.serviceStatus ?? ''
                                  : 'Guaranteed',
                              style: interText(
                                  14, Color(0xff636366), FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      Text('Placed On ${item.orderPlaceTime.toString()}',
                          style: interText(
                              12, Color(0xff767676), FontWeight.w500)),
                      const SizedBox(height: 12),
                      CustomPaint(
                        painter: DashedLinePainter(),
                        size: Size(double.infinity, 10),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              height: 72,
                              width: 72,
                              image:
                                  NetworkImage('$urlBase${item.serviceImage}'),
                              placeholder: const NetworkImage(
                                  'https://images.theconversation.com/files/270592/original/file-20190424-19297-1dn85pe.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=675.0&fit=crop'),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.network(
                                  'https://images.theconversation.com/files/270592/original/file-20190424-19297-1dn85pe.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=675.0&fit=crop',
                                  fit: BoxFit.cover,
                                  height: 72,
                                  width: 72,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.serviceTitle ?? '',
                                    style: interText(
                                        16, Colors.black, FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text(
                                    'Schedule: ${item.scheduledDate}, ${item.scheduledStartTime} - ${item.scheduleEndtime}',
                                    style: interText(
                                        14, Colors.black, FontWeight.w400)),
                                const SizedBox(height: 6),
                                Text(
                                  'Duration : ${DashboardHelpers.formatDuration(
                                    DashboardHelpers.calculateTimeDifference(
                                            item.scheduledStartTime!,
                                            item.scheduleEndtime!) ??
                                        Duration(),
                                  )}',
                                  style: text_16_black_400_TextStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    color: myColors.divider,
                    height: 1,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(12)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (from != 'pending')
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.watch_later,
                                color: myColors.green,
                                size: 20,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                item.serviceStatus ?? '',
                                style: interText(
                                    14, myColors.green, FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: ViewDetailsButton(
                          e: item,
                          btnText: from != 'pending'
                              ? 'View Details'
                              : 'View Order Details',
                          borderColor: Colors.white,
                          bgColor: from != 'pending'
                              ? myColors.greyBg
                              : myColors.green,
                          textClr:
                              from != 'pending' ? Colors.black : Colors.white,
                          loadingIndicatorColor:
                              from != 'pending' ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                if (orderItems.length > 1 && itemIndex < orderItems.length - 1)
                  Container(
                    color: Color(0xFFF2F2F2),
                    height: 1,
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// provider.setLoadingOrder(true); // Set loading to true
//
//                 // Simulate async operation
//                 await Future.delayed(Duration(seconds: 2)); // Replace with your actual async method
//
//                 print('ORDER ID ${provider.workerServiceRequestList[index].orderNumber}');
//
//                 // Set order info for the screen
//                 provider.setOrderInfo(provider.workerServiceRequestList[index]);
//
//                 if(await provider.getWorkerPendingServiceDetails(provider.workerServiceRequestList[index].orderNumber??'',e.serviceTextId??''))
//                 {
//                   provider.setLoadingOrder(false);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => PendingOrderedServiceDetailsScreen(
//                         serviceId: e.serviceTextId ?? '',
//                         orderTextId: provider.workerServiceRequestList[index].orderNumber ?? '',
//                         orderItem: provider.workerServiceRequestList[index],
//                       ),
//                     ),
//                   );
//                 }
//                 provider.setLoadingOrder(false);
