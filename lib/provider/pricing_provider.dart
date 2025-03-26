import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/api_services.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/colors.dart';
import 'package:help_abode_worker_app_ver_2/models/price_configration_model.dart';
import 'package:http/http.dart';
import '../helper_functions/dashboard_helpers.dart';
import '../misc/constants.dart';
import '../models/bundle_attribute_model.dart';
import '../models/details_zone_zipcodes.dart';
import '../models/pending_price_view_details_model.dart';
import '../models/pending_requested_servicelist.dart';
import '../models/price_configration_preview_model_new.dart';
import '../models/pricing_attribute_model_new.dart';
import '../models/requested_service_details_model.dart';
import '../models/worker_service_model.dart';
import '../widgets_reuse/custom_snackbar_message.dart';

//dropdown for area

// List<ZoneList> zoneListForDropDown = [];
// List<GetPlanList> planListForDropDown = [];

class PricingProvider extends ChangeNotifier {
  List<ZoneList> _zoneListForDropDown = [];
  List<GetPlanList> _planListForDropDown = [];

  // Getter for _zoneListForDropDown
  List<ZoneList> get zoneListForDropDown => _zoneListForDropDown;

  // Setter for _zoneListForDropDown
  set zoneListForDropDown(List<ZoneList> value) {
    _zoneListForDropDown = value;
    notifyListeners();
  }

  // Getter for _planListForDropDown
  List<GetPlanList> get planListForDropDown => _planListForDropDown;

  // Setter for _planListForDropDown
  set planListForDropDown(List<GetPlanList> value) {
    _planListForDropDown = value;
    notifyListeners();
  }

  List<GetPlanList> servicePlanList = [];
  List<PriceConfigrationModel> priceConfigrationModelList = [];
  List<PriceConfigrationModel> priceConfigrationPreviewList = [];

  // List<BundlePriceConfigerationModel> bundlePriceConfigModelList = [];

  List<ZoneList> _zoneList = [];
  List<String> zoneNameList = [];
  List<PriceConfigaruatinAttr> attributeList = [];
  List<PriceConfigaruatinAttr> attributeListTesting = [];
  List<Attributes> getPlanattributeList = [];
  List<BundleAttributeModel> bundleAttributeList = [];
  List<PlanArray> planList = [];
  PlanArray? planDetailsInfo;
  List<String> attributeNameList = [];
  List<String> getAttributeNameList = [];
  List<String> getAttributePriceList = [];
  List<String> zipCodeNameList = [];
  List<Attributes> previousPricingInfoList = [];
  late ServiceInfo serviceInfo;
  List<bool> isExpanded = [];
  // List<WorkerServiceModel> workerServiceModel = [];
  // List<WorkerServiceModel> workerServiceModelShow = [];
  bool btnUpdate = false;
  bool showArea = true;
  bool isloadingPrices = true;
  bool isBundleService = false;
  String minimumPrice = '';
  String estTime = '';
  String bundleEstTime = '';
  final List<Attributes> listOfAttributes = [];
  List<Attributes> previousPricingAttributeList = [];
  bool showLoadingTextFields = false;
  final List<PendingRequestedServiceList> pendingListFinal = [];
  final List<PendingRequestedServiceList> requestedListFinal = [];
  List<bool> loadingList = [];
  PricingServiceInfo? pricingServiceDetailsinfo;
  List<PricingPlanArray> pendingPlanArrayList = [];
  List<PricingZoneArray> pricingZoneArrayList = [];
  List<DetailsZoneZipcodes> detailsZoneZipCodeList = [];
  List<RequestedServiceDetailsModel> requestedServiceDetailsPricingList = [];
  List<RequestedServiceDetailsModel> requestedServiceDetailsPricingListShow = [];
  bool editButton = false;
  bool isClickedLoading = false;
  List<dynamic> somethingList = [];
  String? pricingStatus;
  String rejectedNotes = '';
  String pricingScreenButtonStatus = 'Save';

  // List<PriceConfigaruatinAttr> dummyAttributeList = (json.decode(jsonString) as List).map((item) => PriceConfigaruatinAttr.fromJson(item)).toList();

  void setShowAreaValue(bool value) {
    Future.delayed(const Duration(seconds: 0), () {
      showArea = value;
      notifyListeners();
    });
  }

  void setShowAreaValue2(bool value) {
    Future.delayed(const Duration(seconds: 1), () {
      showArea = value;
      notifyListeners();
    });
  }

  Future<bool> getPriceConfiguration({required String? serviceTextId, required String? plan, required String? zone, String? type, required String? categoryTextId}) async {
    ApiService apiService = ApiService();
    setClickedPending(true);
    var responseDecodeJson = await apiService.getData('service/PriceConfiguration/$serviceTextId/$categoryTextId/$plan/$zone/dummy');
    setClickedPending(false);

    if (responseDecodeJson == null) return false;

    _clearLists(); // Helper method to clear lists

    final serviceData = responseDecodeJson['serviceData'];

    serviceInfo = ServiceInfo.fromJson(serviceData['service_info']);
    minimumPrice = serviceData['price_configaruatin_attr']['minimumPrice'].toString();
    pricingStatus = serviceData['price_configaruatin_attr']['priceStatus'].toString();
    rejectedNotes = serviceData['price_configaruatin_attr']['rejectedNotes'] ?? '';

    if (type!.toLowerCase() == "bundle") {
      _handleBundleData(serviceData);
    } else {
      _handleNonBundleData(serviceData);
    }
    // Set button status based on minimumPrice
    pricingScreenButtonStatus = minimumPrice.isEmpty ? 'Save' : 'Update';

    return true;
  }

// Helper method to clear lists
  void _clearLists() {
    servicePlanList.clear();
    _zoneList.clear();
    attributeList.clear();
    attributeNameList.clear();
    zoneNameList.clear();
    notifyListeners();
  }

  List<ZoneList> get zoneList => _zoneList;

// Handle bundle type response
  void _handleBundleData(Map<String, dynamic> serviceData) {
    List<dynamic> getPlanListData = serviceData['get_plan_list'];
    List<dynamic> getZoneList = serviceData['zone_list'];
    //List<dynamic> newPriceConfig = serviceData['new_price_configaruatin_attr'];

    minimumPrice = serviceData['price_configaruatin_attr']['minimumPrice'].toString();
    estTime = serviceData['price_configaruatin_attr']['estTime'].toString();

    debugPrint('minimumPrice ${minimumPrice} : estTime ${estTime}');

    servicePlanList = getPlanListData.map((json) => GetPlanList.fromJson(json)).toList();
    _zoneList = getZoneList.map((json) => ZoneList.fromJson(json)).toList();

    if (serviceData['price_configaruatin_attr']['getAllAttrArray'] != null) {
      bundleAttributeList = parseServiceDetails(serviceData['price_configaruatin_attr']['getAllAttrArray']);
    }

    // Populate zoneNameList
    _zoneList.forEach((element) {
      zoneNameList.add(element.zoneTitle ?? '');
    });
    // Handle button status
    if (minimumPrice.isEmpty) {
      pricingScreenButtonStatus = 'Save';
    } else {
      pricingScreenButtonStatus = 'Update';
    }
  }

// Handle non-bundle type response
  void _handleNonBundleData(Map<String, dynamic> serviceData) {
    List<dynamic> getPlanListData = serviceData['get_plan_list'];
    List<dynamic> getZoneList = serviceData['zone_list'];
    List<dynamic> getAttributesList = serviceData['price_configaruatin_attr']['getAllAttrArray'];

    servicePlanList = getPlanListData.map((json) => GetPlanList.fromJson(json)).toList();
    _zoneList = getZoneList.map((json) => ZoneList.fromJson(json)).toList();
    attributeList = getAttributesList.map((json) => PriceConfigaruatinAttr.fromJson(json)).toList();

    // Populate zoneNameList
    zoneList.forEach((element) {
      zoneNameList.add(element.zoneTitle ?? '');
    });

    // // For requested price data
    // var newPriceConfig = serviceData['new_price_configaruatin_attr'];
    // try {
    // _newRequestedPricingAttributeModelList.clear();
    // for(var i in newPriceConfig){
    //   _newRequestedPricingAttributeModelList.add(NewRequestedPricingAttributeModel.fromJson(i));
    // }
    // } catch (e) {
    //   debugPrint('catch newRequestedPricingAttributeModelList.clear()');
    //   _newRequestedPricingAttributeModelList.clear();
    // }

    // debugPrint('newPriceConfig ${newPriceConfig}');
    // debugPrint('_newRequestedPricingAttributeModelList ${_newRequestedPricingAttributeModelList.length}');

    // Testing
    attributeListTesting.clear();
    attributeListTesting.addAll(attributeList);

    attributeList.forEach((element) {
      attributeNameList.add(element.title ?? '');
    });
    debugPrint('zoneList json ${zoneList.length}');
    notifyListeners();
  }

  Future<bool> savePricingByZone(data, String? serviceTextId, String planId, String zoneId, String categoryId, BuildContext context) async {
    AnimationController? localAnimationController;
    debugPrint('SEND DATA ${data}');
    try {
      print('RESPONSE URL: ${urlBase}service/PriceConfiguration/${serviceTextId}/${categoryId}/${planId}/${zoneId}/${pricingStatus ?? 'dummy'}');
      var header = {"Authorization": "Bearer ${token}", "Content-Type": "application/json"};

      Response response = await post(Uri.parse("${urlBase}service/PriceConfiguration/${serviceTextId}/${categoryId}/${planId}/${zoneId}/${pricingStatus ?? 'dummy'}"), headers: header, body: data);
      var responseDecodeJson = jsonDecode(response.body);

      //price_configuration

      print('RESPONSE BODY: ${responseDecodeJson.toString()}');
      if (response.statusCode == 201) {
        //show success msg
        showCustomSnackBar(
          context,
          responseDecodeJson['message'],
          Colors.white,
          TextStyle(color: myColors.green, fontSize: 22, fontWeight: FontWeight.bold),
          localAnimationController,
        );

        return true;
      } else {
        DashboardHelpers.showAlert(msg: 'please try again');
        return false;
      }
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'Something Went Wrong');
      print("catch ${e}");
      print(e);
      return false;
    }
  }

  // Future<bool> getPriceConfigurationPreview(String? serviceTextId, String planId, String zoneId) async {
  //   print('serviceTextId ${serviceTextId}');
  //   try {
  //     print("PriceConfigurationPreview is calling.....");
  //
  //     var header = {"Authorization": "Bearer ${token}", "Content-Type": "application/json"};
  //
  //     Response response = await get(
  //       Uri.parse("${urlBase}service/PriceConfigurationPreview/${serviceTextId}/${planId}/${zoneId}"),
  //       headers: header,
  //     );
  //     var responseDecodeJson = jsonDecode(response.body);
  //     print('URL ${urlBase}service/PriceConfigurationPreview/${serviceTextId}/${planId}/${zoneId}');
  //
  //     print('RESPONSE BODY: ${responseDecodeJson.toString()}');
  //
  //     if (response.statusCode == 200) {
  //       // Access 'get_plan_list' value
  //       priceConfigrationModelList.clear();
  //       bundleAttributeList.clear();
  //       for (Map i in responseDecodeJson['price_configuration']) {
  //         priceConfigrationModelList.add(PriceConfigrationModel.fromJson(i));
  //       }
  //
  //       isBundleService = responseDecodeJson['isBundle'];
  //
  //       previewServiceInfoModel = PricePreviewServiceInfoModel.fromJson(responseDecodeJson['service_info']);
  //
  //       if (isBundleService) {
  //         for (Map<String,dynamic> i in responseDecodeJson['attributesData']) {
  //           bundleAttributeList.add(BundleAttributeModel.fromJson(i));
  //         }
  //       }
  //
  //       notifyListeners();
  //       print('priceConfigrationModelList ${priceConfigrationModelList.length}');
  //
  //       isExpanded = List.generate(priceConfigrationModelList.length, (index) => false);
  //       debugPrint('isExpanded ${isExpanded.length}');
  //
  //       return true;
  //     } else {
  //       DashboardHelpers.showAlert(msg: 'No Pricing Found');
  //       // workerServiceModel.clear();
  //       // notifyListeners();
  //       return false;
  //     }
  //   } catch (e) {
  //     DashboardHelpers.showAlert(msg: 'Something Went Wrong');
  //     print('URL ${urlBase}service/PriceConfigurationPreview/${serviceTextId}/${planId}/${zoneId}');
  //     print("catch this error ${e}");
  //     print(e);
  //     return false;
  //   }
  // }

  void setExpanded(int index, bool value) {
    isExpanded[index] = value;
    notifyListeners();
  }

  void closeAllExpandedValue() {
    isExpanded.fillRange(0, isExpanded.length, false);
  }

  Future<void> setNewZipInfoList(String textId, int index) async {
    zipCodeNameList.clear();
    priceConfigrationPreviewList.forEach((element) {
      if (element.zoneTextId == textId) {
        zipCodeNameList.addAll(element.zipWisePrice ?? ['No zip code']);
      }
    });
    notifyListeners();
  }

  Future<bool> getAllServicesOfUser() async {
    try {
     // workerServiceModel.clear();
      print("getAllServicesOfUser is calling.....");
      var header = {"Authorization": "Bearer ${token}", "Content-Type": "application/json"};

      Response response = await get(
        Uri.parse("${urlBase}service/MyServiceForPricing/"),
        headers: header,
      );
      print('URL :${urlBase}service/MyServiceForPricing/');
      print('RESPONSE BODY: ${jsonDecode(response.body)}');

      if (response.statusCode == 200) {
        var responseDecodeJson = jsonDecode(response.body);
        pendingListFinal.clear();
        for (Map i in responseDecodeJson['serviceListPending']) {
          pendingListFinal.add(PendingRequestedServiceList.fromJson(i));
        }

        requestedListFinal.clear();
        for (Map i in responseDecodeJson['serviceListRequest']) {
          requestedListFinal.add(PendingRequestedServiceList.fromJson(i));
        }

        isloadingPrices = false;
        notifyListeners();
        return true;
      } else {
        DashboardHelpers.showAlert(msg: 'No Service Found');
       // workerServiceModel.clear();
        isloadingPrices = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      isloadingPrices = false;
      notifyListeners();
      DashboardHelpers.showAlert(msg: 'No Service Found');
      print("catch");
      print(e);
      return false;
    }
  }

  isLoadingPrices(bool loading) {
    isloadingPrices = loading;
    //notifyListeners();
  }

  void setLoadinIndex(int index, bool val) {
    // workerServiceModel[index].selected = val;
    pendingListFinal[index].selected = val;
    notifyListeners();

    debugPrint('pendingListFinal[index].selected ${pendingListFinal[index].selected}');
  }

  void setAllValuesToFalse() {
    pendingListFinal.forEach((e) {
      e.selected = false;
    });
    notifyListeners();
  }

  void getPreviousValue(ZoneList? selectedZone, String plan) {
    previousPricingInfoList.clear();
    minimumPrice = '';
    // Flag to determine if the plan exists
    bool doesPlanExist = false;

    // Loop through the priceConfigrationModelList
    for (var priceConfig in priceConfigrationModelList) {
      // Check if the zoneTitle matches the selected zone's title
      if (priceConfig.zoneTextId == selectedZone!.zoneTextId) {
        // Loop through the planArray of the current price configuration
        for (var element in priceConfig.planArray!) {
          // Check if the planName matches the provided plan name
          if (element.planTextId == plan) {
            debugPrint(element.minimumPrice);
            previousPricingAttributeList.clear();
            previousPricingAttributeList.addAll(element.attributes ?? []);
            // Set doesPlanExist to true
            minimumPrice = element.minimumPrice ?? '';
            doesPlanExist = true;
            break; // Exit the loop since the plan is found
          } else {
            minimumPrice = '';
          }
        }
        // Exit the outer loop since the zone is found
        break;
      }
    }
    // Update the btnUpdate based on whether the plan exists
    btnUpdate = doesPlanExist;

    debugPrint('minimumPrice ${minimumPrice}');
    // Notify listeners about the changes
    notifyListeners();
  }

  bool getBundlePreviousValue(ZoneList selectedZone, String selectedPlan) {
    print('SELECTED ZONE ${selectedZone.zoneTitle} and SELECTED PLAN $selectedPlan');

    for (var element in priceConfigrationModelList) {
      if (element.zoneTextId == selectedZone.zoneTextId) {
        for (var planElement in element.planArray ?? []) {
          if (planElement.planName == selectedPlan) {
            minimumPrice = planElement.minimumPrice.toString();
            bundleEstTime = planElement.estTime.toString();
            print('PRICE FOUND');
            notifyListeners();
            return true; // Exit the method after finding the price
          }
        }
      }
    }

    // If the loop completes without finding the price
    minimumPrice = '';
    bundleEstTime = '';
    print('PRICE NOT FOUND');
    notifyListeners();
    return false; // Indicate that the price was not found
  }

  Future<void> getPlanwizeServiceAreaInfo(String selectedPlan) async {
    priceConfigrationPreviewList.clear();
    getPlanattributeList.clear();
    priceConfigrationModelList.forEach((e1) {
      e1.planArray!.forEach((e2) {
        if (e2.planName == selectedPlan) {
          priceConfigrationPreviewList.add(e1);
          // getPlanattributeListLive.addAll(e1.planArray!.firstWhere((element) => element.planName == selectedPlan).attributes!);
        }
      });
    });
    //FOR EXPANDING ICON
    isExpanded = List.generate(priceConfigrationPreviewList.length, (index) => false);
    debugPrint('isExpanded 1 ${isExpanded.length}');
    //can be use
    //notifyListeners();
  }

  Future<void> getPlanwizeServiceAreaInfoNew(String selectedPlanId) async {
    requestedServiceDetailsPricingListShow.clear();
    requestedServiceDetailsPricingList.forEach((data) {
      if (data.requestedplanArray!.any((e) => e.planTextId == selectedPlanId)) {
        requestedServiceDetailsPricingListShow.add(data);
        debugPrint('data.requestedplanArray!.first.minimumPrice ${selectedPlanId} ${data.requestedplanArray!.first.minimumPrice}');
      }
    });
    debugPrint('requestedServiceDetailsPricingListShow $selectedPlanId ${requestedServiceDetailsPricingListShow.length}');
    notifyListeners();
  }

  String getTotalPrice(List<RequestedAttributes> attributeList) {
    double price = 0.0;
    attributeList.forEach((element) {
      element.requestedOptions!.forEach((element) {
        price = price + double.parse(element.price.toString());
      });
    });

    return price.toStringAsFixed(2);
  }

  // void getPendingRequestedPricingService(bool bool) {
  //   if (bool == true) {
  //     workerServiceModelShow.clear();
  //     workerServiceModelShow.addAll(workerServiceModel);
  //     print('workerServiceModelShow ${workerServiceModelShow.length}');
  //     notifyListeners();
  //   } else {
  //     workerServiceModelShow.clear();
  //     workerServiceModelShow.addAll(workerServiceModel.where((element) => element.isPrice == bool));
  //     print('workerServiceModelShow ${workerServiceModelShow.length}');
  //     notifyListeners();
  //   }
  // }

  String getTopPricingValue(String? pricingBy) {
    if (pricingBy == 'Unit') {
      return pricingBy ?? 'Unit';
    } else if (pricingBy == 'Sqft' || pricingBy == 'Sqmt') {
      return 'Area/Size';
    } else {
      return pricingBy ?? '';
    }
  }

  //
  // Map<String, Map<String, dynamic>> _attributesValueMap = {};
  // Map<String, Map<String, dynamic>> get attributesValueMap => _attributesValueMap;

  //  //dont remove
  // setAttributeValueMap({
  //   required String attributeId,
  //   required String type,
  //   required String value,
  //   required String label,
  // }) {
  //   String key = "${attributeId}${label.toLowerCase().replaceAll(' ', '')}";
  //   debugPrint('Generated key $key');
  //
  //   // Preserve existing values
  //   final existingEntry = _attributesValueMap[key] ?? {};
  //   final existingPrice = existingEntry["price"] ?? 0;
  //   final existingEstTime = existingEntry["estTime"] ?? 0;
  //   debugPrint('existingPrice ${existingPrice}');
  //   debugPrint('existingEstTime ${existingEstTime}');
  //
  //   // Update the map based on type
  //   _attributesValueMap[key] = type == "price"
  //       ? {
  //     "optionLabel": label,
  //     "price": value,
  //     "estTime":pricingScreenButtonStatus=='Save'? existingEstTime : getPreviousTimeIfExists(attributeId, label, existingEstTime.toString())// Retain existing estTime
  //   }
  //       : {
  //     "optionLabel": label,
  //     "price":pricingScreenButtonStatus=='Save'? existingPrice:getPreviousPriceIfExists(attributeId, label, existingPrice),
  //     "estTime": value,
  //   };
  //
  //   notifyListeners();
  //   debugPrint('attributesValueMap.toString() ${_attributesValueMap.toString()}');
  // }

  //
  clearAllAttributeValue() {
    attributeListTesting.clear();
    notifyListeners();
  }

  String getPrice(List<RequestedAttributes>? attributes) {
    double price = 0;
    if (attributes != null) {
      attributes.forEach((attribute) {
        if (attribute.requestedOptions != null) {
          attribute.requestedOptions!.forEach((e) {
            price = price + safeParsePrice(e.price);
          });
        }
      });
    }
    return price.toStringAsFixed(2);
  }

  double safeParsePrice(String? price) {
    try {
      return double.parse(price ?? '0');
    } catch (e) {
      return 0.0;
    }
  }

  void showLoadingFields(bool bool) {
    showLoadingTextFields = bool;
    notifyListeners();
  }

  Future<bool> getPricingServiceViewDetails(String? serviceTextId, String status, String? categoryTextId) async {
    try {
     // workerServiceModel.clear();
      print("pricingServiceDetails is calling.....");
      var header = {"Authorization": "Bearer ${token}", "Content-Type": "application/json"};

      Response response = await get(
        Uri.parse("${urlBase}service/pricingServiceDetails/${status}/${serviceTextId}/${categoryTextId}"),
        headers: header,
      );
      print('URL :${urlBase}service/pricingServiceDetails/${status}/${serviceTextId}/${categoryTextId}');
      print('RESPONSE BODY : ${jsonDecode(response.body)}');
      print('Service Status : ${status}');
      if (response.statusCode == 200) {
        var responseDecodeJson = jsonDecode(response.body);
        pricingServiceDetailsinfo = PricingServiceInfo.fromJson(responseDecodeJson['pricingServiceData']['pricingServiceInfo']);
        pendingPlanArrayList.clear();
        pricingZoneArrayList.clear();
        for (Map i in responseDecodeJson['pricingServiceData']['pricingPlanArray']) {
          pendingPlanArrayList.add(PricingPlanArray.fromJson(i));
        }
        for (Map i in responseDecodeJson['pricingServiceData']['pricingZoneArray']) {
          pricingZoneArrayList.add(PricingZoneArray.fromJson(i));
        }
        debugPrint('pendingPlanArrayList ${pendingPlanArrayList.length}');

        // // detailsZoneZipCodeList.clear();
        for (Map i in responseDecodeJson['pricingServiceData']['zoneArrayList']) {
          detailsZoneZipCodeList.add(DetailsZoneZipcodes.fromJson(i));
        }
        debugPrint('detailsZoneZipCodeList ${detailsZoneZipCodeList.length}');

        // This is for requested service list only
        if (status != 'Pending') {
          requestedServiceDetailsPricingList.clear();
          for (Map i in responseDecodeJson['pricingServiceData']['pricingData']) {
            requestedServiceDetailsPricingList.add(RequestedServiceDetailsModel.fromJson(i));
          }
          //generate bool to open and close widget
          isExpanded = List.generate(requestedServiceDetailsPricingList.length, (index) => false);
          debugPrint('requestedServiceDetailsPricingList ${requestedServiceDetailsPricingList.length}');
          debugPrint('isExpanded 0 ${isExpanded.length}');
        }
        notifyListeners();
        return true;
      } else {
        DashboardHelpers.showAlert(msg: 'Something Went Wrong');
       // workerServiceModel.clear();
        notifyListeners();
        return false;
      }
    } catch (e) {
      notifyListeners();
      DashboardHelpers.showAlert(msg: 'Something Went Wrong');
      print("catch");
      print(e);
      return false;
    }
  }

  void generateBooleanListForLoading(int length) {
    loadingList.clear();
    loadingList = List.generate(length, (_) => false);
  }

  void isLoadingViewDetails(int index, bool loading) {
    loadingList[index] = loading;
    notifyListeners();
  }

  void setZoneListFromPrefered3(List<ZoneList> list) {
    zoneList.addAll(list);

    notifyListeners();
  }

  void showEditButton(bool bool) {
    editButton = bool;
    notifyListeners();
  }

  void updateDetailsZoneZipArray(response) {
    detailsZoneZipCodeList.clear();
    pricingZoneArrayList.clear();
    for (Map i in response['zoneZipArray']) {
      detailsZoneZipCodeList.add(DetailsZoneZipcodes.fromJson(i));
    }
    for (Map i in response['zoneArray']) {
      pricingZoneArrayList.add(PricingZoneArray.fromJson(i));
    }

    debugPrint('detailsZoneZipCodeList ${detailsZoneZipCodeList.length}');
    debugPrint('pricingZoneArrayList ${pricingZoneArrayList.length}');

    notifyListeners();
  }

  void setClickedPending(bool val) {
    isClickedLoading = val;
    notifyListeners();
  }

  void updateAttributes({
    required String textId,
    required String optionLabel,
    required String value,
    required String update,
  }) {
    for (var attribute in attributeListTesting) {
      if (attribute.textId == textId) {
        for (var option in attribute.options ?? []) {
          if (option.optionLabel == optionLabel) {
            // Update the price
            update == 'price' ? option.price = value : option.estTime = value;
            print('Updated price: ${option.price}');
            print('Updated time: ${option.estTime}');
            return; // Exit after updating
          }
        }
      }
    }
    notifyListeners();
    print('No match found for textId: $textId and optionLabel: $optionLabel');
  }

  Future<bool> getServicePreview(String? serviceTextId, String status, String? categoryTextId) async {
    ApiService apiService = ApiService();
    var result = await apiService.getData('service/pricingServiceDetails/${status}/${serviceTextId}/${categoryTextId}');
    if (result != null) {
      pricingServiceDetailsinfo = PricingServiceInfo.fromJson(result['pricingServiceData']['pricingServiceInfo']);
      pendingPlanArrayList.clear();
      requestedServiceDetailsPricingList.clear();
      // pricingZoneArrayList.clear();
      for (Map i in result['pricingServiceData']['pricingPlanArray']) {
        pendingPlanArrayList.add(PricingPlanArray.fromJson(i));
      }

      for (Map i in result['pricingServiceData']['pricingData']) {
        requestedServiceDetailsPricingList.add(RequestedServiceDetailsModel.fromJson(i));
      }

      debugPrint('requestedServiceDetailsPricingList ${requestedServiceDetailsPricingList.length}');
      //generate bool to open and close widget
      // isExpanded2 = List.generate(requestedServiceDetailsPricingList.length, (index) => false);
      //
      // isExpanded2.forEach((e){
      //   debugPrint('isExpanded ${e}');
      // });

      // for (Map i in result['pricingServiceData']['pricingZoneArray']) {
      //   pricingZoneArrayList.add(PricingZoneArray.fromJson(i));
      // }
      // debugPrint('pendingPlanArrayList ${pendingPlanArrayList.length}');
      // detailsZoneZipCodeList.clear();
      // for (Map i in result['pricingServiceData']['zoneArrayList']) {
      //   detailsZoneZipCodeList.add(DetailsZoneZipcodes.fromJson(i));
      // }
      // debugPrint('detailsZoneZipCodeList ${detailsZoneZipCodeList.length}');
      // notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
