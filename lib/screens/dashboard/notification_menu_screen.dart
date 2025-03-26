import 'dart:io';

import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:provider/provider.dart';

import '../../provider/notification_provider.dart';
import '../../widgets_reuse/notification_settings_dialog.dart';

class NotificationMenuScreent extends StatefulWidget {
  const NotificationMenuScreent({super.key});

  @override
  State<NotificationMenuScreent> createState() =>
      _NotificationMenuScreentState();
}

class _NotificationMenuScreentState extends State<NotificationMenuScreent> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    NotificationProvider np = context.read<NotificationProvider>();
    Future.microtask(() async {
      np.notificationMenuList.isEmpty ? await np.getNotificationMenu() : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ensure to call this method only once in initState for performance.

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Expanded(
                child: Consumer<NotificationProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      // Show loading spinner if data is still being fetched
                      return Center(
                          child: CircularProgressIndicator(
                        color: myColors.green,
                      ));
                    }

                    if (provider.notificationMenuList.isEmpty) {
                      // Handle case where there are no notifications
                      return Center(child: Text('No notifications available.'));
                    }

                    // Display the notifications
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: ListView.builder(
                        itemCount: provider.notificationMenuList.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => NotificationTile(
                          title:
                              provider.notificationMenuList[index].title ?? '',
                          subTitle:
                              '${provider.notificationMenuList[index].notificationStatus == "Y" ? "On" : "Off"}: Push ${index == 0 ? '; ${provider.notificationMenuList[index].smsStatus == "Y" ? "On" : "Off"}: SMS' : ''}',
                          onPressed: () {
                            DashboardHelpers.showBottomDialog(
                              height: index == 0
                                  ? Platform.isIOS
                                      ? 420
                                      : 410
                                  : Platform.isIOS
                                      ? 320
                                      : 300,
                              context: context,
                              child: NotificationSettingsdialog(
                                dataModel: provider.notificationMenuList[index],
                                showSms: index == 0 ? true : false,
                                index: index,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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

// Expanded(
//   child: Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 12.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         SizedBox(
//           height: 10,
//         ),
//         Text(
//           'Notifications',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontFamily: 'Inter',
//             fontWeight: FontWeight.w700,
//             height: 0,
//           ),
//         ),
//         SizedBox(
//           height: 10,
//         ),
//
//
//       ],
//     ),
//   ),
// )
