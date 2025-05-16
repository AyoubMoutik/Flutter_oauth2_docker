import 'dart:convert';

import 'package:flutter_oauth2/helpers/constant.dart';
import 'package:http/http.dart';

class AuthService {
  final loginUri = Uri.parse('${Constants.baseUrl}/api/login');
  final registerUri = Uri.parse('${Constants.baseUrl}/api/register');
  final refreshTokenUri = Uri.parse('${Constants.baseUrl}/api/refresh-token');

  Future<Response?> login(String email, String password) async {
    var res = await post(
      loginUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );
    return res;
  }

  Future<Response?> refreshToken(String token) async {
    var res = await post(
      refreshTokenUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"refresh_token": token}),
    );
    return res;
  }

  Future<Response?> register(String email, String password, String name) async {
    var res = await post(
      registerUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password, "name": name}),
    );
    return res;
  }
}
