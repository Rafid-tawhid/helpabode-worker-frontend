import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/signin_signup_helpers.dart';
import 'package:http/http.dart';

import '../helper_functions/api_services.dart';
import '../helper_functions/dashboard_helpers.dart';
import '../misc/constants.dart';
import '../models/notification_menu_model.dart';
import '../models/notification_model.dart';
import '../models/zon_zip_array.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notificationList = [];
  List<NotificationModel> get notificationList => _notificationList;
  List<NotificationMenuModel> notificationMenuList = [];
  bool pushSelection = false;
  bool smsValue = false;
  bool isLoading = false;
  var notificationCount = '0';

  Future<void> getAllNotification() async {
    print("getAllNotification is calling.....");
    setLoading(true);
    ApiService apiService = ApiService();
    var response = await apiService
        .getData("api/getAllNotification/?page=$page&per_page=$perPageCount");

    if (response != null) {
      for (Map i in response['notificationArray']) {
        _notificationList.add(NotificationModel.fromJson(i));
        notifyListeners();
      }
    } else {
      print("Error");
      _page = _page - 1;
    }

    setLoading(false);
  }

  bool _paginationLoading = false;
  bool get paginationLoading => _paginationLoading;
  bool _isLoadingPagination = false;
  bool get isLoadingPagination => _isLoadingPagination;
  int _perPageCount = 10;
  int get perPageCount => _perPageCount;

  setLoading(bool status) {
    if (page == 1) {
      _isLoadingPagination = status;
    } else {
      _paginationLoading = status;
    }
    notifyListeners();
  }

  int _page = 1;
  int get page => _page;

  Future setPage() async {
    _page += 1;
    notifyListeners();
    return null;
  }

  resetPage() {
    _page = 1;
    notifyListeners();
  }

  clearNotifications() {
    _notificationList.clear();
    notifyListeners();
  }

  Future<bool> sendDeviceToken(String deviceToken, BuildContext context) async {
    print('sendDeviceToken is calling...');
    //
    // String udid = '';
    // final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    // if (Platform.isAndroid) {
    //   AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    //   udid = androidInfo.id; // Android ID
    // } else if (Platform.isIOS) {
    //   IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
    //   udid = iosInfo.identifierForVendor.toString(); // Vendor ID for iOS
    // }

    try {
      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };
      dynamic data = {
        "deviceToken": deviceToken,
        "deviceType": Platform.isAndroid ? 'Android' : 'IOS',
        "accountTextId": textId,
        "accountType": "Provider"
      };
      print('SEND Device Token ${data}');

      Response response = await post(Uri.parse("${urlBase}api/sendDeviceToken"),
          headers: header, body: jsonEncode(data));
      var responseDecodeJson = jsonDecode(response.body);

      print('RESPONSE BODY: ${responseDecodeJson.toString()}');

      if (response.statusCode == 201) {
        // print('SUCCESS responseDecodeJson ${responseDecodeJson.toString()}');
        //get all saved value after saving
        return true;
      } else {
        return false;
      }

      return true;
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'Something Went Wrong');
      print("catch");
      print(e);
      return false;
    }
  }

  Future<bool> sendNotificationSeen(String id) async {
    print('send notification is calling...');

    try {
      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };
      dynamic data = {
        "id": id,
        "textId": textId,
        "type": "Provider",
      };
      print('SEND BODY ${data}');

      Response response = await post(
          Uri.parse("${urlBase}api/notificationSeen/"),
          headers: header,
          body: jsonEncode(data));
      // var responseDecodeJson = jsonDecode(response.body);
      if (response.statusCode == 201) {
        // notificationList.clear();
        // for (Map i in responseDecodeJson['notificationArray']) {
        //   notificationList.add(NotificationModel.fromJson(i));
        // }
        // print('update notificationList ${notificationList.length}');
        // notifyListeners();

        return true;
      } else {
        //DashboardHelpers.showAlert(msg: 'Something Went Wrong');

        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  setPushNotfication(bool val) {
    pushSelection = val;
    notifyListeners();
  }

  void setSMS(bool value) {
    smsValue = value;
    notifyListeners();
  }

  List<ZonZipArray> _zoneZipList = [];
  List<ZonZipArray> get zoneZipArrayList => _zoneZipList;
  List<String> _zipList = [];
  List<String> get zipList => _zipList;
  List<String> _zoneList = [];
  List<String> get zoneList => _zoneList;

  Future<void> getNotificationBellIconCount(BuildContext context) async {
    print("getNotificationBellIconCount is calling..... ${token}");

    ApiService apiService = ApiService();
    var data = await apiService.getData('api/$textId/notificationBellCount');
    if (data != null) {
      notificationCount = data['notificationCount'].toString();
      _zoneZipList.clear();
      zipList.clear();
      zoneList.clear();
      for (var i in data['zone_zip_array']) {
        _zoneZipList.add(ZonZipArray.fromJson(i));
      }
      _zoneZipList.forEach((e) {
        zoneList.add(e.zoneTitle ?? '');
        e.zipArray!.forEach((a) {
          _zipList.add(a);
        });
      });
      debugPrint('_zoneZipList ${_zoneZipList.length}');
      debugPrint('_zipList ${_zipList.length}');
      debugPrint('_zoneList ${_zoneList.length}');
      notifyListeners();
    } else {
      SignInSignUpHelpers signInSignUpHelpers = SignInSignUpHelpers();
      signInSignUpHelpers.remove("user");
      signInSignUpHelpers.remove("address");
      signInSignUpHelpers.remove("status");
      context.pushReplacementNamed('home');
    }
  }

  Future<void> getNotificationMenu() async {
    ApiService apiService = ApiService();

    // Set loading to true before making the API call
    isLoadingServices(true);

    try {
      notificationMenuList.clear();
      var data = await apiService.getData('api/notification-stage/');

      // Populate the notification list
      for (Map i in data['data']) {
        notificationMenuList.add(NotificationMenuModel.fromJson(i));
      }

      debugPrint('notificationMenuList ${notificationMenuList.length}');
    } catch (e) {
      // Handle the error accordingly
      debugPrint('Error fetching notifications: $e');
    } finally {
      // Set loading to false once the data is fetched
      isLoadingServices(false);
    }
  }

  // bool _updateLoading = false;
  // bool get updateLoading => _updateLoading;
  // setUpdateLoading(bool status) {
  //   _updateLoading = status;
  //   notifyListeners();
  // }

  void isLoadingServices(bool bool) {
    isLoading = bool;
    notifyListeners();
  }

  replaceInStatusList(int index, NotificationMenuModel value) {
    notificationMenuList[index] = value;
    notifyListeners();
  }

  Future<bool> updateNotificationStatus(
      {required Map<String, dynamic> data}) async {
    ApiService apiService = ApiService();

    // Set loading to true before making the API call
    isLoadingServices(true);

    try {
      var response =
          await apiService.putData('api/update-notification-stage', data);
      debugPrint('response ${response}');

      return true;
    } catch (e) {
      // Handle the error accordingly
      debugPrint('Error fetching notifications: $e');
      return false;
    } finally {
      // Set loading to false once the data is fetched
      isLoadingServices(false);
    }
  }

  void updateNotificationSeen({required NotificationModel data}) {
    _notificationList.forEach((e) {
      if (e.id == data.id) {
        e.setIsSeen = 'Y';
      }
    });

    notifyListeners();
  }

  void setnotification(String i) {
    notificationCount = i;
    notifyListeners();
  }
}
