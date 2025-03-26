import 'dart:async';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/user_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/order_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/open_order/common_screen/work_status_photos_static_screen.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/bottm_sheet.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_material_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../widgets_reuse/markers.dart';
import '../widgets/tracker4.dart';

class UpComingOrderTimeLineDetails extends StatefulWidget {
  // final WorkerServiceRequestModel orderReq;

  @override
  State<UpComingOrderTimeLineDetails> createState() =>
      _UpComingOrderTimeLineDetailsState();

  // UpComingOrderTimeLineDetails({required this.orderReq});
}

class _UpComingOrderTimeLineDetailsState
    extends State<UpComingOrderTimeLineDetails> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // static const CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 18,
  // );
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  Position? currentPosition;
  BitmapDescriptor? customIcon;
  int btn = 1;
  late OrderProvider mapProvider;
  String btnText = '';
  String mapText = '';
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    //print('widget.orderReq.orderItems!.first.serviceStatus ${widget.orderReq.orderItems!.first.serviceStatus}');

    mapProvider = Provider.of<OrderProvider>(context, listen: false);

    goTocurrentLocation();

    //get button text based on status

    getButtonText(mapProvider);

    super.initState();
  }

  static String getServiceButtonText(String serviceStatus) {
    switch (serviceStatus) {
      case JobStatus.confirmed:
        return JobStatus.inTransit;
      case JobStatus.inTransit:
        return JobStatus.jobStarted;
      case JobStatus.jobStarted:
        return 'Submit After Image';
      case JobStatus.completed:
        return 'Completed';
      case JobStatus.completedByProvider:
        return 'Completed';
      case JobStatus.canceled:
        return 'Completed';
      default:
        return 'Canceled';
    }
  }

  // Load custom marker icon
  void setCustomMarker() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(148, 148)),
      'assets/png/Icons.png', // Path to the custom marker image
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildHeader(context),
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
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                    child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height /
                          3.5, // Full width of the screen
                      color: Colors.blue,
                      child: AdjustPinScreen(
                          lat: double.parse(mapProvider
                                  .upcomingServiceModelList.first.latitude ??
                              ''),
                          lon: double.parse(mapProvider
                                  .upcomingServiceModelList.first.longitude ??
                              '')),
                    ),
                  ],
                )),
                SliverStickyHeader(
                  header: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: GestureDetector(
                      //         onTap: () {
                      //           // Fluttertoast.showToast(
                      //           //     msg: odp.orderTrackData!.orderDetails!
                      //           //         .results![0].chatGroupId
                      //           //         .toString());
                      // Helper.toScreen(
                      //   context,
                      //   ChatScreen(
                      //     receiverName: "",
                      //     receiverTextId: "",
                      //     groupTextId: "",
                      //   ),
                      // );
                      //         },
                      //         child: Container(
                      //           height: 42,
                      //           padding: const EdgeInsets.symmetric(
                      //               horizontal: 12, vertical: 10),
                      //           decoration: ShapeDecoration(
                      //             color: Color(0xFFF6F6F6),
                      //             shape: RoundedRectangleBorder(
                      //               side: BorderSide(
                      //                   width: 1.70, color: Color(0xFFE9E9E9)),
                      //               borderRadius: BorderRadius.circular(32),
                      //             ),
                      //           ),
                      //           child: Row(
                      //             mainAxisSize: MainAxisSize.min,
                      //             mainAxisAlignment: MainAxisAlignment.start,
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             children: [
                      //               Container(
                      //                 width: 16,
                      //                 height: 16,
                      //                 clipBehavior: Clip.antiAlias,
                      //                 decoration: BoxDecoration(),
                      //                 child: Icon(
                      //                   Icons.message,
                      //                   size: 16,
                      //                   color: Color(0xFF777777),
                      //                 ),
                      //               ),
                      //               const SizedBox(width: 8),
                      //               Text(
                      //                 'Chat with Help Abode',
                      //                 // style: interStyle12_500.copyWith(
                      //                 //   color: Color(0xFF777777),
                      //                 // ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 16,
                      //     ),
                      //     GestureDetector(
                      //       onTap: () {
                      //         Fluttertoast.showToast(msg: "Need to configure");
                      //       },
                      //       child: Container(
                      //         height: 42,
                      //         width: 42,
                      //         // padding: const EdgeInsets.all(12),
                      //         decoration: ShapeDecoration(
                      //           color: Color(0xFFF6F6F6),
                      //           shape: RoundedRectangleBorder(
                      //             side: BorderSide(
                      //                 width: 1.70, color: Color(0xFFE9E9E9)),
                      //             borderRadius: BorderRadius.circular(500),
                      //           ),
                      //         ),
                      //         child: Icon(
                      //           Icons.phone,
                      //           size: 24,
                      //           color: Color(0xFF777777),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: ListTile(
                          tileColor: Colors.white,
                          // leading: CircularProfileImage('$urlBase${mapProvider.orderedUserData!.endUserImage}', '${mapProvider.orderedUserData!.endUserName}', null, myColors.green, 50),
                          leading: CachedNetworkImage(
                            imageUrl:
                                '$urlBase${mapProvider.orderedUserData!.endUserImage}',
                            placeholder: (context, url) => Container(
                              height: 50,
                              width: 50,
                              child: ClipOval(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: myColors.green, width: 2),
                                  ),
                                  child: Text(
                                    DashboardHelpers
                                        .getFirstCharacterCombinationName(
                                            mapProvider.orderedUserData!
                                                    .endUserName ??
                                                '',
                                            null),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: myColors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 50,
                              width: 50,
                              child: ClipOval(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: myColors.green, width: 2),
                                  ),
                                  child: Text(
                                    DashboardHelpers
                                        .getFirstCharacterCombinationName(
                                            mapProvider.orderedUserData!
                                                    .endUserName ??
                                                '',
                                            null),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: myColors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                            imageBuilder: (context, imageProvider) => ClipOval(
                              child: Image(
                                image: imageProvider,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            mapProvider.orderedUserData!.endUserName ??
                                'No name',
                            style: GoogleFonts.inter(fontSize: 16),
                          ),
                          subtitle: Text(
                            mapProvider.upcomingServiceModelList.first
                                    .scheduledDate ??
                                '',
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                // Helper.toScreen(
                                //   context,
                                //   ChatScreen(
                                //     receiverName: mapProvider.orderedUserData!.endUserName ?? '',
                                //     receiverTextId: mapProvider.orderedUserData!.endUserTextId ?? '',
                                //     groupTextId: mapProvider.upcomingServiceModelList.first.groupName ?? '',
                                //     serviceTitle: ,
                                //   ),
                                // );
                              },
                              icon: Icon(Icons.message)),
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
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => Column(
                        children: [
                          if (mapText != JobStatus.canceled)
                            Consumer<OrderProvider>(
                                builder: (context, pro, _) => OrderTracker4(
                                      //  status: pro.mapJobStatusToOrderStatus(mapText ?? ''),
                                      status: pro.orderStatus,
                                      activeColor: myColors.green,
                                      dataList: [
                                        {
                                          'title': 'Address',
                                          'subTitle':
                                              '${mapProvider.upcomingServiceModelList.first.orderDeliveryAddress!.zip}, ${mapProvider.upcomingServiceModelList.first.orderDeliveryAddress!.city}'
                                        },
                                        {
                                          'title': 'Service booked',
                                          'subTitle': mapProvider
                                              .convertDateTime(mapProvider
                                                  .upcomingServiceModelList
                                                  .first
                                                  .orderDate!)
                                        },
                                        {
                                          'title': 'Scheduled',
                                          'subTitle':
                                              '${mapProvider.upcomingServiceModelList.first.scheduledDate}'
                                        },
                                        {
                                          'title': 'Accepted the order',
                                          'subTitle': mapProvider
                                              .upcomingServiceModelList
                                              .first
                                              .orderStatus
                                        },
                                        {
                                          'title': 'In Transit',
                                          'subTitle': mapProvider
                                              .getStartTimeInfo('In Transit')
                                        },
                                        {
                                          'title': 'Job started',
                                          'subTitle': mapProvider
                                              .getStartTimeInfo('Job Started')
                                        },
                                        {
                                          'title': 'Job completed',
                                          'subTitle': ''
                                        },
                                        {'title': 'Cancelled', 'subTitle': ''},
                                      ],
                                    )),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 8,
                            color: Colors.grey.shade100,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ExpansionTile(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8), // Adjust as needed
                                topRight:
                                    Radius.circular(8), // Adjust as needed
                                bottomLeft: Radius
                                    .zero, // Remove bottom left border radius
                                bottomRight: Radius
                                    .zero, // Remove bottom right border radius
                              ),
                              side: BorderSide(
                                color: Colors.white, // Border color
                                width: 1, // Border width
                              ),
                            ),
                            title: Text(
                              'Order Info',
                              style: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            children: [
                              ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Adjust the value according to your preference
                                  child: FadeInImage(
                                    fit: BoxFit.cover,
                                    height: 60.h,
                                    width: 60.h,
                                    image: NetworkImage(
                                        '$urlBase${mapProvider.upcomingServiceModelList.first.serviceImage}'),
                                    placeholder: const AssetImage(
                                        'images/placeholder.jpg'),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/svg/Selfie.png',
                                        fit: BoxFit.cover,
                                        height: 60.h,
                                        width: 60.h,
                                      );
                                    },
                                  ),
                                ),
                                title: Text(mapProvider.upcomingServiceModelList
                                        .first.serviceTitle ??
                                    'Service Name'),
                                subtitle: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: myColors.green),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3.0, horizontal: 14),
                                        child: Text(
                                          mapProvider.upcomingServiceModelList
                                                  .first.servicePlan ??
                                              'Basic',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const Expanded(child: Text(''))
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Container(
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
                              ),
                              ServiceDetailsInfo(),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Divider(
                            thickness: 8,
                            height: 8.h,
                            color: Colors.grey.shade100,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          if (!UserHelpers.isEmpTypeUnderProvider())
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Consumer<OrderProvider>(
                                          builder: (context, provider, _) =>
                                              Text(
                                            '\$${provider.upcomingServiceModelList.first.serviceAmount}',
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                color: myColors.green,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const Text('Total Bill')
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                if (btnText != JobStatus.completed)
                                  Consumer<OrderProvider>(
                                    builder: (context, provider, _) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 22.0),
                                      child: CustomMaterialButton(
                                          label: btnText,
                                          buttonColor: myColors.green,
                                          fontColor: Colors.white,
                                          funcName: () {
                                            if (btnText ==
                                                JobStatus.inTransit) {
                                              showInTransitAlert(
                                                  context, provider);
                                            } else if (btnText ==
                                                'Job Started') {
                                              showTakingImageAlert(
                                                  context, 'Not started yet');
                                              //set a value to compare before and after in show images screen
                                              provider
                                                  .setWorkerStatus('Before');
                                              // await provider.setWorkerStatus(widget.orderReq.orderNumber, JobStatus.inTransit, textId);
                                            } else if (btnText ==
                                                'Submit After Image') {
                                              showTakingImageAlert(context,
                                                  JobStatus.jobStarted);

                                              provider.setWorkerStatus('After');
                                              // await provider.setWorkerStatus(widget.orderReq.orderNumber, JobStatus.inTransit, textId);
                                            }
                                            // else {
                                            //   showTakingImageAlert(
                                            //     context,
                                            //     JobStatus.end,
                                            //   );
                                            // }
                                          },
                                          borderRadius: 20),
                                    ),
                                  ),
                              ],
                            ),
                          SizedBox(
                            height: 30.h,
                          ),
                        ],
                      ),
                      childCount: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Future<dynamic> showInTransitAlert(
      BuildContext context, OrderProvider provider) {
    return showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (context) => ConfirmBottomSheet(
            message:
                'Are you sure you want to change your status to \'In Transit?',
            // message2: 'Your work is scheduled to start on ',
            icon: Container(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: myColors.green),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Icon(
                  Icons.done_outline_sharp,
                  color: Colors.white,
                ),
              ),
            ),
            btn1: 'Yes',
            btn1Fun: () async {
              provider.saveWorkerStatus(
                  provider.upcomingServiceModelList.first.orderTextId,
                  'InTransit',
                  textId,
                  provider.upcomingServiceModelList.first.serviceTextId
                      .toString(),
                  provider.upcomingServiceModelList.first.orderItemId ?? '');
              provider.setWorkerStatus(JobStatus.inTransit);
              provider.mapJobStatusToOrderStatus(JobStatus.inTransit);
              provider.getOpenOrderInfo();
              Navigator.pop(context);
              setState(() {
                btnText = 'Job Started';
              });
              //  showTakingImageAlert(context);
            },
            btn2Fun: () {
              Navigator.pop(context);
            },
            btn2: 'No'));
  }

  Future<dynamic> showTakingImageAlert(BuildContext context, String status) {
    // print('status ${status}');
    // print('jos status ${JobStatus.jobStarted}');
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Image
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(
                          'assets/svg/Selfie.png',
                        ),
                      ),
                    ),
                    // Description
                    Padding(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        status == JobStatus.jobStarted
                            ? 'Before End Job'
                            : 'Before Start Job',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'Before starting the job, kindly capture or upload a picture of the room. This helps in documenting the current state for reference',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Instruction
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(Icons.check),
                          ),
                          Expanded(
                            child: Text(
                              'Click on the "Take Before Photo" button below.',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(Icons.check),
                          ),
                          Expanded(
                            child: Text(
                              'Capture or upload a clear picture of the room you are working on.',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(Icons.check),
                          ),
                          Expanded(
                            child: Text(
                              'Refer to the guidelines provided on the next screen for photo clarity.',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Icon Button
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: myColors.green),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      WorkStatusStaticScreen()));
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Take Before Photo',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  Column ServiceDetailsInfo() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: mapProvider
                        .upcomingServiceModelList.first.serviceJson!.length,
                    itemBuilder: (context, index) {
                      var item = mapProvider
                          .upcomingServiceModelList.first.serviceJson![index];
                      return Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          children: [
                            Container(
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(
                                      color: myColors.green, width: 1)),
                              alignment: Alignment.center,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: myColors.green),
                                height: 4,
                                width: 4,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Row(
                              children: [
                                Text(
                                  item.title ?? '',
                                  style: interText(
                                      14, Color(0xff636366), FontWeight.w500),
                                ),
                                Text(
                                  '- ${item.amount.toString()}',
                                  style: interText(
                                      14, Color(0xff636366), FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              ),

              // SizedBox(
              //   height: 10.h,
              // ),
              // ListTile(
              //   tileColor: const Color(0XFFEDFCFE),
              //   leading: const Icon(Icons.info_outline),
              //   title: Text(
              //     'Special instructions instructions message will be appear here.pecial instructions instructions message will be appear here. pecial instructions instructions message will be appear here.',
              //     maxLines: 2,
              //     style: TextStyle(color: myColors.green, fontSize: 12),
              //   ),
              // ),

              //  CardAddress(requestedServiceDetailsMap: requestedServiceDetailsMap),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 6),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.location_on)),
                  SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Billing Address : ',
                          style: text_16_black_500_TextStyle,
                        ),
                        Text(
                          '${mapProvider.orderedUserData!.endUserAddress!.zip}, ${mapProvider.orderedUserData!.endUserAddress!.city} ${mapProvider.orderedUserData!.endUserAddress!.state}' ??
                              '',
                          // 'hello world',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: hintClr,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        InkWell(
                          onTap: () {
                            DashboardHelpers.openMap(
                                mapProvider
                                    .orderedUserData!.endUserAddress!.latitude,
                                mapProvider.orderedUserData!.endUserAddress!
                                    .longitude);
                          },
                          child: Text(
                            'Locate on map',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: myColors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                margin: EdgeInsets.symmetric(vertical: 6),
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.calendar_month)),
                  SizedBox(
                    width: 6.w,
                  ),
                  Text(
                    'Date : ',
                    style: text_16_black_500_TextStyle,
                  ),
                  Consumer<OrderProvider>(
                    builder: (context, provider, _) => Text(
                      DashboardHelpers.convertDateTime(provider
                                  .upcomingServiceModelList.first.orderDate ??
                              '') ??
                          '',
                      // 'hello world',
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        color: hintClr,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 6),
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                      padding: EdgeInsets.all(8.0), child: Icon(Icons.timer)),
                  SizedBox(
                    width: 6.w,
                  ),
                  Consumer<OrderProvider>(
                    builder: (context, provider, _) => Text(
                      '${provider.upcomingServiceModelList.first.workHour} -Estimated time',
                      // 'hello world',
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        color: hintClr,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }

  Row buildHeader(BuildContext context) {
    return Row(
      children: [
        Consumer<OrderProvider>(
          builder: (context, provider, _) => IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close)),
        ),
        Expanded(
            child: Consumer<OrderProvider>(
          builder: (context, provider, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Scheduled | ${DashboardHelpers.convertDateTime(provider.upcomingServiceModelList.first.orderDate ?? '')}',
                style: TextStyle(fontSize: 14, color: myColors.greyTxt),
              ),
              Text(
                'Req. No : ${provider.upcomingServiceModelList.first.orderTextId}',
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )),
        // TextButton(
        //     onPressed: () {
        //
        //     },
        //     child: const Text('Reject'))
      ],
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      _showLocationSettingsDialog();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _showLocationSettingsDialog();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _showLocationSettingsDialog();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void _showLocationSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permissions'),
          content: const Text(
              'Location permissions are required for this app. Please enable them in the settings.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Open app settings
                openAppSettings();
                Navigator.of(context).pop();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  Future<void> goTocurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    // Clear existing markers and add a new one
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId(
            'currentLocation',
          ),
          position: LatLng(
              double.parse(
                  mapProvider.upcomingServiceModelList.first.latitude!),
              double.parse(
                  mapProvider.upcomingServiceModelList.first.longitude!)),
          infoWindow: InfoWindow(
              title: mapProvider.orderedUserData!.endUserAddress!.city),
        ),
      };
    });

    //CameraPosition loc = CameraPosition(bearing: 192.8334901395799, target: LatLng(position.latitude, position.longitude), tilt: 59.440717697143555, zoom: 19.151926040649414);
    CameraPosition loc = CameraPosition(
        target: LatLng(
            double.parse(mapProvider.upcomingServiceModelList.first.latitude!),
            double.parse(
                mapProvider.upcomingServiceModelList.first.longitude!)),
        zoom: 12);
    await controller.animateCamera(CameraUpdate.newCameraPosition(loc));
  }

  Future<Uint8List> _loadSvgAsUint8List(String assetName, int width) async {
    ByteData data = await rootBundle.load(assetName);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void getButtonText(OrderProvider mapProvider) async {
    btnText = await getServiceButtonText(
        mapProvider.upcomingServiceModelList.first.serviceStatus ?? '');

    //set tracking indicator
    mapText =
        await mapProvider.upcomingServiceModelList.first.serviceStatus ?? '';
    mapProvider.mapJobStatusToOrderStatus(mapText ?? '');
  }
}

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    super.key,
    required this.widget,
  });

  final UpComingOrderTimeLineDetails widget;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) => ListTile(
        title: Text(provider.orderedUserData!.endUserName ?? 'Name'),
        subtitle: Text(
            '${provider.orderedUserData!.endUserAddress!.zip}, ${provider.orderedUserData!.endUserAddress!.city}' ??
                'Date'),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.message),
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: FadeInImage(
            fit: BoxFit.cover,
            height: 60.h,
            width: 60.h,
            image: NetworkImage(
                '$urlBase${provider.orderedUserData!.endUserImage}'),
            placeholder: const AssetImage('assets/png/person2.png'),
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/svg/Selfie.png',
                fit: BoxFit.cover,
                height: 60.h,
                width: 60.h,
              );
            },
          ),
        ),
      ),
    );
  }
}
