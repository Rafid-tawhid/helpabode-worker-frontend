import 'dart:convert';

import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:http/http.dart';

Future<bool> resetPasswordApi(String emailText, String passwordText) async {
  print("hello_1");

  print(emailText);

  print(passwordText);

  try {
    print("try");
    var data = {
      'email': emailText,
      'password': passwordText,
    };
    var body = jsonEncode(data);
    print("before post");
    Response response = await post(
      Uri.parse("${urlBase}api/workersPasswordReset"),
      body: body,
    );
    var responseDecodeJson = jsonDecode(response.statusCode.toString());
    print(response.body);
    print(responseDecodeJson);
    if (responseDecodeJson.toString() == '200') {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print("catch");
    print(e);
    return false;
  }
}
