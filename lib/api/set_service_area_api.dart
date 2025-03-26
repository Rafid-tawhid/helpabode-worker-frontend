import 'dart:convert';

import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:http/http.dart';

Future<bool> setServiceList() async {
  print("Set Service List");

  try {
    print("try");
    var data = {
      'franchiseTextId': 'akkasali4743@gmail.com',
      'workerTextId': 'akkasali4483@gmail.com',
      'cityTextId': 'Dhaka',
      'areaTextId': 'Mymensingh'
    };
    var body = jsonEncode(data);
    print("before post");
    Response response = await post(
      Uri.parse("${urlBase}api/WorkerCitySelection"),
      body: body,
    );
    var responseDecodeJson = jsonDecode(response.statusCode.toString());
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
