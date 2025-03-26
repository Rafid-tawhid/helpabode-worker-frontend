import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/user_helpers.dart';
import 'package:help_abode_worker_app_ver_2/provider/notification_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/models/pricing_attribute_model_new.dart';
import 'package:help_abode_worker_app_ver_2/models/user_model.dart';
import 'package:help_abode_worker_app_ver_2/widgets_reuse/service_info_bottom_sheet.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../corporate/individual_team/review_team_members_submitted_documents.dart';
import '../corporate/verified_member_details.dart';
import '../misc/constants.dart';
import '../models/notification_model.dart';
import '../models/pending_requested_servicelist.dart';
import '../provider/corporate_provider.dart';
import '../provider/user_provider.dart';
import '../screens/open_order/widgets/congratulations_order.dart';
import '../widgets_reuse/congratulations_alert.dart';
import '../widgets_reuse/custom_snackbar_message.dart';

class DashboardHelpers {
  static UserModel? userModel;
  static String? selectedId;
  static String? idNo;
  static String? expDate;
  static List<String> selectedWorkListName = [];
  static AnimationController? localAnimationController;
  static String profileImageUrl = '';

  static bool pemissionHandler(String empType) {
    if (empType == UserHelpers.empTypeCorporate) {
      return true;
    } else {
      return false;
    }
  }

  static void showAlert({required String msg}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black.withOpacity(.5),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static Future<UserModel> setUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.get('user');
    debugPrint('FETCH USER DATA ${data}');
    return userModel = UserModel.fromJson(jsonDecode(data.toString()));
  }

  static Future<String> getString(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(key) ?? '';
  }

  static Future<void> setString(String key, String val) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, val);
  }

  static void setIdInformation(String type, String idNum, String date) {
    selectedId = type;
    idNo = idNum;
    expDate = date;
  }

  static Future<void> successStopAnimation(
      RoundedLoadingButtonController btnController) async {
    await Future.delayed(Duration(milliseconds: 300));
    btnController.success();
    await Future.delayed(Duration(milliseconds: 500));
    btnController.reset();
    return;
  }

  static Future<void> errorStopAnimation(
      RoundedLoadingButtonController btnController) async {
    await Future.delayed(Duration(milliseconds: 500));
    btnController.error();
    await Future.delayed(Duration(milliseconds: 500));
    btnController.reset();
    return;
  }

  static void showCustomErrorTopAlert(BuildContext context, String msg) {
    showCustomSnackBar(
      context,
      msg,
      Colors.red,
      snackBarNeutralTextStyle,
      localAnimationController,
    );
  }

  static void setSelectedWorkName(String key) {
    selectedWorkListName.add(key);
  }

  static String convertDateTime(String dateTimeString, {String? pattern}) {
    // Parse the original date-time string into a DateTime object
    DateTime originalDateTime = DateTime.parse(dateTimeString);

    // Create a DateFormat object for the desired format
    DateFormat desiredFormat =
        DateFormat(pattern == null ? 'd MMM yyyy HH:mm:aa' : pattern);

    // Format the date according to the desired format
    String formattedDate = desiredFormat.format(originalDateTime);

    // Return the formatted date
    return formattedDate;
  }

  static String convertDateTime2(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd-MM-yyyy').format(date);
  }

  static Duration? calculateTimeDifference(String startTime, String endTime) {
    // Parse start and end times
    try {
      DateTime start = _parseTime(startTime);
      DateTime end = _parseTime(endTime);
      Duration difference = end.difference(start);

      return difference;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> selectExpiryDate(BuildContext context) async {
    final completer = Completer<String?>();
    DateTime today = DateTime.now();
    DateTime selectedDate = today;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 360,
          color: Colors.white,
          child: Column(
            children: [
              // Cancel and Done buttons
              Container(
                height: 50,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text(
                        'Cancel',
                        style: interText(14, Colors.black, FontWeight.bold),
                      ),
                      onPressed: () {
                        completer
                            .complete(null); // Complete with null if canceled
                        Navigator.of(context).pop(); // Close the bottom sheet
                      },
                    ),
                    CupertinoButton(
                      child: Text('Done',
                          style:
                              interText(14, myColors.green, FontWeight.bold)),
                      onPressed: () {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(selectedDate);
                        completer.complete(
                            formattedDate); // Complete with selected date
                        Navigator.of(context).pop(); // Close the bottom sheet
                      },
                    ),
                  ],
                ),
              ),
              // CupertinoDatePicker
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: today,
                  // minimumDate: today,
                  // maximumDate: DateTime(today.year + 10),
                  onDateTimeChanged: (DateTime date) {
                    selectedDate = date;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    // Wait for the Completer to complete with the selected date or null
    return completer.future;
  }

  static DateTime _parseTime(String time) {
    // Split the time string into hours, minutes, and AM/PM
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1].substring(0, 2));
    String period = parts[1].substring(3).trim();

    // Convert 12-hour format to 24-hour format
    if (period == 'PM' && hours != 12) {
      hours += 12;
    } else if (period == 'AM' && hours == 12) {
      hours = 0;
    }

    // Return a DateTime object representing the time
    return DateTime(0, 1, 1, hours, minutes);
  }

  static String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;

    String formattedDuration = '';
    if (hours > 0) {
      formattedDuration += '$hours hr ';
    }
    if (minutes > 0) {
      formattedDuration += '$minutes min';
    }

    return formattedDuration.trim();
  }

  static String formatDate(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    String formattedDate = DateFormat.MMMMEEEEd().format(date);
    return formattedDate;
  }

  static String addMinutesToTime(String timeString, int minutesToAdd) {
    // Split the time string into hours and minutes components
    List<String> components = timeString.split(':');
    int hours = int.parse(components[0]);
    int minutes = int.parse(components[1]);

    // Add the specified minutes
    minutes += minutesToAdd;

    // Handle overflow if minutes exceed 59
    hours += minutes ~/ 60;
    minutes %= 60;

    // Format the time components back into a string
    String newTimeString =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

    return newTimeString;
  }

  static Future<void> checkForFirstLogin(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CongratulationsDialog();
      },
    );
  }

  // static void openMap(latitude, longitude) async {
  //   String url;
  //
  //   if (Platform.isIOS) {
  //     url = 'http://maps.apple.com/?ll=$latitude,$longitude';
  //   } else {
  //     url = 'geo:$latitude,$longitude';
  //   }
  //
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not open the map.';
  //   }
  // }

  static Future<void> openMap(latitude, longitude) async {
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final appleMapsUrl = 'https://maps.apple.com/?q=$latitude,$longitude';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else if (await canLaunch(appleMapsUrl)) {
      await launch(appleMapsUrl);
    } else {
      throw 'Could not launch map URL';
    }
  }

  static Future<void> openUrl(String urlString) async {
    if (!await launchUrl(Uri.parse(urlString))) {
      throw Exception('Could not launch $urlString');
    }
  }

  static bool isKeyboardOpen(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  static String getFirstCharacterCombinationName(
      String firstName, String? lastName) {
    if (lastName == null) {
      if (firstName.contains(' ')) {
        List<String> nameParts = firstName.split(' ');
        if (nameParts.length > 1) {
          return nameParts[0][0].toUpperCase() + nameParts[1][0].toUpperCase();
        }
      }
      return firstName[0].toUpperCase();
    }
    return firstName[0].toUpperCase() + lastName[0].toUpperCase();
  }

  static String truncateString(String text, int length) {
    if (text.length <= length) {
      return text;
    } else {
      return text.substring(0, length) + "..";
    }
  }

  static String getFistAndLastNmaeByFullName(String fullname) {
    // Split the full name by spaces
    List<String> names = fullname.split(' ');

    // Take the first letter of each part of the name
    String initials = names.map((name) => name[0]).join();

    // Return the initials in uppercase
    return initials.toUpperCase();
  }

  static String formmatDate2(String dateString) {
    try {
      // Parse the input string to a DateTime object
      DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(dateString);

      // Format the DateTime object to the desired format
      String formattedDate = DateFormat('MM-dd-yyyy').format(parsedDate);

      return formattedDate;
    } catch (e) {
      // If parsing fails, return today's date in the desired format
      DateTime today = DateTime.now();
      return DateFormat('MM-dd-yyyy').format(today);
    }
  }

  static String formatDate3(String dateString) {
    try {
      // Parse the input string to a DateTime object
      DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(dateString);

      // Format the DateTime object to the desired format
      String formattedDate = DateFormat('d-MMMM-yyyy').format(parsedDate);

      return formattedDate;
    } catch (e) {
      // If parsing fails, return today's date in the desired format
      DateTime today = DateTime.now();
      return DateFormat('d-MMMM-yyyy').format(today);
    }
  }

  static void launchDialer(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static String convertDecimalToHoursMinutes(double? decimalHours) {
    if (decimalHours == null || decimalHours.isNaN || decimalHours < 0) {
      return '00hr 00min';
    }

    int hours = decimalHours.floor(); // Get the integer part as hours
    int minutes = ((decimalHours - hours) * 60)
        .round(); // Convert the decimal part to minutes

    return '${hours}hr ${minutes}min';
  }

  static void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    showAlert(msg: 'Copied!');
  }

  static void showAnimatedDialog(
      BuildContext context, String message, String? title) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withOpacity(0.5),
      // Background dimming
      transitionDuration: Duration(milliseconds: 200),
      // Animation duration
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Alert Title
                  Text(
                    textAlign: TextAlign.center,
                    'Your documents have some issues',
                    style: interText(22, Colors.black, FontWeight.w700),
                  ),
                  SizedBox(height: 24),
                  Text(
                    textAlign: TextAlign.left,
                    title ?? 'Instructions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: myColors.green,
                    ),
                  ),
                  SizedBox(height: 12),
                  // Alert Content
                  Text(message,
                      textAlign: TextAlign.left,
                      style: interText(14, myColors.greyTxt, FontWeight.w500)),
                  SizedBox(height: 20),
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xffe9e9e9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          FocusScope.of(context).unfocus();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          child: Text(
                            'Close',
                            style: interText(16, Colors.black, FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: child,
          ),
        );
      },
    );
  }

  static showCustomAnimatedDialog(
      {required BuildContext context, required Widget child, double? height}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withOpacity(0.5),
      // Background dimming
      transitionDuration: Duration(milliseconds: 200),
      // Animation duration
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: height == null
                ? height
                : MediaQuery.of(context).size.height / 1.8,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Material(
              type: MaterialType.transparency,
              child: child,
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: child,
          ),
        );
      },
    );
  }

  static Future<dynamic> showBottomDialog(
      {required BuildContext context,
      bool? dragable,
      bool? dismissible,
      double? height,
      required Widget child}) {
    return showModalBottomSheet(
      context: context,
      enableDrag: dragable ?? true,
      isScrollControlled: true,
      isDismissible: dismissible ?? true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      constraints: BoxConstraints(
        minHeight: height != null ? height : 300,
        maxHeight: height ?? 360,
      ),
      builder: (BuildContext context) => child,
    );
  }

  static String timeAgo(String dateTimeString) {
    DateTime inputDate = DateTime.parse(dateTimeString);
    DateTime currentDate = DateTime.now();

    Duration difference = currentDate.difference(inputDate);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} sec ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hr ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
    } else if (difference.inDays < 30) {
      int weeks = (difference.inDays / 7).floor();
      return "$weeks week${weeks > 1 ? 's' : ''} ago";
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      return "$months month${months > 1 ? 's' : ''} ago";
    } else {
      int years = (difference.inDays / 365).floor();
      return "$years year${years > 1 ? 's' : ''} ago";
    }
  }

  static void activitiesAfterGettingTheSoketResponse(
      response, BuildContext context) {
    var np = context.read<NotificationProvider>();
    int count = int.parse(np.notificationCount);
    np.setnotification('${count++}');
    if (response['message']['notificationSendStage'] == 'OrderPlace') {
      //optionJson
      OptionJson optionJson =
          OptionJson.fromJson(response['message']['optionJson']);
      DashboardHelpers.showBottomDialog(
          context: context, child: ReceivingOrderDialog(optionJson));
    }
  }

  static String formatTime24Hour(TimeOfDay time) {
    final String hour = time.hour.toString().padLeft(2, '0'); // Ensure 2 digits
    final String minute =
        time.minute.toString().padLeft(2, '0'); // Ensure 2 digits
    return '$hour:$minute';
  }

  static void showServiceDetailsBottomSheet(
      {required BuildContext context,
      required ServiceInfo serviceInfo,
      required PendingRequestedServiceList service,
      required List<PriceConfigaruatinAttr> attributeList}) {
    return serviceInfoBottomSheet(context, serviceInfo, service, attributeList);
  }

  static Future<DateTime?> pickDate(BuildContext context, String title) async {
    DateTime initialDate = DateTime.now();

    DateTime? pickedDate = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime tempPickedDate = initialDate;

        return Container(
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Action Bar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        "Done",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(tempPickedDate);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              // Date Picker
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime.now().add(Duration(days: 1)),
                  minimumDate: DateTime.now(),
                  maximumDate: DateTime.now().add(Duration(days: 120)),
                  backgroundColor: Colors.white,
                  onDateTimeChanged: (DateTime dateTime) {
                    tempPickedDate = dateTime;
                  },
                ),
              ),
              // Cancel Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black87),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    return pickedDate;
  }

  static Future<TimeOfDay?> pickTime(
      BuildContext context, TimeOfDay? initialTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final int minutes = pickedTime.minute;
      final int adjustedMinutes = (minutes ~/ 15) * 15;
      return TimeOfDay(hour: pickedTime.hour, minute: adjustedMinutes);
    }
    return null;
  }

  static String? formatDateRange(String dateRange) {
    try {
      List<String> dates = dateRange.split(" ");
      // Parse the input dates
      DateTime start = DateTime.parse(dates[0]);
      DateTime end = DateTime.parse(dates[1]).subtract(Duration(days: 1));

      // Format dates to the desired style
      String startFormatted = DateFormat("MMM d").format(start); // Nov 5
      String endFormatted = DateFormat("MMM d").format(end); // Dec 4

      // Return the combined range
      return "$startFormatted - $endFormatted";
    } catch (e) {
      return null;
    }
  }

  static getTimeFromDate(String? orderDate) {
    DateTime dateTime = DateTime.parse(orderDate ?? '');

    // Format the time in 'h:mm a' format (e.g., 9:54 AM)
    String formattedTime = DateFormat('h:mm a').format(dateTime.toLocal());

    return formattedTime;
  }

  static String? getDateFormatCard(String? scheduledDate) {
    try {
      DateFormat inputFormat = DateFormat('EEE dd MMM yyyy');
      DateFormat outputFormat = DateFormat('EEE MM/dd');

      // Parse the input date
      DateTime dateTime = inputFormat.parse(scheduledDate ?? '');

      // Format the date to the desired format
      String formattedDate = outputFormat.format(dateTime);

      return formattedDate;
    } catch (E) {
      return null;
    }
  }

  static String? getTimeFormatCart(String? startTime, String? endTime) {
    try {
      // Define the input and output formats
      DateFormat inputFormat = DateFormat('hh:mm a');
      DateFormat outputFormat = DateFormat('ha'); // Format as 8AM

      // Parse the input times
      DateTime start = inputFormat.parse(startTime ?? '');
      DateTime end = inputFormat.parse(endTime ?? '');

      // Format times
      String formattedStart = outputFormat.format(start);
      String formattedEnd = outputFormat.format(end);

      return "$formattedStart - $formattedEnd";
    } catch (e) {
      return null;
    }
  }

  static Future<void> openNumber(
      {required String number, bool isMessage = false}) async {
    final uri = isMessage
        ? Uri(scheme: 'sms', path: number) // Open message app
        : Uri(scheme: 'tel', path: number); // Open dial pad

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $uri';
    }
  }

  static Future<List<Map<String, dynamic>>> fetchLatLngs(
      List<String> zipCodes) async {
    const apiKey = 'AIzaSyAwpFYRk4i1gCEXqDepia2LXtsNuuMHkEY';
    List<Map<String, dynamic>> coordinates = [];

    for (String zipCode in zipCodes) {
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?address=$zipCode&key=$apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final location = data['results'][0]['geometry']['location'];
          coordinates.add({
            'zipCode': zipCode,
            'lat': location['lat'],
            'lng': location['lng'],
          });
        }
      }
    }
    return coordinates;
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Could not make the call");
    }
  }

  static Future<void> sendTextMessage(String phoneNumber) async {
    final Uri url = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Could not send the message");
    }
  }

  static Future<void> handleMemberAction({
    required BuildContext context,
    required dynamic member,
    required CorporateProvider corporateProvider,
    required UserProvider provider,
  }) async {
    debugPrint(
        'UserHelpers.invitedEmployeeStatus ${UserHelpers.invitedEmployeeStatus}');
    debugPrint('member.status ${member.status}');

    if (member.status == 'Verified' || member.status == 'Processing') {
      EasyLoading.dismiss();
      EasyLoading.show(maskType: EasyLoadingMaskType.black);

      if (await corporateProvider.getMemberDetailsData(member)) {
        EasyLoading.dismiss();
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => VerifiedMemberDetails(
              member: member,
            ),
          ),
        );
      } else {
        EasyLoading.dismiss();
      }
    } else if (member.status == 'Documents Submitted') {
      EasyLoading.show(maskType: EasyLoadingMaskType.black);

      if (await provider.getWorkerProfileDetailsData(member.textId)) {
        EasyLoading.dismiss();
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => ReviewTeamMembersSubmittedDocuments(
              empStatus: member.status ?? '',
            ),
          ),
        );
      } else {
        EasyLoading.dismiss();
      }
    } else {
      // Handle other statuses if needed.
      debugPrint('Unhandled member status: ${member.status}');
    }
  }

  static String removeSpecialCharacters(String input) {
    // Replace all non-alphanumeric characters (except spaces) with an empty string
    return input.replaceAll(RegExp(r'[^\w\s]'), '');
  }

  static String getAmPm(String time) {
    try {
      if (!time.contains(":")) {
        return "AM";
      }

      List<String> parts = time.split(":");
      if (parts.length != 2) {
        return "AM";
      }

      int hour = int.tryParse(parts[0]) ?? -1;
      if (hour < 0 || hour > 23) {
        return "AM";
      }

      return hour < 12 ? "AM" : "PM";
    } catch (e) {
      return "AM";
    }
  }

  static String format12Time(DateTime time) {
    int hour = time.hour > 12
        ? time.hour - 12
        : time.hour == 0
            ? 12
            : time.hour;
    String minute = time.minute
        .toString()
        .padLeft(2, '0'); // Ensures two digits for minutes
    String amPm = time.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $amPm";
  }

  static String get12HrFormat(String time) {
    if (time.isEmpty || !time.contains(':')) {
      throw ArgumentError("Invalid time format");
    }

    List<String> parts = time.split(":");
    if (parts.length != 2) {
      throw ArgumentError("Invalid time format");
    }

    int? hour = int.tryParse(parts[0]);
    int? minute = int.tryParse(parts[1]);

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      throw ArgumentError("Invalid time value");
    }

    int hour12 = hour % 12 == 0 ? 12 : hour % 12;

    return "$hour12:${parts[1]}";
  }

  static String extractTitles(String input) {
    // Regular expression to extract title values
    RegExp regExp = RegExp(r'title:\s*([^,}]+)');
    Iterable<Match> matches = regExp.allMatches(input);

    // Extract and return titles as a comma-separated string
    return matches.map((match) => match.group(1)!.trim()).join(', ');
  }

  static getTotal(num? serviceAmount, num? tips) {
    if (serviceAmount != null || tips != null) {
      return serviceAmount! + tips!;
    } else {
      return serviceAmount;
    }
  }

  static DateTime getDateTimeWithTimeInterval(String timeSlot) {
    DateTime now = DateTime.now(); // Get today's date
    List<String> parts = timeSlot.split(':'); // Split hours and minutes

    return DateTime(
        now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
  }

  static String get24HrFormat(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  static String getAmPmFromTimeSlot(String timeRange) {
    List<String> times = timeRange.split('-');

    if (times.length != 2) return "Invalid Time Format";

    String formatTime(String time) {
      List<String> parts = time.split(':');
      if (parts.length != 2) return "Invalid Time";

      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      String period = hour >= 12 ? "PM" : "AM";
      hour = hour % 12 == 0 ? 12 : hour % 12;

      return "$hour:${minute.toString().padLeft(2, '0')} $period";
    }

    return "${formatTime(times[0])} - ${formatTime(times[1])}";
  }

  static bool isEndDateGreaterOrEqual(DateTime startDate, DateTime endDate) {
    DateTime start = DateTime(startDate.year, startDate.month, startDate.day);
    DateTime end = DateTime(endDate.year, endDate.month, endDate.day);
    return start.isBefore(end) || start.isAtSameMomentAs(end);
  }
}

class JobStatus {
  static const String pending = 'Pending';
  static const String confirmed = 'Confirmed';
  static const String inTransit = 'In Transit';
  static const String jobStarted = 'Job Started';
  static const String completedByProvider = 'Completed By Provider';
  static const String completed = 'Completed';
  static const String canceled = 'Canceled';
}
