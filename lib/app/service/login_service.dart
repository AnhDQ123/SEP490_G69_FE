import 'dart:convert';
import 'package:ffb_fe_flutter/app/base/api_base_url.dart';
import 'package:http/http.dart' as http;
import '../base/base_common.dart';

class LoginService {
  Future<String> loginRequest({
    required Map<String, dynamic> body,
    bool isUsingToken = false,
  }) async {
    final String apiUrl = "${ApiBaseUrl.baseUrl}/api/auth/login";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: BaseCommon.instance.headerRequest(isUsingToken: isUsingToken),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }

  Future<String?> login({
    required String username,
    required String password,
  }) async {
    final token = await loginRequest(
      body: {"username": username, "password": password},
      isUsingToken: false,
    );
    return token;
  }
}

