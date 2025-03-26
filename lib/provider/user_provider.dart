import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/api_services.dart';
import 'package:help_abode_worker_app_ver_2/models/address_verification.dart';
import 'package:help_abode_worker_app_ver_2/models/earning_history_model.dart';
import 'package:help_abode_worker_app_ver_2/models/user_model.dart';
import 'package:help_abode_worker_app_ver_2/screens/open_order/completed_order/widgets/ordered_services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper_functions/dashboard_helpers.dart';
import '../helper_functions/signin_signup_helpers.dart';
import '../misc/constants.dart';
import '../models/corporate_team_member_model.dart';
import '../models/date_wise_earning_model.dart';
import '../models/date_wise_earning_model_singel.dart';
import '../models/earning_chart_model.dart';
import '../models/exclude_order_model.dart';
import '../models/rating_details_model.dart';
import '../models/rating_screen_model.dart';
import '../models/rating_warning_doc_model.dart';
import '../models/signup_info_model.dart';
import '../models/tip_list_model.dart';
import 'corporate_provider.dart';

class UserProvider extends ChangeNotifier {
  List<TipListModel> workerTipsInfoList = [];
  List<EarningChartModel> earningChartListData = [];
  List<EarningHistoryModel> workerEarninghistoryInfoList = [];
  List<DateWiseEarningModelSingel> workerEarningInfoSingel = [];
  List<SignupInfoModel> signUpEmpTypeList = [];
  Uint8List? workerImageString64;
  DateWiseEarningModel? dateWiseEarningModel;
  File? selfyImage;
  bool btnEnable = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool tipsChartLoading = false;
  bool isMemberLoading = false;
  bool passwordCheck = false;
  bool showTitleM = false;
  bool showEarningBottomSheetLoading = false;
  int? _apiStatusCode = 200;
  bool setEditValueForTeam = false;
  int? get apiStatusCode => _apiStatusCode;
  String _apiStatusString = '';
  String totalAmountSummary = '';
  String get apiStatusString => _apiStatusString;
  List<bool> seelectedButtonList = [];
  bool showErrorMsg = false;
  String errorMsgText = '';
  String userImageUrl = '';
  String teamImageUrl = '';
  String photoId1 = '';
  String photoId2 = '';
  String jobCompleted = '';
  String avg_amount = '';
  UserModel teamUserModel = UserModel(
      id: '1',
      textId: '11',
      franchiseTextId: '123',
      firstName: 'John',
      lastName: 'Doe',
      email: 'example@wempro.com',
      phone: '123456',
      status: 'Under Provider',
      ssn: '');
  List<RatingScreenModel> ratingScreenModelList = [];
  AddressVerification addressVerification = AddressVerification(
      zipData: '11',
      addressLine1Data: 'Mirpur',
      addressLine2Data: 'Motijhil',
      stateData: 'Dhaka');
  AddressVerification teanAddressVerification = AddressVerification(
      zipData: '11',
      addressLine1Data: 'Mirpur',
      addressLine2Data: 'Motijhil',
      stateData: 'Dhaka');
  List<TeamMemberModel> addIndividualUserModelList = [];
  UserModel userModel = UserModel();

  Future<Uint8List?> convertBase64ToImage(String base64String) async {
    workerImageString64 = base64Decode(base64String);
    notifyListeners();
    return workerImageString64;
  }

  Future<UserModel?> getUserFromProvider() async {
    if (DashboardHelpers.userModel != null) {
      userModel = DashboardHelpers.userModel!;
    }
    debugPrint('getUserFromProvider ${userModel.toJson()}');
    notifyListeners();
    return userModel;
  }

  Future<AddressVerification?> getUserAddressFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final myObjectJson = prefs.getString('address');
    final myObjectMap = jsonDecode(myObjectJson!);
    addressVerification = AddressVerification.fromJson(myObjectMap);
    notifyListeners();
    return addressVerification;
  }

  setUserInfo(String firstname, String lastname, String phone) async {
    userModel = userModel.copyWith(
        firstName: firstname, lastName: lastname, phone: phone);
    debugPrint('USER MODEL ${userModel.toJson()}');
    SignInSignUpHelpers prefHelper = SignInSignUpHelpers();
    await prefHelper.saveString(
        'user', jsonEncode(userModel)); // Update the userModel
    notifyListeners(); // Notify listeners to rebuild
  }

  Future<bool> updateWorkerData(dynamic userInfo) async {
    try {
      var url = Uri.parse('${urlBase}api/WorkerProfileUpdate');
      var headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };

      Map<String, String> requestBody = {
        'firstName': userInfo['firstName'],
        'lastName': userInfo['lastName'],
        'phone': userInfo['phone'],
        'countryCode': userInfo['countryCode'],
      };

      debugPrint('requestBody ${requestBody.toString()}');
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..fields.addAll(requestBody);

      // Add selfie image as a file
      if (selfyImage != null) {
        CachedNetworkImage.evictFromCache(userImageUrl);
        request.files.add(
            await http.MultipartFile.fromPath('selfieData', selfyImage!.path));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        debugPrint('Response body: $responseBody');
        var fname = jsonDecode(responseBody)['firstName'];
        var lname = jsonDecode(responseBody)['lastName'];
        var phone = jsonDecode(responseBody)['phone'];
        var country = jsonDecode(responseBody)['countryCode'];
        var image = '${urlBase}${jsonDecode(responseBody)['worker_image']}';
        userModel = userModel.copyWith(
            firstName: fname,
            lastName: lname,
            phone: phone,
            countryCode: country);
        DashboardHelpers.userModel = userModel.copyWith(
            firstName: fname,
            lastName: lname,
            phone: phone,
            countryCode: country);
        userImageUrl = image;
        // _firstname=jsonDecode(responseBody)['firstName'];
        // _lastname=jsonDecode(responseBody)['lastName'];
        //set affilation value

        notifyListeners();
        return true; // Return true if the response status code is 200
      } else {
        var responseBody = await response.stream.bytesToString();
        print('Failed with status code: ${response.statusCode}');
        print('Response body: $responseBody');
        return false; // Return false for any other status code
      }
    } catch (e) {
      print('Error updating worker data: $e');
      return false; // Return false if there's any exception
    }
  }

  Future<Map<String, dynamic>> signInApi(
      String emailText, String passwordText, BuildContext context) async {
    print(emailText);
    print(passwordText);

    var output = {'result': false, 'message': 'Something went wrong'};

    try {
      var data = {'email': emailText, 'password': passwordText};
      print("before post");

      final response = await http.post(
        Uri.parse("${urlBase}api/workerSignIn"),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      print('##### Status Code: ${response.statusCode} #####');
      print(response.body);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        UserModel user = UserModel.fromJson(responseBody['data']);
        String userJson = jsonEncode(user.toJson());
        DashboardHelpers.userModel = user;

        SignInSignUpHelpers prefHelper = SignInSignUpHelpers();
        final data = responseBody['data'];
        await prefHelper.saveString('employeeType', data['employeeType']);
        await prefHelper.saveString('status', data['status']);
        await prefHelper.saveString('textId', data['textId']);
        await prefHelper.saveString('franchiseTextId', data['franchiseTextId']);
        await prefHelper.saveString('workerDesignationTextId', data['workerDesignationTextId'] ?? '');
        await prefHelper.saveString('token', responseBody['token']);
        await prefHelper.saveString('workerInAppNotificationTextId', data['workerInAppNotificationTextId']);
        await prefHelper.saveString('user', userJson);
        await prefHelper.saveString('average_rating', responseBody['average_rating'].toString());
        fetchUserSavedData();
        if (user.status == 'Verified' || user.status == 'Processing') {
          var addressList = (data['addressJsonWhileVerification'] as List)
              .map((i) => AddressVerification.fromJson(i))
              .toList();
          if (addressList.isNotEmpty) {
            addressVerification = addressList.first;
            await prefHelper.saveString(
                "city", addressVerification.cityData ?? '');
            await prefHelper.saveJson('address', addressVerification.toJson());
          }
        }

        await prefHelper.saveString("login_mail", emailText.trim());
        await prefHelper.saveString("password", passwordText.trim());

        output['result'] = true;
        output['message'] = responseBody['message'];

        final corporateProvider =
            Provider.of<CorporateProvider>(context, listen: false);
        corporateProvider.setAffiliationList(responseBody['worker_roles']);
        corporateProvider.setCorporation_type_arrayList(
            responseBody['corporation_type_array']);

        if (responseBody['selfieData'] != null)
          setImageUrl(responseBody['selfieData']);
      } else {
        output['message'] = jsonDecode(response.body)['message'];
      }
    } catch (e) {
      print("Error during signIn: $e");
    }

    return output;
  }

  fetchUserSavedData() async {
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
    await DashboardHelpers.setUserInfo();
  }

  void getUserLoginInfo() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('user');
    final address = pref.getString('address');

    if (data != null && address != null) {
      // Create a User object from the Map
      userModel = UserModel.fromJson(jsonDecode(data));
      addressVerification = AddressVerification.fromJson(jsonDecode(address));
      notifyListeners();
      // print('LOGGED USER ${userModel.toString()}');
    }
  }

  Future<void> setLoadingValue(bool val) async {
    debugPrint('_isLoading ${val}');
    _isLoading = val;
    notifyListeners();
  }

  void setSelectedListUpdate(int index, bool val) {
    seelectedButtonList[index] = val;
    notifyListeners();
  }

  Future<bool> getWorkerTipsInfo() async {
    ApiService apiService = ApiService();
    setLoadingTips(true);
    var data = await apiService.getData('service/ProviderTipManagement');
    setLoadingTips(false);
    if (data != null) {
      workerTipsInfoList.clear();
      earningChartListData.clear();
      for (Map i in data['tip_list']) {
        workerTipsInfoList.add(TipListModel.fromJson(i));
      }
      for (Map<String, dynamic> i in data['earningChartData']) {
        earningChartListData.add(EarningChartModel.fromJson(i));
      }
      debugPrint('workerTipsInfoList ${workerTipsInfoList.length}');
      debugPrint('earningChartListData ${earningChartListData.length}');
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getProviderEarningHistory() async {
    ApiService apiService = ApiService();
    setLoadingValue(true);
    var data = await apiService.getData('api/providerEarningHistory');
    setLoadingValue(false);
    if (data != null) {
      workerEarninghistoryInfoList.clear();
      earningChartListData.clear();
      for (var i in data['earningChartData']) {
        earningChartListData.add(EarningChartModel.fromJson(i));
      }
      for (Map i in data['earningData']) {
        workerEarninghistoryInfoList.add(EarningHistoryModel.fromJson(i));
      }
      totalAmountSummary = data['totalAmountSummary'].toString();
      avg_amount = data['avg_amount'].toString();
      jobCompleted = data['jobCompleted'].toString();
      debugPrint(
          'workerEarninghistoryInfoList ${workerEarninghistoryInfoList.length}');
      setLoadingValue(false);
      return true;
    } else {
      return false;
    }
  }

  void setImageUrl(String imageUrl) async {
    //selfyImage = pickedImage;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("imageUrl", '${urlBase}${imageUrl}');
    userImageUrl = '${urlBase}${imageUrl}';
    DashboardHelpers.profileImageUrl = '${urlBase}${imageUrl}';
    notifyListeners();
    print('imageUrl Profile: $imageUrl');
  }

  Future<String> getProfileImage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String image = pref.getString("imageUrl") ?? '';
    userImageUrl = image;
    notifyListeners();
    debugPrint('get image url ${image}');
    return image;
  }

  Future<void> upDateButton(bool bool) async {
    Future.delayed(const Duration(milliseconds: 100), () {
      btnEnable = bool;
      notifyListeners();
    });
  }

  clearApiStatus() {
    _apiStatusCode = 0;
    _apiStatusString = '';
    notifyListeners();
  }

  Future<bool> changeUserPassword(
      BuildContext context, Map<String, String> data) async {
    print('POST Request ACCEPT');
    try {
      var body = jsonEncode(data);

      var header = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };
      //EasyLoading.show(maskType: EasyLoadingMaskType.black);
      Response response = await post(
        Uri.parse("${urlBase}api/workerChangePassword"),
        body: body,
        headers: header,
      );
      print('Response Json');
      var responseDecodeJson = jsonDecode(response.body);
      print(responseDecodeJson);

      // EasyLoading.dismiss();
      if (response.statusCode == 200) {
        var responseDecodeJson = jsonDecode(response.body);
        print('Response Json');
        print(responseDecodeJson);
        //print('Returning Response Json');
        setApiStatus(
            code: response.statusCode, status: responseDecodeJson['message']);

        return true;
      }
      setApiStatus(
          code: response.statusCode, status: responseDecodeJson['message']);

      return false;
    } catch (e) {
      print("catch");
      print(e);
      return false;
    }
  }

  Future<bool> dateWiseEarningList(String date) async {
    try {
      print("try dateWiseEarningList/");
      var header = {
        "Authorization": "Bearer ${token}",
      };

      Response response = await post(
        Uri.parse("${urlBase}api/dateWiseEarningList"),
        headers: header,
        body: {'textId': textId, 'orderDate': date},
      );
      //Response response = await get(Uri.parse("http://dummyjson.com/users"));

      print('Response Json ${response.body}');
      if (response.statusCode == 200) {
        workerTipsInfoList.clear();
        var responseDecodeJson = jsonDecode(response.body);
        dateWiseEarningModel =
            DateWiseEarningModel.fromJson(responseDecodeJson['earningData']);

        print('dateWiseEarningModel ${dateWiseEarningModel!.toJson()}');
        notifyListeners();

        return true;
      }
      return false;
    } catch (e) {
      print("catch");
      print(e);
      return false;
    }
  }

  Future<bool> dateWiseOrderEarningSingel(String orderTextId) async {
    try {
      print("try dateWiseOrderEarning/");
      var header = {
        "Authorization": "Bearer ${token}",
      };

      Response response = await post(
        Uri.parse("${urlBase}api/dateWiseOrderEarning"),
        headers: header,
        body: {'workerTextId': textId, 'orderTextId': orderTextId},
      );

      print('Response Json ${response.body}');
      if (response.statusCode == 200) {
        workerEarningInfoSingel.clear();
        var responseDecodeJson = jsonDecode(response.body);

        for (Map i in responseDecodeJson['orderDetails']) {
          workerEarningInfoSingel.add(DateWiseEarningModelSingel.fromJson(i));
        }
        notifyListeners();

        return true;
      }
      return false;
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'Something went wrong');
      print("catch");
      print(e);
      return false;
    }
  }

  setApiStatus({required int code, required String status}) {
    _apiStatusCode = code;
    _apiStatusString = status;
    notifyListeners();
  }

  late Timer _timer;
  int _secondsRemaining = 300; // 5 minutes in seconds

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        notifyListeners();
      } else {
        _timer.cancel();
        // Timer completed, you can add any logic here
      }
    });
  }

  String getTimerText() {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void stopTimer() {
    _timer.cancel();
    notifyListeners(); // Notify listeners after stopping the timer
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<bool> sendOTPApi(String emailText, String otpCode) async {
    print("Send OTP API Start");
    bool isSuccess = false;
    try {
      print("try");
      showErrorMsg = false;
      errorMsgText = '';
      notifyListeners();
      var data = {
        'email': emailText,
        'otp_code': otpCode,
      };
      var body = jsonEncode(data);
      print("before post");
      Response response = await post(
        Uri.parse("${urlBase}api/confirmOtpForForgotPassword"),
        body: body,
      );
      print("URL :${urlBase}api/confirmOtpForForgotPassword");
      print('responseDecodeJson 22 ${response.statusCode}');
      var responseDecodeJson = jsonDecode(response.body);
      print('responseDecodeJson ${responseDecodeJson}');

      if (response.statusCode == 200) {
        print('OTP VALIDATION SUCESS');
        //DashboardHelpers.showAlert(msg: responseDecodeJson.toString());
        print(response.body.toString());
        isSuccess = true;
        return isSuccess;
      } else {
        var res = jsonDecode(response.body);
        // DashboardHelpers.showAlert(msg: res['message']);
        isSuccess = false;
        showErrorMsg = true;
        errorMsgText = res['message'];
        notifyListeners();
        return isSuccess;
      }
    } catch (e) {
      print("catch: ${e}");
      print(e);
      DashboardHelpers.showAlert(msg: 'Something went wrong');
      showErrorMsg = false;

      notifyListeners();
      return false;
    }
  }

  void setPinPutBg(bool bool) {
    showErrorMsg = bool;
    notifyListeners();
  }

  void setErrorMsg(bool bool) {
    showErrorMsg = bool;
    notifyListeners();
  }

  String getFirstCharecterCombinationName(String str1, String str2) {
    if (str1.isEmpty || str2.isEmpty) {
      return 'Input strings should not be empty.';
    }

    String firstLetterStr1 = str1[0];
    String firstLetterStr2 = str2[0];
    // notifyListeners();
    return firstLetterStr1.toUpperCase() + firstLetterStr2.toUpperCase();
  }

  void setImageFile(File file) {
    selfyImage = file;
    notifyListeners();
  }

  Future<bool> addNewMemberToIndividual(
      dynamic data, CorporateProvider? cp) async {
    ApiService service = ApiService();
    if (data != null) {
      var response = await service.postData('api/provider-team-manage', data);
      if (response != null) {
        //set updated usermodel
        teamUserModel = UserModel(
            firstName: data['firstName'],
            lastName: data['lastName'],
            email: data['email'],
            phone: data['phone'],
            countryCode: data['countryCode']);
        debugPrint('UPDATED USERMODEL ${teamUserModel.toJson()}');

        addIndividualUserModelList.clear();
        for (Map i in response['member_list']) {
          addIndividualUserModelList.add(TeamMemberModel.fromJson(i));
        }
        debugPrint(
            'addIndividualUserModelList ${addIndividualUserModelList.length}');
        notifyListeners();

        return true;
      } else {
        return false;
      }
    } else {
      var response = await service.getData('api/provider-team-manage/');
      if (response != null) {
        addIndividualUserModelList.clear();
        for (Map i in response['team_member_list']) {
          addIndividualUserModelList.add(TeamMemberModel.fromJson(i));
        }
        //get dynamic role list
        cp!.setAffiliationList(response['worker_roles']);
        notifyListeners();
        debugPrint(
            'addIndividualUserModelList ${addIndividualUserModelList.length}');
        return true;
      } else {
        return false;
      }
    }
  }

  Future<bool> updatePersonalInfo(dynamic user, String mail) async {
    final url = Uri.parse("${urlBase}api/team/personalInfoUpdate/");

    final headers = {
      "Authorization": "Bearer ${token}",
      "Content-Type": "application/json",
    };

    try {
      debugPrint("Calling /api/personalInfoUpdate: $url");
      if (user != null) {
        final body = jsonEncode(user);
        debugPrint('SEND BODY: $user');
        final response = await http.put(url, headers: headers, body: body);
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');

        if (response.statusCode == 205) {
          var data = jsonDecode(response.body);
          debugPrint('Request was successful');

          //set updated usermodel
          //existing values will remain same
          teamUserModel = userModel.copyWith(
              firstName: user['firstName'],
              lastName: user['lastName'],
              email: mail,
              phone: user['phone'],
              countryCode: user['countryCode']);
          debugPrint('UPDATED USERMODEL ${userModel.toJson()}');

          notifyListeners();
          return true;
        } else {
          debugPrint('Failed with status code: ${response.statusCode}');
          var data = jsonDecode(response.body);
          DashboardHelpers.showAlert(
              msg: data['message'] ?? 'Something went wrong');
          return false;
        }
      } else {
        final response = await http.get(url, headers: headers);

        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');

        if (response.statusCode == 205) {
          var data = jsonDecode(response.body);
          debugPrint('Get was successful');

          addIndividualUserModelList.clear();
          for (Map i in data['team_member_list']) {
            addIndividualUserModelList.add(TeamMemberModel.fromJson(i));
          }
          notifyListeners();

          debugPrint(
              'addIndividualUserModelList ${addIndividualUserModelList.length}');
          return true;
        } else {
          debugPrint('Failed with status code: ${response.statusCode}');
          var data = jsonDecode(response.body);
          DashboardHelpers.showAlert(
              msg: data['message'] ?? 'Something went wrong');
          return false;
        }
      }
    } catch (e) {
      debugPrint("Exception caught:");
      debugPrint(e.toString());
      DashboardHelpers.showAlert(msg: 'An error occurred: ${e.toString()}');
      return false;
    } finally {
      // isMemberLoading = false;
      // notifyListeners();
    }
  }

  Future<bool> updateMailingInfo(dynamic mailInfo) async {
    final url = Uri.parse("${urlBase}api/team/mailingInfoUpdate/");

    final headers = {
      "Authorization": "Bearer ${token}",
      "Content-Type": "application/json",
    };

    try {
      debugPrint("Calling /api/personalInfoUpdate: $url");
      if (mailInfo != null) {
        final body = jsonEncode(mailInfo);
        debugPrint('SEND BODY: $mailInfo');
        final response = await http.put(url, headers: headers, body: body);
        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');

        if (response.statusCode == 205) {
          var data = jsonDecode(response.body);
          debugPrint('Request was successful');

          //set updated usermodel
          //existing values will remain same
          teanAddressVerification = teanAddressVerification.copyWith(
              zipData: mailInfo['zipData'],
              addressLine1Data: mailInfo['addressLine1Data'],
              addressLine2Data: mailInfo['addressLine2Data'],
              cityData: mailInfo['cityData'],
              stateData: mailInfo['stateData']);
          debugPrint('UPDATED USERMODEL ${userModel.toJson()}');

          notifyListeners();
          return true;
        } else {
          debugPrint('Failed with status code: ${response.statusCode}');
          var data = jsonDecode(response.body);
          DashboardHelpers.showAlert(
              msg: data['message'] ?? 'Something went wrong');
          return false;
        }
      } else {
        final response = await http.get(url, headers: headers);

        debugPrint('Status Code: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');

        if (response.statusCode == 205) {
          var data = jsonDecode(response.body);
          debugPrint('Get was successful');

          addIndividualUserModelList.clear();
          for (Map i in data['team_member_list']) {
            addIndividualUserModelList.add(TeamMemberModel.fromJson(i));
          }
          notifyListeners();

          debugPrint(
              'addIndividualUserModelList ${addIndividualUserModelList.length}');
          return true;
        } else {
          debugPrint('Failed with status code: ${response.statusCode}');
          var data = jsonDecode(response.body);
          DashboardHelpers.showAlert(
              msg: data['message'] ?? 'Something went wrong');
          return false;
        }
      }
    } catch (e) {
      debugPrint("Exception caught:");
      debugPrint(e.toString());
      DashboardHelpers.showAlert(msg: 'An error occurred: ${e.toString()}');
      return false;
    } finally {
      // isMemberLoading = false;
      // notifyListeners();
    }
  }

  Future<bool> submitPendingMemberDetailsInfo(dynamic user) async {
    final url = Uri.parse("${urlBase}api/team/information-confirmed/");

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    try {
      debugPrint("Calling team/information-confirmed/with URL: $url");
      //  isMemberLoading = true;
      // notifyListeners();

      final body = jsonEncode(user);
      debugPrint('SEND BODY: $user');
      final response = await http.put(url, headers: headers, body: body);

      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        debugPrint('Request was successful');
        await userBox.put('status',
            '${jsonDecode(response.body)['worker_status']['status']}');
        await userBox.put('textId',
            '${jsonDecode(response.body)['worker_status']['workerTextId']}');

        return true;
      } else {
        debugPrint('Failed with status code: ${response.statusCode}');
        var data = jsonDecode(response.body);
        DashboardHelpers.showAlert(
            msg: data['message'] ?? 'Something went wrong');
        return false;
      }
    } catch (e) {
      debugPrint("Exception caught:");
      debugPrint(e.toString());
      DashboardHelpers.showAlert(msg: 'An error occurred: ${e.toString()}');
      return false;
    } finally {
      // isMemberLoading = false;
      // notifyListeners();
    }
  }

  Future<bool> getWorkerProfileDetailsData(String? textId) async {
    ApiService apiService = ApiService();

    var response =
        await apiService.getData('api/worker/$textId/profileDetails/');
    if (response != null) {
      teamUserModel = UserModel.fromJson(response['profileData']);
      teamImageUrl = response['selfieData'];
      photoId1 = response['PhotoId1'];
      photoId2 = response['PhotoId2'];
      debugPrint('userImageUrl ${userImageUrl}');

      List<AddressVerification> addressList = [];
      for (Map i in response['profileData']['addressJsonWhileVerification']) {
        addressList.add(AddressVerification.fromJson(i));
      }
      teanAddressVerification = addressList.first;
      debugPrint('teamAddressVerification ${teanAddressVerification.toJson()}');
      debugPrint('teamUserModel ${teamUserModel.toJson()}');

      notifyListeners();

      return true;
    } else {
      return false;
    }
  }

  Future<bool> submitPendingMemberDetailsInfoCheckbox(String teamTextId) async {
    final url = Uri.parse("${urlBase}api/team/$teamTextId/statusApproved/");

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    try {
      debugPrint("Calling team/statusApproved/with URL: $url");
      //  isMemberLoading = true;
      // notifyListeners();

      final response = await http.post(url,
          headers: headers,
          body: jsonEncode({'acknowledged': 'yes', 'declaration': 'yes'}));

      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        debugPrint('Request was successful');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Exception caught:");
      debugPrint(e.toString());
      return false;
    } finally {
      // isMemberLoading = false;
      // notifyListeners();
    }
  }

  void setAjiraStatus(String val) {
    userModel.setStatus = val;
    notifyListeners();
  }

  Future<bool> postSelfie(String image) async {
    try {
      print('#####____ POST SELFY WORK ____##### ${userBox.get('status')}');
      print(token);

      var header = {
        "Authorization": "Bearer $token",
      };

      print(header);

      var request = MultipartRequest(
          'PUT', Uri.parse('${urlBase}api/team/SelfieUpdate/'));

      request.fields['textId'] = textId;

      request.headers.addAll(header);
      request.files.add(await MultipartFile.fromPath('selfieData', image));
      var response = await request.send();
      print(response.statusCode);

      if (response.statusCode == 205) {
        final responseBody =
            await response.stream.transform(utf8.decoder).join();
        final decodedResponse = jsonDecode(responseBody);

        print(decodedResponse);
        print('image uploaded');

        userImageUrl = '${decodedResponse['selfieData']}';

        debugPrint('userImageUrl ${userImageUrl}');
        notifyListeners();
        return true; // Success
      } else {
        print('failed');
        return false; // Failure due to response status code
      }
    } catch (error) {
      print('Error uploading selfie: $error');
      return false; // Failure due to exception
    }
  }

  Future<bool> postWorkerPhotoIdUpdate({
    required String idType,
    required String idNo,
    required String expDate,
    required String token,
    required String urlBase,
    required String textId,
    required String frontImagePath,
    required String backImagePath,
  }) async {
    Completer<bool> completer = Completer();

    print(frontImagePath);
    print(backImagePath);
    print('#####____ POST START WORK ____#####');

    print(token);

    var header = {
      "Authorization": "Bearer $token",
    };

    print(header);

    var request =
        MultipartRequest('PUT', Uri.parse('${urlBase}api/team/PhotoIdUpdate/'));

    request.fields['photoIdType'] = idType;
    request.fields['textId'] = textId;
    request.fields['photoIdNo'] = idNo;
    request.fields['photoIdExpirationDate'] = expDate;
    print('SENDING ${request.fields.toString()}');

    request.headers.addAll(header);

    request.files
        .add(await MultipartFile.fromPath('photoIdData1', frontImagePath));
    request.files
        .add(await MultipartFile.fromPath('photoIdData2', backImagePath));

    print('Hello World 2');
    print(request.fields.toString());

    var response = await request.send();

    print('Hello World 3');
    print(response.statusCode);

    if (response.statusCode == 205) {
      response.stream.transform(utf8.decoder).listen((value) async {
        print('Return ${value}');
        var data = jsonDecode(value);
        DashboardHelpers.showAlert(msg: data['message'] ?? '');
        photoId1 = data['PhotoId1'];
        photoId2 = data['PhotoId2'];
        // Clear both photos
        SignInSignUpHelpers.clearImage();

        completer.complete(true);
        notifyListeners();
      });
    } else {
      print(
          'Failed... Error:${response.stream.transform(utf8.decoder).listen((event) {
        print(event);
      })}');
      completer.complete(false);
    }

    return completer.future;
  }

  void setEditValue(bool val) {
    setEditValueForTeam = val;
    notifyListeners();
  }

  Future<bool> submitAcknowledgementCheckbox() async {
    final url = Uri.parse("${urlBase}api/team/${textId}/information-review/");

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    try {
      debugPrint("URL: $url");
      //  isMemberLoading = true;
      // notifyListeners();

      final response = await http.post(url, headers: headers);

      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        debugPrint('Request Response :${data}');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Exception caught:");
      debugPrint(e.toString());
      return false;
    } finally {
      // isMemberLoading = false;
      // notifyListeners();
    }
  }

  void checkOldAndNewPassword(String? newPass, String? confirmPass) {
    if (newPass != null || confirmPass != null) {
      if (newPass!.length >= 8 &&
          confirmPass!.length >= 8 &&
          newPass == confirmPass) {
        passwordCheck = true;
        notifyListeners();
      } else {
        passwordCheck = false;
        notifyListeners();
      }
    } else {
      passwordCheck = false;
      notifyListeners();
    }
  }

  Future<bool> getSignUpInformation() async {
    _isLoading = true;
    try {
      print("try getSignUpInformation");
      var header = {
        "Authorization": "Bearer ${token}",
      };

      Response response = await get(
        Uri.parse("${urlBase}api/workerSignUp"),
        headers: header,
      );
      debugPrint(
          'Response getSignUpInformation : ${jsonDecode(response.body)}');

      if (response.statusCode == 200) {
        signUpEmpTypeList.clear();
        var responseDecodeJson = jsonDecode(response.body);

        for (Map i in responseDecodeJson['employee_type']) {
          signUpEmpTypeList.add(SignupInfoModel.fromJson(i));
        }

        notifyListeners();
        debugPrint('Response ${responseDecodeJson}');
        print(
            'Returning Response Json signUpEmpTypeList ${signUpEmpTypeList.length}');
        return true;
      }
      return false;
    } catch (e) {
      print("getSignUpInformation catch ${e.toString()}");

      return false;
    }
  }

  void showTitle(bool bool) {
    showTitleM = bool;
    notifyListeners();
  }

  void setLoadingTips(bool val) async {
    tipsChartLoading = val;
    notifyListeners();
  }

  Future<void> getEarningHistory(
      {required dynamic date, required String callDefault}) async {
    if (callDefault == 'get') {
      await getProviderEarningHistory();
    } else {
      try {
        // API call for earning history
        setEarningBottomSheetLoading(true);
        var data =
            await ApiService().postData('api/providerEarningHistory', date);
        setEarningBottomSheetLoading(false);
        if (data != null) {
          // Clear and update earning data
          workerEarninghistoryInfoList.clear();
          workerEarninghistoryInfoList.addAll(
            (data['earningData'] as List)
                .map((i) => EarningHistoryModel.fromJson(i)),
          );
          totalAmountSummary = data['totalAmountSummary'].toString();
          avg_amount = data['avg_amount'].toString();
          jobCompleted = data['jobCompleted'].toString();

          // Clear and update earning chart data
          earningChartListData.clear();
          for (var i in data['earningChartData']) {
            earningChartListData.add(EarningChartModel.fromJson(i));
          }

          debugPrint(
              'workerEarninghistoryInfoList ${workerEarninghistoryInfoList.length}');
        }
      } catch (e) {
        debugPrint("Error in getEarningHistory: $e");
      }
      notifyListeners();
    }
  }

  Future<void> getTipManagement(
      {required dynamic date, required String callDefault}) async {
    if (callDefault == 'get') {
      await getWorkerTipsInfo();
    } else {
      try {
        // API call for tip management
        var data =
            await ApiService().postData('service/ProviderTipManagement', date);

        if (data != null) {
          // Clear and update earning chart data
          earningChartListData.clear();
          for (var i in data['earningChartData']) {
            earningChartListData.add(EarningChartModel.fromJson(i));
          }
        }
      } catch (e) {
        debugPrint("Error in getTipManagement: $e");
      }
      notifyListeners();
    }
  }

  void setEarningBottomSheetLoading(bool val) {
    showEarningBottomSheetLoading = val;
    notifyListeners();
  }

  Future<void> getRatingInfo() async {
    ApiService apiService = ApiService();
    var data = await apiService.getData('api/providerRatings/');
    if (data != null) {
      ratingScreenModelList.clear();
      for (var i in data['my_response']) {
        ratingScreenModelList.add(RatingScreenModel.fromJson(i));
      }
    }

    debugPrint('ratingScreenModel ${ratingScreenModelList.length}');
    notifyListeners();
  }

  Future<void> getMemberAccordingToOrder(Map<String, Object?> data) async {
    ApiService apiService = ApiService();
    var data = await apiService.getData('endpoint');
    if (data != null) {
    } else {
      DashboardHelpers.showAlert(msg: 'Something went wrong');
    }
  }

  RatingDetailsModel? _ratingDetailsModel;
  List<UserReviews> _listOfUserReviews = [];
  RatingDetailsModel? get ratingDetailsModel => _ratingDetailsModel;
  List<UserReviews> get listOfUserReviews => _listOfUserReviews;
  List<Map<String, dynamic>> _ratingServiceArray = [];
  List<Map<String, dynamic>> get ratingServiceArray => _ratingServiceArray;

  Future<void> getRatingDetailsInfo() async {
    ApiService apiService = ApiService();
    var data = await apiService.getData('api/providerRatingsDetails/');
    if (data != null) {
      _listOfUserReviews.clear();
      _ratingServiceArray.clear();
      //serviceArray
      for (var i in data['serviceArray']) {
        _ratingServiceArray.add(i);
      }
      _ratingDetailsModel = RatingDetailsModel.fromJson(data['results']);
      //set data
      convertToRatingListData(_ratingDetailsModel ?? RatingDetailsModel());
      for (var i in data['user_reviews']) {
        _listOfUserReviews.add(UserReviews.fromJson(i));
      }
    }
    debugPrint('_ratingDetailsModel ${_ratingDetailsModel!.toJson()}');
    debugPrint('_listOfUserReviews ${_listOfUserReviews.length}');
    debugPrint('_ratingServiceArray ${_ratingServiceArray.length}');
    notifyListeners();
  }

  List<Map<String, dynamic>> convertRatingList = [];

  List<Map<String, dynamic>> convertToRatingListData(
    RatingDetailsModel ratingDetails,
  ) {
    // Initialize a map to store the count of each star rating
    final Map<int, int> starCounts = {
      5: ratingDetails.star5RatingCount == null
          ? 0
          : ratingDetails.star5RatingCount!.toInt(),
      4: ratingDetails.star4RatingCount == null
          ? 0
          : ratingDetails.star4RatingCount!.toInt() ?? 0,
      3: ratingDetails.star3RatingCount == null
          ? 0
          : ratingDetails.star3RatingCount!.toInt() ?? 0,
      2: ratingDetails.star2RatingCount == null
          ? 0
          : ratingDetails.star2RatingCount!.toInt() ?? 0,
      1: ratingDetails.star1RatingCount == null
          ? 0
          : ratingDetails.star1RatingCount!.toInt() ?? 0,
    };

    // Calculate the total count of ratings
    final totalRatings = starCounts.values.reduce((a, b) => a + b);

    // Calculate the maximum value for normalization (e.g., 10)
    const maxValue = 10;

    // Convert the data into the desired format
    convertRatingList = starCounts.entries.map((entry) {
      final starRating = entry.key;
      final currentValue = entry.value;

      return {
        'rating': starRating,
        'maxValue': maxValue,
        'currentValue': currentValue,
        'total': totalRatings.toString(),
      };
    }).toList();

    notifyListeners();
    return convertRatingList;
  }

  Future<void> getReviewAccordingToService(selectedService) async {
    ApiService apiService = ApiService();
    var data = await apiService.getData(
        'api/serviceRatingsDetails/${selectedService['serviceTextId']}/${selectedService['categoryTextId']}/');
    if (data != null) {
      _listOfUserReviews.clear();
      _ratingDetailsModel = RatingDetailsModel.fromJson(data['results']);
      //set data
      convertToRatingListData(_ratingDetailsModel ?? RatingDetailsModel());
      for (var i in data['user_reviews']) {
        _listOfUserReviews.add(UserReviews.fromJson(i));
      }
    }
    debugPrint('_ratingDetailsModel ${_ratingDetailsModel!.toJson()}');
    debugPrint('_listOfUserReviews ${_listOfUserReviews.length}');
    debugPrint('_ratingServiceArray ${_ratingServiceArray.length}');
    notifyListeners();
  }

  List<String> _excludeList = [];
  List<String> get excludeList => _excludeList;

  List<ExcludeOrderModel> _excludeOrderList = [];
  List<ExcludeOrderModel> get excludeOrderList => _excludeOrderList;

  Future<void> getExcludingRatingInfo() async {
    setLoadingValue(true);
    ApiService apiService = ApiService();
    var data = await apiService.getData('api/excluded-rating-reason/');
    _excludeList.clear();
    _excludeOrderList.clear();
    for (var i in data['get_data']['excluded_reasons']) {
      _excludeList.add(i['reason']);
    }
    for (var i in data['order_array']) {
      _excludeOrderList.add(ExcludeOrderModel.fromJson(i));
    }
    setLoadingValue(false);
    debugPrint('_excludeList ${_excludeList.length}');
    debugPrint('_excludeOrderList ${_excludeOrderList.length}');
  }

  List<RatingWarningDocModel> _ratingWarningDocList = [];
  List<RatingWarningDocModel> get ratingWarningDocList => _ratingWarningDocList;

  Future<void> getRatingWarningDocInfo() async {
    setLoadingValue(true);
    ApiService apiService = ApiService();
    var data = await apiService.getData('api/rating-warning-documents/');
    _ratingWarningDocList.clear();
    for (var i in data['get_data']) {
      _ratingWarningDocList.add(RatingWarningDocModel.fromJson(i));
    }
    setLoadingValue(false);
    debugPrint('_ratingWarningDocList ${_ratingWarningDocList.length}');
    notifyListeners();
  }
}

//sign in jan 8

//  Future<Map<String, dynamic>> signInApi(
//       String emailText, String passwordText, BuildContext context) async {
//     print(emailText);
//     print(passwordText);
//
//     var output = {'result': false, 'message': 'Something went wrong'};
//
//     try {
//       var data = {'email': emailText, 'password': passwordText};
//
//       print("before post");
//       http.Response response = await http.post(
//         Uri.parse("${urlBase}api/workerSignIn"),
//         body: jsonEncode(data),
//         headers: {'Content-Type': 'application/json'},
//       );
//
//       print('#####________STATUS CODE START_____#####');
//       print(response.statusCode);
//       print(response.body);
//       print('#####________STATUS CODE END_____#####${response.statusCode}');
//
//       if (response.statusCode == 200) {
//         UserModel user = UserModel.fromJson(jsonDecode(response.body)['data']);
//         DashboardHelpers.userModel = user;
//         userModel = user;
//         SignInSignUpHelpers prefHelper = SignInSignUpHelpers();
//         await prefHelper.saveString('employeeType', jsonDecode(response.body)['data']['employeeType']);
//         await prefHelper.saveString('status', jsonDecode(response.body)['data']['status']);
//         await prefHelper.saveString('textId', jsonDecode(response.body)['data']['textId']);
//         await prefHelper.saveString('franchiseTextId', jsonDecode(response.body)['data']['franchiseTextId']);
//         await prefHelper.saveString('workerDesignationTextId', jsonDecode(response.body)['data']['workerDesignationTextId']??'');
//         await prefHelper.saveString('token', jsonDecode(response.body)['token']);
//         await prefHelper.saveString('workerInAppNotificationTextId', jsonDecode(response.body)['data']['workerInAppNotificationTextId']);
//         await prefHelper.saveString('workerDesignationTextId', jsonDecode(response.body)['data']['workerDesignationTextId']);
//         //get dall saved data
//         fetchUserSavedData();
//         // Convert address string to json
//         if (userModel.status == 'Verified' || userModel.status == 'Processing') {
//           var addressList = (jsonDecode(response.body)['data']
//           ['addressJsonWhileVerification'] as List).map((i) => AddressVerification.fromJson(i))
//               .toList();
//
//           debugPrint('addressList ${addressList.length}');
//
//           addressVerification = addressList.isNotEmpty ? addressList.first : addressVerification;
//
//           await prefHelper.saveString("city", addressVerification.cityData ?? '');
//           await prefHelper.saveString('textId', userModel.textId ?? '');
//           await prefHelper.saveString('token', jsonDecode(response.body)['token']);
//           await prefHelper.saveJson('user', userModel.toJson());
//           await prefHelper.saveJson('address', addressVerification.toJson());
//         }
//
//         // Save user mail and password for another login
//         await prefHelper.saveString("login_mail", emailText.trim());
//         await prefHelper.saveString("password", passwordText.trim());
//
//         output['result'] = true;
//         output['message'] = jsonDecode(response.body)['message'];
//
//         // Save role lists and image
//         Provider.of<CorporateProvider>(context, listen: false)
//             .setAffiliationList(jsonDecode(response.body)['worker_roles']);
//
//         // Save corporation_type_array
//         Provider.of<CorporateProvider>(context, listen: false)
//             .setCorporation_type_arrayList(
//             jsonDecode(response.body)['corporation_type_array']);
//
//         if (jsonDecode(response.body)['selfieData'] != null) {
//           setImageUrl(jsonDecode(response.body)['selfieData']);
//         }
//         //corporation_type_array
//       } else {
//         output['message'] = jsonDecode(response.body)['message'];
//       }
//     } catch (e) {
//       print("Error during signIn: $e");
//     }
//
//     return output;
//   }
