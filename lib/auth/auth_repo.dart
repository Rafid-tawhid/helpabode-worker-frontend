double progressPercent = 0;

// class AuthRepo {
//   final DioClient dioClient;
//   final SharedPreferences sharedPreferences;
//
//   AuthRepo({required this.dioClient, required this.sharedPreferences});
//
//   Future<ApiResponse> emailCheck(String email, {ProgressCallback? onSendProgress}) async {
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     try {
//       Map map = {"email": email};
//
//       response = await dioClient.post(AppConstant.signInURI, data: map, onSendProgress: onSendProgress);
//       return ApiResponse.withSuccess(response);
//     } catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
//     }
//   }
//
//   updateUserData(FormData userData) async {
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     try {
//       response = await dioClient.post(
//         AppConstant.editUserInformationUrl,
//         data: userData,
//       );
//       Fluttertoast.showToast(msg: '${response.data['message']}');
//       return ApiResponse.withSuccess(response);
//     } catch (error) {
//       if (error is DioException) {
//         if (error.response != null) {
//           debugPrint("DioException data: ${error.response!.statusCode}");
//           Fluttertoast.showToast(msg: 'Something went wrong: ${error.response!.statusCode}');
//         } else {
//           debugPrint("DioException without response: $error");
//           Fluttertoast.showToast(msg: 'Something went wrong');
//         }
//       } else {
//         debugPrint("Error: $error");
//         Fluttertoast.showToast(msg: 'Failed');
//       }
//
//       return ApiResponse.withError(ApiErrorHandler.getMessage(error), response);
//     }
//   }
//
//   changeUserPassword(BuildContext context, Map<String, String> userData) async {
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     var authProvider = context.read<AuthProvider>();
//     try {
//       response = await dioClient.post(
//         AppConstant.setNewPasswordURI,
//         data: userData,
//       );
//       authProvider.setApiStatus(code: response.statusCode ?? 300, status: response.data['message']);
//       Fluttertoast.showToast(msg: '${response.data['message']}');
//       return ApiResponse.withSuccess(response);
//     } catch (error) {
//       // debugPrint('Error : $error');
//       if (error is DioException) {
//         // Check if the response is available
//         if (error.response != null) {
//           authProvider.setApiStatus(
//             code: error.response!.statusCode ?? 300,
//             status: error.response!.data['message'],
//           );
//           // debugPrint("DioException: ${error.response!.statusCode}");
//           // debugPrint("DioException data: ${error.response!.data}");
//           // Fluttertoast.showToast(msg: '${error.response!.data['message']}');
//         } else {
//           // debugPrint("DioException without response: $error");
//         }
//       } else {
//         // debugPrint("Error: $error");
//       }
//
//       return ApiResponse.withError(ApiErrorHandler.getMessage(error), response);
//     }
//   }
//
//   // getUserInformation() async {
//   //   Response response = Response(requestOptions: RequestOptions(path: '22222'));
//   //   try {
//   //     response = await dioClient.get(AppConstant.userInformationUrl);
//   //     Fluttertoast.showToast(msg: '${response.data}');
//
//   //     return ApiResponse.withSuccess(response);
//   //   } catch (e) {
//   //     Fluttertoast.showToast(msg: 'Post Error :${response.statusCode}');
//   //     return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
//   //   }
//   // }
//
//   //UserSavedCardListRepo
//   Future<ApiResponse> getUserInformation({ProgressCallback? onSendProgress}) async {
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     try {
//       response = await dioClient.get(
//         AppConstant.userInformationUrl,
//       );
//       debugPrint("Error: 1");
//       return ApiResponse.withSuccess(response);
//     } catch (error) {
//       debugPrint('Error : $error');
//       if (error is DioException) {
//         if (error.response != null) {
//           if (error.response!.statusCode == 401) {
//             SharedPreferences sp = await SharedPreferences.getInstance();
//             sp.setString(AppConstant.token, '');
//           }
//           debugPrint("DioException: ${error.response!.statusCode}: ${error.response!.statusMessage} ");
//         } else {
//           debugPrint("DioException without response: $error");
//         }
//       } else {
//         debugPrint("Error: $error");
//       }
//       return ApiResponse.withError(ApiErrorHandler.getMessage(error), response);
//     }
//   }
//
//   //TODO: longin sector
//   Future<ApiResponse> login(String email, String confirmPassword, {ProgressCallback? onSendProgress}) async {
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     Map map = {"email": email, "password": confirmPassword};
//
//     try {
//       debugPrint("show password============>$map");
//       response = await dioClient.post(AppConstant.signInEmailPassURI, data: map, onSendProgress: onSendProgress);
//       return ApiResponse.withSuccess(response);
//     } catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
//     }
//   }
//
//   Future<ApiResponse> signup(String firstName, String lastName, String email, String phoneNumber, String countryCode, String password, {ProgressCallback? onSendProgress}) async {
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     Map map = {"firstName": firstName, "lastName": lastName, "phone": phoneNumber, "email": email, "password": password, "countryCode": countryCode};
//     try {
//       response = await dioClient.post(
//         AppConstant.signupURI,
//         data: map,
//         onSendProgress: onSendProgress,
//       );
//       return ApiResponse.withSuccess(response);
//     } catch (error) {
//       debugPrint('Error : $error');
//       if (error is DioException) {
//         if (error.response != null) {
//           debugPrint("DioException: ${error.response!.data['message']}");
//         } else {
//           debugPrint("DioException without response: $error");
//         }
//       } else {
//         debugPrint("Error: $error");
//       }
//       return ApiResponse.withError(ApiErrorHandler.getMessage(error), response);
//     }
//     // try {
//     //   response = await dioClient.post(
//     //     AppConstant.signupURI,
//     //     data: map,
//     //     onSendProgress: onSendProgress,
//     //   );
//     //   debugPrint('Error Response is: ${response.toString()}');
//     //   return ApiResponse.withSuccess(response);
//     // } on DioException catch (e) {
//     //   return ApiResponse.withError(
//     //       ApiErrorHandler.getMessage(e.response), e.response!);
//     //   // return e;
//     // }
//   }
//
//   //TODO:Send User Adress
//   Future<ApiResponse> sendAdress(String name, String street, String countryIso2Code, String doorCode, String country, String postalCode, String administrativeArea, String subadministrativeArea, String locality, String sublocality, String thoroughfare, String subthoroughfare, double latitude, double longitude, String apartment, {ProgressCallback? onSendProgress}) async {
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     Map map = {
//       "name": name,
//       "street": street,
//       "countryIso2Code": countryIso2Code,
//       "doorCode": doorCode,
//       "postalCode": postalCode,
//       "administrativeArea": administrativeArea,
//       "subadministrativeArea": subadministrativeArea,
//       "locality": locality,
//       "sublocality": sublocality,
//       "thoroughfare": thoroughfare,
//       "subthoroughfare": subthoroughfare,
//       "latitude": latitude,
//       "longitude": longitude,
//       "apartment": apartment,
//     };
//
//     try {
//       response = await dioClient.post(
//         "address/EndUserAddressView",
//         data: map,
//         onSendProgress: onSendProgress,
//       );
//       debugPrint("===============Address Saved Successfully =====$map ");
//       await sharedPreferences.remove('postal_code');
//       await sharedPreferences.setString('postal_code', map['postalCode']);
//       debugPrint('======Postal Code======= ${sharedPreferences.getString('postal_code')}');
//       return ApiResponse.withSuccess(response);
//     } on DioException catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e.response), e.response!);
//     }
//     // } catch (e) {
//     //   return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
//     // }
//   }
//
//   Future<ApiResponse> updateAddress(AddressModel addressModel, {ProgressCallback? onSendProgress}) async {
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     Map map = {
//       "id": addressModel.id,
//       "textId": addressModel.textId,
//       "latitude": addressModel.latitude,
//       "longitude": addressModel.longitude,
//       "postalCode": addressModel.postalCode,
//       "street": addressModel.street,
//       "apartment": addressModel.apartment,
//       "doorCode": addressModel.doorCode,
//       "city": addressModel.city,
//       "administrativeArea": addressModel.administrativeArea,
//       "countryIso2Code": addressModel.countryIso2Code,
//       // "country": addressModel.country,
//       "isDefault": addressModel.isDefault,
//     };
//
//     debugPrint("===============ok boy =====$map ");
//     // try {
//     // response = await dioClient.put(
//     //   AppConstant.updateAddressURI,
//     //   data: map,
//     //   onSendProgress: onSendProgress,
//     // );
//     //   return ApiResponse.withSuccess(response);
//     // } catch (e) {
//     //   return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
//     // }
//     try {
//       response = await dioClient.put(
//         AppConstant.updateAddressURI,
//         data: map,
//         onSendProgress: onSendProgress,
//       );
//       debugPrint('Response is: ${response.toString()}');
//       // debugPrint("===============Address Upadate Successfully =====$map ");
//       // await sharedPreferences.remove('postal_code');
//       // await sharedPreferences.setString('postal_code', map['postalCode']);
//       // debugPrint(
//       //     '======Postal Code======= ${sharedPreferences.getString('postal_code')}');
//       return ApiResponse.withSuccess(response);
//     } on DioException catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e.response), e.response!);
//       // return e;
//     }
//   }
//
//   Future<ApiResponse> deleteAddress(String textId, {ProgressCallback? onSendProgress}) async {
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     try {
//       response = await dioClient.delete('${AppConstant.deleteAddressURI}/$textId/');
//       debugPrint('Error Response is: ${response.toString()}');
//       return ApiResponse.withSuccess(response);
//     } on DioException catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e.response), e.response!);
//     }
//   }
//
//   Future<ApiResponse> changeDefaultAddress(String textId, {ProgressCallback? onSendProgress}) async {
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     Map<String, String> map = {"textId": textId};
//     try {
//       response = await dioClient.put(AppConstant.changeDefaultAddressURI, data: map);
//       debugPrint('Error Response is: ${response.toString()}');
//       return ApiResponse.withSuccess(response);
//     } on DioException catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e.response), e.response!);
//     }
//   }
//
//   Future<ApiResponse> setNewPassword(String email, String newPassword, {ProgressCallback? onSendProgress}) async {
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     try {
//       Map map = {"email": email, "password": newPassword};
//
//       response = await dioClient.post(AppConstant.resetPasswordURI, data: map, onSendProgress: onSendProgress);
//       return ApiResponse.withSuccess(response);
//     } catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
//     }
//   }
//
//   Future<ApiResponse> getMultipleAddress() async {
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     try {
//       response = await dioClient.get(AppConstant.multipleAddressURI);
//       debugPrint('Multiple addresses list: ${response.toString()}');
//       return ApiResponse.withSuccess(response);
//     } on DioException catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e.response), e.response!);
//       // return e;
//     }
//   }
//
//   Future<ApiResponse> otpSend(String email, {ProgressCallback? onSendProgress}) async {
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     try {
//       Map map = {
//         "email": email,
//       };
//       response = await dioClient.post(AppConstant.otpSendURI, data: map, onSendProgress: onSendProgress);
//       debugPrint('Error Response is: ${response.toString()}');
//       return ApiResponse.withSuccess(response);
//     } on DioException catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e.response), e.response!);
//       // return e;
//     }
//   }
//
//   Future<ApiResponse> onTimeOtpLogin(String email, {ProgressCallback? onSendProgress}) async {
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     try {
//       Map map = {
//         "email": email,
//       };
//       response = await dioClient.post(AppConstant.oneTimePasscodeLogin, data: map, onSendProgress: onSendProgress);
//       debugPrint('Error Response is: ${response.toString()}');
//       return ApiResponse.withSuccess(response);
//     } on DioException catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e.response), e.response!);
//       // return e;
//     }
//   }
//
//   // Future<ApiResponse> onTimeOtpLogin(String email,
//   //     {ProgressCallback? onSendProgress}) async {
//   //   Response response = Response(requestOptions: RequestOptions(path: '22222'));
//   //   try {
//   //     Map map = {
//   //       "email": email,
//   //     };
//   //     response = await dioClient.post(AppConstant.oneTimePasscodeLogin,
//   //         data: map, onSendProgress: onSendProgress);
//   //     return ApiResponse.withSuccess(response);
//   //   } catch (e) {
//   //     return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
//   //   }
//   // }
//
//   Future<ApiResponse> houseConfig(String houseConfig, {ProgressCallback? onSendProgress}) async {
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     try {
//       Map map = {
//         "confHouse1": houseConfig,
//       };
//       response = await dioClient.post(AppConstant.houseConfigurationPost, data: map, onSendProgress: onSendProgress);
//       return ApiResponse.withSuccess(response);
//     } catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
//     }
//   }
//
//   Future<ApiResponse> onTimeLogin(String email, String code, BuildContext context, {ProgressCallback? onSendProgress}) async {
//     // Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     // try {
//     //   Map map = {
//     //     "email": email,
//     //     "otp_code": code,
//     //   };
//
//     //   response = await dioClient.post(AppConstant.signInViaOtp,
//     //       data: map, onSendProgress: onSendProgress);
//     //   return ApiResponse.withSuccess(response);
//     // } catch (e) {
//     //   return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
//     // }
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     var authProvider = context.read<AuthProvider>();
//     Map map = {"email": email, "otp_code": code};
//     try {
//       response = await dioClient.post(
//         AppConstant.signInViaOtp,
//         data: map,
//       );
//       authProvider.setApiStatus(code: response.statusCode ?? 300, status: response.data['message']);
//       Fluttertoast.showToast(
//         msg: '${response.data['message']}',
//       );
//       return ApiResponse.withSuccess(response);
//     } catch (error) {
//       debugPrint('Error : $error');
//       if (error is DioException) {
//         // Check if the response is available
//         if (error.response != null) {
//           authProvider.setApiStatus(
//             code: error.response!.statusCode ?? 300,
//             status: error.response!.data['message'],
//           );
//           debugPrint("DioException: ${error.response!.statusCode}");
//           debugPrint("DioException data: ${error.response!.data}");
//           // Fluttertoast.showToast(msg: '${error.response!.data['message']}');
//         } else {
//           debugPrint("DioException without response: $error");
//         }
//       } else {
//         debugPrint("Error: $error");
//       }
//
//       return ApiResponse.withError(ApiErrorHandler.getMessage(error), response);
//     }
//   }
//
//   Future<ApiResponse> otpVerify(String code, String email, BuildContext context, {ProgressCallback? onSendProgress}) async {
//     // Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     // try {
//     //   Map map = {"email": email, "otp_code": code};
//     //   debugPrint(map.toString());
//     //   response = await dioClient.post(AppConstant.otpVerifyURI,
//     //       data: map, onSendProgress: onSendProgress);
//     //   return ApiResponse.withSuccess(response);
//     // } catch (e) {
//     //   return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
//     // }
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     var authProvider = context.read<AuthProvider>();
//     Map map = {"email": email, "otp_code": code};
//     try {
//       response = await dioClient.post(
//         AppConstant.otpVerifyURI,
//         data: map,
//       );
//       authProvider.setApiStatus(code: response.statusCode ?? 300, status: response.data['message']);
//       Fluttertoast.showToast(
//         msg: '${response.data['message']}',
//       );
//       return ApiResponse.withSuccess(response);
//     } catch (error) {
//       debugPrint('Error : $error');
//       if (error is DioException) {
//         // Check if the response is available
//         if (error.response != null) {
//           authProvider.setApiStatus(
//             code: error.response!.statusCode ?? 300,
//             status: error.response!.data['message'],
//           );
//           debugPrint("DioException: ${error.response!.statusCode}");
//           debugPrint("DioException data: ${error.response!.data}");
//           // Fluttertoast.showToast(msg: '${error.response!.data['message']}');
//         } else {
//           debugPrint("DioException without response: $error");
//         }
//       } else {
//         debugPrint("Error: $error");
//       }
//
//       return ApiResponse.withError(ApiErrorHandler.getMessage(error), response);
//     }
//   }
//
//   Future<ApiResponse> houseConfigurationRepo({ProgressCallback? onSendProgress}) async {
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     try {
//       response = await dioClient.get(
//         AppConstant.houseConfigurationUrl,
//       );
//       // Fluttertoast.showToast(
//       //   msg: '${response.data['message']}',
//       // );
//       return ApiResponse.withSuccess(response);
//     } catch (error) {
//       debugPrint('Error : $error');
//       if (error is DioException) {
//         if (error.response != null) {
//           debugPrint("DioException: ${error.response!.statusCode}");
//           // debugPrint("DioException data: ${error.response!.data}");
//         } else {
//           debugPrint("DioException without response: $error");
//         }
//       } else {
//         debugPrint("Error: $error");
//       }
//       return ApiResponse.withError(ApiErrorHandler.getMessage(error), response);
//     }
//   }
//
//   Future<ApiResponse> saveHouseConfigurationRepo(Map<String, dynamic> savedData, bool isSaved, {ProgressCallback? onSendProgress}) async {
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     try {
//       response = !isSaved
//           ? await dioClient.post(
//               AppConstant.saveHouseConfigurationUrl,
//               data: savedData,
//             )
//           : await dioClient.put(
//               AppConstant.updateHouseConfigurationUrl,
//               data: savedData,
//             );
//       // Fluttertoast.showToast(
//       //   msg: '${response.data['message']}',
//       // );
//       return ApiResponse.withSuccess(response);
//     } catch (error) {
//       debugPrint('Error : $error');
//       if (error is DioException) {
//         if (error.response != null) {
//           debugPrint("DioException: ${error.response!.statusCode}");
//           // debugPrint("DioException data: ${error.response!.data}");
//         } else {
//           debugPrint("DioException without response: $error");
//         }
//       } else {
//         debugPrint("Error: $error");
//       }
//       return ApiResponse.withError(ApiErrorHandler.getMessage(error), response);
//     }
//   }
//
//   Future<ApiResponse> getUserLocationLatLong(double? lat, double? long) async {
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     try {
//       response = await dioClient.get("https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=AIzaSyAwpFYRk4i1gCEXqDepia2LXtsNuuMHkEY");
//       return ApiResponse.withSuccess(response);
//     } catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
//     }
//   }
//
//   Future<ApiResponse> getUserDetailsLocation(String placeId) async {
//     Response response = Response(requestOptions: RequestOptions(path: '22222'));
//     try {
//       response = await dioClient.get("https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyAwpFYRk4i1gCEXqDepia2LXtsNuuMHkEY");
//       return ApiResponse.withSuccess(response);
//     } catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
//     }
//   }
//
//   //TODO: for save User Information
//   Future<void> saveUserInformation(String userID, String fastName, String lastName, String phone, String email) async {
//     try {
//       await sharedPreferences.setString(AppConstant.userID, userID);
//       await sharedPreferences.setString(AppConstant.userEmail, email);
//       await sharedPreferences.setString(AppConstant.usercode, phone);
//       await sharedPreferences.setString(AppConstant.userName, fastName);
//       await sharedPreferences.setString(AppConstant.lastNAme, lastName);
//       getUserProfile();
//       getUserName();
//       getUserID();
//       getUserCode();
//       getUserEmail();
//     } catch (e) {
//       rethrow;
//     }
//   }
//   //TODO: for save User Adress
//
//   // Future<void> changeUserImage(String image) async {
//   //   try {
//   //     await sharedPreferences.setString(AppConstant.userProfileImage, image);
//   //   } catch (e) {
//   //     rethrow;
//   //   }
//   // }
//
//   Future<ApiResponse> getHouseConfiguration(bool isITFromLogin) async {
//     Response response = Response(requestOptions: RequestOptions());
//     try {
//       if (isITFromLogin == true) {
//         response = await dioClient.get(AppConstant.houseConfiguration);
//       } else {
//         response = await dioClient.get(AppConstant.houseConfigurationUpdate);
//       }
//       // debugPrint(response.data);
//
//       return ApiResponse.withSuccess(response);
//     } catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e), response);
//     }
//   }
//
//   Future<void> changeUserName(String value) async {
//     try {
//       await sharedPreferences.setString(AppConstant.userName, value);
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   //TODO:: for get User Information
//   String getUserID() {
//     return sharedPreferences.getString(AppConstant.userID) ?? "";
//   }
//
//   String getUserName() {
//     return sharedPreferences.getString(AppConstant.userName) ?? "";
//   }
//
//   String getUserEmail() {
//     return sharedPreferences.getString(AppConstant.userEmail) ?? "";
//   }
//
//   String getUserCode() {
//     return sharedPreferences.getString(AppConstant.usercode) ?? "";
//   }
//
//   String getUserProfile() {
//     return sharedPreferences.getString(AppConstant.lastNAme) ?? "";
//   }
//
//   String getUseradress() {
//     return sharedPreferences.getString(AppConstant.address) ?? "";
//   }
//
//   String getlocation() {
//     return sharedPreferences.getString(AppConstant.location) ?? "";
//   }
//
//   // TODO; clear all user Information
//   Future<bool> clearUserInformation() async {
//     await sharedPreferences.remove(AppConstant.token);
//     await sharedPreferences.remove(AppConstant.userID);
//     await sharedPreferences.remove(AppConstant.userName);
//     await sharedPreferences.remove(AppConstant.userEmail);
//     await sharedPreferences.remove(AppConstant.usercode);
//     return await sharedPreferences.remove(AppConstant.lastNAme);
//   }
//
//   // for  user token
//   Future<void> removeUserToken() async {
//     dioClient.token = null;
//     dioClient.dio!.options.headers = {
//       'Content-Type': 'application/json',
//     };
//     clearToken();
//   }
//
//   // for  user token
//   Future<void> saveUserToken(String token) async {
//     dioClient.token = token;
//     dioClient.dio!.options.headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
//
//     try {
//       await sharedPreferences.setString(AppConstant.token, token);
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   bool checkTokenExist() {
//     return sharedPreferences.containsKey(AppConstant.token);
//   }
//
//   String getUserToken() {
//     return sharedPreferences.getString(AppConstant.token) ?? "";
//   }
//
//   bool isLoggedIn() {
//     return sharedPreferences.containsKey(AppConstant.token);
//   }
//
//   Future<bool> clearToken() async {
//     return sharedPreferences.remove(AppConstant.token);
//   }
// }

bool isNumeric(String s) {
  if (s.isEmpty) {
    return false;
  }
  return double.tryParse(s) != null;
}
