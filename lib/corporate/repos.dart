import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../../../misc/constants.dart';

class CorporationRepository {
  final String apiUrl = "https://your-api-url.com/post-corporation";

  Future<Map<String, dynamic>> postCorporateDocumentation(
      File article,
      String entity,
      String state1,
      File salesTax,
      String taxId,
      String state2) async {
    try {
      var headers = {
        "Authorization": "Bearer $token",
      };

      var request = MultipartRequest('POST',
          Uri.parse('${urlBase}corporate/corporation-documents-update/'));

      request.fields['entityNo'] = entity;
      request.fields['corporationState'] = state1;
      request.fields['salesTaxId'] = taxId;
      request.fields['salesState'] = state2;

      request.headers.addAll(headers);

      request.files.add(
          await MultipartFile.fromPath('articleOfCorporation', article.path));
      request.files.add(await MultipartFile.fromPath(
          'stateSalesTaxCertificate', salesTax.path));

      var response = await request.send();

      debugPrint('RETURN CODE ${response.statusCode}');

      if (response.statusCode == 201) {
        var responseString = await response.stream.bytesToString();
        return jsonDecode(responseString);
      } else {
        return {
          "error": "Failed to upload. Status code: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"error": e.toString()};
    }
  }
}
