import 'dart:convert';

import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:http/http.dart';

Future<bool> deleteCityAreaData(
  String workerTextId,
  String zipcode,
) async {
  try {
    var data = {
      "workerTextId": "${workerTextId}",
      "zipCode": "${zipcode}",
    };
    print('DELETED DATA ${data}');
    var header = {
      "Authorization": "Bearer ${token}",
    };
    // var body = jsonEncode(data);
    Response response = await delete(
        Uri.parse("${urlBase}api/WorkerCityDelete"),
        body: data,
        headers: header);
    print('Delete Response Json');
    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      var responseDecodeJson = jsonDecode(response.body);
      print('Success Delete');
      print(responseDecodeJson);

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
