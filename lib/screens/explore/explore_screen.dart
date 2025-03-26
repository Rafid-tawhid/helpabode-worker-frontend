import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:provider/provider.dart';
import '../../helper_functions/notification_helpers.dart';
import '../../helper_functions/user_helpers.dart';
import '../../misc/constants.dart';
import '../../provider/dashboard_provider.dart';
import '../../provider/notification_provider.dart';
import '../../provider/order_provider.dart';
import '../../web_soket.dart';
import '../../widgets_reuse/bottom_nav_bar.dart';
import '../dashboard/widgets/dashboard_bottom_sheet.dart';
import 'document_screen.dart';

class ExploreScreenDashboard extends StatefulWidget {
  const ExploreScreenDashboard({super.key});

  @override
  _ExploreScreenDashboardState createState() => _ExploreScreenDashboardState();
}

class _ExploreScreenDashboardState extends State<ExploreScreenDashboard> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  static const Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MyBottomNavBar(
        screenName: 'explore',
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                //here
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  circles: {
                    Circle(
                      circleId: const CircleId('currentLocationRadius'),
                      center:
                          const LatLng(37.42796133580664, -122.085749655962),
                      radius: 20,
                      fillColor: Colors.blue.withOpacity(0.3),
                      strokeWidth: 0,
                    ),
                  },
                  onMapCreated: (GoogleMapController controller) {},
                  markers: _markers,
                ),
                TopRowExplore(),

                DashboardBottomSheet(
                  // frrom: 'ex',
                  frrom: 'ex',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TopRowExplore extends StatefulWidget {
  const TopRowExplore({
    super.key,
  });

  @override
  State<TopRowExplore> createState() => _TopRowExploreState();
}

class _TopRowExploreState extends State<TopRowExplore> {
  bool showText = false;

  @override
  void initState() {
    super.initState();

    // Delay the showing of the text after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showText = true;
      });
    });
  }

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
                    InkWell(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                border:
                                    Border.all(width: .5, color: Colors.grey)),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.notifications_none),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        print('TOKEN : $token');
                      },
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
                        //  print('TOKEN : $token');
                      },
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Consumer<OrderProvider>(
                      builder: (context, provider, _) => InkWell(
                        onTap: () {},
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
                  // DashboardHelpers.checkForFirstLogin(context);
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
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DocumentScreen()));
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.info,
                  size: 24,
                  color: myColors.green,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'We have received your submission. Check the verification status',
                    style: interText(14, Color(0xff636366), FontWeight.w600)
                        .copyWith(letterSpacing: 0),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black54,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: showText ? 1.0 : 0.0,
                child: AnimatedLine()),
          ],
        ),
      ],
    );
  }
}

class AnimatedLine extends StatefulWidget {
  @override
  _AnimatedLineState createState() => _AnimatedLineState();
}

class _AnimatedLineState extends State<AnimatedLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late OrderProvider mapProvider;
  late NotificationProvider notfProvider;
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: 2), // Increased duration to 50 seconds
    );

    _animation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Using easeInOut curve for smoother animation
    ));

    //from dashboard
    final mapProvider = Provider.of<OrderProvider>(context, listen: false);
    notfProvider = Provider.of<NotificationProvider>(context, listen: false);

    //get user intransit or start job data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false)
          .getworkerRunningServiceList();
    });
    WebSoketHelper.connectChannel(context);
    Provider.of<NotificationProvider>(context, listen: false)
        .getNotificationBellIconCount(context);
    notificationServices.forGroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.isTokenExperied();
    notificationServices.getTokens().then((value) {
      print('DEVICE TOKEN ${value}');
      notfProvider.sendDeviceToken(value, context);
    });
    //Get user notificationServices
    //get all faqs
    var provider = Provider.of<DashboardProvider>(context, listen: false);
    provider.getAllFaqs();

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return _controller.isAnimating
            ? Consumer<UserProvider>(
                builder: (context, provider, _) => Stack(
                  children: [
                    if (provider.userModel.employeeType !=
                        UserHelpers.empTypeUnderProvider)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: CustomPaint(
                              size: const Size(20, 10),
                              painter: ReversedTrianglePainter(),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 16, bottom: 16),
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset('assets/svg/docs.svg'),
                                    const SizedBox(
                                      width: 32,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              'Check your submitted documents',
                                              style: interText(14, Colors.white,
                                                  FontWeight.w500),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DocumentScreen()));
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6,
                                                      horizontal: 12),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.white,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'See Documents',
                                                    style: interText(
                                                        12,
                                                        Colors.black,
                                                        FontWeight
                                                            .w500), // Black text color
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                // Animated Divider
                                Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6)),
                                  child: LinearProgressIndicator(
                                    value: 1.0 - _animation.value,
                                    backgroundColor: Colors.transparent,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        myColors
                                            .primaryColor), // Change to your desired color
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              )
            : SizedBox(); // If animation is finished, return an empty SizedBox
      },
    );
  }
}

class ReversedTrianglePainter extends CustomPainter {
  Color? color;
  ReversedTrianglePainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (color == null ? Colors.black : color)!
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = (color == null ? Colors.black : color)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.0;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
