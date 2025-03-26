import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../helper_functions/notification_helpers.dart';
import '../../helper_functions/signin_signup_helpers.dart';
import '../../misc/constants.dart';
import '../../provider/notification_provider.dart';
import '../explore/explore_screen.dart';

class PendingRegistrationProcess extends StatefulWidget {
  static const String routeName = 'profile_pending';
  const PendingRegistrationProcess({super.key});

  @override
  State<PendingRegistrationProcess> createState() =>
      _PendingRegistrationProcessState();
}

class _PendingRegistrationProcessState
    extends State<PendingRegistrationProcess> {
  NotificationServices notificationServices = NotificationServices();
  late NotificationProvider notfProvider;

  @override
  void initState() {
    notfProvider = Provider.of<NotificationProvider>(context, listen: false);
    notificationServices.forGroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.isTokenExperied();
    notificationServices.getTokens().then((value) {
      print('DEVICE TOKEN ${value}');
      notfProvider.sendDeviceToken(value, context);
    });
    callNotifPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/png/pending_bg.png'), // Replace with your image asset
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/svg/click.svg'),
              SizedBox(
                height: 30.h,
              ),
              const SizedBox(
                  child: Text(
                'We have received your application',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              )),
              SizedBox(
                height: 20,
              ),
              const Flexible(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('You are currently in the '),
                  Text(
                    'verification process, ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text.rich(
                    TextSpan(
                      text:
                          'Please wait until the process is complete. We will notify or confirm you via email at ',
                      style: TextStyle(color: Colors.black), // Base style
                      children: [
                        TextSpan(
                          text: DashboardHelpers.userModel != null
                              ? DashboardHelpers.userModel!.email
                              : 'xyz@gmail.com',
                          style: TextStyle(
                              fontWeight: FontWeight.bold), // Bold for email
                        ),
                        TextSpan(
                          text: ' and the mobile number ',
                        ),
                        TextSpan(
                          text: DashboardHelpers.userModel != null
                              ? DashboardHelpers.userModel!.phone
                              : 'XXXXXXXXXX',
                          style: TextStyle(
                              fontWeight: FontWeight.bold), // Bold for phone
                        ),
                        TextSpan(
                          text: ' that you provided.',
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Flexible(
                  child: Text('If you have any query, please visit our')),
              GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse('https://helpabode.com');
                  if (!await launchUrl(url,
                      mode: LaunchMode.externalApplication)) {
                    debugPrint('Could not launch $url');
                  }
                },
                child: const Text(
                  'Help Center',
                  style: TextStyle(
                    color: Colors.green,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: MaterialButton(
                      onPressed: () {
                        //clear photo id screen
                        SignInSignUpHelpers.clearImage();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ExploreScreenDashboard()));
                        debugPrint('USER TOKEN ${token}');
                        var provider =
                            Provider.of<UserProvider>(context, listen: false);
                        debugPrint(
                            'Team USER INFO ${provider.teamUserModel.toJson()}');
                        debugPrint(
                            'Normal USER INFO ${provider.userModel.toJson()}');
                      },
                      // padding: EdgeInsets.fromLTRB(10.w, 5.w, 10.w, 5.w),
                      // padding: EdgeInsets.fromLTRB(52.w, 13.w, 52.w, 13.w),
                      // padding: padding,
                      color: myColors.green,
                      minWidth: double.infinity,
                      height: 50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.w),
                      ),
                      child: const Text(
                        'Explore app',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void callNotifPermission() async {
    await notificationServices.requestForPermission();
  }
}
