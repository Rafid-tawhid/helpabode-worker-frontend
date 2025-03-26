import 'dart:convert';

import 'package:http/http.dart';

import '../misc/constants.dart';

class DashboardApi {
  static Future<dynamic> getCityAndAreaData() async {
    try {
      print("try");

      print("Area and city");

      var header = {
        "Authorization": "Bearer ${token}",
      };

      Response response = await get(
        Uri.parse("${urlBase}api/WorkerCitySelection"),
        headers: header,
      );

      if (response.statusCode == 200) {
        var responseDecodeJson = jsonDecode(response.body);
        print('Response Json 33 ');
        print(responseDecodeJson);
        return responseDecodeJson;
      } else {
        return null;
      }
    } catch (e) {
      print("catch");
      print(e);
      return null;
    }
  }

  static Future<dynamic> setWorkersCityBySearch(dynamic lists) async {
    print('LISTS ${lists.toString()}');
    try {
      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };

      Response response = await post(
          Uri.parse("${urlBase}api/WorkerCitySelection"),
          headers: header,
          body: jsonEncode(lists));

      print('RETURN CITY RESPONSE ${jsonDecode(response.body)}');

      if (response.statusCode == 200) {
        var responseDecodeJson = jsonDecode(response.body);
        print('Response Json 1');
        print(responseDecodeJson);
        return responseDecodeJson;
      } else if (response.statusCode == 409) {
        var responseDecodeJson = jsonDecode(response.body);
        print('Response Json 2');
        print(responseDecodeJson);
        return responseDecodeJson;
      } else {
        return null;
      }
    } catch (e) {
      print("catch");
      print(e);
      return null;
    }
  }

  static Future<Response?> updateWorkerData(dynamic userInfo) async {
    print('SEND USER RESPONSE ${userInfo.toString()}');
    try {
      print("try");

      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };

      Response response = await put(
          Uri.parse("${urlBase}api/WorkerProfileUpdate"),
          headers: header,
          body: jsonEncode(userInfo));
      print('SERVER RESPONSE ${response.body.toString()}');
      //Response response = await get(Uri.parse("http://dummyjson.com/users"));

      return response;
    } catch (e) {
      print("catch");
      print(e);
      return null;
    }
  }
}
