import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../helper_functions/dashboard_helpers.dart';
import '../misc/constants.dart';
import '../models/my_selected_zone_model.dart';
import '../models/my_service_zone_model.dart';
import '../models/worker_area_model.dart';

class ShowServiceProvider extends ChangeNotifier {
  List<MyServiceZoneModel> myWorkServiceList = [];
  List<WorkerAreaModel> workerServiceAreaList = [];
  List<MySelectedZoneModel> mySelectedZoneList = [];

  Future<bool> getMySelectedServiceZone() async {
    try {
      print("Service is calling.....1 2 3");

      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };

      Response response = await get(
        Uri.parse("${urlBase}service/GetMySelectedServiceZoneNeW/"),
        headers: header,
      );
      var responseDecodeJson = jsonDecode(response.body);
      print('STATUS CODE ${response.statusCode}');
      // print('getMySelectedServiceZone RESPONSE BODY ${responseDecodeJson}');
      if (response.statusCode == 201) {
        mySelectedZoneList.clear();
        for (Map i in responseDecodeJson['results']) {
          mySelectedZoneList.add(MySelectedZoneModel.fromJson(i));
        }
        print('mainServiceList ${mySelectedZoneList.length}');

        notifyListeners();
      }
      return true;
    } catch (e) {
      print("catch");
      DashboardHelpers.showAlert(msg: 'Something went wrong');
      print(e);
      return false;
    }
  }

  List<String> getAllZonesInfo(String title, String zoneName) {
    List<String> info = [];
    myWorkServiceList.forEach((element) {
      if (element.categoryTitle == title) {
        element.values!.forEach((element) {
          if (element.workerZoneTitle == zoneName) {
            info.add(
                '${element.workerServiceZipCode}, ${element.cityTextId}, ${element.countryShortName}');
          }
        });
      }
    });
    return info;
  }

  List<String> getZoneNames(String? title) {
    List<String> zoneName = [];
    myWorkServiceList.forEach((element) {
      if (element.categoryTitle == title) {
        element.values!.forEach((element) {
          if (!zoneName.contains(element.workerZoneTitle)) {
            zoneName.add(element.workerZoneTitle!);
          }
        });
      }
    });
    return zoneName;
  }

  List<String> getZipCode(String? title) {
    List<String> zipcodes = [];
    myWorkServiceList.forEach((element) {
      if (element.categoryTitle == title) {
        element.values!.forEach((element) {
          if (!zipcodes.contains(element.workerZoneTitle)) {
            zipcodes.add(element.workerServiceZipCode!);
          }
        });
      }
    });
    print('zipcodes ${zipcodes.length}');
    return zipcodes;
  }

  List<String> getAllZonesFromMyWorkZoneLists(String title) {
    List<String> zones = [];
    myWorkServiceList.forEach((element) {
      print('This is printing...${title} and ${element.categoryTitle}');
      if (element.categoryTitle == title) {
        element.values!.forEach((element) {
          zones.add(element.workerServiceZipCode ?? '');
          //print('ADDING ZONE ${element.workerServiceZipCode}');
        });
      }
    });
    return zones;
  }

  Future<bool> getWorkerSelectedZoneInfo() async {
    try {
      print("getWorkerSelectedZoneNames is calling.....1 2 3");

      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };

      Response response = await get(
        Uri.parse("${urlBase}service/WorkerServiceAreaList/"),
        headers: header,
      );
      var responseDecodeJson = jsonDecode(response.body);
      print('STATUS CODE ${responseDecodeJson}');
      print('getMySelectedServiceZone RESPONSE BODY ${responseDecodeJson}');
      if (response.statusCode == 200) {
        workerServiceAreaList.clear();
        for (Map i in responseDecodeJson['areaList']) {
          workerServiceAreaList.add(WorkerAreaModel.fromJson(i));
        }
        print('workerServiceAreaList ${workerServiceAreaList.length}');
        notifyListeners();
      }
      return true;
    } catch (e) {
      print("catch");
      DashboardHelpers.showAlert(msg: 'Something went wrong');
      print(e);
      return false;
    }
  }
}
