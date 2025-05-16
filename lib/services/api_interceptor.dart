import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_oauth2/services/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';

class ApiInterceptor implements InterceptorContract {
  final storage = const FlutterSecureStorage();
  final AuthService authService = AuthService();

  Future<String> get tokenOrEmpty async {
    var token = await storage.read(key: "token");
    if (token == null) return "";
    return token;
  }

  @override
  bool shouldInterceptRequest() => true;

  @override
  bool shouldInterceptResponse() => true;

  @override
  FutureOr<BaseRequest> interceptRequest({required BaseRequest request}) async {
    String token = await tokenOrEmpty;
    try {
      request.headers["Authorization"] = "Bearer $token";
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return request;
  }

  @override
  FutureOr<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    var refreshToken = await storage.read(key: "refresh_token");
    if (response.statusCode == 401 && refreshToken != null) {
      var res = await authService.refreshToken(refreshToken);
      var responseData = jsonDecode(res!.body);
      await storage.write(key: "token", value: responseData['access_token']);
      await storage.write(
        key: "refresh_token",
        value: responseData['refresh_token'],
      );
    }
    return response;
  }
}
