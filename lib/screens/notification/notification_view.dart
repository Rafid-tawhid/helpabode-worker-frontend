import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/auth/helper.dart';
import 'package:help_abode_worker_app_ver_2/chat/chat_provider.dart';
import 'package:help_abode_worker_app_ver_2/chat/views/chat_screen.dart';
import 'package:help_abode_worker_app_ver_2/provider/notification_provider.dart';
import 'package:help_abode_worker_app_ver_2/screens/notification/show_notification_screen.dart';
import 'package:provider/provider.dart';

import '../../helper_functions/colors.dart';
import '../../helper_functions/dashboard_helpers.dart';
import '../../misc/constants.dart';
import '../../models/notification_model.dart';

class NotificationView extends StatelessWidget {
  final NotificationModel notificationModel;

  const NotificationView({super.key, required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    debugPrint('notificationModel ${notificationModel.notificationSendStage}');

    return SizedBox(
      child: NotificationWidget(
          notificationStage: notificationModel.notificationSendStage ?? '',
          notificationModel: notificationModel),
    );
  }
}

class NotificationWidget extends StatelessWidget {
  final String notificationStage;
  final NotificationModel notificationModel;

  const NotificationWidget({
    Key? key,
    required this.notificationStage,
    required this.notificationModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (notificationStage) {
      case 'OrderPlace':
        content = OrderReceivedWidget(notificationModel: notificationModel);
        break;
      case 'reviewRatingsFrom':
        content = OrderRatingWidget(notificationModel: notificationModel);
        break;
      case 'InTransit':
        content = OrderStatusWidget(notificationModel: notificationModel);
      case 'JobStarted':
        content = OrderStatusWidget(notificationModel: notificationModel);
      case 'OrderCompleted':
        content = OrderStatusWidget(notificationModel: notificationModel);
      default:
        content = InkWell(
          onTap: notificationModel.isSeen! == "N"
              ? () async {
                  debugPrint(notificationModel.messages ?? '');
                  var provider = context.read<NotificationProvider>();
                  provider
                      .sendNotificationSeen(notificationModel.id.toString());
                  provider.updateNotificationSeen(data: notificationModel);
                  if (notificationStage == 'serviceOrderChat') {
                    debugPrint(notificationModel.messages ?? '');
                    var notifInfo = notificationModel.optionJson;
                    var cp = context.read<ChatProvider>();
                    if (await cp
                        .getChat(notifInfo['endUserOrderTimeId'].toString())) {
                      Helper.toScreen(
                          context,
                          ChatScreen(
                              receiverName: notifInfo['senderName'],
                              receiverTextId: notifInfo['senderTextId'],
                              groupTextId: notifInfo['groupName'],
                              workerId: notifInfo['receiverTextId'],
                              orderTimeId:
                                  notifInfo['endUserOrderTimeId'].toString(),
                              orderTextId: notifInfo['endUserOrderTextId']));
                    }
                  }
                }
              : () {
                  debugPrint(notificationModel.messages ?? '');
                },
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: notificationModel.isSeen! == "N"
                    ? Colors.white60
                    : Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.notifications,
                      color: notificationModel.isSeen! == "N"
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notificationModel.title ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: notificationModel.isSeen! == "N"
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                          Text(
                            notificationModel.messages
                                    ?.replaceAll("’", "'")
                                    .replaceAll("‘", "'") ??
                                '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: notificationModel.isSeen! == "N"
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              DashboardHelpers.convertDateTime(
                                  notificationModel.created ?? '',
                                  pattern: 'd MMM, HH:mm:aa'),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
    }
    return SizedBox(child: content);
  }
}
