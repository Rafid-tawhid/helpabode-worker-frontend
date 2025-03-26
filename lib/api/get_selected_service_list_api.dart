import 'dart:convert';

import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:http/http.dart';

Future<bool> getSelectedServiceList() async {
  print("Get Selected Service List");

  try {
    print("try");

    print("before post");
    Response response =
        await get(Uri.parse("${urlBase}api/WorkerServiceWithPrice"));
    var responseDecodeJson = jsonDecode(response.body);
    print(responseDecodeJson);

    var service_list = responseDecodeJson['service_list'];

    var worker_service = responseDecodeJson['worker_service'];

    for (var elem in service_list) {
      serviceListWorkerScreen.add(elem['title']);
    }

    for (var elem in worker_service) {
      serviceListSelectedWorkerScreen.add(elem['serviceTextId']);
    }

    print(service_area_list);

    return true;
  } catch (e) {
    print("catch");
    print(e);
    return false;
  }
}
