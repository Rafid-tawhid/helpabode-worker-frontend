import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'auth/auth_screen.dart';
import 'corporate/individual_team/dashboard_individual_team_member.dart';
import 'helper_functions/dashboard_helpers.dart';
import 'helper_functions/signin_signup_helpers.dart';
import 'helper_functions/user_helpers.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({super.key});

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _controller;
  // late Animation<double> _animation;
  late UserProvider provider;

  @override
  void initState() {
    Future.delayed(
        const Duration(
          milliseconds: 1000,
        ), () {
      funcHiveToken();
    });

    provider = Provider.of(context, listen: false);
    super.initState();
  }

  funcHiveToken() async {
    SignInSignUpHelpers signInSignUpHelpers = SignInSignUpHelpers();
    textId = await signInSignUpHelpers.getString("textId");
    token = await signInSignUpHelpers.getString("token");
    status = await signInSignUpHelpers.getString("status");
    franchiseTextId = await signInSignUpHelpers.getString("franchiseTextId");
    employeeType = await signInSignUpHelpers.getString("employeeType");
    rating = await signInSignUpHelpers.getString("average_rating");
    debugPrint('TEXT ID: ${textId}');
    debugPrint('TOKEN: ${token}');
    debugPrint('STATUS: ${status}');
    if (token != null && status == 'Verified') {
      //set user info
      await DashboardHelpers.setUserInfo();
      provider.getUserFromProvider();
      //get employee type
      String? empType = await UserHelpers.getLoginUserEmployeeStatus();
      if (empType == UserHelpers.empTypeUnderProvider) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardIndividualTeamMember()));
      } else if (empType == UserHelpers.empTypeCorporate) {
        context.pushNamed('dashboard');
        // Navigator.push(context, MaterialPageRoute(builder: (context) => RoadLiveLocationTrackingScreen()));
      } else {
        context.pushNamed('dashboard');
        // Navigator.push(context, MaterialPageRoute(builder: (context) => RoadLiveLocationTrackingScreen()));
      }
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
      // context.pushNamed('home');
    }
  }

  @override
  Widget build(BuildContext context) {
    CurrentDevice.setContext(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.grey, width: .5),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey, // Shadow color
                    offset: Offset(0, 2), // Horizontal and vertical offset
                    blurRadius: 1, // Spread or blur radius
                    spreadRadius:
                        0, // Negative value reduces the size of the shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  'assets/png/logos.png',
                  height: 180,
                  width: 180,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(
              color: myColors.green,
            )

            //linear animation may use later

            // AnimatedBuilder(
            //   animation: _animation,
            //   builder: (context, child) {
            //     return Container(
            //       width: 200,
            //       height: 10,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(6), // Adjust the radius as needed
            //         color: Colors.grey[300], // Background color
            //       ),
            //       child: ClipRRect(
            //         borderRadius: BorderRadius.circular(6), // Same radius as the container
            //         child: LinearProgressIndicator(
            //           value: _animation.value,
            //           backgroundColor: Colors.transparent, // Transparent background
            //           valueColor: AlwaysStoppedAnimation<Color>(Colors.green), // Progress color
            //         ),
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
