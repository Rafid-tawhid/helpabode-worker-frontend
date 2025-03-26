import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/custom_appbar.dart';

class NotificationMenuScreent extends StatelessWidget {
  const NotificationMenuScreent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(label: ''),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  NotificationTile(
                      title: 'Order Updates',
                      subTitle: 'On: Push; Off: SMS',
                      onPressed: () {
                        print('object');
                      }),
                  NotificationTile(
                      title: 'Service Offers',
                      subTitle: 'On: Push; Off: SMS',
                      onPressed: () {
                        print('object');
                      }),
                  NotificationTile(
                      title: 'Help Abode Offers',
                      subTitle: 'On: Push; Off: SMS',
                      onPressed: () {
                        print('object');
                      }),
                  NotificationTile(
                      title: 'Recommendations',
                      subTitle: 'On: Push; Off: SMS',
                      onPressed: () {
                        print('object');
                      }),
                  NotificationTile(
                      title: 'Reminders',
                      subTitle: 'On: Push; Off: SMS',
                      onPressed: () {
                        print('object');
                      }),
                  NotificationTile(
                      title: 'Product Updates & News',
                      subTitle: 'On: Push; Off: SMS',
                      onPressed: () {
                        print('object');
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  String title;
  String subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          InkWell(
            onTap: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 36,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subTitle,
                              style: TextStyle(
                                color: Color(0xFF535151),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
              ],
            ),
          ),
          Container(
            height: 2,
            margin: EdgeInsets.only(top: 10),
            color: myColors.devider,
          )
        ],
      ),
    );
  }

  NotificationTile(
      {required this.title, required this.subTitle, required this.onPressed});
}
