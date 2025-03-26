import 'dart:convert';
import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/api_services.dart';
import 'package:help_abode_worker_app_ver_2/models/corporate_team_member_model.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import '../corporate/corporate_review_details_tracker.dart';
import '../helper_functions/colors.dart';
import '../helper_functions/dashboard_helpers.dart';
import '../misc/constants.dart';
import '../models/dashboardRunningServicemodel.dart';
import '../models/dashboard_order_card_model.dart';
import '../models/earning_chart_model.dart';
import '../models/tracker_model.dart';
import '../models/upcoming_service_details_model.dart';
import '../models/pending_service_details_model.dart';
import '../models/user_model_with_address.dart';
import '../models/worker_service_request_model.dart';
import '../screens/open_order/widgets/tracker4.dart';

class OrderProvider extends ChangeNotifier {
  List<WorkerServiceRequestModel> workerServiceRequestList = [];
  List<WorkerServiceRequestModel> workerAcceptedServiceList = [];

  List<UpcomingServiceDetailsModel> upcomingServiceModelList = [];
  List<DashboardRunningServicemodel> workerRunningServiceList = [];
  List<DashboardOrderCardModel> dashboardOrderCardDataList = [];
  List<TeamMemberModel> dashboardMyTeamMemberList = [];
  // UserData? orderedUserData;
  UserModelWithAddress? orderedUserData;
  UpcomingServiceDetailsModel? acceptedOrderDetailsInfo;
  String? tempStatus;
  bool isLoading = true;
  bool isLoadingUpcoming = true;
  int orderIndex = 0;
  List<File> cameraBeforeImageList = [];
  // LatLng currentPosition = LatLng(37.42796133580664, -122.085749655962);
  // double latitude = 37.42796133580664;
  // double longitude = -122.085749655962;
  OrderStatus orderStatus = OrderStatus.pending;

  String pendingDetailsScreenServiceStatus = 'Pending';
  String pendingDetailsScreenButtonText = 'Accept';

  WorkerServiceRequestModel? workerServiceRequestModel;
  List<Map<String, dynamic>> _scheduleTimeListDataList = [];

  List<PendingServiceDetailsModel> pendingOrderInfoList = [];
  // Getter to access the list
  List<Map<String, dynamic>> get scheduleTimeListDataList =>
      _scheduleTimeListDataList;
  // Method to initialize the values
  void initializeScheduleTimeList() {
    if (pendingOrderInfoList.isNotEmpty) {
      _scheduleTimeListDataList = [
        {
          'title': 'Address',
          'subTitle':
              '${pendingOrderInfoList.first.orderDeliveryAddress?.zip ?? ''}, ${pendingOrderInfoList.first.orderDeliveryAddress?.city ?? ''}',
        },
        {
          'title': 'Service booked',
          'subTitle':
              convertDateTime(pendingOrderInfoList.first.orderDate ?? ''),
        },
        {
          'title': 'Scheduled',
          'subTitle':
              '${pendingOrderInfoList.first.scheduledDate ?? ''} (${pendingOrderInfoList.first.startTime}-${pendingOrderInfoList.first.endtime})',
        },
        {
          'title': 'Accepted the order',
          'subTitle': getStartTimeInfo('Confirmed'),
        },
        {
          'title': 'In Transit',
          'subTitle': getStartTimeInfo('In Transit'),
        },
        {
          'title': 'Job started',
          'subTitle': getStartTimeInfo('Job Started'),
        },
        {
          'title': 'Job completed',
          'subTitle': getStartTimeInfo('Job completed'),
        },
        {
          'title': 'Cancelled',
          'subTitle': getStartTimeInfo('Cancelled'),
        },
      ];
      notifyListeners(); // Notify listeners of the change
    }
  }
  // Method to update specific values

  void updateScheduleTimeValue(String title, String newValue) {
    final index =
        _scheduleTimeListDataList.indexWhere((item) => item['title'] == title);
    if (index != -1) {
      _scheduleTimeListDataList[index]['subTitle'] = newValue;
      notifyListeners(); // Notify listeners of the change
    }
  }

  void setOrderIndex(int index) {
    orderIndex = index;
    notifyListeners();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  Future<bool> getWorkerServiceRequest() async {
    try {
      print("getWorkerServiceRequest is calling.....");

      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };

      Response response = await get(
        Uri.parse("${urlBase}api/workerServiceRequest"),
        headers: header,
      );
      var responseDecodeJson = jsonDecode(response.body);
      print('RESPONSE BODY: ${responseDecodeJson.toString()}');

      if (response.statusCode == 200) {
        workerServiceRequestList.clear();
        for (Map i in responseDecodeJson['order_data']) {
          workerServiceRequestList.add(WorkerServiceRequestModel.fromJson(i));
        }
        print('workerServiceRequestList ${workerServiceRequestList.length}');

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        isLoading = false;
        DashboardHelpers.showAlert(msg: 'No Service Request Found');
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;
      DashboardHelpers.showAlert(msg: 'No Service Request Found');
      print("catch");
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> getWorkerUpcomingRequest() async {
    try {
      print("getWorkerUpcomingRequest is calling.....");

      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };

      Response response = await get(
        Uri.parse("${urlBase}api/workerUpcomingRequest"),
        headers: header,
      );

      print('URL: ${urlBase}api/workerUpcomingRequest');
      print('token :${token}');

      var responseDecodeJson = jsonDecode(response.body);
      print('RESPONSE BODY 2: ${responseDecodeJson.toString()}');

      if (response.statusCode == 200) {
        workerAcceptedServiceList.clear();
        for (Map i in responseDecodeJson['order_data']) {
          workerAcceptedServiceList.add(WorkerServiceRequestModel.fromJson(i));
        }

        isLoadingUpcoming = false;
        notifyListeners();
        return true;
      } else {
        isLoadingUpcoming = false;
        DashboardHelpers.showAlert(msg: 'No Order Request Found');
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoadingUpcoming = false;
      DashboardHelpers.showAlert(msg: 'Something went wrong');
      print("catch");
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<void> getOpenOrderInfo() async {
    var d1 = await getWorkerServiceRequest();
    var d2 = await getWorkerUpcomingRequest();
  }

  Future<bool> getWorkerPendingServiceDetails(
      String timesId, String serviceId) async {
    setSDLoading(true);
    try {
      print("getWorkerPendingServiceDetails is calling..... ");
      print("time id..... ${timesId}");
      print("serviceid..... ${serviceId}");

      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };

      Response response = await get(
        Uri.parse("${urlBase}api/RequestedServiceDetails/$timesId/$serviceId"),
        headers: header,
      );
      print('URL ${urlBase}api/RequestedServiceDetails/$timesId/$serviceId');
      var responseDecodeJson = jsonDecode(response.body);

      debugPrint('Status Code : ${response.statusCode}');
      if (response.statusCode == 200) {
        pendingOrderInfoList.clear();
        orderedUserData =
            UserModelWithAddress.fromJson(responseDecodeJson['userData'][0]);
        //   debugPrint('RESPONSE ${responseDecodeJson}');

        debugPrint('Response Data : ${orderedUserData!.toJson().toString()}');

        for (Map i in responseDecodeJson['order_data']) {
          pendingOrderInfoList.add(PendingServiceDetailsModel.fromJson(i));
        }

        print(
            'pendingOrderInfoList ${pendingOrderInfoList.first.serviceCategoryTextId}');

        setSDLoading(false);
        notifyListeners();
        return true;
      } else {
        setSDLoading(false);
        DashboardHelpers.showAlert(
            msg: responseDecodeJson['message'] ?? 'No Order Info Found');
        notifyListeners();
        return false;
      }
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'No Order Info Found');
      print("catch ${e}");
      print(e);
      setSDLoading(false);
      notifyListeners();
      return false;
    }
  }

  Future<bool> postRequestServiceAccept(
      String orderTextId, String orderItemId, bool isAccept) async {
    print('POST Request ACCEPT ${orderTextId}');
    print('POST Request ACCEPT ${orderItemId}');
    try {
      print("try");

      print("before post");

      var data = {
        "orderTextId": orderTextId,
        "orderItemId": orderItemId,
      };
      var body = jsonEncode(data);

      var header = {
        "Authorization": "Bearer $token",
      };
      //EasyLoading.show(maskType: EasyLoadingMaskType.black);
      Response response = await post(
        isAccept == true
            ? Uri.parse("${urlBase}api/workerServiceRequestAccept")
            : Uri.parse("${urlBase}api/workerServiceRequestReject"),
        body: body,
        headers: header,
      );

      var responseDecodeJson = jsonDecode(response.body);
      print('Response Json');
      print(responseDecodeJson);
      if (response.statusCode == 200) {
        //print('Returning Response Json');
        return true;
      }
      return false;
    } catch (e) {
      print("catch");
      print(e);
      return false;
    }
  }

  Future<bool> workerServiceRequestReject(
      String orderTextId, String serviceTextId, String reason) async {
    ApiService apiService = ApiService();
    var data = await apiService.postData2(
        'api/order-cancel/$orderTextId/$serviceTextId/', {'reason': reason});
    return data == null ? false : true;
  }

  bool _getServiceDetailsLoading = false;
  bool get getServiceDetailsLoading => _getServiceDetailsLoading;

  setSDLoading(bool status) {
    _getServiceDetailsLoading = status;
    notifyListeners();
  }

  Future<bool> getWorkerUpcomingServiceDetails(
      String orderTextId, String serviceID) async {
    setSDLoading(true);
    try {
      print("getWorkerUpcomingServiceDetails is calling.....");

      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };

      Response response = await get(
        Uri.parse(
            "${urlBase}api/upcomingServiceDetails/${orderTextId}/${serviceID}"),
        headers: header,
      );

      print('${urlBase}api/upcomingServiceDetails/${orderTextId}/${serviceID}');
      print('---');
      print('TOKEN ${token}');

      var responseDecodeJson = jsonDecode(response.body);
      print('RESPONSE BODY: ${responseDecodeJson['order_data'].toString()}');

      if (response.statusCode == 200) {
        upcomingServiceModelList.clear();

        List<dynamic> data = jsonDecode(response.body)['userData'];
        List<UserModelWithAddress> userDataList =
            data.map((json) => UserModelWithAddress.fromJson(json)).toList();
        orderedUserData = userDataList.first;

        for (Map i in responseDecodeJson['order_data']) {
          upcomingServiceModelList.add(UpcomingServiceDetailsModel.fromJson(i));
        }
        //set to use in different page
        acceptedOrderDetailsInfo = upcomingServiceModelList.first;

        print('upcomingServiceModelList ${upcomingServiceModelList.length}');

        notifyListeners();
        setSDLoading(false);
        return true;
      } else {
        DashboardHelpers.showAlert(msg: 'No Order Info Found');
        notifyListeners();
        setSDLoading(false);
        return false;
      }
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'No Order Info Found');
      print("catch");
      print(e);
      notifyListeners();
      setSDLoading(false);
      return false;
    }
  }

  Future<bool> getWorkerUpcomingServiceDetailsFromPending(
      String orderTextId, String serviceID) async {
    setSDLoading(true);
    try {
      print("getWorkerUpcomingServiceDetailsFromPending is calling.....");

      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };

      Response response = await get(
        Uri.parse(
            "${urlBase}api/upcomingServiceDetails/${orderTextId}/${serviceID}"),
        headers: header,
      );

      print('${urlBase}api/upcomingServiceDetails/${orderTextId}/${serviceID}');
      print('---');
      print('TOKEN ${token}');

      var responseDecodeJson = jsonDecode(response.body);
      print('RESPONSE BODY: ${responseDecodeJson['order_data'].toString()}');

      if (response.statusCode == 200) {
        pendingOrderInfoList.clear();

        List<dynamic> data = jsonDecode(response.body)['userData'];
        List<UserModelWithAddress> userDataList =
            data.map((json) => UserModelWithAddress.fromJson(json)).toList();
        orderedUserData = userDataList.first;

        for (Map i in responseDecodeJson['order_data']) {
          pendingOrderInfoList.add(PendingServiceDetailsModel.fromJson(i));
        }

        // pendingDetailsScreenServiceStatus=pendingOrderInfoList.first.orderStatus??'';

        print('pendingOrderInfoList ${pendingOrderInfoList.length}');

        notifyListeners();
        setSDLoading(false);
        return true;
      } else {
        DashboardHelpers.showAlert(msg: 'No Order Info Found');
        notifyListeners();
        setSDLoading(false);
        return false;
      }
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'No Order Info Found');
      print("catch");
      print(e);
      notifyListeners();
      setSDLoading(false);
      return false;
    }
  }

  UpcomingServiceDetailsModel getLatLng() => upcomingServiceModelList.first;

  void addToCameraList(File imageTemp) {
    cameraBeforeImageList.add(imageTemp);
    notifyListeners();
  }

  // void setLocation(Position position) {
  //   //currentPosition = LatLng(position.latitude, position.longitude);
  //   currentPosition = LatLng(90.15, 121.3);
  //   latitude = position.latitude;
  //   longitude = position.longitude;
  //
  //   notifyListeners();
  //
  //   print('Position ${position.latitude} ${position.longitude}');
  // }

  Future<bool> saveWorkerStatus(String? orderNumber, String status, textId,
      String serviceId, String orderItemId) async {
    try {
      print('POST Request saveWorkerStatus ${status}');

      var data = {
        "orderTextId": orderNumber,
        "orderStatus": status,
        "workerTextId": textId,
        "serviceTextId": serviceId,
        "orderItemId": orderItemId
      };
      var body = jsonEncode(data);

      print('SEND BODY ${body}');

      var header = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
      Response response = await post(
        Uri.parse("${urlBase}api/workerOrderStatusMaintenance"),
        body: body,
        headers: header,
      );

      print('RESPONSE ${response.body}');

      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        var responseDecodeJson = jsonDecode(response.body);
        print(responseDecodeJson);
        //print('Returning Response Json');
        return true;
      }
      return false;
    } catch (e) {
      print("catch ${e}");
      print(e);
      return false;
    }
  }

  Future postStartWork(String? orderTextId, List<File> pictureList) async {
    var request = MultipartRequest(
        'POST', Uri.parse('${urlBase}api/UpcomingServiceStartWork'));

    var header = {
      "Authorization": "Bearer ${token}",
    };

    request.headers.addAll(header);

    //request.fields['orderTextId'] = '${widget.upcomingList['endUserOrderTextId']}';
    // print(mapData[0]['orderTextId']);
    // print(mapData[0]['orderItemId']);
    request.fields['orderTextId'] = '${orderTextId}';
    // request.fields['orderItemId'] = '${mapData[0]['orderItemId']}';

    // print(beforeImage);
    // for (var filePath in pictureList) {
    //   var multipartFile = await MultipartFile.fromPath('beforeImage', filePath.path);
    //   print('FILE PATH ${filePath.path}');
    //   request.files.add(multipartFile);
    // }
    request.files.add(
        await MultipartFile.fromPath('beforeImage', pictureList.first.path));

    var response = await request.send();

    print('---------------');
    print(request.files.toString());

    print(response.stream.toString());
    if (response.statusCode == 200) {
      print('image uploaded');
    } else {
      print('failed');
    }
  }

  Future postMultipleImageBeforStartWork(
      String? orderTextId, String? orderItemId, List<File> pictureList) async {
    print('postMultipleImageBeforStartWork is calling');
    print(
        '#####____ POST postMultipleImageBeforStartWork WORK ____##### ${orderTextId} ${orderItemId}');

    print(token);

    var header = {
      "Authorization": "Bearer ${token}",
    };

    print(header);

    var request = MultipartRequest(
        'POST', Uri.parse('${urlBase}api/UpcomingServiceStartWork'));

    request.fields['orderItemId'] = orderTextId!;
    request.fields['orderTextId'] = orderItemId!;

    request.headers.addAll(header);

    for (var filePath in pictureList) {
      var multipartFile =
          await MultipartFile.fromPath('beforeImage', filePath.path);
      print('FILE PATH ${filePath.path}');
      request.files.add(multipartFile);
    }

    //request.files.add(await MultipartFile.fromPath('beforeImage', pictureList.first.path));

    // request.files
    //     .add(await MultipartFile.fromPath('afterImage', afterImage!.path));

    var response = await request.send();

    // print(response.stream.toString());

    print(response.statusCode);

    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) async {
        print('image uploaded');
      });
      print(response);
      print('image uploaded out');
    } else {
      print('failed');
    }
  }

  Future postMultipleImageAfterStartWork(
      String? orderTextId, String? orderItemId, List<File> pictureList) async {
    print('#####____ POST SELFY WORK ____##### ${orderTextId} ${orderItemId}');

    print(token);

    var header = {
      "Authorization": "Bearer ${token}",
    };

    print(header);

    var request = MultipartRequest(
        'POST', Uri.parse('${urlBase}api/UpcomingServiceJobDone'));

    request.fields['orderItemId'] = orderTextId!;
    request.fields['orderTextId'] = orderItemId!;

    request.headers.addAll(header);

    for (var filePath in pictureList) {
      var multipartFile =
          await MultipartFile.fromPath('afterImage', filePath.path);
      print('FILE PATH ${filePath.path}');
      request.files.add(multipartFile);
    }

    var response = await request.send();

    // print(response.stream.toString());

    print(response.statusCode);

    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) async {});
      print(response);
      print('image uploaded');

      //go to next page skip one page before

      print(userBox.get('textId'));
      print(userBox.get('status'));
    } else {
      print('failed');
    }
  }

  void clearImage() {
    cameraBeforeImageList.clear();
    _afterImages.clear();
    _beforeImages.clear();
    notifyListeners();
  }

  void removeImage(File image) {
    cameraBeforeImageList.remove(image);
    notifyListeners();
  }

  void setWorkerStatus(String s) {
    tempStatus = s;
    notifyListeners();
  }

  String getStartTimeInfo(String status) {
    String item = '';
    if (pendingOrderInfoList.isNotEmpty) {
      pendingOrderInfoList.first.orderTracking!.forEach((element) {
        if (element.status == status) {
          item = convertDateTime(element.created!);
        }
      });
    }
    return item;
  }

  String convertToUtcIsoString(DateTime dateTime) {
    // Convert the DateTime to UTC
    DateTime utcDateTime = dateTime.toUtc();

    // Convert to ISO8601 string with 'Z' to indicate UTC
    String isoFormatted = utcDateTime.toIso8601String();

    // Remove the milliseconds part if present
    if (isoFormatted.contains('.')) {
      isoFormatted = isoFormatted.substring(0, isoFormatted.indexOf('.')) + 'Z';
    }

    return isoFormatted;
  }

  String convertDateTime(String dateTimeString) {
    // Parse the input datetime string into a DateTime object
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format the date part into "10 Jan 2024" format
    String formattedDate = DateFormat('d MMM yyyy').format(dateTime);

    // Format the time part into "9:45 AM - 12:45 PM" format
    String formattedTime = DateFormat('h:mm a').format(dateTime);
    String formattedEndTime = DateFormat('h:mm a')
        .format(dateTime.add(Duration(hours: 3))); // Add 3 hours for end time
    // String formattedTimeRange = '$formattedTime - $formattedEndTime';

    // Combine the formatted date and time
    return '$formattedDate, $formattedTime';
  }

  List<EarningChartModel> dashboardEarningChartData = [];

  Future<bool> getworkerRunningServiceList() async {
    ApiService apiService = ApiService();
    var response = await apiService.getData('api/workerRunningServiceList');
    if (response != null) {
      workerRunningServiceList.clear();
      dashboardOrderCardDataList.clear();
      dashboardMyTeamMemberList.clear();
      dashboardEarningChartData.clear();
      for (Map i in response['order_data']) {
        workerRunningServiceList.add(DashboardRunningServicemodel.fromJson(i));
      }
      for (Map<String, dynamic> i in response['order_summary']) {
        dashboardOrderCardDataList.add(DashboardOrderCardModel.fromJson(i));
      }
      //save average rating
      saveRating();

      for (Map<String, dynamic> i in response['memberListArray']) {
        dashboardMyTeamMemberList.add(TeamMemberModel.fromJson(i));
      }
      for (Map<String, dynamic> i in response['earningChartData']) {
        dashboardEarningChartData.add(EarningChartModel.fromJson(i));
      }

      print('workerRunningServiceList ${workerRunningServiceList.length}');
      print('dashboardOrderCardDataList ${dashboardOrderCardDataList.length}');
      print('dashboardMyTeamMemberList ${dashboardMyTeamMemberList.length}');
      print('dashboardEarningChartData ${dashboardEarningChartData.length}');
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void saveRating() {
    dashboardOrderCardDataList.forEach((e) async {
      if (e.label == 'Customer Rating') {
        var rating = await DashboardHelpers.getString('rating');
        DashboardHelpers.setString('rating', e.scoreRate ?? '0');
      }
    });
  }

  OrderStatus mapJobStatusToOrderStatus(String jobStatus) {
    print('jobStatus ${jobStatus}');
    switch (jobStatus) {
      case JobStatus.pending:
        orderStatus = OrderStatus.pending;
        notifyListeners();
        return OrderStatus.pending;
      case JobStatus.confirmed:
        orderStatus = OrderStatus.confirmed;
        updateScheduleTimeValue('Accepted the order',
            convertDateTime(convertToUtcIsoString(DateTime.now())));
        notifyListeners();
        return OrderStatus.confirmed;
      case JobStatus.inTransit:
        orderStatus = OrderStatus.inTransit;
        updateScheduleTimeValue(
            jobStatus, convertDateTime(convertToUtcIsoString(DateTime.now())));
        notifyListeners();
        return OrderStatus.inTransit;
      case JobStatus.jobStarted:
        orderStatus = OrderStatus.jobStarted;
        updateScheduleTimeValue('Job started',
            convertDateTime(convertToUtcIsoString(DateTime.now())));
        notifyListeners();
        return OrderStatus.jobStarted;
      // case JobStatus.completedByProvider:
      //   orderStatus = OrderStatus.completedByProvider;
      //   notifyListeners();
      //   return OrderStatus.completedByProvider;
      case JobStatus.completed:
        orderStatus = OrderStatus.completed;
        updateScheduleTimeValue('Job completed',
            convertDateTime(convertToUtcIsoString(DateTime.now())));
        notifyListeners();
        return OrderStatus.completed;
      default:
        // Handle unrecognized status
        orderStatus = OrderStatus.pending;
        notifyListeners();
        return OrderStatus.pending;
    }
  }

  void setPendingDetailsScreenServiceStatus(String status) {
    pendingDetailsScreenServiceStatus = status;
    notifyListeners();
  }

  void getPendingDetailsScreenButtonText(String value) {
    var btnText = value;
    if (value == JobStatus.pending) {
      btnText = 'Accept';
    } else if (value == JobStatus.confirmed) {
      btnText = JobStatus.inTransit;
    } else if (value == JobStatus.inTransit) {
      btnText = JobStatus.jobStarted;
    } else if (value == JobStatus.jobStarted) {
      btnText = 'Complete the job';
    } else {
      btnText = 'Completed';
    }
    pendingDetailsScreenButtonText = btnText;
    notifyListeners();
  }

  // void convertPendingListToUpcomingList(List<PendingServiceDetailsModel> pendingList) {
  //   for (var pendingService in pendingList) {
  //     var upcomingService = UpcomingServiceDetailsModel(
  //       orderItemId: pendingService.orderItemId,
  //       groupName: '',
  //       orderTextId: pendingService.orderTextId,
  //       workerTextId: pendingService.workerTextId,
  //       orderDate: pendingService.orderDate,
  //       scheduledDate: pendingService.scheduledDate,
  //       startTime: pendingService.startTime,
  //       endtime: pendingService.endtime,
  //       workHour: pendingService.workHour,
  //       serviceTextId: pendingService.serviceTextId,
  //       serviceTitle: pendingService.serviceTitle,
  //       serviceImage: pendingService.serviceImage,
  //       serviceAmount: pendingService.serviceAmount,
  //       shortDescription: pendingService.shortDescription,
  //       latitude: pendingService.orderDeliveryAddress!.latitude,
  //       longitude: pendingService.orderDeliveryAddress!.longitude,
  //       instructionToWorker: pendingService.instructionToWorker,
  //       serviceStatus: pendingService.serviceStatus,
  //       servicePlan: pendingService.servicePlan,
  //       serviceJson: pendingService.serviceJson,
  //       orderDeliveryAddress: pendingService.orderDeliveryAddress,
  //       orderStatus: pendingService.orderStatus,
  //       orderTracking: [],
  //       reviewImage: [],
  //     );
  //     upcomingServiceModelList.clear();
  //     upcomingServiceModelList.add(upcomingService);
  //   }
  //   notifyListeners();
  // }

  void setOrderInfo(WorkerServiceRequestModel model) {
    workerServiceRequestModel = model;

    debugPrint(
        'setOrderInfo workerServiceRequestModel ${workerServiceRequestModel!.toJson()}');
    notifyListeners();
  }

  Map<String, bool> loadingStates = {};

  bool isLoadingOrder(String orderNumber) {
    return loadingStates[orderNumber] ?? false;
  }

  void setLoadingOrder(String orderNumber, bool isLoading) {
    loadingStates[orderNumber] = isLoading;
    notifyListeners();
  }

  List<FlSpot> parseEarningChartData(List<EarningChartModel> earningChartData) {
    return earningChartData.asMap().entries.map((entry) {
      int index = entry.key; // Day index (0-based)
      double totalEarned = entry.value.totalEarned;
      return FlSpot(index.toDouble(), totalEarned);
    }).toList();
  }

  LineChartData mainData(List<FlSpot> spots) {
    double minX = spots.map((spot) => spot.x).reduce((a, b) => a < b ? a : b);
    double maxX = spots.map((spot) => spot.x).reduce((a, b) => a > b ? a : b);
    double minY = spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
    double maxY = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);

    // Add a fallback range if all Y values are zero
    if (minY == maxY) {
      minY = 0;
      maxY = 1; // Set a default range
    }

    return LineChartData(
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        verticalInterval: 5, // Set interval to 5 days
        horizontalInterval: (maxY - minY) / 5,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.grey.withOpacity(0.4),
          strokeWidth: 0.5,
        ),
        getDrawingVerticalLine: (value) => FlLine(
          color: Colors.grey.withOpacity(0.4),
          strokeWidth: 0.5,
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 50,
            interval: (maxY - minY) / 5,
            getTitlesWidget: (value, _) => Text(
              '\$${value.toInt()}',
              style: TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
                fontSize: 8,
              ),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24,
            interval: 5, // Set interval to 5 days
            getTitlesWidget: (value, _) {
              // Calculate the date corresponding to the value
              DateTime startDate = DateTime.now().subtract(
                  Duration(days: 30)); // Start date of the 30-day range
              DateTime date = startDate.add(Duration(
                  days:
                      value.toInt())); // Add the 'value' days to the start date
              // Format the date as "dd MMM"
              return Text(
                '${DateFormat('dd MMM').format(date)}',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
                textAlign: TextAlign.start,
              );
            },
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          color: Colors.green,
          barWidth: 3,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            color: Colors.green.withOpacity(0.3),
          ),
          dotData: FlDotData(show: false),
        ),
      ],
    );
  }

  List<Color> gradientColors = [
    Colors.greenAccent,
    myColors.green.withOpacity(.3),
  ];
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  List<String> _beforeImages = [];
  List<String> _afterImages = [];

  List<String> get beforeImage => _beforeImages;
  List<String> get afterImages => _afterImages;
  String _is_chat = "No";
  String get is_chat => _is_chat;

  Future<void> getUploadedImages(num? orderItemId, String? orderTextId) async {
    ApiService apiService = ApiService();
    var data = await apiService
        .getData('api/ServiceBeforAfterImages/${orderTextId}/${orderItemId}');
    if (data != null) {
      _beforeImages.clear();
      _afterImages.clear();
      _beforeImages = List<String>.from(data["beforeImageArray"]);
      _afterImages = List<String>.from(data["afterImageArray"]);
      _is_chat = data['is_chat'] ?? '';
    }

    debugPrint('_beforeImages ${_beforeImages.length}');
    debugPrint('_afterImages ${_afterImages.length}');
    notifyListeners();
  }

  List<OrderTrackingInfoModel> _orderTrackingInfo = [];
  List<OrderTrackingInfoModel> get orderTrackingInfo => _orderTrackingInfo;

  getServiceTimeLineInfo(String orderTimeId, String serviceTextId) async {
    ApiService apiService = ApiService();

    var result = await apiService
        .getData('api/order-tracking/${orderTimeId}/${serviceTextId}/');
    if (result != null) {
      _orderTrackingInfo.clear();
      for (var i in result['tracking_data']) {
        _orderTrackingInfo.add(OrderTrackingInfoModel.fromJson(i));
      }
    }

    debugPrint('_orderTrackingInfo ${_orderTrackingInfo.length}');
    notifyListeners();
    return result;
  }

  List<WorkerServiceRequestModel> _rejectedOrderList = [];

  List<WorkerServiceRequestModel> get rejectedOrderList => _rejectedOrderList;

  Future<void> getRejectedOrderList() async {
    ApiService apiService = ApiService();
    setLoading(true);
    var result = await apiService.getData('api/rejectedOrderList');
    setLoading(false);
    if (result != null) {
      _rejectedOrderList.clear();
      for (var i in result['order_data']) {
        _rejectedOrderList.add(WorkerServiceRequestModel.fromJson(i));
      }
    }

    debugPrint('_rejectedOrderList ${_rejectedOrderList.length}');
    notifyListeners();
    return result;
  }
}

class MyLineChart extends StatefulWidget {
  final List<FlSpot> spots;
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;

  const MyLineChart({
    Key? key,
    required this.spots,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
  }) : super(key: key);

  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: widget.minX,
        maxX: widget.maxX,
        minY: widget.minY,
        maxY: widget.maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          verticalInterval: 5, // Set interval to 5 days
          horizontalInterval: (widget.maxY - widget.minY) / 5,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.4),
            strokeWidth: 0.5,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.4),
            strokeWidth: 0.5,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 50,
              interval: (widget.maxY - widget.minY) / 5,
              getTitlesWidget: (value, _) => Text(
                '\$${value.toInt()}',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 8,
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: 5, // Set interval to 5 days
              getTitlesWidget: (value, _) {
                DateTime currentDate = DateTime.now();
                DateTime date = currentDate.add(Duration(days: value.toInt()));
                return Text(
                  '${DateFormat('dd').format(date)}', // Display only day
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.start,
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: widget.spots,
            isCurved: false,
            color: Colors.green,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.3),
            ),
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
