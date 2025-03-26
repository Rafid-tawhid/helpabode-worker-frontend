import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helper_functions/notification_helpers.dart';
import '../../../../misc/constants.dart';
import '../../../../provider/notification_provider.dart';
import '../../../../provider/order_provider.dart';
import '../../../../provider/user_provider.dart';
import '../../helper_functions/colors.dart';
import '../../helper_functions/dashboard_helpers.dart';
import '../../screens/support/dashboard_support_screen.dart';
import '../../screens/myservice/my_services_screen.dart';
import '../../screens/notification/show_notification_screen.dart';
import '../../screens/open_order/open_order_screen.dart';
import '../../screens/profile/edit_profile_screen.dart';
import '../../screens/shift/shift_config.dart';
import '../../widgets_reuse/team_member_bottom_nav_bar.dart';

class DashboardIndividualTeamMember extends StatefulWidget {
  const DashboardIndividualTeamMember({super.key});

  @override
  State<DashboardIndividualTeamMember> createState() =>
      _DashboardIndividualTeamMemberState();
}

class _DashboardIndividualTeamMemberState
    extends State<DashboardIndividualTeamMember> {
  var firstName = '';
  var lastName = '';

  late UserProvider userPro;
  double latitude = 0;
  double lngtitude = 0;
  bool showMap = false;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  Position? currentPosition;

  //Set<Marker> _markers = {};
  late OrderProvider mapProvider;
  late NotificationProvider notfProvider;

  // late TabControllerProvider tabControllerProvider;
  NotificationServices notificationServices = NotificationServices();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Marker> _markers = {};
  CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962), // Default position
    zoom: 12,
  );
  Circle? _currentLocationCircle;

  @override
  void initState() {
    super.initState();
    notfProvider = Provider.of<NotificationProvider>(context, listen: false);
    userPro = Provider.of<UserProvider>(context, listen: false);
    //notfProvider.getNotificationBellIconCount();
    Provider.of<NotificationProvider>(context, listen: false)
        .getNotificationBellIconCount(context);
    notificationServices.forGroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.isTokenExperied();
    notificationServices.getTokens().then((value) {
      print('DEVICE TOKEN ${value}');
      notfProvider.sendDeviceToken(value, context);
    });

    //  _requestNotificationAndLocationPermission();
  }

  @override
  void didChangeDependencies() {
    //workingServiceProvider.getServiceData();
    // provider.getWorkersCityModels();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Consumer<NotificationProvider>(
                            builder: (context, provider, _) => InkWell(
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            width: .5, color: Colors.grey)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.notifications_none),
                                    ),
                                  ),
                                  if (provider.notificationCount != '0')
                                    Container(
                                      height: 16,
                                      width: 16,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.red),
                                      child: Text(
                                        provider.notificationCount,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 8),
                                      ),
                                    )
                                ],
                              ),
                              onTap: () async {
                                // print('TOKEN : $token');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ShowNotificationScreen()));
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      width: .5, color: Colors.grey)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.message),
                              ),
                            ),
                            onTap: () async {
                              print('TOKEN : $textId');
                              var registrationBox =
                                  await Hive.openBox('registrationBox');
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              pref.remove('user');
                              pref.remove('address');
                              pref.remove('status');
                              registrationBox.clear();
                              context.pushReplacementNamed('home');

                              // Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen()));
                            },
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShiftConfigration()));
                        // DashboardHelpers.checkForFirstLogin(context);
                        //  FirebaseServices.addUserEmail('rafid@gmail.com');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(width: .5, color: Colors.grey)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.access_time_outlined, size: 24),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DashboardSupportScreen()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(width: .5, color: Colors.grey)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.help_outline_sharp,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 24,
              ),
              Container(
                padding: const EdgeInsets.only(left: 28, top: 16, bottom: 16),
                decoration: BoxDecoration(color: myColors.greyBg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Consumer<UserProvider>(builder: (context, pro, _) {
                          return Hero(
                            tag: 'account',
                            child: Container(
                              height: 100,
                              width: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape
                                    .circle, // Makes the container a perfect circle
                                boxShadow: [
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
                                border:
                                    Border.all(width: 1, color: Colors.white),
                              ),
                              child: InkWell(
                                onTap: () {
                                  print('${pro.userImageUrl}');
                                },
                                child: ClipOval(
                                  child: Image.network(
                                    '${pro.userImageUrl}',
                                    alignment: Alignment.center,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Container(
                                          height: 100,
                                          width: 100,
                                          alignment: Alignment.center,
                                          child: Text(
                                            DashboardHelpers
                                                .getFirstCharacterCombinationName(
                                                    pro.userModel.firstName ??
                                                        '',
                                                    '${pro.userModel.lastName}'),
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: myColors.green),
                                          ),
                                        );
                                      }
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return Container(
                                        height: 100,
                                        width: 100,
                                        alignment: Alignment.center,
                                        child: Text(
                                          DashboardHelpers
                                              .getFirstCharacterCombinationName(
                                                  pro.userModel.firstName ?? '',
                                                  '${pro.userModel.lastName}'),
                                          style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(
                          width: 28,
                        ),
                        Consumer<UserProvider>(
                          builder: (context, provider, _) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                '${provider.userModel.firstName ?? 'Jon'} ${provider.userModel.lastName ?? 'doe'}',
                                style: profileText,
                              ),
                              const SizedBox(height: 2),
                              FittedBox(
                                child: AutoSizeText(
                                  provider.userModel.email ?? 'mail',
                                  style: profileEmail,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              InkWell(
                                onTap: () {
                                  // context.pushNamed('profile_edit');
                                  Navigator.of(context).push(PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        EditProfileScreen(),
                                  ));

                                  // Navigator.push(context, CupertinoPageRoute(builder: (context) => EditProfileScreen()));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: myColors.primaryColor,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Text(
                                    'Edit Profile',
                                    style: editProfile,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacer(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height / 2,
            child: DraggableScrollableSheet(
              initialChildSize: .6,
              // Initial size of the sheet
              minChildSize: 0.4,
              // Minimum size of the sheet
              maxChildSize: 1,
              // Maximum size of the sheet
              expand: true,
              // Whether to expand the sheet to full screen when dragged upwards
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 4,
                          width: 44,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xFFD9D9D9)),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        InkWell(
                                          child: Container(
                                            height: 80,
                                            width: 80,
                                            margin: EdgeInsets.all(4),
                                            padding: const EdgeInsets.all(22),
                                            clipBehavior: Clip.antiAlias,
                                            decoration: ShapeDecoration(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(500),
                                              ),
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/svg/time.svg',
                                              height: 20,
                                              width: 20,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ShiftConfigration()));
                                          },
                                        ),
                                        Text(
                                          'Schedule',
                                          style: interText(14, Colors.black,
                                              FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        InkWell(
                                          child: Container(
                                            height: 80,
                                            width: 80,
                                            margin: EdgeInsets.all(4),
                                            padding: const EdgeInsets.all(20),
                                            clipBehavior: Clip.antiAlias,
                                            decoration: ShapeDecoration(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(500),
                                              ),
                                            ),
                                            child: Image.asset(
                                              'assets/png/myservices.png',
                                            ),
                                          ),
                                          onTap: () async {
                                            // EasyLoading.show(maskType: EasyLoadingMaskType.black);
                                            // var provider = Provider.of<WorkingServiceProvider>(context, listen: false);
                                            // if (await provider.getMyTeamLeaderServices()) {
                                            //   EasyLoading.dismiss();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyServicesScreen(
                                                          empType: 'teamMember',
                                                        )));
                                            // } else {
                                            //   EasyLoading.dismiss();
                                            // }
                                          },
                                        ),
                                        Text(
                                          'Services',
                                          style: interText(14, Colors.black,
                                              FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Consumer<OrderProvider>(
                                          builder: (context, provider, _) =>
                                              InkWell(
                                            child: Container(
                                              height: 80,
                                              width: 80,
                                              margin: EdgeInsets.all(4),
                                              padding: const EdgeInsets.all(22),
                                              clipBehavior: Clip.antiAlias,
                                              decoration: ShapeDecoration(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          500),
                                                ),
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/svg/receipt.svg',
                                                height: 20,
                                                width: 20,
                                              ),
                                            ),
                                            onTap: () {
                                              provider.isLoading = true;
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const RequestedServiceScreen()));
                                            },
                                          ),
                                        ),
                                        Text(
                                          'Orders',
                                          style: interText(14, Colors.black,
                                              FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 20,
                              )
                              // Add more widgets here
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
      bottomSheet: const MyBottomNavBarTeam(),
    );
  }

  void _updateMapLocation(Position position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 19.4746,
        ),
      ),
    );
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: LatLng(position.latitude, position.longitude),
        ),
      );
      _currentLocationCircle = Circle(
        circleId: CircleId('currentLocationRadius'),
        center: LatLng(position.latitude, position.longitude),
        radius: 20,
        fillColor: Colors.blue.withOpacity(0.3),
        strokeWidth: 2,
      );
    });
  }
}
