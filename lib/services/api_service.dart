import 'package:flutter_oauth2/helpers/constant.dart';
import 'package:flutter_oauth2/services/api_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'dart:convert';

class ApiService {
  Client client = InterceptedClient.build(interceptors: [ApiInterceptor()]);

  Future<Response> getSecretArea() async {
    var secretUrl = Uri.parse('${Constants.baseUrl}/api/protected');
    final res = await client.get(secretUrl);
    return res;
  }

  Future<Response> getUsers() async {
    var usersUrl = Uri.parse('${Constants.baseUrl}/api/users');
    final res = await client.get(usersUrl);
    return res;
  }

  Future<Response> editUser(
    String userId,
    Map<String, dynamic> userData,
  ) async {
    var editUrl = Uri.parse('${Constants.baseUrl}/api/users/$userId');
    final res = await client.put(
      editUrl,
      body: jsonEncode(userData),
      headers: {'Content-Type': 'application/json'},
    );
    return res;
  }
}
