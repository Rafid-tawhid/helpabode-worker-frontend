import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSoketHelper {
  static void connectChannel(BuildContext context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? groupId = sp.getString('workerInAppNotificationTextId');
    //debugPrint("-----------WS-------ws://${AppConstant.wsBaseUrl}ws/notifications/${Provider.of<AuthProvider>(context, listen: false).userGroupTextId}/?token=${token ?? ''}");
    WebSocketChannel? channel;
    try {
      channel = WebSocketChannel.connect(Uri.parse(
          'ws://team.dev.helpabode.com:54292/ws/notifications/${groupId}/?token=${token}'));
      debugPrint('Final');
      debugPrint(
          'ws://team.dev.helpabode.com:54292/ws/notifications/${groupId}/?token=${token}');
      debugPrint("------websocket connection success -----------");
      channel.stream.listen(
        (message) {
          debugPrint(
              "Hello minhaz. Websocket Response is: ${jsonDecode(message)}");
          var response = jsonDecode(message);
          // NotificationModel model=NotificationModel.fromJson(jsonDecode(message));
          DashboardHelpers.activitiesAfterGettingTheSoketResponse(
              response, context);
        },
        onDone: () {
          debugPrint('WebSocket connection closed');
        },
        onError: (error) {
          debugPrint('WebSocket error: $error');
        },
      );
    } catch (e) {
      debugPrint("------websocket connection error -----------: $e");
    }
  }
}
