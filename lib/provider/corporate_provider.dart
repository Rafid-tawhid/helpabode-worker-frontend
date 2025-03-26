import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:help_abode_worker_app_ver_2/models/corporate_team_member_model.dart';
import 'package:help_abode_worker_app_ver_2/models/user_model.dart';
import 'package:help_abode_worker_app_ver_2/models/worker_service_request_model.dart';
import 'package:http/http.dart';
import '../corporate/repos.dart';
import '../helper_functions/api_services.dart';
import '../helper_functions/dashboard_helpers.dart';
import '../misc/constants.dart';
import '../models/corporate_review_data_model.dart';
import '../models/corporate_roles_model.dart';
import '../models/corporate_schedule_model.dart';
import '../models/corporate_search_category_model.dart';
import '../models/corporation_category_selection_model.dart';
import '../models/corporation_type_model.dart';
import '../models/member_full_details_model.dart';

class CorporateProvider extends ChangeNotifier {
  List<CorporateRolesModel> affiliationList = [];
  List<CorporationTypeModel> corporationTypeList = [];
  List<String> teamList = [];
  List<String> teamMemberArray = [];
  List<TeamMemberModel> teamMemberArrayList = [];
  List<CorporationCategorySelectionModel> corporationCategorySelectionList = [];
  List<Children> selectedServiceList = [];
  bool _isLoading = false;
  bool _isLoadingSearch = false;
  String _errorMessage = '';
  Map<String, dynamic>? _response;
  bool get isLoadingAll => _isLoading;
  bool get isLoadingSearch => _isLoadingSearch;
  String get errorMessage => _errorMessage;
  Map<String, dynamic>? get response => _response;
  List<CorporateSearchCategoryModel> corporateSearchCategoryList = [];
  CorporateReviewDataModel corporateReviewDataModel =
      CorporateReviewDataModel();

  setAffiliationList(dynamic json) {
    if (json != []) {
      affiliationList.clear();
      for (Map i in json) {
        affiliationList.add(CorporateRolesModel.fromJson(i));
      }
    }
    debugPrint('affiliationList ${affiliationList.length}');
    notifyListeners();
  }

  setCorporation_type_arrayList(dynamic json) {
    if (json != []) {
      corporationTypeList.clear();
      for (Map i in json) {
        corporationTypeList.add(CorporationTypeModel.fromJson(i));
      }
    }
    debugPrint('corporationTypeList ${corporationTypeList.length}');
    notifyListeners();
  }

  Future<bool> setApplitationValue(
      String affilationId, String corporationType) async {
    print('setApplitationValue is calling...');

    try {
      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };
      dynamic data = {
        "workerTextId": textId,
        "affiliationTextId": affilationId
      };
      print('SEND BODY ${data}');

      Response response = await post(
          Uri.parse("${urlBase}corporate/affiliation-update/"),
          headers: header,
          body: jsonEncode(data));
      var responseDecodeJson = jsonDecode(response.body);

      print('RESPONSE BODY: ${responseDecodeJson.toString()}');
      if (response.statusCode == 201) {
        // print('SUCESS responseDecodeJson ${responseDecodeJson.toString()}');

        //get all saved value after saving

        return true;
      } else {
        DashboardHelpers.showAlert(
            msg: responseDecodeJson['message'] ?? 'Something Went Wrong');
        return false;
      }

      return true;
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'Something Went Wrong');
      print("catch");
      print(e);
      return false;
    }
  }

  Future<bool> postCorporationDetails(String companyName, String alternateName,
      String email, String number, String taxId, File article) async {
    debugPrint('#####____ POST postCorporationDetails WORK ____#####');

    debugPrint(
        'Send Body: {name: ${companyName},alt: ${alternateName},email: ${email},number: ${number},txId: ${taxId},article: ${article}');
    var header = {
      "Authorization": "Bearer ${token}",
    };

    print(header);

    try {
      var request = MultipartRequest(
          'POST', Uri.parse('${urlBase}corporate/corporation-details/'));

      request.fields['workerTextId'] = '${userBox.get('textId')}';
      request.fields['corporationName'] = companyName;
      request.fields['alternateName'] = alternateName;
      request.fields['email'] = email;
      request.fields['contactNumber'] = number;
      request.fields['taxId'] = taxId;

      request.headers.addAll(header);
      request.files.add(
          await MultipartFile.fromPath('corporationArticle', article.path));

      print('Hello World 2');
      print('${userBox.get('status')}');
      print('${userBox.get('textId')}');

      var response = await request.send();

      print('Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print('Response Body: $responseBody');

        // If further processing of response data is needed, it can be done here

        return true; // Successful request
      } else {
        DashboardHelpers.showAlert(msg: 'Something went wrong');
        print('Request failed with status: ${response.statusCode}');
        return false; // Request failed
      }
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'Something went wrong');
      print('Error occurred: $e');
      return false; // Error handling
    }
  }

  Future<bool> setCorporationAddress(dynamic data) async {
    print('setCorporationAddress is calling...');

    try {
      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };
      print('SEND BODY ${data}');

      Response response = await post(
          Uri.parse("${urlBase}corporate/corporation-address-update/"),
          headers: header,
          body: jsonEncode(data));
      var responseDecodeJson = jsonDecode(response.body);

      print('RESPONSE CODE: ${response.statusCode}');
      print('RESPONSE BODY: ${responseDecodeJson.toString()}');
      if (response.statusCode == 200) {
        // print('SUCESS responseDecodeJson ${responseDecodeJson.toString()}');

        //get all saved value after saving

        return true;
      } else {
        DashboardHelpers.showAlert(
            msg: responseDecodeJson['message'] ?? 'Something Went Wrong');
        return false;
      }

      return true;
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'Something Went Wrong');
      print("catch");
      print(e);
      return false;
    }
  }

  bool isLoadingConfig = false;
  bool get isLoading => isLoadingConfig;

  Future<bool> getTeamConfiguration() async {
    isLoadingConfig = true;
    notifyListeners();

    try {
      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };
      Response response = await get(
          Uri.parse("${urlBase}corporate/team-configuration/"),
          headers: header);
      var responseDecodeJson = jsonDecode(response.body);

      if (response.statusCode == 201) {
        teamList.clear();
        for (String i in responseDecodeJson['teamArray']) {
          teamList.add(i);
        }
        teamMemberArray.clear();
        for (String i in responseDecodeJson['teamMemberArray']) {
          teamMemberArray.add(i);
        }
        notifyListeners();
        return true;
      } else {
        DashboardHelpers.showAlert(
            msg: responseDecodeJson['message'] ?? 'Something Went Wrong');
        return false;
      }
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'Something Went Wrong');
      print("catch");
      print(e);
      return false;
    } finally {
      isLoadingConfig = false;
      notifyListeners();
    }
  }

  Future<bool> setTeamMember(
      String? selectedMember, String? selectedTeam) async {
    print('setCorporationAddress is calling...');

    try {
      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };
      var data = {
        "workerTextId": textId,
        "numberOfTeam": selectedTeam,
        "numberOfTeamMember": selectedTeam
      };
      print('SEND BODY ${data}');

      Response response = await post(
          Uri.parse("${urlBase}corporate/team-configuration/"),
          headers: header,
          body: jsonEncode(data));
      var responseDecodeJson = jsonDecode(response.body);

      print('RESPONSE CODE: ${response.statusCode}');
      print('RESPONSE BODY: ${responseDecodeJson.toString()}');
      if (response.statusCode == 201) {
        // print('SUCESS responseDecodeJson ${responseDecodeJson.toString()}');

        return true;
      } else {
        DashboardHelpers.showAlert(
            msg: responseDecodeJson['message'] ?? 'Something Went Wrong');
        return false;
      }
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'Something Went Wrong');
      print("catch");
      print(e);
      return false;
    }
  }

  Future<bool> addNewCorporateMember(Map<String, Object?> data) async {
    print('addNewCorporateMember is calling...');

    try {
      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };
      print('SEND BODY ${data}');

      Response response = await post(
          Uri.parse("${urlBase}corporate/team-member-add/"),
          headers: header,
          body: jsonEncode(data));
      var responseDecodeJson = jsonDecode(response.body);

      print('RESPONSE CODE: ${response.statusCode}');
      print('RESPONSE BODY: ${responseDecodeJson.toString()}');
      if (response.statusCode == 201) {
        //get all saved value after saving

        teamMemberArrayList.clear();
        //get all saved value after saving
        for (Map i in responseDecodeJson['member_list']) {
          teamMemberArrayList.add(TeamMemberModel.fromJson(i));
        }

        debugPrint('teamMemberArrayList ${teamMemberArrayList.length}');
        notifyListeners();
        return true;
      } else {
        DashboardHelpers.showAlert(
            msg: responseDecodeJson['message'] ?? 'Something Went Wrong');
        return false;
      }

      return true;
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'Something Went Wrong');
      print("catch");
      print(e);
      return false;
    }
  }

  Future<void> uploadCorporateDocs(File article, String entity, String state1,
      File salesTax, String taxId, String state2) async {
    _isLoading = true;
    notifyListeners();

    CorporationRepository repo = CorporationRepository();
    final result = await repo.postCorporateDocumentation(
        article, entity, state1, salesTax, taxId, state2);

    if (result.containsKey('message')) {
      _errorMessage = result['message'];
    } else {
      _response = result;
    }
    _isLoading = false;
    notifyListeners();
  }

  void getAllItemsAndCategory() async {
    ApiService apiService = ApiService();
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final result =
        await apiService.getData('corporate/corporation-category-selection');

    if (result != null) {
      corporationCategorySelectionList.clear();
      selectedServiceList.clear();
      for (var i in result['results']) {
        corporationCategorySelectionList
            .add(CorporationCategorySelectionModel.fromJson(i));
      }
      notifyListeners();
      debugPrint(
          'corporationCategorySelectionList ${corporationCategorySelectionList.length}');
    } else {
      _errorMessage = "Failed to fetch data.";
    }

    _isLoading = false;
    notifyListeners();
  }

  void changeExpandable(CorporationCategorySelectionModel item, bool expanded) {
    item.isSelected = expanded;
    notifyListeners();
  }

  void addToList(Children item) {
    debugPrint(item.categoryTextId.toString());

    // Check if the item is already in the list by comparing textId
    bool exists =
        selectedServiceList.any((element) => element.textId == item.textId);

    if (exists) {
      // If the item exists, remove it
      selectedServiceList
          .removeWhere((element) => element.textId == item.textId);
    } else {
      // If the item doesn't exist, add it
      selectedServiceList.add(item);
    }
    notifyListeners();
    debugPrint('selectedServiceList ${selectedServiceList.length}');
  }

  void getCategorySearchItems(String val) async {
    try {
      // Check if the search value is empty
      if (val.isEmpty) {
        corporateSearchCategoryList.clear();
        notifyListeners(); // Update the UI
        return; // Don't proceed further
      }

      print("getCategorySearchItems is calling..... Value: $val");

      setIsLoadingSearch(true);

      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };

      Response response = await get(
        Uri.parse("${urlBase}corporate/search-category/?q=${val}"),
        headers: header,
      );

      var responseDecodeJson = jsonDecode(response.body);
      print(responseDecodeJson.toString());

      if (response.statusCode == 200) {
        corporateSearchCategoryList.clear();
        for (Map i in responseDecodeJson['results']) {
          corporateSearchCategoryList
              .add(CorporateSearchCategoryModel.fromJson(i));
        }
        print(
            'corporateSearchCategoryList LENGTH : ${corporateSearchCategoryList.length}');
        notifyListeners();
      } else if (response.statusCode == 404) {
        // No result found
        corporateSearchCategoryList.clear();
        notifyListeners();
      }
    } catch (e) {
      corporateSearchCategoryList.clear();
      notifyListeners();
      print("catch");
      print(e);
    } finally {
      setIsLoadingSearch(false);
    }
  }

  void setIsLoadingSearch(bool val) async {
    _isLoadingSearch = val;
    notifyListeners();
  }

  void clearSearchList() {
    corporateSearchCategoryList.clear();
    notifyListeners();
  }

  //
  Future<bool> saveSelectedCategories() async {
    List<Map<String, dynamic>> mapList = [];

    selectedServiceList.forEach((e) {
      mapList.add(e.toJson());
    });

    debugPrint('send data ${mapList}');

    ApiService apiService = ApiService();
    // _isLoading = true;
    // _errorMessage = '';
    // notifyListeners();

    final result = await apiService.postData(
        'corporate/corporation-category-selection', mapList);

    if (result != null) {
      print('THIS IS COR ${result}');

      DashboardHelpers.showAlert(msg: result['message'] ?? '');
      // corporationCategorySelectionList.clear();
      // selectedServiceList.clear();
      // for(var i in result['results']){
      //   corporationCategorySelectionList.add(CorporationCategorySelectionModel.fromJson(i));
      // }
      // notifyListeners();
      // debugPrint('corporationCategorySelectionList ${corporationCategorySelectionList.length}');

      return true;
    } else {
      _errorMessage = "Failed to fetch data.";

      return false;
    }

    // _isLoading = false;
    // notifyListeners();
  }

  void getAllCorporateSubmittedDocumentInfo() async {
    ApiService apiService = ApiService();
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    final result = await apiService.getData('corporate/data-review-details/');

    if (result != null) {
      var data = CorporateReviewDataModel.fromJson(result['corporateData']);
      corporateReviewDataModel = data;
      // debugPrint('corporateReviewDataModel ${corporateReviewDataModel.toJson()}');
      debugPrint(
          'worker_category length ${corporateReviewDataModel.workerCategory!.length}');

      notifyListeners();
    } else {
      _errorMessage = "Failed to fetch data.";
    }
    _isLoading = false;
    notifyListeners();
  }

  void saveCorporateSubmittedDocumentInfo() async {
    ApiService apiService = ApiService();
    final result =
        await apiService.postData('corporate/data-review-details', [{}]);

    if (result != null) {
      debugPrint('SUCCESS ${result}');
    } else {
      _errorMessage = "Failed to fetch data.";
      debugPrint('Error ${_errorMessage}');
    }
  }

  MemberFullDetailsModel? get teamMemberDetails => _teamUser;
  MemberFullDetailsModel? _teamUser;
  UserModel? _singleMemberInfo;
  List<OrderItems> _teamMemberOrderList = [];
  List<OrderItems> get teamMemberOrderList => _teamMemberOrderList;
  List<CorporateScheduleModel> _corporateMemberScheduleList = [];
  List<CorporateScheduleModel> get corporateMemberScheduleList =>
      _corporateMemberScheduleList;
  UserModel? get singleMemberInfo => _singleMemberInfo;

  setIsLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<bool> getMemberDetailsData(TeamMemberModel member) async {
    ApiService apiService = ApiService();
    final data = await apiService
        .getData('corporate/worker/${member.textId}/profile-overview/');
    final schedule = await apiService
        .getData('corporate/worker/${member.textId}/schedule-viewer/');

    _isLoading = false;
    if (data != null || schedule != null) {
      _teamMemberOrderList.clear();
      _corporateMemberScheduleList.clear();
      _teamUser = MemberFullDetailsModel.fromJson(data['results']);
      _singleMemberInfo = _teamUser!.profileData;
      _teamUser!.orderData!.forEach((e) {
        _teamMemberOrderList.add(e);
      });
      for (var i in schedule['worker_schedule']) {
        _corporateMemberScheduleList.add(CorporateScheduleModel.fromJson(i));
      }

      //get todays schedule
      filterByToday(_corporateMemberScheduleList);
      debugPrint(
          '_corporateMemberScheduleList ${_corporateMemberScheduleList.length}');

      notifyListeners();
      return true;
    } else {
      _errorMessage = "Failed to fetch data.";
      debugPrint('Error ${_errorMessage}');
      notifyListeners();
      return false;
    }
  }

  List<CorporateScheduleModel> _filteredScheduleList = [];
  List<CorporateScheduleModel> get filteredScheduleList =>
      _filteredScheduleList;

  void filterByWeek(
      List<CorporateScheduleModel> schedules, DateTime weekStart) {
    DateTime weekEnd = weekStart.add(const Duration(days: 6));
    filteredScheduleList.clear();
    filteredScheduleList.addAll(schedules.where((schedule) {
      DateTime scheduleDate = DateTime.parse(schedule.scheduleDate ?? '');
      return scheduleDate
              .isAfter(weekStart.subtract(const Duration(days: 1))) &&
          scheduleDate.isBefore(weekEnd.add(const Duration(days: 1)));
    }).toList());
    notifyListeners();
  }

  void filterByMonth(
      List<CorporateScheduleModel> schedules, int month, int year) {
    filteredScheduleList.clear();
    filteredScheduleList.addAll(schedules.where((schedule) {
      DateTime scheduleDate = DateTime.parse(schedule.scheduleDate ?? '');
      return scheduleDate.month == month && scheduleDate.year == year;
    }).toList());
    notifyListeners();
  }

  void filterByToday(List<CorporateScheduleModel> schedules) {
    DateTime today = DateTime.now(); // Get today's date
    filteredScheduleList.clear();
    filteredScheduleList.addAll(schedules.where((schedule) {
      DateTime scheduleDate = DateTime.parse(schedule.scheduleDate ?? '');
      return scheduleDate.year == today.year &&
          scheduleDate.month == today.month &&
          scheduleDate.day == today.day; // Match year, month, and day
    }).toList());
    notifyListeners();
  }

  void getOrderListAccordingToStatus(String status) {
    debugPrint('_teamMemberOrderList ${status}');
    if (status == 'Completed') {
      List<OrderItems> data = [];
      _teamMemberOrderList.forEach((e) {
        if (e.serviceStatus == 'Completed') {
          data.add(e);
        }
      });
      _teamMemberOrderList.clear();
      _teamMemberOrderList.addAll(data);
    } else {
      _teamMemberOrderList.clear();
      _teamMemberOrderList.addAll(_teamUser!.orderData!);
    }
    debugPrint('_teamMemberOrderList ${_teamMemberOrderList.length}');
    _errorMessage = "";
    notifyListeners();
  }

  Future<bool> assignOrderToMember(Map<String, Object?> data) async {
    ApiService apiService = ApiService();
    var res = await apiService.postData('corporate/order-assign', {
      "assignWorkerTextId": data['assignWorkerTextId'],
      "serviceTextId": data['serviceTextId'],
      "orderItemId": data['orderItemId'],
      "categoryTextId": data['categoryTextId'],
    });
    return res != null ? true : false;
  }
}
