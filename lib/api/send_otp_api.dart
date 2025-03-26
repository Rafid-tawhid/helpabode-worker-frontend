import 'dart:convert';

import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:http/http.dart';

Future<String> sendOTPApi(String emailText, String otpCode) async {
  print("Send OTP API Start");
  try {
    print("try");
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
    var responseDecodeJson = jsonDecode(response.statusCode.toString());
    print(responseDecodeJson);
    if (responseDecodeJson.toString() == '200') {
      print(response.body);
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
