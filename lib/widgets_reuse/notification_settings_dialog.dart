import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/models/notification_menu_model.dart';
import 'package:provider/provider.dart';

import '../provider/notification_provider.dart';
import 'custom_switch.dart';
import 'loading_indicator.dart';

class NotificationSettingsdialog extends StatefulWidget {
  const NotificationSettingsdialog({
    super.key,
    required this.showSms,
    required this.index,
    required this.dataModel,
  });

  final bool showSms;
  final int index;
  final NotificationMenuModel dataModel;

  @override
  _NotificationSettingsdialogState createState() =>
      _NotificationSettingsdialogState();
}

class _NotificationSettingsdialogState
    extends State<NotificationSettingsdialog> {
  // bool pushNotifications = true;
  // bool smsNotifications = false;

  String notificationStatus = "Y";
  String smsStatus = "Y";

  @override
  void initState() {
    super.initState();
    setState(() {
      notificationStatus = widget.dataModel.notificationStatus!;
      smsStatus = widget.dataModel.smsStatus!;
    });
  }

  @override
  Widget build(BuildContext context) {
    NotificationProvider np = context.watch<NotificationProvider>();
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom == 0
              ? 20
              : MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Text(widget.dataModel.title ?? '',
                style: interText(20, Colors.black, FontWeight.w600)),
            const SizedBox(height: 16),
            Text(
              widget.dataModel.description ?? '',
              style: interText(16, Colors.black, FontWeight.w400),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: Text('Push',
                  style: interText(16, Colors.black, FontWeight.w400)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              trailing: CustomSwitch(
                value: notificationStatus == "Y",
                activeColor: Colors.white,
                activeTrackColor: Colors.black,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: myColors.devider,
                onChanged: (bool value) {
                  // np.setPushPermision(widget.index, value);
                  setState(() {
                    notificationStatus = notificationStatus == "Y" ? "N" : "Y";
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
            widget.showSms
                ? Container(
                    height: 1,
                    color: AppColors.borderColor,
                  )
                : SizedBox.shrink(),
            SizedBox(height: 8),
            widget.showSms
                ? ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    title: Text('SMS',
                        style: interText(16, Colors.black, FontWeight.w300)),
                    trailing: CustomSwitch(
                      value: smsStatus == "Y",
                      activeColor: Colors.white,
                      activeTrackColor: Colors.black,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: AppColors.borderColor,
                      onChanged: (bool value) {
                        setState(() {
                          smsStatus = smsStatus == "Y" ? "N" : "Y";
                        });
                      },
                    ),
                  )
                : SizedBox.shrink(),
            //SizedBox(height: widget.showSms ? 12 : 0),
            // widget.showSms
            //     ? Text(
            //   'Toggle on to get Order Updates by text message. Message & data rates may apply.',
            //   style: interText(14, Color(0xFF636366), FontWeight.w400),
            // )
            //     : SizedBox.shrink(),
            // SizedBox(height: widget.showSms ? 36 : 0),
            Spacer(),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.dataModel.notificationStatus ==
                              notificationStatus &&
                          widget.dataModel.smsStatus == smsStatus
                      ? AppColors.borderColor
                      : AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () async {
                  Map<String, dynamic> data = {
                    "id": widget.dataModel.id,
                    "textId": widget.dataModel.textId,
                    "title": widget.dataModel.title,
                    "notificationStatus": notificationStatus,
                    "smsStatus": smsStatus,
                    "description": widget.dataModel.description
                  };
                  if (widget.dataModel.notificationStatus ==
                          notificationStatus &&
                      widget.dataModel.smsStatus == smsStatus) {
                    Navigator.pop(context);
                  } else {
                    await np
                        .updateNotificationStatus(data: data)
                        .then((status) {
                      if (status) {
                        np.replaceInStatusList(
                          np.notificationMenuList
                              .indexWhere((e) => e.id == data["id"]),
                          NotificationMenuModel.fromJson(data),
                        );
                        Navigator.pop(context);
                      }
                    });
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: np.isLoading ? 0 : 12,
                  ),
                  child: np.isLoading
                      ? SizedBox(
                          height: 48,
                          child: LoadingIndicatorWidget(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Done',
                          style: interText(16, Colors.white, FontWeight.w600),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
