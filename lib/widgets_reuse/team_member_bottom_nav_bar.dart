import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';

import 'package:provider/provider.dart';

import '../provider/navbar_provider.dart';

var iconListTeam = [
  'images/nav1.svg',
  'assets/svg/acc.svg',
  'images/court_house.svg',
];
var nameListTeam = ['Home', 'Account', 'Support'];

class MyBottomNavBarTeam extends StatelessWidget {
  const MyBottomNavBarTeam({
    super.key,
    this.screenName,
    this.isHomePage,
  });
  final bool? isHomePage;
  final String? screenName;

  @override
  Widget build(BuildContext context) {
    var tp = context.watch<TabControllerProvider>();
    return AnimatedBottomNavigationBar.builder(
      activeIndex: tp.currentIndexTeam,
      gapWidth: 0,
      backgroundColor: Colors.white,
      borderColor: Color(0xFFD9D9D9),
      borderWidth: 1,
      height: 64,
      shadow: BoxShadow(
        color: Color(0x0C11111A),
        blurRadius: 32,
        offset: Offset(0, 8),
        spreadRadius: 0,
      ),
      // activeColor: Colors.red,
      onTap: (index) async {
        tp.controlMemberTab(index, context);
      },
      itemCount: iconListTeam.length,
      tabBuilder: (int index, bool isActive) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconListTeam[index],
              height: 24,
              width: 24,
              colorFilter: index != 0
                  ? ColorFilter.mode(
                      isActive ? myColors.green : Colors.black, BlendMode.srcIn)
                  : null,
            ),
            Text(
              nameListTeam[index],
              style: TextStyle(
                  color: isActive ? myColors.green : Colors.black,
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal),
            ),
          ],
        );
      },
    );
  }
}
