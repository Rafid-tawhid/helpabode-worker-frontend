import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/api_services.dart';
import 'package:help_abode_worker_app_ver_2/models/category_service_model.dart';
import 'package:help_abode_worker_app_ver_2/models/corporate_review_data_model.dart';
import 'package:help_abode_worker_app_ver_2/models/selected_services_list.dart';
import 'package:help_abode_worker_app_ver_2/models/state_model.dart';
import 'package:help_abode_worker_app_ver_2/models/working_service_model.dart';
import 'package:help_abode_worker_app_ver_2/models/zone_service_model.dart';
import 'package:http/http.dart';

import '../helper_functions/dashboard_helpers.dart';
import '../misc/constants.dart';
import '../models/get_my_selected_services.dart';
import '../models/my_service_model.dart';
import '../models/my_service_work_model.dart';
import '../models/my_service_zone_model.dart';
import '../models/service_search_model.dart';
import '../models/work_service_model.dart';

class WorkingServiceProvider extends ChangeNotifier {
  List<Subcategories> subCatList = [];
  List<Category> mainCategoryList = [];
  List<WorkServiceModel> mainServiceList = [];
  List<String> mainServiceListName = [];
  List<ServiceList> filteredServiceList = [];
  List<MyServiceZoneModel> mySelectedWorkServiceList = [];
  List<StateModel> get stateModelList => _stateModelList;
  List<StateModel> _stateModelList = [];
  List<StateModel> get cityModelList => _cityModelList;
  List<StateModel> _cityModelList = [];
  List<MyServiceWorkModel> uniqueCategoryIds = [];
  List<String> zonesInfo = [];
  List<Services> myAllServices = [];
  List<Services> myAllServicesByCategory = [];
  List<Services> myAllServicesByStatus = [];
  List<Address> workerAddressList = [];
  bool isLoading = true;
  ApiService apiService = ApiService();

  void setLoading(bool loading) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading = loading;
      notifyListeners();
    });
  }

  setSubCategory(String textId) {
    subCatList.clear();
    mainCategoryList.forEach((element) {
      if (element.textId == textId) {
        element.subcategories!.forEach((data) {
          subCatList.add(data);
        });
      }
    });
    notifyListeners();
  }

  Future getServiceData() async {
    try {
      debugPrint("Service is calling.....");

      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };

      Response response = await get(
        Uri.parse("${urlBase}service/GetAllServicePreApproval/"),
        headers: header,
      );
      var responseDecodeJson = jsonDecode(response.body);
      debugPrint(responseDecodeJson.toString());

      if (response.statusCode == 200) {
        mainServiceList.clear();
        for (Map i in responseDecodeJson['results']) {
          mainServiceList.add(WorkServiceModel.fromJson(i));
        }
        debugPrint('mainServiceList ${mainServiceList.length}');
        notifyListeners();
      }
    } catch (e) {
      debugPrint("catch");
      debugPrint(e.toString());
    }
  }

  Future<void> setSelectedService(List<SelectedServicesModel> services) async {
    final url = Uri.parse('${urlBase}service/MySelectedServicePreApproval/');

    try {
      final response = await post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'services': services}),
      );
      var responseDecodeJson = jsonDecode(response.body);
      debugPrint('MY RESPONSE ${responseDecodeJson}');

      if (response.statusCode == 200) {
        debugPrint('Post request successful');
        debugPrint(response.body);
        DashboardHelpers.showAlert(msg: 'Service Request Added Sucessfully.');
      } else {
        debugPrint('Failed to post data. Status code: ${response.statusCode}');
        DashboardHelpers.showAlert(
            msg: responseDecodeJson['message'] ?? 'Something went wrong.');
        debugPrint(response.body);
      }
    } catch (error) {
      DashboardHelpers.showAlert(msg: 'Server Problem.');
      debugPrint('Error during post request: $error');
      // ShowCustomAlert('Some thing went wrong.');
    }
  }

  List<ServiceSearchModel> _searchServiceList = [];

  List<ServiceSearchModel> get searchServiceList => _searchServiceList;

  void getServiceByStatus(String status) {
    myAllServicesByStatus.clear();
    myAllServicesByCategory.forEach((element) {
      if (element.status == status) {
        myAllServicesByStatus.add(element);
      }
    });
    debugPrint('myAllServicesByCategory ${myAllServicesByCategory.length}');
    // notifyListeners();
  }

  Future getStateByIsoCode() async {
    try {
      debugPrint('#######_______INSIDE POST_______########');
      setLoading(true);
      var header = {
        "Authorization": "Bearer ${token}",
      };

      Response response = await get(
        Uri.parse("${urlBase}api/WorkerMailingAddressUpdate"),
        headers: header,
      );

      debugPrint('FULL RESPONSE ${jsonDecode(response.body)}');

      debugPrint(response.statusCode.toString());

      if (response.statusCode == 200) {
        var responseDecodeJson = jsonDecode(response.body);

        _stateModelList.clear();
        for (Map i in responseDecodeJson['results']) {
          // debugPrint('-----------');
          // debugPrint(i.toString());
          _stateModelList.add(StateModel.fromJson(i));
        }

        notifyListeners();
        debugPrint('stateModelList ${_stateModelList.length}');
        return true;
      } else if (response.statusCode == 406) {
        debugPrint('Inside 406');
        debugPrint('RESPONSE 1 ${response}');
        return false;
      }
    } catch (e) {
      debugPrint("catch");

      debugPrint('RESPONSE 2 ${e}');
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future getCityNameByStateTxtId(String state) async {
    ApiService apiService = ApiService();
    var data =
        await apiService.getData('api/WorkerMailigAddressCityZipUpdate/$state');
    if (data != null) {
      _cityModelList.clear();
      for (Map i in data['results']) {
        _cityModelList.add(StateModel.fromJson(i));
      }
      notifyListeners();
      debugPrint('cityModelList ${_cityModelList.length}');
      return true;
    }
  }

  bool getIfAnyPendingRequest() {
    return myAllServicesByCategory
        .any((element) => element.status == 'Pending');
  }

  Future<void> getWorkerAddressToUpdate() async {
    ApiService apiService = ApiService();
    workerAddressList.clear();
    var response = await apiService.getData('api/worker/profile/addressUpdate');
    for (var i in response['results']) {
      workerAddressList.add(Address.fromJson(i));
    }
    debugPrint('workerAddressList ${response}');
    notifyListeners();
  }

  void updateAddressListDirectly(Map<String, dynamic> updates) {
    // Get the first address in the list (or any specific index)
    Address address = workerAddressList[0];

    // Create a new Address by applying updates
    Address updatedAddress = address.copyWith(
      addressLine1Data: updates.containsKey('line1')
          ? updates['line1']
          : address.addressLine1Data,
      addressLine2Data: updates.containsKey('line2')
          ? updates['line2']
          : address.addressLine2Data,
      stateData:
          updates.containsKey('state') ? updates['state'] : address.stateData,
      cityData:
          updates.containsKey('city') ? updates['city'] : address.cityData,
      zipData: updates.containsKey('zip') ? updates['zip'] : address.zipData,
    );

    // Update the list with the new Address object
    workerAddressList[0] = updatedAddress;

    // Notify listeners after updating
    notifyListeners();

    // Debugging: print the updated address
    debugPrint('Updated address: ${updatedAddress.toJson()}');
  }

  Future<dynamic> updateWorkerAddress() async {
    ApiService apiService = ApiService();
    var response = await apiService.putData(
        'api/worker/profile/addressUpdate', workerAddressList);
    if (response != null) {
      DashboardHelpers.showAlert(
          msg: response['message'] ?? 'Something went wrong');
    }
    return response;
  }

  List<ZoneServiceModel> _myServiceZoneFilterList = [];
  List<CategoryServiceModel> _myServiceCategoryFilterList = [];

  List<ZoneServiceModel> get myServiceZoneFilterList =>
      _myServiceZoneFilterList;

  List<CategoryServiceModel> get myServiceCategoryFilterList =>
      _myServiceCategoryFilterList;

  List<MyServiceModel> _myServiceMainServiceList = [];
  List<MyServiceModel> _myServiceFilterServiceList = [];

  List<MyServiceModel> get myServiceMainServiceList =>
      _myServiceMainServiceList;

  List<MyServiceModel> get myServiceFilterServiceList =>
      _myServiceFilterServiceList;

  bool _isLoadingService = false;

  bool get isLoadingService => _isLoadingService;

  setLoadingService(bool val) {
    _isLoadingService = val;
    notifyListeners();
  }

  Future<void> getMySelectedCatList() async {
    setLoadingService(true);
    var data = await apiService.getData('service/MySelectedCategoryList/');
    setLoadingService(false);
    if (data != null) {
      _myServiceZoneFilterList.clear();
      _myServiceCategoryFilterList.clear();
      _myServiceMainServiceList.clear();
      _myServiceFilterServiceList.clear();
      for (var i in data['zone_array']) {
        _myServiceZoneFilterList.add(ZoneServiceModel.fromJson(i));
      }
      for (var i in data['all_categories']) {
        _myServiceCategoryFilterList.add(CategoryServiceModel.fromJson(i));
      }
      for (var i in data['service_list_array']) {
        _myServiceMainServiceList.add(MyServiceModel.fromJson(i));
        _myServiceFilterServiceList.add(MyServiceModel.fromJson(i));
      }
    }
    debugPrint('_myServiceZoneFilterList ${_myServiceZoneFilterList.length}');
    debugPrint(
        '_myServiceCategoryFilterList ${_myServiceCategoryFilterList.length}');
    debugPrint('_myServiceMainServiceList ${_myServiceMainServiceList.length}');
    notifyListeners();
  }

  void getServicesByCategory(String categoryTextId) {
    _myServiceFilterServiceList.clear();
    if (categoryTextId == 'all') {
      _myServiceFilterServiceList.addAll(_myServiceMainServiceList);
      notifyListeners();
    } else {
      _myServiceFilterServiceList.addAll(_myServiceMainServiceList
          .where((service) => service.attributeGroupTextId == categoryTextId)
          .toList());
      notifyListeners();
    }
    debugPrint(
        '_myServiceFilterServiceList ${_myServiceMainServiceList.length}');
  }

  void getServicesByZone(String zoneId) {
    _myServiceFilterServiceList.clear();
    if (zoneId == "all") {
      _myServiceFilterServiceList.addAll(_myServiceMainServiceList);
      notifyListeners();
    } else {
      _myServiceFilterServiceList
          .addAll(_myServiceMainServiceList.where((service) {
        return service.zoneArray?.any((category) => category == zoneId) ??
            false;
      }).toList());
      notifyListeners();
    }
    debugPrint(
        '_myServiceFilterServiceList ${_myServiceFilterServiceList.length}');
  }

// Function to create a unique list based on categoryTextId
//   void createUniqueList() {
//     Set<String> seenCategoryTextIds = Set();
//
//     uniqueCategoryIds.clear();
//     for (var model in myWorkServiceList) {
//       if (seenCategoryTextIds.add(model.categoryTextId!)) {
//         uniqueCategoryIds.add(model);
//       }
//     }
//     // debugPrint the result
//     uniqueCategoryIds.forEach((element) {
//       debugPrint(element.categoryTextId);
//     });
//
//     debugPrint('uniqueCategoryIds ${uniqueCategoryIds.length}');
//     debugPrint('workerServicesList ${myWorkServiceList.length}');
//     debugPrint('seenCategoryTextIds ${seenCategoryTextIds.length}');
//   }

// Example usage

// void getZipByCategoryId(String uniqueCategoryId) {
//   zones.clear();
//   myWorkServiceList.forEach((element) {
//     if (element.categoryTextId == uniqueCategoryId) {
//       zones.add(element.workerServiceZipCode ?? '');
//     }
//   });
//   debugPrint('zones ${zones.length}');
//   notifyListeners();
// }

// List<String> getzipInfoByCategoryIds(String uniqueCategoryId) {
//   zonesInfo.clear();
//   zoneName.clear();
//   myWorkServiceList.forEach((element) {
//     if (element.categoryTextId == uniqueCategoryId) {
//       zonesInfo.add(element.workerServiceZipCode!);
//       zoneName.add(element.workerZoneTextId!);
//     }
//   });
//   notifyListeners();
//   return zonesInfo;
// }

//  Future<void> getMySelectedzones(AddNewServiceProvider provider) async {
//     debugPrint('Get Request Service');
//     try {
//       debugPrint("try");
//
//       var header = {
//         "Authorization": "Bearer ${token}",
//       };
//
//       Response response = await get(
//         Uri.parse("${urlBase}service/GetMySelectedServiceZone/"),
//         headers: header,
//       );
//
//       debugPrint(response.statusCode);
//
//       if (response.statusCode == 200) {
//         myWorkServiceList.clear();
//         mySelectedWorkServiceList.clear();
//         DashboardHelpers.selectedWorkListName.clear();
//         var responseDecodeJson = jsonDecode(response.body);
//         debugPrint('Response Json');
//         debugPrint(responseDecodeJson);
//
//         for (String key in provider.serviceListName) {
//           dynamic value = responseDecodeJson['results'][key];
//           debugPrint('AJIRA VAL ${value}');
//           if (value != null) {
//             for (Map i in value) {
//               mySelectedWorkServiceList.add(MyServiceZoneModel.fromJson(i));
//             }
//             DashboardHelpers.setSelectedWorkName(key);
//           }
//           debugPrint('$key: $value');
//         }
//
//         notifyListeners();
//
//         debugPrint('mySelectedWorkServiceList ${mySelectedWorkServiceList.length}');
//       } else {
//         DashboardHelpers.showAlert(msg: 'Something went wrong.');
//       }
//     } catch (e) {
//       debugPrint("catch");
//     }
//   }
}
