import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_abode_worker_app_ver_2/provider/map_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/notification/messages_list_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/signin_signup_helpers.dart';
import 'package:help_abode_worker_app_ver_2/provider/notification_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/order_provider.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/dashboard/widgets/dashboard_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../helper_functions/notification_helpers.dart';
import '../../provider/dashboard_provider.dart';
import '../../provider/lifecycle_provider.dart';
import '../../provider/network_provider.dart';
import '../../web_soket.dart';
import '../../widgets_reuse/bottom_nav_bar.dart';
import '../open_order/open_order_screen.dart';
import '../notification/show_notification_screen.dart';
import '../shift/new_schedule_screen.dart';
import '../shift/shift_config.dart';
import '../support/dashboard_support_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  static const String routeName = 'dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  var firstName = '';
  var lastName = '';

  late DashboardProvider provider;
  late UserProvider userPro;
  late MapProvider mapProvider;
  late NotificationProvider notfProvider;
  late OrderProvider orderPro;

  NotificationServices notificationServices = NotificationServices();
  SignInSignUpHelpers signInSignUpHelpers = SignInSignUpHelpers();
  final LatLng fixedLocation = LatLng(23.722740, 90.413933);

  @override
  void initState() {
    super.initState();
    initializeProviders();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _initializeAppFeatures());
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration.zero, () {
      Provider.of<InternetProvider>(context, listen: false)
          .startListening(context);
      Provider.of<AppLifecycleProvider>(context, listen: false)
          .isAvailable('Y');
    });
  }

  void initializeProviders() {
    notfProvider = Provider.of<NotificationProvider>(context, listen: false);
    userPro = Provider.of<UserProvider>(context, listen: false);
    orderPro = Provider.of<OrderProvider>(context, listen: false);
    mapProvider = Provider.of<MapProvider>(context, listen: false);
    provider = Provider.of<DashboardProvider>(context, listen: false);
  }

  Future<void> _initializeAppFeatures() async {
    provider.getAllFaqs();
    orderPro.getworkerRunningServiceList();
    notfProvider.getNotificationBellIconCount(context);
    notificationServices.forGroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.isTokenExperied();
    WebSoketHelper.connectChannel(context);
    String? deviceToken = await notificationServices.getTokens();
    await notfProvider.sendDeviceToken(deviceToken, context);
    _requestPermissionsAndFetchLocation();
  }

  Future<void> _requestPermissionsAndFetchLocation() async {
    await notificationServices.requestForPermission();
    try {
      await mapProvider.initializeLocation(context);
    } catch (error) {
      debugPrint('Error determining position: $error');
      _showLocationSettingsDialog();
    }
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
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

  Future<bool> _onWillPopAlert() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: Row(
              children: [
                Icon(Icons.exit_to_app, color: Colors.green),
                const SizedBox(width: 10),
                const Text('Exit App', style: TextStyle(color: Colors.green)),
              ],
            ),
            content: const Text(
              'Do you really want to exit the app?',
              style: TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No', style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => SystemNavigator.pop(),
                child: const Text('Yes', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: _onWillPopAlert,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Consumer<MapProvider>(
                    builder: (context, mapProvider, child) {
                      // Check if userLocation is available
                      if (mapProvider.userLocation != null &&
                          mapProvider.mapController != null) {
                        // Move the camera to the user's location
                        mapProvider.mapController!.animateCamera(
                          CameraUpdate.newLatLngZoom(
                            mapProvider.userLocation!,
                            15, // Zoom level
                          ),
                        );
                      }
                      return mapProvider.userLocation == null
                          ? SizedBox.shrink()
                          : GoogleMap(
                              onMapCreated: (controller) {
                                mapProvider.setMapController(controller);
                              },
                              initialCameraPosition: CameraPosition(
                                target: mapProvider.orderLocation,
                                zoom: 14,
                              ),
                              markers: {
                                Marker(
                                  markerId: MarkerId('userLocation'),
                                  position: mapProvider.userLocation!,
                                  infoWindow:
                                      InfoWindow(title: 'Current Location'),
                                ),
                              },
                              circles: {
                                Circle(
                                  circleId: CircleId('circle_1'),
                                  center: mapProvider.userLocation!,
                                  radius: 300,
                                  // Radius in meters
                                  fillColor: Colors.blue.withOpacity(0.2),
                                  // Transparent fill color
                                  strokeColor: Colors.blue,
                                  // Circle border color
                                  strokeWidth: 3, // Border width
                                )
                              },
                            );
                    },
                  ),
                  const TopRow(),
                  DashboardBottomSheet(frrom: 'db'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}

class TopRow extends StatelessWidget {
  const TopRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
                                    borderRadius: BorderRadius.circular(20),
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
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      ShowNotificationScreen()));
                          // Navigator.push(context, CupertinoPageRoute(builder: (context) => MessagesScreen()));
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(width: .5, color: Colors.grey)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.message),
                        ),
                      ),
                      onTap: () async {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => AddScheduleScreen()));
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => MessagesScreen()));
                      },
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Consumer<OrderProvider>(
                      builder: (context, provider, _) => InkWell(
                        onTap: () {
                          provider.isLoading = true;
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      const RequestedServiceScreen()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              border:
                                  Border.all(color: Colors.grey, width: .5)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.receipt_long, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                'Open Orders',
                                style: GoogleFonts.inter(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  //Navigator.push(context, CupertinoPageRoute(builder: (context) => ShiftConfigration()));
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => NewScheduleScreen()));
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
                      CupertinoPageRoute(
                          builder: (context) => DashboardSupportScreen()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: .5, color: Colors.grey)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.help_outline_outlined,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
