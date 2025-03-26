import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/models/worker_service_request_model.dart';
import 'package:help_abode_worker_app_ver_2/provider/completed_order_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/notification_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/order_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/add_new_service/add_new_service.dart';
import 'package:help_abode_worker_app_ver_2/screens/notification/notification_view.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_appbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/notification_model.dart';
import '../../widgets_reuse/loading_indicator.dart';
import '../open_order/completed_order/completed_order_details.dart';
import '../open_order/ordered_service_details_screen.dart';
import '../open_order/widgets/order_tracker5.dart';

class ShowNotificationScreen extends StatefulWidget {
  const ShowNotificationScreen({super.key});

  @override
  State<ShowNotificationScreen> createState() => _ShowNotificationScreenState();
}

class _ShowNotificationScreenState extends State<ShowNotificationScreen> {
  bool show = true;
  Future<void>? _notificationFuture;
  ScrollController? _controller;
  int page = 1;

  @override
  void initState() {
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller!.addListener(_scrollListener);
    super.initState();
    clearNotificaitons();

    Future.microtask(() {
      _notificationFuture =
          Provider.of<NotificationProvider>(context, listen: false)
              .getAllNotification();
    });
    // getNotificaitonList();
    // getUserData();
  }

  _scrollListener() async {
    NotificationProvider np = context.read<NotificationProvider>();
    var isEnd = _controller!.offset >= _controller!.position.maxScrollExtent &&
        !_controller!.position.outOfRange;
    if (isEnd && np.notificationList.isNotEmpty) {
      await np.setPage().then(
            (value) => np.getAllNotification().then(
                  (_) {},
                ),
          );
    }
  }

  // getNotificaitonList() {
  //   NotificationProvider np = context.read<NotificationProvider>();
  //   Future.microtask(() async {
  //     await np.getAllNotification().then((status) {
  //       // status ? np.reverseList() : null;
  //     });
  //   });
  // }
  clearNotificaitons() {
    NotificationProvider np = context.read<NotificationProvider>();
    Future.microtask(() async {
      await np.resetPage();
      await np.clearNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<NotificationProvider>(
            builder: (context, np, _) => Column(
                  children: [
                    CustomAppBar(label: 'Notifications'),
                    Expanded(
                      child: Consumer<NotificationProvider>(
                        builder: (context, provider, _) => FutureBuilder(
                          future: _notificationFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: ListView.builder(
                                  itemCount: 10, // Placeholder items
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        height: 100.0,
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else if (provider.notificationList.isEmpty) {
                              return NoNotificationFound(context);
                            } else {
                              return ShowNotification(np);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                )),
      ),
    );
  }

  Consumer<NotificationProvider> ShowNotification(NotificationProvider np) {
    return Consumer<NotificationProvider>(
      builder: (context, provider, _) {
        return SingleChildScrollView(
          controller: _controller,
          child: Column(
            children: [
              ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  Column(
                    children: [
                      // OrderRatingWidget(),
                      // OrderStatusWidget(),
                      ListView.builder(
                        itemCount: provider.notificationList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var item = provider.notificationList[index];
                          return NotificationView(notificationModel: item);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              np.paginationLoading
                  ? SizedBox(
                      height: 60,
                      child: LoadingIndicatorWidget(
                        color: myColors.green,
                        width: 100,
                      ),
                    )
                  : SizedBox(
                      height: 60,
                    ),
            ],
          ),
        );
      },
    );
  }

  Column NoNotificationFound(BuildContext context) {
    return Column(
      children: [
        Consumer<UserProvider>(
          builder: (context, provider, _) => Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                'Hello, ${provider.userModel.firstName}',
                style: interText(22, Colors.black, FontWeight.w700),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0xFFE9E9E9)),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.notifications,
                    color: Color(0xffE9E9E9),
                    size: 34,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Nothing to see here yet',
                    style: interText(16, Color(0xffE9E9E9), FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          '''Start browsing to hear from your favorite
      Helper, find best ways to save, or get
      updates on any active orders here.''',
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 30,
        ),
        SizedBox(
          width: 200,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddNewServiceScreen()));
            },
            child: Container(
              // Corrected MediaQuery usage
              decoration: BoxDecoration(
                  color: myColors.green,
                  borderRadius: BorderRadius.circular(20)),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Browse the service',
                  style: interText(14, Colors.white, FontWeight.w600),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class OrderRatingWidget extends StatelessWidget {
  NotificationModel notificationModel;

  OrderRatingWidget({required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          height: 2,
          color: myColors.divider,
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Row(
                  children: [
                    Container(
                      height: 6,
                      width: 6,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: myColors.green,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    CircleAvatar(
                      radius: 26, // Adjust the radius as needed
                      backgroundImage: AssetImage(
                          'assets/png/person2.png'), // Replace with your image path
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${notificationModel.title}',
                      style: interText(16, Colors.black, FontWeight.bold),
                    ),
                    Text(notificationModel.optionJson['ratingDate']),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 2,
                      color: myColors.divider,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    StarRatingWidget(
                      rating: double.parse(
                          notificationModel.optionJson['ratings'].toString()),
                      size: 22,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                        'You have received ${notificationModel.optionJson['ratings']} star rating and \$${notificationModel.optionJson['tipsAmount']} tips from your clients.'),
                    SizedBox(
                      height: 12,
                    ),
                    Consumer<OrderProvider>(
                      builder: (context, provider, _) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DashboardHelpers.timeAgo(
                              notificationModel.created ?? '')),
                          OrderDetailsButton(provider, notificationModel,
                              type: 'completed'),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 2,
          color: myColors.divider,
        ),
      ],
    );
  }
}

String? getDate(String date) {
  // Parse the input string into a DateTime object
  DateTime dateTime = DateTime.parse(date);

  // Format the date into "Saturday 11 May 2024 at 10:11 AM"
  String formattedDate =
      DateFormat("EEEE d MMM yyyy 'at' hh:mm a").format(dateTime);
  return formattedDate;
}

class OrderStatusWidget extends StatelessWidget {
  NotificationModel notificationModel;

  OrderStatusWidget({required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          height: 2,
          color: myColors.divider,
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 6,
                    width: 6,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: myColors.green,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  CircleAvatar(
                    radius: 26, // Adjust the radius as needed
                    backgroundImage: AssetImage(
                        'assets/png/person2.png'), // Replace with your image path
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${notificationModel.title!}',
                      style: interText(16, Colors.black, FontWeight.bold),
                    ),
                    Text(getDate(notificationModel.created ?? '') ?? ''),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 2,
                      color: myColors.divider,
                    ),
                    Text(
                        'Your order is now on its way to you. Track its journey in real-time!'),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: myColors.greyBg,
                          borderRadius: BorderRadius.circular(8)),
                      margin: EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Container(
                                height: 16,
                                color: myColors.green,
                                width: 4,
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: myColors.green,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ],
                              ),
                              Container(
                                height: 16,
                                color: myColors.green,
                                width: 4,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${notificationModel.optionJson['orderStatus']}',
                            style: interText(16, Colors.black, FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Consumer<OrderProvider>(
                      builder: (context, provider, _) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DashboardHelpers.timeAgo(
                              notificationModel.created ?? '')),
                          OrderDetailsButton(
                            provider,
                            notificationModel,
                            type: 'status',
                            btnText: 'Track Order',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 2,
          color: myColors.divider,
        ),
      ],
    );
  }
}

class OrderReceivedWidget extends StatelessWidget {
  final NotificationModel notificationModel;

  const OrderReceivedWidget({super.key, required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: notificationModel.isSeen! == "N"
          ? () {
              var provider = context.read<NotificationProvider>();
              provider.sendNotificationSeen(notificationModel.id.toString());
              provider.updateNotificationSeen(data: notificationModel);
            }
          : null,
      child: Card(
        child: Container(
          color:
              notificationModel.isSeen! == "N" ? Colors.white60 : Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                height: 2,
                color: myColors.divider,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 6,
                          width: 6,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: myColors.green,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        CircleAvatar(
                          radius: 26, // Adjust the radius as needed
                          backgroundImage: AssetImage(
                              'assets/png/person2.png'), // Replace with your image path
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notificationModel.title ?? '',
                            style: interText(16, Colors.black, FontWeight.bold),
                          ),
                          Text(notificationModel.optionJson['scheduleDate'] ??
                              ''),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 2,
                            color: myColors.divider,
                          ),
                          Text(notificationModel.messages ?? ''),
                          SizedBox(
                            height: 12,
                          ),
                          Consumer<OrderProvider>(
                            builder: (context, provider, _) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(DashboardHelpers.timeAgo(
                                    notificationModel.created ?? '')),
                                OrderDetailsButton(provider, notificationModel),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 2,
                color: myColors.divider,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetailsButton extends StatefulWidget {
  final OrderProvider provider;
  final NotificationModel notification;
  String? type;
  String? btnText;

  OrderDetailsButton(this.provider, this.notification,
      {this.type, this.btnText});

  @override
  State<OrderDetailsButton> createState() => _OrderDetailsButtonState();
}

class _OrderDetailsButtonState extends State<OrderDetailsButton> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? SizedBox(
            height: 30,
            width: 60,
            child: LoadingIndicatorWidget(
              color: myColors.green,
            ))
        : GestureDetector(
            onTap: () async {
              if (isSelected)
                return; // Prevent further taps if already in progress

              setState(() {
                isSelected = true;
              });

              try {
                // Handle the different types

                if (widget.type == 'completed') {
                  await _handleCompletedOrder();
                } else if (widget.type == 'status') {
                  await _handleStatusOrder();
                } else {
                  await _handlePendingOrder();
                }
              } catch (e) {
                // Handle any exceptions that occur during the process
                _handleError(e);
              } finally {
                setState(() {
                  isSelected = false;
                });
              }
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: myColors.greyBg),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Text(
                    widget.btnText != null
                        ? '${widget.btnText!}'
                        : 'View order details',
                    style: interText(14, Colors.black, FontWeight.bold),
                  ),
                )),
          );
  }

  // Function to handle completed order
  Future<void> _handleCompletedOrder() async {
    var provider = context.read<CompletedOrderProvider>();
    final endUserOrderTimeId =
        widget.notification.optionJson['endUserOrderTimeId'] ?? '';
    final serviceTextId = widget.notification.optionJson['serviceTextId'] ?? '';

    if (await provider.getSelectedCompletedOrderDetails(
        endUserOrderTimeId, serviceTextId)) {
      final orderItems = OrderItems.fromJson(
          provider.completedOrderDetailsList.first.toJson());
      Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => CompletedOrderDetails(
                  singleItem: orderItems,
                )),
      );
    } else {
      _showErrorMessage('Failed to load completed order details');
    }
  }

// Function to handle status orders
  Future<void> _handleStatusOrder() async {
    var data = await widget.provider.getServiceTimeLineInfo(
        widget.notification.optionJson['endUserOrderTimeId'],
        widget.notification.optionJson['serviceTextId']);

    if (data != null) {
      showServiceTimelineBottomSheet(context, widget.notification, data);
    } else {
      _showErrorMessage('Failed to load service timeline');
    }
  }

// Function to handle pending orders
  Future<void> _handlePendingOrder() async {
    final endUserOrderTimeId =
        widget.notification.optionJson['endUserOrderTimeId'].toString();
    final serviceTextId = widget.notification.optionJson['serviceTextId'];

    if (await widget.provider
        .getWorkerPendingServiceDetails(endUserOrderTimeId, serviceTextId)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderedServiceDetailsScreen(
            orderTextId: widget.notification.optionJson['orderTextId'],
            serviceId: serviceTextId ?? '',
          ),
        ),
      );
    } else {
      _showErrorMessage('Failed to load pending order details');
    }
  }

// Function to handle errors and show a message
  void _handleError(dynamic error) {
    print('Error: $error');
    _showErrorMessage('An unexpected error occurred');
  }

// Function to show error messages
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

void showServiceTimelineBottomSheet(
    BuildContext context, NotificationModel notificationn, dynamic data) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      Future.microtask(() {
        var pro = context.read<OrderProvider>();
        pro.mapJobStatusToOrderStatus(
            notificationn.optionJson['orderStatus'].toString() == 'InTransit'
                ? 'In Transit'
                : notificationn.optionJson['orderStatus'].toString());
      });

      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        // Adjust height
        minChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Text(
                    "Scheduled | ${notificationn.optionJson['scheduleTime']}",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Order ID : ${notificationn.optionJson['orderTextId']}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[50],
                      child:
                          Icon(Icons.cleaning_services, color: myColors.green),
                    ),
                    title: Text(notificationn.title ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle:
                        Text("${notificationn.optionJson['schedulePeriod']}"),
                    trailing: Icon(Icons.chat_bubble_outline,
                        color: Colors.grey[600]),
                  ),
                  const Divider(),
                  const Text(
                    "Service Timeline",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Consumer<OrderProvider>(builder: (context, pro, _) {
                    return OrderTracker5(
                      status: pro.orderStatus,
                      activeColor: myColors.green,
                      dataList: [
                        {
                          'title': 'Address',
                          'subTitle':
                              '${notificationn.optionJson['scheduleAddress'] ?? ''}',
                        },
                        {
                          'title': 'Service booked',
                          'subTitle': DashboardHelpers.convertDateTime(
                              notificationn.created.toString(),
                              pattern: 'd MMM yyyy h:mm a'),
                        },
                        {
                          'title': 'Scheduled',
                          'subTitle':
                              '${notificationn.optionJson['scheduleTime'] ?? ''}',
                        },
                        {
                          'title': 'Accepted the order',
                          'subTitle':
                              getOrderTrackingData(pro, 'Confirmed') ?? '',
                        },
                        {
                          'title': 'In Transit',
                          'subTitle':
                              getOrderTrackingData(pro, 'InTransit') ?? '',
                        },
                        {
                          'title': 'Job started',
                          'subTitle':
                              getOrderTrackingData(pro, 'JobStarted') ?? '',
                        },
                        {
                          'title': 'Job completed',
                          'subTitle':
                              getOrderTrackingData(pro, 'Completed') ?? '',
                        },
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

String? getOrderTrackingData(OrderProvider pro, String status) {
  try {
    return DashboardHelpers.convertDateTime(
        pro.orderTrackingInfo
            .firstWhere((order) => order.status == status)
            .created
            .toString(),
        pattern: 'd MMM yyyy h:mm a');
  } catch (e) {
    return null; // Return null if no match is found
  }
}

class StarRatingWidget extends StatelessWidget {
  final double rating; // Rating value from 0 to 5
  final double size;

  const StarRatingWidget({Key? key, required this.rating, this.size = 30})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rating,
      // Dynamic rating value
      itemBuilder: (context, index) => const Icon(
        Icons.star,
        color: Colors.orange,
      ),
      itemCount: 5,
      itemSize: size,
      unratedColor: Colors.grey,
      // Color for empty stars
      direction: Axis.horizontal,
    );
  }
}
