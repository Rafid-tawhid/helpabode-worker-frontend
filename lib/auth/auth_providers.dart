// ignore_for_file: unused_local_variable, avoid_print, prefer_const_constructors, sort_child_properties_last

import 'dart:async';
import 'dart:convert';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

enum AppPermissions {
  granted,
  denied,
  restricted,
  permanentlyDenied,
}

class CallBackResponse {
  bool status;
  String message;

  CallBackResponse({this.status = false, this.message = ''});
}

class AuthProvider with ChangeNotifier {
  String? _firstName;
  String? get firstName => _firstName;
  // ignore: non_constant_identifier_names
  String SaveUserAddress = "";
  // ignore: non_constant_identifier_names
  String SaveUserLocation = "";

  TextEditingController _confirmPassword = TextEditingController();
  TextEditingController get confirmPassword => _confirmPassword;

  setConfirmPasswordText(String? text) {
    if (text == null) {
      _confirmPassword.clear();
    } else {
      _confirmPassword.text = text;
    }
    notifyListeners();
  }

  String _passwordText = '';
  String get passwordText => _passwordText;
  setPasswordText(String? text) {
    if (text == null) {
      _passwordText = '';
    } else {
      _passwordText = text;
    }
    notifyListeners();
  }

  setDefaultLocation(String address, String location) {
    SaveUserAddress = address;
    SaveUserLocation = location;
    // sharedPreferences.remove("address");
    // sharedPreferences.remove("location");
    // sharedPreferences.setString("address", address);
    // sharedPreferences.setString("location", location);
    notifyListeners();
  }

  PermissionStatus _locationStatus = PermissionStatus.denied;
  Position? currentPosition;

  bool _isFirstTimeInDashboard = true;
  bool get isFirstTimeInDashboard => _isFirstTimeInDashboard;
  setIsFirstTimeInDashboard(bool status) {
    _isFirstTimeInDashboard = status;
    notifyListeners();
  }

  int? _apiStatusCode = 200;
  int? get apiStatusCode => _apiStatusCode;

  String _apiStatusString = '';
  String get apiStatusString => _apiStatusString;

  setApiStatus({required int code, required String status}) {
    _apiStatusCode = code;
    _apiStatusString = status;
    notifyListeners();
  }

  clearApiStatus() {
    _apiStatusCode = 0;
    _apiStatusString = '';
    notifyListeners();
  }

  Future<PermissionStatus> getLocationStatus() async {
    // Request for permission
    final status = await Permission.location.request();
    // change the location status
    _locationStatus = status;
    // notiy listeners
    notifyListeners();
    print(_locationStatus);
    return status;
  }

  bool checkBoxValue = false;
  checkboxValueChane() {
    checkBoxValue = !checkBoxValue;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  bool isNumber = false;
  bool emptyText = false;
  bool hasNextData = false;
  bool isShowMap = false;

  bool _mailExist = false;
  bool get mailExist => _mailExist;
  setMailExist(bool exist) {
    _mailExist = exist;
    notifyListeners();
  }

  bool _phoneExist = false;
  bool get phoneExist => _phoneExist;
  setPhoneExist(bool exist) {
    _phoneExist = exist;
    notifyListeners();
  }

  Future signup(
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      String countryCode,
      String password,
      Function callback) async {
    setLoading(true);
    await setMailExist(false);
    await setPhoneExist(false);

    try {} catch (e) {
      debugPrint("Sign up error: $e");
      setLoading(false);
    }

    notifyListeners();
  }

  Future changeUserPassword(
      BuildContext context, Map<String, String> data) async {
    try {} catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
      return null;
    }
  }

  bool _userInfoLoading = false;
  bool get userInfoLoading => _userInfoLoading;
  setUserInfoLoading(bool status) {
    _userInfoLoading = status;
    notifyListeners();
  }

  String _userTextId = '';
  String get userTextId => _userTextId;

  String _userGroupTextId = '';
  String get userGroupTextId => _userGroupTextId;

  setUserTextId(String id) {
    _userTextId = id;
    notifyListeners();
  }

  setGroupTextId(String id) {
    _userGroupTextId = id;
    notifyListeners();
  }

  //TODO: USER ADRESS SEND AND SAVE
  int isSlectedIndex = 0;
  bool isCheckboxSelected = false;
  void changeSlectedIndex(int index, bool? value) {
    isSlectedIndex = index;
    isCheckboxSelected = value!;
    notifyListeners();
  }

  Future resetPasswordConfirm(
      String email, String newPassword, Function callback) async {
    setOtpSendStatus(true);
    try {
      // ApiResponse apiResponse = await authRepo.setNewPassword(
      //   email,
      //   newPassword,
      // );
      // if (apiResponse.response.statusCode == 200) {
      //   callback(true, "Password Set Successfully");
      // } else {
      //   callback(false, apiResponse.error.toString());
      //   //print(response.statusCode);
      // }
      // setOtpSendStatus(false);
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
    notifyListeners();
  }

  //TODO:: for Sign in Section email

  bool incorrectemail = false;

  setEmailInCorrect(bool inCorrect) {
    incorrectemail = inCorrect;
    notifyListeners();
  }

  bool isFullyStretched = false;
  setStretch(bool stretched) {
    isCheckboxSelected = stretched;
    notifyListeners();
  }

  bool isLoadingSignIn = false;
  bool isShowCheckMark = false;
  setCheckMarkStatus(bool show) {
    isShowCheckMark = show;
    notifyListeners();
  }

  signIn(String email, Function callback) async {
    isLoadingSignIn = true;
    //
    // notifyListeners();
    // try {
    //   ApiResponse apiResponse = await authRepo.emailCheck(email,
    //       onSendProgress: (int sentBytes, int totalBytes) {
    //         progressPercent = sentBytes / totalBytes * 100;
    //         showLog("Progress: $progressPercent %");
    //         if (progressPercent == 100) {
    //           // dispose();
    //           showLog('finished');
    //         }
    //       });
    //   if (apiResponse.response.statusCode == 200) {
    //     isLoadingSignIn = false;
    //     debugPrint(apiResponse.response.data.toString());
    //     _firstName = apiResponse.response.data['results'];
    //     callback(true, apiResponse.response.data['message']);
    //   } else {
    //     incorrectemail = true;
    //     isLoadingSignIn = false;
    //     notifyListeners();
    //     String errorMessage;
    //     if (apiResponse.error is String) {
    //       debugPrint(apiResponse.error.toString());
    //       errorMessage = apiResponse.error.toString();
    //     } else {
    //       ErrorResponse errorResponse = apiResponse.error;
    //       errorMessage = errorResponse.toString();
    //     }
    //     callback(false, errorMessage);
    //   }
    // } catch (e) {
    //   isLoadingSignIn = false;
    //   Fluttertoast.showToast(msg: "Something went wrong!");
    // }
    notifyListeners();
  }

  Future<void> signInEmailPassword(String email, String confirmPassword) async {
    _isLoading = true;
    // sharedPreferences.remove("address");
    // sharedPreferences.remove("location");

    // ApiResponse apiResponse = await authRepo.login(email, confirmPassword,
    //     onSendProgress: (int sentBytes, int totalBytes) {
    //       progressPercent = sentBytes / totalBytes * 100;
    //       showLog("Progress: $progressPercent %");
    //       if (progressPercent == 100) {
    //         // dispose();
    //         showLog('finished');
    //       }
    //     });

    // notifyListeners();
    //
    // if (apiResponse.response.statusCode == 201) {
    //   Map responseLocation = apiResponse.response.data['results'];
    //   debugPrint(
    //       'This is minhaz form login: ${apiResponse.response.data['results']}');
    //   print(
    //       "==============================>${responseLocation['addressLine1']}");
    //   if (authRepo.checkTokenExist()) {
    //     authRepo.clearUserInformation();
    //     authRepo.clearToken();
    //   } else {
    //     sharedPreferences.setString(
    //         "address", responseLocation['addressLine1']);
    //     sharedPreferences.setString("location", responseLocation['cityTextId']);
    //     authRepo.saveUserToken(apiResponse.response.data['token'].toString());
    //     authRepo.saveUserInformation(
    //         responseLocation['id'].toString(),
    //         '${responseLocation['first_name']}',
    //         '${responseLocation['last_name']}',
    //         '${responseLocation['email']}',
    //         '${responseLocation['phone']}');
    //     name =
    //     '${responseLocation['first_name']} ${responseLocation['last_name']}';
    //     userID = '${responseLocation['id']}';
    //   }
    //   // Fluttertoast.showToast(msg: 'Success');
    //   setLoading(false);
    //   return CallBackResponse(status: true, message: 'Login Successfully');
    // } else {
    //   // Fluttertoast.showToast(msg: 'Failed');
    //   notifyListeners();
    //   String errorMessage;
    //   if (apiResponse.error is String) {
    //     debugPrint(apiResponse.error);
    //     errorMessage = apiResponse.error.toString();
    //   } else {
    //     ErrorResponse errorResponse = apiResponse.error;
    //     errorMessage = errorResponse.toString();
    //   }
    //   setLoading(false);
    //
    //   notifyListeners();
    //  return CallBackResponse(status: false, message: errorMessage);
    //  }
  }

  // for OTP send
  bool _isOtpSend = false;
  bool get isOtpSend => _isOtpSend;
  setOtpSendStatus(bool status) {
    _isOtpSend = status;
    notifyListeners();
  }

  Future otpSend(String email, bool fromResend, Function callback) async {
    // setOtpSendStatus(true);
    // try {
    //   ApiResponse apiResponse = await authRepo.otpSend(email, fromResend);
    //
    //   if (apiResponse.response.statusCode == 200) {
    //     callback(true, true, apiResponse.response.data['message']);
    //     setOtpSendStatus(false);
    //   } else {
    //     if (apiResponse.response.data['results'] != null) {
    //       if (apiResponse.response.data['results'] >= 5) {
    //         callback(
    //           false,
    //           false,
    //           apiResponse.response.data['message'].toString(),
    //         );
    //       } else {
    //         callback(
    //           false,
    //           true,
    //           apiResponse.response.data['message'].toString(),
    //         );
    //       }
    //     } else {
    //       callback(
    //         false,
    //         true,
    //         apiResponse.response.data['message'].toString(),
    //       );
    //     }
    //     setOtpSendStatus(false);
    //   }
    // } catch (e) {
    //   Fluttertoast.showToast(msg: "Something went wrong");
    //   setOtpSendStatus(false);
    // }
    notifyListeners();
  }

  Future onTimeOtpSend(String email, bool fromResend, Function callback) async {
    // setOtpSendStatus(true);
    // try {
    //   ApiResponse apiResponse =
    //   await authRepo.onTimeOtpLogin(email, fromResend);
    //
    //   if (apiResponse.response.statusCode == 200) {
    //     setOtpSendStatus(false);
    //     // callback(true, "apiResponse.response.data['message']");
    //     callback(true, true, apiResponse.response.data['message']);
    //   } else {
    //     //   await Future.delayed(const Duration(seconds: 2));
    //
    //     //   // callback(false, "${apiResponse.error}");
    //     if (apiResponse.response.data['results'] != null) {
    //       if (apiResponse.response.data['results'] >= 5) {
    //         callback(
    //           false,
    //           false,
    //           apiResponse.response.data['message'].toString(),
    //         );
    //       } else {
    //         callback(
    //           false,
    //           true,
    //           apiResponse.response.data['message'].toString(),
    //         );
    //       }
    //     } else {
    //       callback(
    //         false,
    //         true,
    //         apiResponse.response.data['message'].toString(),
    //       );
    //     }
    //     setOtpSendStatus(false);
    //   }
    // } catch (e) {
    //   Fluttertoast.showToast(msg: "Something went wrong");
    //   setOtpSendStatus(false);
    // }
    // notifyListeners();
  }

  // for onetime otp Send login
  // Future onTimeOtpSend(String email, Function callback) async {
  //   _isLoading = true;

  //   notifyListeners();
  //   ApiResponse apiResponse = await authRepo.onTimeOtpLogin(email);
  //   _isLoading = false;

  //   if (apiResponse.response.statusCode == 200) {
  //     callback(true, apiResponse.response.data['message']);
  //   } else {
  //     callback(false, apiResponse.error.toString());
  //   }
  //   notifyListeners();
  // }

  // TODO: for onetime  login
  Future onTimeLogin(String email, String code, BuildContext context,
      Function callback) async {
    _isLoading = true;
    // sharedPreferences.remove("address");
    // sharedPreferences.remove("location");

    notifyListeners();
    //  ApiResponse apiResponse = await authRepo.onTimeLogin(email, code, context);
    //   _isLoading = false;
    //   debugPrint('This is minhaz: ${apiResponse.response.data}');
    //
    //   if (apiResponse.response.statusCode == 200) {
    //     Map responseLocation = apiResponse.response.data['results'];
    //     print(
    //         "==============================>${responseLocation['addressLine1']}");
    //     if (authRepo.checkTokenExist()) {
    //       authRepo.clearUserInformation();
    //       authRepo.clearToken();
    //     } else {
    //       sharedPreferences.setString(
    //           "address", responseLocation['addressLine1']);
    //       sharedPreferences.setString("location", responseLocation['cityTextId']);
    //       authRepo.saveUserToken(apiResponse.response.data['Token'].toString());
    //       authRepo.saveUserInformation(
    //           responseLocation['id'].toString(),
    //           '${responseLocation['firstName']}',
    //           '${responseLocation['lastName']}',
    //           '${responseLocation['email']}',
    //           '${responseLocation['phone']}');
    //       name =
    //       '${responseLocation['firstName']} ${responseLocation['lastName']}';
    //       userID = '${responseLocation['id']}';
    //     }
    //     callback(true, 'Login Successfull');
    //   } else {
    //     callback(false, apiResponse.error.toString());
    //   }
    notifyListeners();
  }
  // for OTP Verify
  //
  // otpVerify(String code, String email, BuildContext context,Function callback) async {
  //   setOtpSendStatus(true);
  //   try {
  //     ApiResponse apiResponse = await authRepo.otpVerify(code, email, context);
  //
  //     debugPrint('Response Is: ${apiResponse.response}');
  //
  //     if (apiResponse.response.statusCode == 200) {
  //       callback(true, 'Successfully Verified');
  //       setOtpSendStatus(false);
  //     } else {
  //       callback(false, '${apiResponse.response}');
  //       setOtpSendStatus(false);
  //     }
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: "Something went wrong");
  //   }
  //   notifyListeners();
  // }

  String dateTime =
      "${DateTime.now().year.toString()}-${DateTime.now().month.toString()}-${DateTime.now().day.toString()}";
  String dateTimeForUser =
      "${DateTime.now().day.toString()}/${DateTime.now().month.toString()}/${DateTime.now().year.toString()}";

  void showDateDialog(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Theme(
          data: ThemeData.dark(),
          child: Container(
            height: 300,
            color: Colors.black,
            child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.now(),
                maximumDate: DateTime.now(),
                dateOrder: DatePickerDateOrder.dmy,
                onDateTimeChanged: (dateTimeValue) {
                  dateTime =
                      "${dateTimeValue.year.toString()}-${dateTimeValue.month.toString()}-${dateTimeValue.day.toString()}";
                  dateTimeForUser =
                      "${dateTimeValue.day.toString()}/${dateTimeValue.month.toString()}/${dateTimeValue.year.toString()}";
                  notifyListeners();
                }),
          ), // This will change to light theme.
        );
      },
    );
  }

  List<String> genderLists = ["Male", "Female", "Other"];

  String selectGender = "Male";

  changeGenderStatus(String status) {
    selectGender = status;
    notifyListeners();
  }

  //TODO: for Logout
  Future<bool> logout() async {
    // if (authRepo.checkTokenExist()) {
    //   authRepo.clearUserInformation();
    //   authRepo.clearToken();
    // }
    // authRepo.clearToken();
    // authRepo.clearUserInformation();
    return true;
  }

  // get User INFO:
  String name = '';
  String profileImage = '';
  String userID = '';
  String userCode = '';

//TODO: for country code picker
  String code = "US";

  void pickupCountry(BuildContext context) {
    showCountryPicker(
        context: context,
        countryListTheme: CountryListThemeData(
          flagSize: 20,
          backgroundColor: Colors.white,
          searchTextStyle: TextStyle(color: Colors.black),
          textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
          bottomSheetHeight: 500,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          //Optional. Styles the search field.
          inputDecoration: InputDecoration(
            fillColor: Color(0xFFE9E9E9),
            filled: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            hintText: 'Start typing to search',
            // prefixIcon: const Icon(Icons.search),
            prefixIcon: Container(
              margin: EdgeInsets.only(right: 12, left: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // Handle icon click here
                  print('Icon clicked');
                },
                child: CircleAvatar(
                  radius: 16,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 24,
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                width: 1.5,
                color: Colors.black,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        onSelect: (
          Country country,
        ) {
          //code = "+${country.phoneCode} (${country.countryCode})";
          code = "${country.countryCode}";
          debugPrint('code ${code}');
          notifyListeners();
        });
  }

  bool isSelectEmail = false;

  void changeSelectStatus(bool value) {
    isSelectEmail = value;
    notifyListeners();
  }

  bool isSelected = false;
  void changeSelectedStatus(bool value) {
    isSelected != isSelected;
    notifyListeners();
  }

  // TODO: fast page
  int menuValue = 0;

  changeMenuValue(int value) {
    menuValue = value;
    notifyListeners();
  }

  String dropDownValue = "";
  Map houseConfiguration = {};

  changeDropDownValue(
    String? newValue,
    Map whereInput,
  ) {
    whereInput.update("selectedValue", (value) => newValue);
    print("--------------${(whereInput['selectedValue'])}");

    notifyListeners();
  }

  bool userHouseConfig = false;
  changeHouseConfigValue(bool value) {
    userHouseConfig = value;
    // sharedPreferences.setBool('userConfig', value);
    notifyListeners();
  }

  houseConfigurationSave(Map houseConfig) async {
    String encodedMap = json.encode(houseConfig);

    print(encodedMap);

    //sharedPreferences.setString('houseConfigData', encodedMap);

    notifyListeners();
  }

  houseConfigurationUpdated() async {
    houseConfiguration.clear();
    // String encodedMap = sharedPreferences.getString('houseConfigData') ?? "";
    //  houseConfiguration = json.decode(encodedMap);
    print("-------------ready for second option-------$houseConfiguration");
    notifyListeners();
  }

  bool passwordError = false;
  changeErrorStatus(bool value) {
    passwordError = value;
    notifyListeners();
  }

  bool isFieldEmpty = false;
  changeFieldEmpty(bool value) {
    isFieldEmpty = value;
    notifyListeners();
  }

  bool isLastName = false;
  changeLastName(bool value) {
    isLastName = value;
    notifyListeners();
  }

  bool isEmail = false;
  changeEmail(bool value) {
    isEmail = value;
    notifyListeners();
  }

  bool isEmailCheck = false;
  changeEmailCheck(bool value) {
    isEmailCheck = value;
  }

  bool rongMail = false;
  changeRongMail(bool value) {
    rongMail = value;
    notifyListeners();
  }

  bool isCountry = false;
  changeCountry(bool value) {
    isCountry = value;
    notifyListeners();
  }

  bool isPhoneCheck = false;
  checkPhone(bool value) {
    isPhoneCheck = value;
    notifyListeners();
  }

  bool pnNumber = false;
  checkPnNumbervalue(bool value) {
    pnNumber = value;
    notifyListeners();
  }

  bool isPhone = false;
  changePhone(bool value) {
    isPhone = value;
    notifyListeners();
  }

  bool isPassword = false;
  changePassword(bool value) {
    isPassword = value;
    notifyListeners();
  }

  bool myEmailError = false;
  String myEmailErrMessage = '';
  setMyEmailError(bool value) {
    myEmailError = value;
    mySignUpErrorBox = false;
    myPasswordErrorBox = false;
    notifyListeners();
  }

  bool checkEmailError(String? text) {
    if (text == "" || text == null || text.isEmpty) {
      myEmailError = true;
      mySignUpErrorBox = false;
      myPasswordErrorBox = false;
      myEmailErrMessage = 'Email is required';
      notifyListeners();
      return false;
    } else if (RegExp(
                r"^[a-zA-Z0-9.a-zA-Z\d.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(text) ==
        false) {
      myEmailError = true;
      mySignUpErrorBox = false;
      myPasswordErrorBox = false;
      myEmailErrMessage = 'Please enter valid email';
      notifyListeners();
      return false;
    } else {
      myEmailError = false;
      mySignUpErrorBox = false;
      myPasswordErrorBox = false;
      notifyListeners();
      return true;
    }
  }

  bool myPasswordError = false;
  String myPasswordErrMessage = '';
  setMyPasswordError(bool value) {
    myPasswordError = value;
    mySignUpErrorBox = false;
    myPasswordErrorBox = false;
    notifyListeners();
  }

  bool checkPasswordError(String? text) {
    if (text == "" || text == null || text.isEmpty) {
      myPasswordError = true;
      mySignUpErrorBox = false;
      myPasswordErrorBox = false;
      myPasswordErrMessage = 'Password is required';
      notifyListeners();
      return false;
    } else if (text.length < 8) {
      myPasswordError = true;
      mySignUpErrorBox = false;
      myPasswordErrorBox = false;
      myPasswordErrMessage = 'Password must be at least 8 character';
      notifyListeners();
      return false;
    } else {
      myPasswordError = false;
      mySignUpErrorBox = false;
      myPasswordErrorBox = false;
      notifyListeners();
      return true;
    }
  }

  bool mySignUpErrorBox = false;
  void showSignUpErrorBox(bool val) {
    mySignUpErrorBox = true;
    myPasswordErrorBox = false;
    notifyListeners();
  }

  bool myPasswordErrorBox = false;

  void showPasswordErrorBox(bool val) {
    myPasswordErrorBox = true;
    mySignUpErrorBox = false;
    notifyListeners();
  }
}
