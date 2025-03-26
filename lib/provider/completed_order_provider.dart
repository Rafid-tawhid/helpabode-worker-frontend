import 'package:flutter/cupertino.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:help_abode_worker_app_ver_2/models/worker_service_request_model.dart';

import '../helper_functions/api_services.dart';
import '../models/completed_order_details_model.dart';
import '../models/tracker_model.dart';

class CompletedOrderProvider extends ChangeNotifier {
  bool clicked = false;
  List<OrderItems> completedServiceModelList = [];
  List<CompletedOrderDetailsModel> completedOrderDetailsList = [];
  bool loadingAllCompletedService = false;
  final List<String> imageUrls = [
    "https://img.freepik.com/free-photo/blue-house-with-blue-roof-sky-background_1340-25953.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUTdywojKNrpBhg60_Ro53kqRgPoMNnqtiP6E0h115ZA&s",
    "https://img.freepik.com/free-photo/blue-house-with-blue-roof-sky-background_1340-25954.jpg",
    "https://img.freepik.com/free-photo/blue-house-with-blue-roof-sky-background_1340-25955.jpg",
    "https://img.freepik.com/free-photo/blue-house-with-blue-roof-sky-background_1340-25956.jpg",
  ];

  Future<bool> getWorkerCompletedService() async {
    ApiService apiService = ApiService();
    setLoadingData(true);
    final data = await apiService.getData('api/workerCompletedServices');
    setLoadingData(false);
    if (data != null) {
      completedServiceModelList.clear();
      for (Map i in data['order_data']) {
        completedServiceModelList.add(OrderItems.fromJson(i));
      }
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getSelectedCompletedOrderDetails(
      String orderTimesId, String serviceId) async {
    ApiService apiService = ApiService();
    isClickedButton(true);
    final data = await apiService
        .getData('api/workerCompletedServiceDetails/$orderTimesId/$serviceId');
    isClickedButton(false);
    if (data != null) {
      completedOrderDetailsList.clear();
      for (Map i in data['order_data']) {
        completedOrderDetailsList.add(CompletedOrderDetailsModel.fromJson(i));
      }
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void setLoadingData(bool val) {
    loadingAllCompletedService = val;
    notifyListeners();
  }

  void isClickedButton(bool val) {
    clicked = val;
    notifyListeners();
  }

  void setImageToPreview(List<String> beforeArray) {
    imageUrls.clear();
    imageUrls.addAll(beforeArray);
    notifyListeners();
  }
}
