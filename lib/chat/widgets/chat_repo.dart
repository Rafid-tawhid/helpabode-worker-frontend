import 'package:flutter/cupertino.dart';
import 'package:help_abode_worker_app_ver_2/misc/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiResponse {
  final bool success;
  final dynamic data;
  final String? error;
  final int? statusCode; // New statusCode variable

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.statusCode, // Include statusCode in the constructor
  });

  // Factory constructor for a successful response
  factory ApiResponse.withSuccess(http.Response response) {
    return ApiResponse(
      success: true,
      data: json.decode(response.body),
      statusCode: response.statusCode, // Capture statusCode from response
    );
  }

  // Factory constructor for an error response
  factory ApiResponse.withError(String error, http.Response? response) {
    return ApiResponse(
      success: false,
      error: error,
      statusCode: response
          ?.statusCode, // Capture statusCode from response, if available
      data: response?.body != null ? json.decode(response!.body) : null,
    );
  }
}

class ApiErrorHandler {
  static String getMessage(dynamic error) {
    return error.toString();
  }
}

class ChatRepo {
  final http.Client httpClient;

  ChatRepo({required this.httpClient});

  Future<ApiResponse> chatHistoryRepo({
    required String orderTimeId,
  }) async {
    final uri = Uri.parse("${urlBase}service/get-chat/$orderTimeId/");

    try {
      final response = await httpClient.get(uri);

      debugPrint('RETURN RESPONSE ${response.body.toString()}');

      if (response.statusCode == 200) {
        return ApiResponse.withSuccess(response);
      } else {
        return ApiResponse.withError('Error: ${response.statusCode}', response);
      }
    } catch (error) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(error), null);
    }
  }

  Future<ApiResponse> saveChatImagesRepo({
    required http.MultipartRequest request,
  }) async {
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('SAVE IMAGE RESPONSE ${jsonDecode(response.body).toString()}');

      if (response.statusCode == 200) {
        return ApiResponse.withSuccess(response);
      } else {
        return ApiResponse.withError('Error: ${response.statusCode}', response);
      }
    } catch (error) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(error), null);
    }
  }
}
