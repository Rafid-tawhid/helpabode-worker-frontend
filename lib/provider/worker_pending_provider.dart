import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:help_abode_worker_app_ver_2/helper_functions/api_services.dart';
import 'package:http/http.dart';

import '../helper_functions/dashboard_helpers.dart';
import '../misc/constants.dart';
import '../models/corporation_doc_validation_model.dart';
import '../models/document_update_model.dart';
import '../models/documentation_check_model.dart';

class WorkerPendingProvider extends ChangeNotifier {
  List<DocumentationCheckModel> documentationList = [];
  List<DocumentUpdateModel> documentUpdateInfoList = [];
  bool showLoading = false;

  Future<bool> getDocumentValidationCheck() async {
    ApiService apiService = ApiService();
    try {
      print("getDocumentValidationCheck is calling.....");
      setShowLoading(true);
      var data = await apiService.getData('api/documentValidationCheck');
      //clear for all
      documentationList.clear();

      for (Map i in data['document_chk']) {
        documentationList.add(DocumentationCheckModel.fromJson(i));
        print('documentationList ${documentationList.length}');
        notifyListeners();
      }
      return true;
    } catch (e) {
      print("catch ${e}");
      DashboardHelpers.showAlert(msg: 'Something went wrong');
      print(e);
      return false;
    } finally {
      setShowLoading(false);
    }
  }

  setShowLoading(bool val) {
    showLoading = val;
    notifyListeners();
  }

  Future<bool> postDocumentValidationUpdate(String status) async {
    try {
      print("postDocumentValidationUpdate is calling.....");
      var header = {
        "Authorization": "Bearer ${token}",
        "Content-Type": "application/json"
      };
      var body = {"workerTextId": textId, "workerStage": status};
      print('SEND BODY ${body}');
      print('SEND URL ${urlBase}api/getWorkerDocuments');
      Response response = await post(
          Uri.parse("${urlBase}api/getWorkerDocuments"),
          headers: header,
          body: jsonEncode(body));
      var responseDecodeJson = jsonDecode(response.body);
      //print('STATUS CODE ${response.statusCode}');
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        documentUpdateInfoList.clear();
        for (Map i in responseDecodeJson['dataArray']) {
          documentUpdateInfoList.add(DocumentUpdateModel.fromJson(i));
        }
        ;

        print(
            'documentUpdateInfoList ${documentUpdateInfoList.first.issueFor!.first}');
      }
      return true;
    } catch (e) {
      print("catch ${e}");
      DashboardHelpers.showAlert(msg: 'Something went wrong');
      print(e);
      return false;
    }
  }

  Future<bool> postWorkerDocumentUpdate(
      {required String stage,
      String? ssn,
      File? img1,
      File? img2,
      File? selfie,
      String? id,
      String? date}) async {
    bool returnRes = false;
    try {
      print("postWorkerDocumentUpdate is calling.....");

      debugPrint('SEND BODY : stage:${stage}');
      debugPrint('SEND BODY : ssn:${ssn}');
      debugPrint('SEND BODY : img1:${img1}');
      debugPrint('SEND BODY : img2:${img2}');
      debugPrint('SEND BODY : selfie:${selfie}');
      debugPrint('SEND BODY : ID:${id}');
      debugPrint('SEND BODY : Date:${date}');

      var header = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      };

      if (stage == PendingStatus.ssn) {
        returnRes = await _uploadSSN(stage, ssn, header);
      } else if (stage == PendingStatus.selfy) {
        returnRes = await _uploadSelfie(stage, selfie, header);
      } else if (stage == PendingStatus.photo) {
        returnRes = await _uploadPhotos(stage, img1, img2, id!, date!, header);
      }
      return returnRes;
    } catch (e) {
      print("catch $e");
      DashboardHelpers.showAlert(msg: 'Something went wrong');
      return false;
    }
  }

  Future<bool> _uploadSSN(
      String stage, String? ssn, Map<String, String> header) async {
    var body = {"workerTextId": textId, "workerStage": stage, "ssnData": ssn};

    Response response = await post(
        Uri.parse("${urlBase}api/workerDocumentUpdate"),
        headers: header,
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      DashboardHelpers.showAlert(msg: 'SSN Upload Successful');
      return true;
    }

    return false;
  }

  Future<bool> _uploadSelfie(
      String stage, File? selfie, Map<String, String> header) async {
    var request = MultipartRequest(
        'POST', Uri.parse('${urlBase}api/workerDocumentUpdate'));
    request.fields['workerTextId'] = textId;
    request.fields['workerStage'] = stage;
    request.headers.addAll(header);

    if (selfie != null) {
      request.files
          .add(await MultipartFile.fromPath('selfieData', selfie.path));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      DashboardHelpers.showAlert(msg: 'Profile Image Upload Successful');

      return true;
    }

    return false;
  }

  Future<bool> _uploadPhotos(String stage, File? img1, File? img2, String id,
      String date, Map<String, String> header) async {
    print('Driving license is uploading....');
    var request = MultipartRequest(
        'POST', Uri.parse('${urlBase}api/workerDocumentUpdate'));
    request.fields['workerTextId'] = textId;
    request.fields['workerStage'] = stage;
    request.fields['photoIdNo'] = id;
    request.fields['photoIdExpirationDate'] = date;
    request.headers.addAll(header);

    if (img1 != null) {
      request.files
          .add(await MultipartFile.fromPath('photoIdData1', img1.path));
    }
    if (img2 != null) {
      request.files
          .add(await MultipartFile.fromPath('photoIdData2', img2.path));
    }

    var response = await request.send();
    print('RESPNSE : ${response.request.toString()}');
    if (response.statusCode == 200) {
      DashboardHelpers.showAlert(msg: 'Image Upload Successful');
      return true;
    }

    return false;
  }

  Color getColorByStatus(String? status) {
    if (status == 'Approved') {
      return Color(0xFFECF7EF);
    } else if (status == 'Pending') {
      return Color(0xFFF7F7F7);
    } else {
      return Color(0xFFFFF1F1);
    }
  }

  Map<String, dynamic> getIconByStatus(String? status) {
    if (status == 'Approved') {
      return {
        'icon': Icons.check,
        'color': Colors.green,
      };
    } else if (status == 'Pending') {
      return {
        'icon': Icons.watch_later,
        'color': Colors.grey.shade700,
      };
    } else {
      return {
        'icon': Icons.error,
        'color': Color(0xffc40606),
      };
    }
  }

  CorporationDocValidationModel _corporationDocValidationModel =
      CorporationDocValidationModel();

  CorporationDocValidationModel get corporationDocValidationModel =>
      _corporationDocValidationModel;

  getCorporateValidationDocument() async {
    ApiService apiService = ApiService();
    try {
      setShowLoading(true);
      var data =
          await apiService.getData('corporate/document-validation-check/');

      _corporationDocValidationModel =
          CorporationDocValidationModel.fromJson(data['get_document_data']);
      notifyListeners();

      return true;
    } catch (e) {
      print("catch ${e}");
      DashboardHelpers.showAlert(msg: 'Something went wrong');
      print(e);
      return false;
    } finally {
      setShowLoading(false);
    }
  }
}

class PendingStatus {
  static const photo = 'PhotoId Required';
  static const selfy = 'Selfie Required';
  static const ssn = 'SSN Required';
}

// class StatusUtils {
//   static IconData getIconByStatus(Status status) {
//     switch (status) {
//       case Status.Approved:
//         return Icons.check;
//       case Status.Pending:
//         return Icons.access_time_rounded;
//       case Status.Error:
//         return Icons.error_outline;
//       default:
//         return Icons.help_outline; // Default icon if none match
//     }
//   }
