import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:help_abode_worker_app_ver_2/chat/chat_provider.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/user_helpers.dart';
import 'package:help_abode_worker_app_ver_2/models/corporate_team_member_model.dart';
import 'package:help_abode_worker_app_ver_2/provider/map_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/order_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/open_order/completed_order/widgets/service_attribute.dart';
import 'package:help_abode_worker_app_ver_2/screens/open_order/widgets/end_job_no_contact_static_screen.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../auth/helper.dart';
import '../../chat/views/chat_screen.dart';
import '../../corporate/order_assign_member_list.dart';
import '../../misc/constants.dart';
import '../../models/pending_service_details_model.dart';
import '../../widgets_reuse/bottm_sheet.dart';
import '../../widgets_reuse/custom_rounded_button.dart';
import '../../widgets_reuse/free_call_bottom_sheet.dart';
import '../../widgets_reuse/my_custom_bottom_sheet.dart';
import '../../widgets_reuse/order_locate_on_map.dart';
import '../../widgets_reuse/user_info_row.dart';
import 'common_screen/customer_support_reject.dart';
import 'widgets/tracker4.dart';
import 'common_screen/work_status_photos_static_screen.dart';

class OrderedServiceDetailsScreen extends StatefulWidget {
  const OrderedServiceDetailsScreen({
    super.key,
    required this.orderTextId,
    required this.serviceId,
  });

  final String orderTextId;
  final String serviceId;

  @override
  State<OrderedServiceDetailsScreen> createState() => _OrderedServiceDetailsScreenState();
}

class _OrderedServiceDetailsScreenState extends State<OrderedServiceDetailsScreen> {
  AnimationController? localAnimationController;

  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  String mapText = '';
  late OrderProvider orderProvider;

  @override
  void initState() {
    orderProvider = Provider.of<OrderProvider>(context, listen: false);
    mapText = orderProvider.pendingOrderInfoList.first.serviceStatus ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Update the order location dynamically
      // mp.setOrderLocation(LatLng(double.parse(orderProvider.pendingOrderInfoList.first.latitude ?? '0.0'), double.parse(orderProvider.pendingOrderInfoList.first.longitude ?? '0.0')), '${orderProvider.orderedUserData!.endUserAddress!.zip}, ${orderProvider.orderedUserData!.endUserAddress!.city}');
      orderProvider.setPendingDetailsScreenServiceStatus(mapText);
      orderProvider.mapJobStatusToOrderStatus(mapText ?? '');
      orderProvider.getPendingDetailsScreenButtonText(mapText);
      orderProvider.initializeScheduleTimeList();
    });
    debugPrint('orderTextId ${widget.orderTextId}');
    debugPrint('mapText ${mapText}');
    // Provider.of<OrderProvider>(context, listen: false).getWorkerPendingServiceDetails(widget.orderTextId, widget.serviceId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Consumer<OrderProvider>(
            builder: (context, provider, _) => SafeArea(
              child: Column(
                children: [
                  buildHeader(context, provider.pendingOrderInfoList.first, provider),
                  provider.pendingOrderInfoList.isEmpty
                      ? const Expanded(
                          child: Center(
                            child: Text('No Order Found'),
                          ),
                        )
                      : Expanded(
                          child: Stack(children: [
                            LiveMapView(),
                            DraggableScrollableSheet(
                              initialChildSize: 0.6,
                              // Initial size of the sheet
                              minChildSize: 0.2,
                              // Minimum size of the sheet
                              maxChildSize: 0.9,
                              // Maximum size of the sheet
                              expand: true,
                              // Whether to expand the sheet to full screen when dragged upwards
                              builder: (BuildContext context, ScrollController scrollController) {
                                return Container(
                                  decoration: BoxDecoration(color: Colors.white),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          controller: scrollController,
                                          child: Column(
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(top: 8, bottom: 20),
                                                    alignment: Alignment.center,
                                                    width: 44,
                                                    height: 4,
                                                    decoration: ShapeDecoration(
                                                      color: Color(0xFFD9D9D9),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 16),
                                                    child: Consumer<OrderProvider>(
                                                      builder: (context, provider, _) => provider.pendingDetailsScreenButtonText != 'Accept'
                                                          ? UserInfoRow(
                                                              imageUrl: '$urlBase${provider.orderedUserData!.endUserImage}',
                                                              userName: provider.orderedUserData!.endUserName ?? '',
                                                              onImageTap: () {
                                                                debugPrint(provider.orderedUserData!.toJson().toString());
                                                                debugPrint('$urlBase${provider.orderedUserData!.endUserImage}');
                                                              },
                                                              onCallTap: () {
                                                                showModalBottomSheet(
                                                                  context: context,
                                                                  builder: (context) => CallSupportScreen(
                                                                    model: TeamMemberModel(
                                                                      firstName: provider.orderedUserData!.endUserName,
                                                                      phone: '+88034342323',
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              onChatTap: () async {
                                                                var cp = context.read<ChatProvider>();
                                                                if (await cp.getChat(provider.pendingOrderInfoList.first.orderItemId.toString() ?? '')) {
                                                                  Helper.toScreen(
                                                                    context,
                                                                    ChatScreen(
                                                                      receiverName: orderProvider.orderedUserData!.endUserName ?? '',
                                                                      receiverTextId: orderProvider.orderedUserData!.endUserTextId ?? '',
                                                                      groupTextId: orderProvider.pendingOrderInfoList.first.groupName ?? '',
                                                                      service: orderProvider.pendingOrderInfoList.first.serviceTitle ?? '',
                                                                      workerId: orderProvider.pendingOrderInfoList.first.workerTextId ?? '',
                                                                      orderTimeId: orderProvider.pendingOrderInfoList.first.orderItemId.toString(),
                                                                      orderTextId: orderProvider.pendingOrderInfoList.first.orderTextId ?? '',
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                            )
                                                          : SizedBox(),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: ShapeDecoration(
                                                      shape: RoundedRectangleBorder(
                                                        side: BorderSide(
                                                          width: 1,
                                                          strokeAlign: BorderSide.strokeAlignCenter,
                                                          color: Color(0xFFF6F6F6),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (provider.pendingDetailsScreenButtonText == 'Accept')
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Icon(Icons.location_pin),
                                                      SizedBox(width: 12),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text('Address', style: interText(16, Colors.black, FontWeight.w600)),
                                                          SizedBox(height: 2),
                                                          Text(
                                                            '${orderProvider.orderedUserData!.endUserAddress!.zip}, ${orderProvider.orderedUserData!.endUserAddress!.city} ${orderProvider.orderedUserData!.endUserAddress!.state}' ?? '',
                                                            style: GoogleFonts.inter(
                                                              fontSize: 14,
                                                              color: Color(0xff636366),
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () async {
                                                              //   final mp = Provider.of<MapProvider>(context, listen: false);

                                                              // Update the order location dynamically
                                                              // mp.setOrderLocation(LatLng(23.8103, 90.4125), '${orderProvider.orderedUserData!.endUserAddress!.zip}, ${orderProvider.orderedUserData!.endUserAddress!.city}');

                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => CustomGoogleMap()));
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                              child: Text('Locate on map', style: interText(14, myColors.green, FontWeight.w500)),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              if (provider.pendingDetailsScreenButtonText != 'Accept')
                                                Consumer<OrderProvider>(builder: (context, pro, _) {
                                                  if (true) {
                                                    //pro.pendingOrderInfoList.first.orderStatus!=JobStatus.pending
                                                    return OrderTracker4(
                                                      //  status: pro.mapJobStatusToOrderStatus(mapText ?? ''),
                                                      status: pro.orderStatus,
                                                      activeColor: myColors.green,
                                                      dataList: pro.scheduleTimeListDataList,
                                                    );
                                                  } else {
                                                    return SizedBox();
                                                  }
                                                }),
                                              Container(
                                                color: myColors.divider,
                                                height: 8,
                                              ),
                                              buildOrderInfoWidget(provider),
                                              Container(color: myColors.divider, height: 1.7),
                                              SizedBox(height: 20),
                                              Text(
                                                '\$${provider.pendingOrderInfoList.first.serviceAmount}',
                                                style: interText(24, myColors.green, FontWeight.bold),
                                              ),
                                              Text('Total Bill', style: interText(14, Color(0xff777777), FontWeight.w500)),
                                              SizedBox(
                                                height: 24,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                                child: CustomRoundedButton(
                                                  label: provider.pendingDetailsScreenButtonText == 'Job Started'
                                                      ? 'Start Job'
                                                      : provider.pendingDetailsScreenButtonText == 'Complete the job'
                                                          ? 'End This Job'
                                                          : provider.pendingDetailsScreenButtonText,
                                                  funcName: () async {
                                                    //set functionalities base on button text
                                                    // debugPrint(provider.pendingDetailsScreenButtonText);
                                                    setFunctionalitiesBasedOnButtonText(provider.pendingDetailsScreenButtonText, provider);
                                                  },
                                                  buttonColor: buttonClr,
                                                  fontColor: Colors.white,
                                                  borderRadius: 40,
                                                  controller: _btnController,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              // if (DashboardHelpers.pemissionHandler(
                                              //             UserHelpers
                                              //                 .empType) &&
                                              //     provider
                                              //             .pendingOrderInfoList
                                              //             .first
                                              //             .serviceStatus ==
                                              //         JobStatus.pending)
                                              //   CustomRoundedButton(
                                              //     label: 'Assign Order +',
                                              //     funcName: () async {
                                              //       Navigator.push(
                                              //           context,
                                              //           MaterialPageRoute(
                                              //               builder: (context) =>
                                              //                   OrderAssignMemberList(
                                              //                     orderInfo: provider
                                              //                         .pendingOrderInfoList
                                              //                         .first,
                                              //                   )));
                                              //     },
                                              //     buttonColor: myColors.greyBtn,
                                              //     fontColor: Colors.black,
                                              //     borderRadius: 40,
                                              //     controller: _btnController,
                                              //   ),
                                              SizedBox(
                                                height: 24,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          ]),
                        ),
                ],
              ),
            ),
          )),
    );
  }

  void _showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return CustomBottomSheet(
          icon: Icons.check_circle_outline,
          message: 'Order successfully accepted!',
          buttonText: 'Okay',
          onButtonPressed: () {
            Navigator.of(context).pop(); // Close the bottom sheet
          },
        );
      },
    );
  }

  ExpansionTile buildOrderInfoWidget(OrderProvider provider) {
    return ExpansionTile(
      initiallyExpanded: provider.pendingDetailsScreenButtonText == 'Accept',
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        side: BorderSide(
          color: Colors.white,
          width: 1,
        ),
      ),
      title: Text(
        'Order Info',
        style: interText(18, Colors.black, FontWeight.w700),
      ),
      children: [
        _buildDivider(),
        const SizedBox(height: 16),
        _buildOrderDetailsRow(provider),
        OrderAttributeInfo(provider),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      color: myColors.divider,
      height: 1.7,
    );
  }

  Widget _buildOrderDetailsRow(OrderProvider provider) {
    final pendingOrder = provider.pendingOrderInfoList.first;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderImage(pendingOrder.serviceImage),
          const SizedBox(width: 16),
          Expanded(
            child: _buildOrderDetails(pendingOrder),
          ),
          Text(
            '\$${pendingOrder.serviceAmount}',
            style: interText(16, Colors.black, FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderImage(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: FadeInImage(
        fit: BoxFit.cover,
        height: 64,
        width: 64,
        image: NetworkImage('$urlBase$imageUrl'),
        placeholder: const AssetImage('images/placeholder.jpg'),
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/svg/Selfie.png',
            fit: BoxFit.cover,
            height: 64,
            width: 64,
          );
        },
      ),
    );
  }

  Widget _buildOrderDetails(PendingServiceDetailsModel pendingOrder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pendingOrder.serviceTitle ?? 'Service Name',
          style: interText(16, Colors.black, FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (pendingOrder.servicePlanTextId != 'AdminBundlePlan') _buildServicePlanTag(pendingOrder.servicePlan),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _buildServicePlanTag(String? servicePlan) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: myColors.primaryStroke,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Text(
          servicePlan ?? 'Basic',
          style: interText(12, Colors.black, FontWeight.w500),
        ),
      ),
    );
  }

  Column OrderAttributeInfo(OrderProvider provider) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 16),
                ServiceAttribute(
                  serviceJsonList: provider.pendingOrderInfoList.first.serviceJson!,
                )
              ],
            ),
          ),
        ),
        BillingAddressWidgets(
          widget: widget,
          btnController: _btnController,
        ),
      ],
    );
  }

  Future<void> showInTransitAlert(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Confirm Transit Status",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              Text(
                "You are about to mark this order as 'In Transit.' This will notify the customer that you are on your way.\nDo you want to proceed?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  var provider = context.read<OrderProvider>();
                  provider.saveWorkerStatus(provider.pendingOrderInfoList.first.orderTextId, 'InTransit', textId, provider.pendingOrderInfoList.first.serviceTextId.toString(), provider.pendingOrderInfoList.first.orderItemId.toString() ?? '');
                  // provider.setWorkerStatus(JobStatus.inTransit);
                  // provider.mapJobStatusToOrderStatus(JobStatus.inTransit);
                  // provider.getOpenOrderInfo();
                  //set service status
                  orderProvider.setPendingDetailsScreenServiceStatus(JobStatus.inTransit);
                  //set timeline details
                  orderProvider.mapJobStatusToOrderStatus(JobStatus.inTransit ?? '');
                  //set button text
                  orderProvider.getPendingDetailsScreenButtonText(JobStatus.inTransit);
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      "Yes, Confirm",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> showTakingImageAlert(BuildContext context, String status) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Profile Image
                        SizedBox(height: 20),
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.grey[200],
                          child: Image.asset(
                            'assets/png/demo_selfie.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Description
                        Padding(
                          padding: EdgeInsets.all(6),
                          child: Text(
                            status == JobStatus.jobStarted ? 'Before start work' : 'Before end work',
                            textAlign: TextAlign.center,
                            style: interText(16, Colors.black, FontWeight.w500).copyWith(letterSpacing: 0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Before ${status == JobStatus.jobStarted ? 'start' : 'end'} the job, kindly capture or upload a picture of the room. This helps in documenting the current state for reference',
                            textAlign: TextAlign.center,
                            style: interText(12, Color(0xff777777), FontWeight.w400).copyWith(letterSpacing: 0),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        // Instruction
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check, size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Click on the "Take Before Photo" button below.',
                                  textAlign: TextAlign.left,
                                  style: interText(12, Color(0xff777777), FontWeight.w400).copyWith(letterSpacing: 0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Capture or upload a clear picture of the room you are working on.',
                                  textAlign: TextAlign.left,
                                  style: interText(12, Color(0xff777777), FontWeight.w400).copyWith(letterSpacing: 0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check, size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Refer to the guidelines provided on the next screen for photo clarity.',
                                  textAlign: TextAlign.left,
                                  style: interText(12, Color(0xff777777), FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Icon Button
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: myColors.green, padding: EdgeInsets.symmetric(vertical: 12)),
                            onPressed: () {
                              //set pending list to upcoming list
                              // orderProvider.convertPendingListToUpcomingList(orderProvider.pendingOrderInfoList);

                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => WorkStatusStaticScreen()));
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            label: Text(
                              status == JobStatus.jobStarted ? 'Take Before Photo' : 'Take After Photo',
                              style: interText(16, Colors.white, FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context); // Close the alert box
                      },
                    ),
                  ),
                ],
              ),
            ));
  }

  Future<void> setFunctionalitiesBasedOnButtonText(String pendingDetailsScreenButtonText, OrderProvider provider) async {
    if (pendingDetailsScreenButtonText == 'Accept') {
      _btnController.start();
      var item = provider.pendingOrderInfoList.first;
      var output = await provider.postRequestServiceAccept(item.orderTextId!, item.orderItemId.toString(), true);
      print('output ${output}');

      //for updating timeline
      // get order information
      // await provider.getWorkerUpcomingServiceDetailsFromPending(provider.pendingOrderInfoList.first.orderItemId.toString()??'',provider.pendingOrderInfoList.first.serviceTextId??'');
      if (output) {
        //set service status
        orderProvider.setPendingDetailsScreenServiceStatus(JobStatus.confirmed);
        //set timeline details
        orderProvider.mapJobStatusToOrderStatus(JobStatus.confirmed ?? '');
        //set button text
        orderProvider.getPendingDetailsScreenButtonText(JobStatus.confirmed);

        DashboardHelpers.successStopAnimation(_btnController);
        _showCustomBottomSheet(context);
        //set in progress order index
        // provider.setOrderIndex(1);
      } else {
        DashboardHelpers.errorStopAnimation(_btnController);
      }
    } else if (pendingDetailsScreenButtonText == JobStatus.inTransit) {
      showInTransitAlert(context);
    } else if (pendingDetailsScreenButtonText == JobStatus.jobStarted) {
      showTakingImageAlert(context, JobStatus.jobStarted);
      provider.setWorkerStatus('Before');
    } else if (pendingDetailsScreenButtonText == 'Complete the job') {
      provider.setWorkerStatus('After');
      showEndJobBottom(context);
      //previously used
      // showTakingImageAlert(context, 'Not started yet');
    }
  }

  Future<void> showEndJobBottom(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Are you sure you want to end this job?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Container(
                height: 1,
                width: MediaQuery.sizeOf(context).width,
                color: myColors.devider,
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  var provider = context.read<OrderProvider>();
                  await provider.getUploadedImages(provider.pendingOrderInfoList.first.orderItemId, provider.pendingOrderInfoList.first.orderTextId);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NoContactServiceScreen(orderInfo: provider.pendingOrderInfoList.first)));
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      "Yes, Confirm",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

class BillingAddressWidgets extends StatelessWidget {
  const BillingAddressWidgets({
    super.key,
    required this.widget,
    required RoundedLoadingButtonController btnController,
  }) : _btnController = btnController;

  final OrderedServiceDetailsScreen widget;
  final RoundedLoadingButtonController _btnController;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Billing Address ',
                            style: interText(16, Colors.black, FontWeight.w500).copyWith(letterSpacing: 0),
                          ),
                          Text('${provider.orderedUserData!.endUserAddress!.zip}, ${provider.orderedUserData!.endUserAddress!.city} ${provider.orderedUserData!.endUserAddress!.state}' ?? '',
                              // 'hello world',
                              style: interText(14, Color(0xff636366), FontWeight.w500).copyWith(letterSpacing: 0)),
                          if (provider.orderedUserData!.endUserAddress!.addressLine2 != null)
                            Text(
                              '${provider.orderedUserData!.endUserAddress!.addressLine2}',
                              style: interText(14, Color(0xff636366), FontWeight.w500).copyWith(letterSpacing: 0),
                            ),
                          if (provider.orderedUserData!.endUserAddress!.doorCode != null)
                            Text(
                              '${provider.orderedUserData!.endUserAddress!.doorCode}',
                              style: interText(14, Color(0xff636366), FontWeight.w500).copyWith(letterSpacing: 0),
                            ),
                          SizedBox(
                            height: 6,
                          ),
                          InkWell(
                            onTap: () {
                              DashboardHelpers.openMap(provider.orderedUserData!.endUserAddress!.latitude, provider.orderedUserData!.endUserAddress!.longitude);
                            },
                            child: Text('Locate on map', style: interText(14, myColors.green, FontWeight.w500).copyWith(letterSpacing: 0)),
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
                  margin: EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFFF6F6F6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Color(0xff777777),
                      size: 20,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Schedule Date',
                          style: interText(16, Colors.black, FontWeight.w500).copyWith(letterSpacing: 0),
                        ),
                        Consumer<OrderProvider>(
                          builder: (context, provider, _) => Row(
                            children: [
                              Text(provider.pendingOrderInfoList.first.scheduledDate ?? '',
                                  // 'hello world',
                                  style: interText(14, Color(0xff636366), FontWeight.w500)),
                              Text(' (${provider.pendingOrderInfoList.first.startTime} | ${provider.pendingOrderInfoList.first.endtime})',
                                  // 'hello world',
                                  style: interText(14, Color(0xff636366), FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFFF6F6F6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      child: Consumer<OrderProvider>(
                        builder: (context, provider, _) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Duration',
                              style: interText(16, Colors.black, FontWeight.w500).copyWith(letterSpacing: 0),
                            ),
                            Text(DashboardHelpers.convertDecimalToHoursMinutes(double.parse(provider.pendingOrderInfoList.first.workHour.toString())),
                                // 'hello world',
                                style: interText(14, Color(0xff636366), FontWeight.w500).copyWith(letterSpacing: 0))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFFF6F6F6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.copy,
                      color: Color(0xff777777),
                      size: 20,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          DashboardHelpers.copyToClipboard(provider.pendingOrderInfoList.first.orderTextId ?? '');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order Number: ${provider.pendingOrderInfoList.first.orderTextId}',
                              style: interText(14, Colors.black, FontWeight.w500).copyWith(letterSpacing: 0),
                            ),
                            FittedBox(
                              child: Text('Please use this ID instead of the customer name', style: interText(12, Color(0xff636366), FontWeight.w500).copyWith(letterSpacing: 0)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFFF6F6F6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (provider.pendingOrderInfoList.first.instructionToWorker != null)
            ExpansionTile(
              title: Text(
                'Special Instructions',
                style: interText(16, Colors.black, FontWeight.w500).copyWith(letterSpacing: 0),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                    provider.pendingOrderInfoList.first.instructionToWorker ?? 'No Instruction',
                    style: interText(14, Color(0xff636366), FontWeight.w500).copyWith(letterSpacing: 0),
                  ),
                )
              ],
              shape: RoundedRectangleBorder(side: BorderSide(color: Colors.transparent, width: 2)),
              leading: Icon(
                Icons.message,
                color: Color(0xff777777),
                size: 20,
              ),
            ),
          SizedBox(
            height: 12,
          ),
          Container(
            height: 8,
            color: myColors.divider,
          ),
        ],
      ),
    );
  }
}

Padding buildHeader(BuildContext context, PendingServiceDetailsModel orderInfo, OrderProvider provider) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Consumer<OrderProvider>(
          builder: (context, provider, _) => IconButton(
              onPressed: () {
                //clear selected list
                Navigator.pop(context);
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardScreen()));
              },
              icon: const Icon(Icons.close)),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Scheduled | ${orderInfo.scheduledDate}',
                style: interText(12, Color(0xff767676), FontWeight.w500),
              ),
              SizedBox(height: 2),
              Text(
                'Req. No : ${orderInfo.orderTextId}',
                style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        if (provider.pendingDetailsScreenButtonText == 'Accept')
          TextButton(
              onPressed: () {
                // showModalBottomSheet(
                //     context: context,
                //     isScrollControlled: true,
                //     builder: (context) {
                //       return CancelSupportModal(orderInfo);
                //     });

                Navigator.push(context, MaterialPageRoute(builder: (context) => CancelSupportModal(orderInfo)));
              },
              child: Text(
                'Reject',
                style: TextStyle(color: Colors.black),
              ))
      ],
    ),
  );
}

class LiveMapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) {
        return Stack(
          children: [
            if (mapProvider.userLocation != null)
              GoogleMap(
                mapType: MapType.terrain,
                initialCameraPosition: CameraPosition(
                  target: mapProvider.userLocation ?? LatLng(23.6429, 90.4883),
                  zoom: 12, // Default zoom level
                ),
                onMapCreated: (GoogleMapController controller) async {
                  mapProvider.setMapController(controller);

                  final mp = Provider.of<MapProvider>(context, listen: false);
                  // Set order location manually
                  mp.setOrderLocation(LatLng(23.7516, 90.3943), 'Tirupur 10-B/67');

                  // Save the initial zoom level
                  double currentZoom = await controller.getZoomLevel();

                  // Move camera but keep zoom unchanged
                  Future.delayed(Duration(milliseconds: 500), () {
                    controller.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: mapProvider.userLocation ?? LatLng(23.6429, 90.4883),
                        zoom: currentZoom, // Keep existing zoom
                      ),
                    ));
                  });
                },
                markers: mapProvider.markerList,
                polylines: mapProvider.polylines,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                compassEnabled: true,
              ),

            if (mapProvider.routeNotFound)
              Center(
                child: Container(
                  color: Colors.black54,
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No route found',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            // Toggle button for Live Tracking
            Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () async {
                  double currentZoom = await mapProvider.mapController?.getZoomLevel() ?? 12;
                  mapProvider.startNavigation();
                  // mapProvider.startNavigation(currentZoom);
                },
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.directions,
                  color: Colors.white,
                ),
              ),
            ),

            // Display distance & duration
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Container(
                child: Column(
                  children: [
                    Text(
                      'Distance : ${mapProvider.distance}',
                      style: interText(12, Colors.black, FontWeight.w500),
                    ),
                    Text(
                      'Duration : ${mapProvider.duration}',
                      style: interText(12, Colors.black, FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// class LiveMapView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MapProvider>(
//       builder: (context, mapProvider, child) {
//         return Stack(
//           children: [
//             if (mapProvider.userLocation != null)
//               GoogleMap(
//                 mapType: MapType.terrain,
//                 initialCameraPosition: CameraPosition(
//                   target: mapProvider.userLocation ?? LatLng(23.6429, 90.4883),
//                   zoom: 12, // Ensure default zoom is 12
//                 ),
//                 onMapCreated: (GoogleMapController controller) {
//                   mapProvider.setMapController(controller);
//
//                   final mp = Provider.of<MapProvider>(context, listen: false);
//                   // Update the order location manually
//                   //23.7516° N, 90.3943
//                   mp.setOrderLocation(
//                       LatLng(23.7516, 90.3943), 'Tirupur 10-B/67');
//
//                   // Force camera position with zoom 12 after map is created
//                   Future.delayed(Duration(milliseconds: 500), () {
//                     controller.animateCamera(CameraUpdate.newCameraPosition(
//                       CameraPosition(
//                         target: mapProvider.userLocation ??
//                             LatLng(23.6429, 90.4883),
//                         zoom: 12, // Ensure zoom is locked at 12
//                       ),
//                     ));
//                   });
//                 },
//                 markers: mapProvider.markerList,
//                 polylines: mapProvider.polylines,
//                 myLocationEnabled: true,
//                 myLocationButtonEnabled: false,
//                 compassEnabled: true,
//               ),
//
//             if (mapProvider.routeNotFound)
//               Center(
//                 child: Container(
//                   color: Colors.black54,
//                   padding: EdgeInsets.all(16.0),
//                   child: Text(
//                     'No route found',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//
//             // Toggle button for Live Tracking
//             Positioned(
//               top: 16,
//               right: 16,
//               child: FloatingActionButton(
//                 onPressed: () {
//                   mapProvider.startNavigation(); // Start following the user
//                 },
//                 backgroundColor: Colors.green,
//                 child: Icon(
//                   Icons.directions,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//
//             // Display distance & duration
//             Positioned(
//               top: 20,
//               left: 0,
//               right: 0,
//               child: Container(
//                 child: Column(
//                   children: [
//                     Text(
//                       'Distance : ${mapProvider.distance}',
//                       style: interText(12, Colors.black, FontWeight.w500),
//                     ),
//                     Text(
//                       'Duration : ${mapProvider.duration}',
//                       style: interText(12, Colors.black, FontWeight.w500),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
