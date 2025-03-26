import 'dart:convert';

import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:http/http.dart';

Future<bool> getServiceList() async {
  print("Get Service List");

  try {
    print("try");

    print("before post");
    Response response =
        await get(Uri.parse("${urlBase}api/WorkerCitySelection"));
    var responseDecodeJson = jsonDecode(response.body);
    print(responseDecodeJson);

    var city_list = responseDecodeJson['city_list'];

    var area_list = responseDecodeJson['area_list'];

    for (var elem in city_list) {
      service_area_list[0].add(elem['title']);
    }

    for (var elem in area_list) {
      service_area_list[1].add(elem['title']);
    }

    print(service_area_list);

    return true;
  } catch (e) {
    print("catch");
    print(e);
    return false;
  }
}
