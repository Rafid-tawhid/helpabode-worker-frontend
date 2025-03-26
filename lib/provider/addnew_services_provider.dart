import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/api_services.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
import 'package:help_abode_worker_app_ver_2/models/all_service_items.dart';
import 'package:help_abode_worker_app_ver_2/models/sub_category_model.dart';
import 'package:help_abode_worker_app_ver_2/provider/pricing_provider.dart';
import 'package:http/http.dart';

import '../misc/constants.dart';
import '../models/add_new_service_model.dart';
import '../models/category_service_model.dart';
import '../models/details_zone_zipcodes.dart';
import '../models/my_service_area_model.dart';
import '../models/pending_price_view_details_model.dart';
import '../models/search_model.dart';
import '../models/service_according_category_model.dart';
import '../models/service_area_with_info_model.dart';
import '../models/service_search_model.dart';
import '../models/sub_category_model_new.dart';
import '../models/zip_info_model.dart';

class AddNewServiceProvider extends ChangeNotifier {
  List<AddNewServiceModel> addNewServiceList = [];
  List<AddNewServiceModel> selectedServiceList = [];
  List<String> serviceListName = [];
  List<SearchModel> searchSuggestionList = [];
  List<SearchModel> searchSuggestionListMain = [];
  List<SearchModel> searchSuggestionListAddedMain = [];
  List<SearchModel> selectedSearchList = [];
  List<SearchModel> allCitiesAndZipList = [];
  List<SearchModel> allCitiesAndZipList2 = [];
  List<SearchModel> dummyList = [];
  List<SubCategoryModel> subCatgoryList = [];
  List<AllServiceItems> allServiceItemList = [];
  List<CategoryServiceModel> categoryServiceList = [];
  List<ServiceAccordingCategoryModel> serviceCategoryList = [];
  List<SubCategoryModelNew> subCategoryListNew = [];
  List<ServiceAccordingCategoryModel> serviceCategorySelectedList = [];
  List<Map<String, dynamic>> getValueMapOfSaveService = [];
  String getParentServiceTextIdToSaveServices = '';

  bool isloadingServices = true;
  bool isloadingSearch = false;
  bool isloadingSearchNew = false;
  bool showLodingEditButton = false;
  bool showLoadingZipUpdateBtn = false;
  bool isParentValue = false;

  int selectedIndexCategory = 0;

  Future isLoadingServices(bool loading) async {
    isloadingServices = loading;
    debugPrint('isloadingServices ${isloadingServices}');
    notifyListeners();
  }

  isLoadingSearch(bool loading) {
    isloadingSearch = loading;
    notifyListeners();
  }

  isLoadingSearch2(bool loading) {
    isloadingSearchNew = loading;
    notifyListeners();
  }

  Future getHomeServices() async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    try {
      print("HOME Service is calling.....");

      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };

      Response response = await get(
        Uri.parse("${urlBase}service/ServiceCategoriesSelection/"),
        headers: header,
      );
      EasyLoading.dismiss();
      var responseDecodeJson = jsonDecode(response.body);
      print(responseDecodeJson.toString());

      if (response.statusCode == 200) {
        addNewServiceList.clear();
        for (Map i in responseDecodeJson['results']) {
          addNewServiceList.add(AddNewServiceModel.fromJson(i));
        }
        print('addNewServiceList ${addNewServiceList.length}');

        addNewServiceList.forEach((element) {
          serviceListName.add(element.textId ?? '');
        });
        print('serviceListName ${serviceListName.length}');
        notifyListeners();
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("catch");
      print(e);
    }
  }

  Future getSubCategoryOrServices(String service) async {
    try {
      print("Sub Service is calling.....");
      subCatgoryList.clear();
      notifyListeners();
      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };

      Response response = await get(
        Uri.parse("${urlBase}service/SubServiceItemGet/${service}/"),
        headers: header,
      );
      var responseDecodeJson = jsonDecode(response.body);
      print(responseDecodeJson.toString());

      if (response.statusCode == 200) {
        subCatgoryList.clear();
        for (Map i in responseDecodeJson['results']) {
          subCatgoryList.add(SubCategoryModel.fromJson(i));
        }
        print('subCatgoryList ${subCatgoryList.length}');
        notifyListeners();
      }
      if (response.statusCode == 400) {
        subCatgoryList.clear();
        notifyListeners();
      }
    } catch (e) {
      print("catch");
      print(e);
    }
  }

  Future<void> searchByCityAndZip(String value) async {
    try {
      print("Search is calling..... Value: $value");

      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };

      Response response = await get(
        Uri.parse("${urlBase}service/SearchCityZip/?q=${value}"),
        headers: header,
      );
      var responseDecodeJson = jsonDecode(response.body);
      // print(responseDecodeJson.toString());

      if (response.statusCode == 200) {
        searchSuggestionListMain.clear();
        for (Map i in responseDecodeJson['results']) {
          searchSuggestionListMain.add(SearchModel.fromJson(i));
        }
        print('searchSuggestionList 33 ${searchSuggestionListMain.length}');
        notifyListeners();
      }
      if (response.statusCode == 400) {
        subCatgoryList.clear();
        notifyListeners();
      }
    } catch (e) {
      print("catch");
      print(e);
    }
  }

  Future<void> searchCity(String query) async {
    List<SearchModel> tempList = [];

    if (query.isNotEmpty) {
      allCitiesAndZipList2.forEach((item) {
        if (item.cityTextId!.toLowerCase().contains(query.toLowerCase()) ||
            item.stateTextId!.toLowerCase().contains(query.toLowerCase()) ||
            item.zip!.toLowerCase().contains(query.toLowerCase()) ||
            item.stateName!.toLowerCase().contains(query.toLowerCase()) ||
            item.stateShortName!.toLowerCase().contains(query.toLowerCase()) ||
            item.countryIso2Code!.toLowerCase().contains(query.toLowerCase()) ||
            item.countryName!.toLowerCase().contains(query.toLowerCase()) ||
            item.countryShortName!
                .toLowerCase()
                .contains(query.toLowerCase())) {
          tempList.add(item);
        }
      });
      if (tempList.isEmpty) {
        // If no items match the query, add a placeholder item indicating no match
        tempList.clear();
      }
    } else {
      // If query is empty, show the full list

      tempList.addAll(allCitiesAndZipList);
    }

    allCitiesAndZipList2 = tempList;
    notifyListeners();
    print('allCitiesAndZipList2 ${allCitiesAndZipList2.length}');
  }

  void getSelectesService() {
    selectedServiceList.clear();
    selectedServiceList.addAll(addNewServiceList
        .where((element) => element.isSelected == true)
        .toList());
    notifyListeners();
  }

  void getSelectesService2() {
    serviceCategorySelectedList.clear();
    serviceCategorySelectedList.addAll(serviceCategoryList
        .where((element) => element.isSelected == true)
        .toList());
    notifyListeners();
  }

  Future<bool> getAllCityAndZipCodes() async {
    try {
      print("getAllCityAndZipCodes is calling.....");
      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
      Response response = await get(
        Uri.parse("${urlBase}service/AllCityZip/"),
        headers: header,
      );
      EasyLoading.dismiss();
      var responseDecodeJson = jsonDecode(response.body);
      print(responseDecodeJson.toString());

      if (response.statusCode == 200) {
        allCitiesAndZipList.clear();
        allCitiesAndZipList2.clear();
        for (Map i in responseDecodeJson['results']) {
          allCitiesAndZipList.add(SearchModel.fromJson(i));
        }
        allCitiesAndZipList2.addAll(allCitiesAndZipList);
        print('searchList ${allCitiesAndZipList.length}');
        notifyListeners();

        return true;
      } else {
        //allCitiesAndZipList.clear();
        DashboardHelpers.showAlert(msg: 'Something went wrong');
        return false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("catch");
      print(e);
      DashboardHelpers.showAlert(msg: 'Something went wrong');
      return false;
    }
  }

  Future<bool> saveCategoriesAndZipCode(
      List<String> categories, List<String> zones, String title) async {
    try {
      print("save categories and zone is calling.....");
      print('------------');
      print('Url: ${urlBase}service/WorkerServiceZoneCreation/');
      notifyListeners();

      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };
      var bodys = jsonEncode({
        'categories': categories.toList(),
        'zoneTitle': title,
        'zipCodes': zones.toList()
      });
      print('SEND BODY : ${bodys}');
      // slash added before service

      Response response = await post(
          Uri.parse("${urlBase}service/WorkerServiceZoneCreation/"),
          headers: header,
          body: bodys);
      var responseDecodeJson = jsonDecode(response.body);
      print('responseDecodeJson : ${responseDecodeJson.toString()}');

      if (response.statusCode == 201) {
        searchSuggestionList.clear();
        categories.clear();
        zones.clear();
        print('searchSuggestionList ${searchSuggestionList.length}');
        // await userBox.put('status', '${jsonDecode(response.body)['WorkerStatus']}');
        //print('SERVICE ${userBox.get('status')}');
        notifyListeners();
        return true;
      } else {
        DashboardHelpers.showAlert(msg: 'Something went wrong');
        subCatgoryList.clear();
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("catch : ${e}");
      return false;
    }
  }

  Future<dynamic> saveCategoriesAndZipCode2(
      String categoryId,
      List<Map<String, dynamic>> services,
      List<String> zipList,
      String title,
      String? updateCall,
      List<dynamic> existsZip,
      String? isExists) async {
    try {
      print('------------');
      debugPrint('Exists List ${existsZip.toList()}');
      debugPrint('Send List ${zipList.toList()}');
      notifyListeners();

      if (existsZip.isNotEmpty) {
        existsZip.forEach((element) {
          zipList.remove(element);
        });
      }
      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };
      var bodys = jsonEncode({
        'categoryTextId': categoryId,
        'services': getValueMapOfSaveService,
        'zoneTitle': title,
        'zipCodes': zipList.toList(),
        'isExists': isExists
      });

      debugPrint(
          "save categories and zone is calling..... 2 URL ${urlBase}service/WorkerServiceZoneCreationInDashboard/");
      debugPrint('SEND BODY SERVICE: ${bodys}');
      Response response;
      // slash added before service
      if (updateCall == 'update') {
        response = await put(
            Uri.parse(
                "${urlBase}service/WorkerServiceZoneCreationInDashboard/"),
            headers: header,
            body: bodys);
      } else {
        response = await post(
            Uri.parse(
                "${urlBase}service/WorkerServiceZoneCreationInDashboard/"),
            headers: header,
            body: bodys);
      }

      var responseDecodeJson = jsonDecode(response.body);
      print('responseDecodeJson : ${responseDecodeJson.toString()}');

      if (response.statusCode == 201) {
        searchSuggestionList.clear();
        services.clear();
        zipList.clear();
        print('searchSuggestionList ${searchSuggestionList.length}');
        await userBox.put(
            'status', '${jsonDecode(response.body)['WorkerStatus']}');
        print('SERVICE ${userBox.get('status')}');
        notifyListeners();

        return true;
      } else if (response.statusCode == 409) {
        print('responseDecodeJson : ${responseDecodeJson.toString()}');
        return responseDecodeJson;
      } else {
        DashboardHelpers.showAlert(
            msg: responseDecodeJson['message'] ?? 'Something went wrong');
        subCatgoryList.clear();
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("catch : ${e}");

      return false;
    } finally {
      //clear list
      searchSuggestionListAddedMain.clear();
      notifyListeners();
    }
  }

  void setSelected(int id) {
    print('setSelected id: ${id}');
    allCitiesAndZipList2.forEach((element) {
      if (element.id == id) {
        element.isSelected = !element.isSelected;
      }
    });
    notifyListeners();
  }

  deleteSearchList(SearchModel model) {
    if (searchSuggestionListAddedMain.contains(model)) {
      searchSuggestionListAddedMain.remove(model);
      notifyListeners();
    }
  }

  deleteAllSelectedSearch() {
    selectedSearchList.clear();
    notifyListeners();
  }

  // deleteSearchListEdit(SearchModel model) {
  //   if (editSelectedSearchList.contains(model)) {
  //     editSelectedSearchList.remove(model);
  //     notifyListeners();
  //   }
  // }

  Future<void> getAllServiceItems2() async {
    ApiService apiService = ApiService();
    isLoadingServices(true);
    allServiceItemList.clear();
    var data = await apiService.getData('service/AllServiceItems/');
    for (Map i in data['results']) {
      allServiceItemList.add(AllServiceItems.fromJson(i));
    }
    debugPrint('allServiceItemList ${allServiceItemList.length}');
    isLoadingServices(false);
  }

  Future<bool> addNewServiceWithZone(String categories, List<String> services,
      List<String> zips, String trim) async {
    try {
      print("addNewServiceWithZone is calling.....");
      print('------------');
      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };
      var bodys = jsonEncode({
        "categoryTextId": categories,
        "allService": services,
        "zip": zips,
        "serviceZone": trim
      });
      print('SEND BODY : ${bodys}');

      Response response = await post(
          Uri.parse("${urlBase}service/AddNewServiceWithZone/"),
          headers: header,
          body: bodys);
      var responseDecodeJson = jsonDecode(response.body);
      print('responseDecodeJson : ${responseDecodeJson.toString()}');

      if (response.statusCode == 200) {
        return true;
      } else {
        DashboardHelpers.showAlert(msg: 'Something went wrong');
        return false;
      }
    } catch (e) {
      print("catch : ${e}");

      return false;
    }
  }

  void resetSelectedList() {
    searchSuggestionList.clear();
    print('searchSuggestionList ${searchSuggestionList.length}');
    notifyListeners();
  }

  Future<bool> servcieAccordingToCategory(String? id) async {
    try {
      print("ServcieAccordingToCategory is calling..... 67");
      debugPrint('Url ${urlBase}service/ServcieAccordingToCategory/${id}/');
      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };

      Response response = await get(
        Uri.parse("${urlBase}service/ServcieAccordingToCategory/${id}/"),
        headers: header,
      );
      var responseDecodeJson = jsonDecode(response.body);

      print('RESPONSE BODY: ${responseDecodeJson.toString()}');

      if (response.statusCode == 200) {
        serviceCategoryList.clear();
        for (Map i in responseDecodeJson['results']) {
          serviceCategoryList.add(ServiceAccordingCategoryModel.fromJson(i));
        }
        print('serviceCategoryList ${serviceCategoryList.length}');
        notifyListeners();
        return true;
      } else {
        DashboardHelpers.showAlert(msg: 'Something Went Wrong');
        serviceCategoryList.clear();
        notifyListeners();
        return false;
      }
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'Something Went Wrong');
      print("catch");
      print(e);
      return false;
    }
  }

  Future<bool> myCategoryServices(String? itemId, String catId) async {
    try {
      print("MyCategoryServices is calling..... ");
      debugPrint('Url ${urlBase}service/MyCategoryServices/${itemId}/${catId}');
      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };

      Response response = await get(
        Uri.parse("${urlBase}service/MyCategoryServices/${itemId}/${catId}"),
        headers: header,
      );
      var responseDecodeJson = jsonDecode(response.body);

      print('RESPONSE BODY: ${responseDecodeJson.toString()}');

      if (response.statusCode == 200) {
        serviceCategoryList.clear();
        subCategoryListNew.clear();
        debugPrint('THIS IS SERVICE ${responseDecodeJson['serviceArray']}');
        for (Map i in responseDecodeJson['serviceArray']) {
          serviceCategoryList.add(ServiceAccordingCategoryModel.fromJson(i));
        }
        for (Map i in responseDecodeJson['subCategoryArray']) {
          subCategoryListNew.add(SubCategoryModelNew.fromJson(i));
        }
        print('serviceCategoryList ${serviceCategoryList.length}');
        print('subCategoryListNew ${subCategoryListNew.length}');
        notifyListeners();
        return true;
      } else {
        DashboardHelpers.showAlert(msg: 'Something Went Wrong');
        serviceCategoryList.clear();
        notifyListeners();
        return false;
      }
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'Something Went Wrong');
      print("catch");
      print(e);
      return false;
    }
  }

  void addSelected(List<SearchModel> selectedMainList) {
    selectedSearchList.clear();
    Set<String> uniqueIds = {};

    // Add dummyList items' IDs to uniqueIds //For edit purpose
    if (dummyList.isNotEmpty) {
      dummyList.forEach((element) {
        uniqueIds.add(element.zip ?? '');
      });
    }

    // Add selected items from selectedMainList ensuring uniqueness
    selectedMainList.forEach((element) {
      if (element.isSelected == true && !uniqueIds.contains(element.zip)) {
        uniqueIds.add(element.zip ?? '');
        selectedSearchList.add(element);
      }
    });

    notifyListeners();

    print('selectedSearchList ${selectedSearchList.length}');
  }

  // void addSelected(List<SearchModel> selectedMainList) {
  //   selectedSearchList.clear();
  //   selectedMainList.forEach((element) {
  //     if (element.isSelected == true) {
  //       selectedSearchList.add(element);
  //     }
  //   });
  //   notifyListeners();
  //
  //   print('selectedSearchList ${selectedSearchList.length}');
  // }

  bool isSelected(SearchModel item) {
    return selectedSearchList.any((element) => element.id == item.id);
  }

  void setSelectedvalueMain(SearchModel model, int id) {
    if (!searchSuggestionListAddedMain.any((element) => element.id == id)) {
      print('ADDED ${model.id}');
      model.isSelected = true;
      searchSuggestionListAddedMain.add(model);
    } else {
      print('REMOVE ${model.id}');
      model.isSelected = false;
      searchSuggestionListAddedMain.removeWhere((element) => element.id == id);
    }
    notifyListeners();
  }

  bool getIfItemIsAlreadyAddedInSelectedList(SearchModel value) {
    if (searchSuggestionListAddedMain.contains(value)) {
      print('${value.id} is already in the list.');
      return true;
    } else {
      print('${value.id} is not in the list.');
      return false;
    }
  }

  void clearSelectedList() {
    searchSuggestionListAddedMain.clear();
    getValueMapOfSaveService.clear();
    notifyListeners();
  }

  void setSelectedSearchAreaList(
      PricingProvider pProvider, PricingZoneArray selectedZone) {
    DetailsZoneZipcodes zone = pProvider.detailsZoneZipCodeList
        .firstWhere((e) => e.zoneTextId == selectedZone.zoneTextId);
    selectedSearchList.clear();
    zone.zipCode!.forEach((e) {
      SearchModel model = SearchModel(
          id: Random.secure().nextInt(1000000),
          cityTextId: e.cityTextId,
          stateTextId: e.stateTextId,
          countryName: e.cityName,
          stateName: e.stateTextId,
          zip: e.zip,
          stateShortName: e.stateShortName,
          countryShortName: e.countryShortName,
          countryIso2Code: 'ISO',
          isSelected: false);
      selectedSearchList.add(model);
    });
    notifyListeners();
  }

  void setSelectedAreaToSearch(
      PricingProvider provider, PricingZoneArray selectedZone) {
    DetailsZoneZipcodes zone = provider.detailsZoneZipCodeList
        .firstWhere((e) => e.zoneTextId == selectedZone.zoneTextId);
    zone.zipCode!.forEach((e) {
      if (searchSuggestionListMain.any((a) => a.zip == e.zip)) {
        searchSuggestionListMain.forEach((b) {
          b.isSelected = true;
          searchSuggestionListAddedMain.add(b);
          notifyListeners();
        });
      }
    });

    searchSuggestionListMain.forEach((o) {
      debugPrint(
          'searchSuggestionListMain searchSuggestionListMain ${o.isSelected}');
    });
    notifyListeners();
  }

  void addDummyList() {
    dummyList.forEach((e) {
      selectedSearchList.add(e);
    });
    debugPrint('selectedSearchList ${selectedSearchList.length}');
    notifyListeners();
  }

  void setSelectedListForAnotherUse() {
    // Clear the dummyList and selectedSearchList first
    dummyList.clear();
    // selectedSearchList.clear();

    // Populate dummyList with unique items
    for (var a in selectedSearchList) {
      if (!dummyList.any((b) => b.zip == a.zip)) {
        dummyList.add(a);
      }
    }
    debugPrint('dummyList ${dummyList.length}');
    notifyListeners();
  }

  Future<dynamic> updateServiceZoneWithZipcode(
      dynamic body, PricingProvider pProvider, String? updateCall) async {
    try {
      print(
          "updateServiceZoneWithZipcode is calling..... ${urlBase}service/zoneZipUpdate/");
      print('------------ ${body.toString()}');
      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };
      var bodys = body;
      print('SEND BODY : ${bodys}');
      print('SEND Token : ${token}');
      Response response;
      if (updateCall == 'update') {
        response = await put(Uri.parse("${urlBase}service/zoneZipUpdate/"),
            headers: header, body: bodys);
      } else {
        response = await post(Uri.parse("${urlBase}service/zoneZipUpdate/"),
            headers: header, body: bodys);
      }
      var responseDecodeJson = jsonDecode(response.body);
      print('responseDecodeJson : ${responseDecodeJson.toString()}');

      if (response.statusCode == 201) {
        //Update zone zip
        pProvider.updateDetailsZoneZipArray(responseDecodeJson);

        return true;
      } else if (response.statusCode == 409) {
        //Update zone zip

        return responseDecodeJson;
      } else {
        DashboardHelpers.showAlert(
            msg: responseDecodeJson['message'] ?? 'Something went wrong');
        return false;
      }
    } catch (e) {
      print("catch : ${e}");
      return false;
    }
  }

  setShowLoadingEdit(loading) {
    showLodingEditButton = loading;
    notifyListeners();
  }

  void setSearchSelected(SearchModel item) {
    if (selectedSearchList.any((e) => e.zip == item.zip)) {
      selectedSearchList.removeWhere((e) => e.zip == item.zip);
      debugPrint('REMOVED${selectedSearchList.length}');
    } else {
      selectedSearchList.add(item);
      debugPrint('ADDED ${selectedSearchList.length}');
    }
    notifyListeners();
  }

  void showLoadingZipUpdateButton(bool val) {
    showLoadingZipUpdateBtn = val;
    debugPrint('showLoadingZipUpdateBtn ${val}');
    notifyListeners();
  }

  void setParentValue(bool bool) {
    isParentValue = bool;
    notifyListeners();
    debugPrint('isParentValue ${isParentValue}');
  }

  void setValueMapToSaveService(
      String parentTextId, String serviceTextId, String serviceTitle) {
    if (getValueMapOfSaveService
        .any((e) => e['key'] == parentTextId + serviceTextId)) {
      debugPrint('Remove');
      getValueMapOfSaveService.removeWhere(
          (element) => element['key'] == parentTextId + serviceTextId);
    } else {
      // add
      getValueMapOfSaveService.add({
        "parentTextId": parentTextId,
        "serviceTextId": serviceTextId,
        "serviceTitle": serviceTitle,
        "key": parentTextId + serviceTextId,
      });
    }
    debugPrint('------Value Map-------');
    debugPrint(getValueMapOfSaveService.toString());
    notifyListeners();
  }

  void setParentServiceTextIdToSaveServices(String textId) {
    getParentServiceTextIdToSaveServices = textId;
    notifyListeners();
  }

  void setSelectedIndexCategory(int index) {
    selectedIndexCategory = index;
    notifyListeners();
  }

  Future<void> getServiceByCategoryId(String? textId) async {
    ApiService apiService = ApiService();
    serviceCategoryList.clear();
    isLoadingServices(true);
    var data =
        await apiService.getData('service/service-from-parent/${textId}/');
    for (Map i in data['serviceList']) {
      serviceCategoryList.add(ServiceAccordingCategoryModel.fromJson(i));
    }
    debugPrint('serviceCategoryList ${serviceCategoryList.length}');
    isLoadingServices(false);
  }

  void setSelection(bool showZoneSelectType) {
    selectedAreaIsDropdown = showZoneSelectType;
    notifyListeners();
  }

  bool isLoading = true;
  List<MyServiceAreaModel> myServiceAreaList = [];
  bool selectedAreaIsDropdown = false;

  Future<bool> getMyAllServiceArea() async {
    print('Get Request Service');
    try {
      print("try getMyAll SERVICE AREA");

      // setLoadingArea(true);
      var header = {
        "Authorization": "Bearer ${token}",
      };

      Response response = await get(
        Uri.parse("${urlBase}service/ALLServiceZone/"),
        headers: header,
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        myServiceAreaList.clear();
        var responseDecodeJson = jsonDecode(response.body);
        for (Map i in responseDecodeJson['results']) {
          myServiceAreaList.add(MyServiceAreaModel.fromJson(i));
        }

        print('myServiceAreaList ${myServiceAreaList.length}');

        return true;
      } else {
        print(response.body);
        DashboardHelpers.showAlert(msg: 'Something went wrong.');
        return false;
      }
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'Something went wrong.');
      print("catch");
      return false;
    } finally {
      setLoadingArea(false);
    }
  }

  bool _isLoadingArea = false;
  List<ServiceAreaWithInfoModel> _serviceAreaWithInfoList = [];
  List<ServiceAreaWithInfoModel> _filterserviceAreaWithInfoList = [];
  List<dynamic> _servicesList = [];

  bool get isLoadingArea => _isLoadingArea;

  List<ServiceAreaWithInfoModel> get serviceAreaWithInfoList =>
      _serviceAreaWithInfoList;

  List<ServiceAreaWithInfoModel> get filterserviceAreaWithInfoList =>
      _filterserviceAreaWithInfoList;

  List<dynamic> get servicesList => _servicesList;

  Future<void> getMyAllServiceAreaWIthAllInfo() async {
    _isLoadingArea = true;
    notifyListeners();

    ApiService apiService = ApiService();
    var data = await apiService.getData('service/serviceArea/');
    if (data != null) {
      _serviceAreaWithInfoList.clear();
      _filterserviceAreaWithInfoList.clear();
      _servicesList.clear();

      for (var i in data['service_area_list']) {
        _serviceAreaWithInfoList.add(ServiceAreaWithInfoModel.fromJson(i));
      }
      _filterserviceAreaWithInfoList.addAll(_serviceAreaWithInfoList);
      for (var i in data['all_services']) {
        _servicesList.add(i);
      }
    }
    debugPrint('_serviceAreaWithInfoList ${_serviceAreaWithInfoList.length}');

    _isLoadingArea = false;
    notifyListeners();
  }

  void setLoadingArea(bool bool) {
    isLoading = bool;
    notifyListeners();
  }

  int selectedIndex = 0;
  bool showAreaScreen = true;

  void showServiceAreaLoading(bool show) {
    showAreaScreen = show;
    notifyListeners();
  }

  List<String> filtteredZipcodeListByZone = [];

  void getTheZipCodesAccordingToZoneName(String? zoneTextId) {
    filtteredZipcodeListByZone.clear();
    filtteredZipcodeListByZone.addAll(myServiceAreaList
            .firstWhere((e) => e.zoneTextId == zoneTextId)
            .zipCodes ??
        []);
    notifyListeners();
  }

  void clearFiltteredZipcodeListByZone() {
    filtteredZipcodeListByZone.clear();
    notifyListeners();
  }

  List<ZipInfoModel> _zipInfoModelList = [];

  // List<ZoneServiceModel> _zoneServiceModelList = [];

  List<ZipInfoModel> get zipInfoModelList => _zipInfoModelList;

  // List<ZoneServiceModel> get zoneServiceModelList => _zoneServiceModelList;

  Future<void> getDetailsInfoByZoneId(String? zoneTextId) async {
    ApiService apiService = ApiService();
    var data =
        await apiService.getData('service/serviceAreaDetails/${zoneTextId}');
    if (data != null) {
      _zipInfoModelList.clear();
      _searchSelectedServiceList.clear();
      for (var i in data['zoneData']['zipArrayByZone']) {
        _zipInfoModelList.add(ZipInfoModel.fromJson(i));
      }
      for (var i in data['zoneData']['serviceArrayByZone']) {
        _searchSelectedServiceList.add(ServiceSearchModel.fromJson(i));
      }
    }
    debugPrint('_zipInfoModelList ${_zipInfoModelList.length}');
    debugPrint(
        '_searchSelectedServiceList ${_searchSelectedServiceList.length}');
  }

  List<ServiceSearchModel> _searchServiceListMain = [];
  List<ServiceSearchModel> _searchServiceListFilter = [];

  List<ServiceSearchModel> get searchServiceListMain => _searchServiceListMain;

  List<ServiceSearchModel> get searchServiceListFilter =>
      _searchServiceListFilter;

  Future<void> getAllServicesToSearch() async {
    ApiService apiService = ApiService();
    var data = await apiService.getData('service/allServiceWithCategory');
    if (data != null) {
      _searchServiceListMain.clear();
      _searchServiceListFilter.clear();
      for (var i in data['service_array']) {
        _searchServiceListMain.add(ServiceSearchModel.fromJson(i));
      }

      _searchServiceListFilter.addAll(_searchServiceListMain);
      debugPrint('_searchServiceListMain ${_searchServiceListMain.length}');
    }
    setServicesUnderCategory(_searchServiceListMain);
  }

  List<ServiceSearchModel> _searchSelectedServiceList = [];

  List<ServiceSearchModel> get searchSelectedServiceList =>
      _searchSelectedServiceList;

  clearSearchSelected() {
    _searchSelectedServiceList.clear();
    notifyListeners();
  }

  void updateSelectedService(ServiceSearchModel searchModel) {
    debugPrint(
        'Service TextId: ${searchModel.serviceTextId} : Cat TextId: ${searchModel.categoryTextId}');

    // Combine IDs for unique identification
    String combinedId =
        '${searchModel.serviceTextId}${searchModel.categoryTextId}';

    // Find existing element by ID
    int existingIndex = _searchSelectedServiceList.indexWhere(
      (e) => '${e.serviceTextId}${e.categoryTextId}' == combinedId,
    );

    if (existingIndex != -1) {
      // If the service already exists, remove it
      debugPrint('Service Removed');
      _searchSelectedServiceList.removeAt(existingIndex);
    } else {
      // If not found, add it
      debugPrint('Service Added');
      _searchSelectedServiceList.add(searchModel);
    }

    //just add to this list to show data in service area

    // Set<String> existingServiceTitles = zoneServiceModelList.map((e) => e.serviceTitle??'').toSet();
    // Add only unique service titles
    // zoneServiceModelList.addAll(
    //     _searchSelectedServiceList.where((service) => !existingServiceTitles.contains(service.serviceTitle)) // Filter out duplicates
    //         .map((service) => ZoneServiceModel(
    //       zoneTextId: '',
    //       serviceTextId: service.serviceTextId,
    //       serviceTitle: service.serviceTitle,
    //       pricingBy: service.pricingBy,
    //       image: service.serviceImage,
    //     ))
    // );
    notifyListeners();
    debugPrint('updated service list ${_searchSelectedServiceList.length}');
  }

  Future<void> postServiceAndZipCodeForUpdate(
      String zoneId, String zoneName) async {
    // Ensure unique zip codes
    var zipSet = <String>{};
    var serviceSet = <ServiceSearchModel>{};
    List<Map<String, dynamic>> serviceJson = [];

    // Collect unique zip codes, filtering out null or empty values
    searchSuggestionListAddedMain.forEach((e) {
      if (e.zip != null && e.zip!.isNotEmpty) {
        zipSet.add(e.zip!);
      }
    });

    // Collect unique services
    _searchSelectedServiceList.forEach((e) {
      serviceSet.add(e);
    });

    // Convert services to JSON format
    serviceSet.forEach((e) {
      serviceJson.add(e.toJson());
    });

    // Prepare final data payload
    final data = {
      "zoneTextId": zoneId,
      "zoneTitle": zoneName,
      "ziparray": zipSet.toList(), // Use zipSet for unique zip codes
      "serviceList": serviceJson, // Use serviceJson for service data
    };

    debugPrint('SEND DATA: $data');
    ApiService apiService = ApiService();
    showLoadingZipUpdateButton(true);
    var response = await apiService.postData('service/serviceAddInZone', data);
    showLoadingZipUpdateButton(false);
    if (response != null) {
      _serviceAreaWithInfoList.forEach((e) {
        if (e.zoneTextId == zoneId) {
          e.updateZipAndService(
              zip: searchSuggestionListAddedMain.length,
              service: _searchSelectedServiceList.length);
        }
      });
      //zipcodes and services added success now update zone area list

      notifyListeners();
    }
  }

  Future<bool> createZoneFromMyService(
      String zoneName, PricingServiceInfo service) async {
    // Ensure unique zip codes
    var zipSet = <String>{};
    // Collect unique zip codes, filtering out null or empty values
    searchSuggestionListAddedMain.forEach((e) {
      if (e.zip != null && e.zip!.isNotEmpty) {
        zipSet.add(e.zip!);
      }
    });
    // Prepare final data payload
    final data = [
      {
        "zoneTitle": zoneName,
        "zipcodes": zipSet.toList(),
      }
    ];

    debugPrint('SEND DATA: $data');
    ApiService apiService = ApiService();
    showLoadingZipUpdateButton(true);
    var response = await apiService.postData2(
        'service/zoneAddInService/${service.textId}/${service.categoryTextId}',
        data);
    showLoadingZipUpdateButton(false);
    if (response != null) {
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Map<String, List<Map<String, String>>> _categoryMap = {};

  Map<String, List<Map<String, String>>> get categoryMap => _categoryMap;

  void setServicesUnderCategory(
      List<ServiceSearchModel> searchServiceListMain) {
    _categoryMap.clear();
    // Initialize the map to group services by category

// Iterate over the list of services
    for (var service in searchServiceListMain) {
      String category = service.categoryTitle ?? '';
      String serviceTitle = service.serviceTitle ?? '';
      String serviceTextId = service.serviceTextId ?? '';
      String categoryTextId = service.categoryTextId ?? '';
      String categoryTitle = service.categoryTitle ?? '';
      String serviceImage = service.serviceImage ?? '';
      // Add to the corresponding category
      if (!_categoryMap.containsKey(category)) {
        _categoryMap[category] = [];
      }

      // Add service details to the list under the category
      _categoryMap[category]!.add({
        "serviceTitle": serviceTitle,
        "categoryTitle": categoryTitle,
        "serviceTextId": serviceTextId,
        "categoryTextId": categoryTextId,
        "serviceImage": serviceImage,
      });
    }
    notifyListeners();
  }

  void searchWithZoneName(String val) async {
    debugPrint('Search Val ${val}');
    if (val == "") {
      filterserviceAreaWithInfoList.clear();
      filterserviceAreaWithInfoList.addAll(serviceAreaWithInfoList);
    }
    if (filterserviceAreaWithInfoList.isNotEmpty) {
      // Filter the list based on the search value
      filterserviceAreaWithInfoList.clear();
      filterserviceAreaWithInfoList.addAll(serviceAreaWithInfoList
          .where((item) =>
              item.zoneTitle!.toLowerCase().contains(val.toLowerCase()))
          .toList());
      // Notify listeners to update the UI
      debugPrint(
          'filterserviceAreaWithInfoList ${filterserviceAreaWithInfoList.length}');
      notifyListeners();
    }
  }

  void searchInServiceList(String query) {
    if (query.isEmpty) {
      _searchServiceListFilter =
          _searchServiceListMain; // Show all services if query is empty
    } else {
      _searchServiceListFilter = _searchServiceListMain
          .where((service) =>
              service.serviceTitle!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              service.categoryTitle!
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  String? _selectedService;
  String? _selectedServiceId;
  String? _selectedCategoryId;
  String? get selectedService => _selectedService;
  String? get selectedServiceId => _selectedServiceId;
  String? get selectedCategoryId => _selectedCategoryId;

  void filterServiceArea(
      String serviceTextId, String serviceTitle, String categoryTextId) {
    if (serviceTextId == 'All Service') {
      _filterserviceAreaWithInfoList.addAll(_serviceAreaWithInfoList);
      _selectedService = null;
      _selectedServiceId = null;
      _selectedCategoryId = null;
    } else {
      _filterserviceAreaWithInfoList.clear();
      for (var e in _serviceAreaWithInfoList) {
        if (e.serviceArray!.any((a) => a.serviceTextId == serviceTextId)) {
          debugPrint('serviceTextId Found ${serviceTextId}');
          _filterserviceAreaWithInfoList.add(e);
        }
      }
      _selectedService = serviceTitle;
      _selectedServiceId = serviceTextId;
      _selectedCategoryId = categoryTextId;

      debugPrint('_serviceAreaWithInfoList ${_serviceAreaWithInfoList.length}');
      debugPrint(
          '_filterserviceAreaWithInfoList ${_filterserviceAreaWithInfoList.length}');
    }

    notifyListeners();
  }

  void setSingleSelectedService() {
    searchSelectedServiceList.clear();
    searchSelectedServiceList.add(ServiceSearchModel(
        serviceTextId: _selectedServiceId, serviceTitle: _selectedService));
    searchSuggestionListAddedMain.clear();
    notifyListeners();
  }
}
