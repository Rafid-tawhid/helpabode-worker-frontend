import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper_functions/signin_signup_helpers.dart';
import '../provider/corporate_provider.dart';
import '../widgets_reuse/custom_snackbar_message.dart';

Future<String?> signUpApi(
    String fNameText,
    String lNameText,
    String emailText,
    String phoneText,
    String countryCodeText,
    String passwordText,
    String type,
    BuildContext context) async {
  print(
      "Sign Up Data: $fNameText, $lNameText, $emailText, $phoneText, $countryCodeText");

  userBox = Hive.box('registrationBox');

  AnimationController? localAnimationController;

  final data = {
    'firstName': fNameText,
    'lastName': lNameText,
    'email': emailText,
    'phone': phoneText,
    'countryCode': countryCodeText,
    'password': passwordText,
    'emplyeeType':
        type, // corrected the key from 'emplyeeType' to 'employeeType'
  };

  final body = jsonEncode(data);
  print("Request Body: $body");

  try {
    final response = await post(
      Uri.parse("${urlBase}api/workerSignUp"),
      body: body,
      headers: {
        'Content-Type': 'application/json'
      }, // Added headers to ensure JSON encoding
    );

    print('SIGN UP RESPONSE: ${response.body}');

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body)['data'];

      if (type == 'Corporate') {
        //save worker_roles
        Provider.of<CorporateProvider>(context, listen: false)
            .setAffiliationList(jsonDecode(response.body)['worker_roles']);

        // Save corporation_type_array
        Provider.of<CorporateProvider>(context, listen: false)
            .setCorporation_type_arrayList(
                jsonDecode(response.body)['corporation_type_array']);
      }

      // await userBox.put('status', responseData['status']);
      // await userBox.put('token', jsonDecode(response.body)['token']);
      // await userBox.put('textId', responseData['textId']);
      // await userBox.put('franchiseTextId', responseData['franchiseTextId']);
      // await userBox.put('firstName', responseData['firstName']);
      // await userBox.put('lastName', responseData['lastName']);
      //
      // textId = userBox.get('textId');
      // franchiseTextId = userBox.get('franchiseTextId');
      // token = token;

      SignInSignUpHelpers prefHelper = SignInSignUpHelpers();
      await prefHelper.saveString(
          'employeeType', jsonDecode(response.body)['data']['employeeType']);
      await prefHelper.saveString(
          'status', jsonDecode(response.body)['data']['status']);
      await prefHelper.saveString(
          'textId', jsonDecode(response.body)['data']['textId']);
      await prefHelper.saveString('franchiseTextId',
          jsonDecode(response.body)['data']['franchiseTextId']);
      await prefHelper.saveString('token', jsonDecode(response.body)['token']);
      await prefHelper.saveString('workerInAppNotificationTextId',
          jsonDecode(response.body)['data']['workerInAppNotificationTextId']);

      //get dall saved data
      funcHiveToken();

      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('employeeType', responseData['employeeType']);
      print('Employee Type saved: ${pref.getString('employeeType')}');

      return '201';
    } else if (response.statusCode == 409 || response.statusCode == 400) {
      final responseMessage = jsonDecode(response.body)['message'] ?? '';
      print('Error: $responseMessage');

      showCustomSnackBar(
        context,
        responseMessage,
        Colors.red,
        snackBarNeutralTextStyle,
        localAnimationController,
      );

      return response.statusCode.toString();
    } else {
      print('Unexpected Error: ${response.body}');
      DashboardHelpers.showAlert(msg: 'Something went wrong');
      return null;
    }
  } catch (e) {
    print("Exception caught: $e");
    DashboardHelpers.showAlert(msg: 'Something went wrong');
    return null;
  }
}

funcHiveToken() async {
  SignInSignUpHelpers signInSignUpHelpers = SignInSignUpHelpers();
  textId = await signInSignUpHelpers.getString("textId");
  token = await signInSignUpHelpers.getString("token");
  status = await signInSignUpHelpers.getString("status");
  franchiseTextId = await signInSignUpHelpers.getString("franchiseTextId");
  employeeType = await signInSignUpHelpers.getString("employeeType");
  debugPrint('TEXT ID: ${textId}');
  debugPrint('TOKEN: ${token}');
  debugPrint('STATUS: ${status}');
}
