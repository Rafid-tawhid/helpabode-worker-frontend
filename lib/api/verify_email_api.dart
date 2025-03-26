import 'dart:convert';

import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> verifyEmailApi(String emailText) async {
  print("Send OTP API Start");
  //save user name to show
  SharedPreferences pref = await SharedPreferences.getInstance();

  print(emailText);

  try {
    print("try");
    var data = {'email': emailText};
    var body = jsonEncode(data);
    print("before post");
    Response response = await post(
      Uri.parse("${urlBase}api/sendOtpForforgotPassword"),
      body: body,
    );
    var responseDecodeJson = jsonDecode(response.statusCode.toString());
    print('otp response ${responseDecodeJson}');
    print('URL :${urlBase}api/sendOtpForforgotPassword');
    pref.setString('f_name', jsonDecode(response.body)['providerName'] ?? '');
    if (responseDecodeJson.toString() == '200') {
      return '200';
    } else {
      return '404';
    }
  } catch (e) {
    print("catch");
    print(e);
    return '500';
  }
}
