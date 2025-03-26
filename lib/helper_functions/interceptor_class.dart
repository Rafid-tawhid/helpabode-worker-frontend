import 'dart:async';
import 'package:http_interceptor/http_interceptor.dart';

import '../misc/constants.dart';

class CustomInterceptor implements InterceptorContract {
  @override
  FutureOr<bool> shouldInterceptRequest() {
    // This method indicates whether the request should be intercepted.
    // In most cases, you'd return `true` to always intercept.
    return true;
  }

  @override
  FutureOr<bool> shouldInterceptResponse() {
    // This method indicates whether the response should be intercepted.
    // In most cases, you'd return `true` to always intercept.
    return true;
  }

  @override
  FutureOr<BaseRequest> interceptRequest({required BaseRequest request}) {
    // Add Bearer token to the headers
    request.headers["Authorization"] = "Bearer $token";

    // Optionally log the request for debugging
    print("Request URL: ${request.url}");
    print("Request Headers: ${request.headers}");

    // Return the request after modification
    return request;
  }

  @override
  FutureOr<BaseResponse> interceptResponse({required BaseResponse response}) {
    // Optionally log the response for debugging
    print("Response Status Code: ${response.statusCode}");
    print("Response Headers: ${response.headers}");

    // You can handle specific status codes here (e.g., token expiration, errors)

    // Return the response after processing
    return response;
  }
}
