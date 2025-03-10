import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'base_common.dart';

class ApiService {
  Future<List<T>> fetchDataList<T>(
      String apiUrl, T Function(Map<String, dynamic>) fromJson) async {
    final response = await http.get(Uri.parse(apiUrl),
        headers: BaseCommon.instance.headerRequest());
    log('StatusCode ${response.statusCode} - $apiUrl');
    log('Body ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map<T>((item) => fromJson(item)).toList();
    }
    throw Exception(json.decode(response.body)['message']);
  }

  Future<T> fetchDataObject<T>(
      String apiUrl, T Function(Map<String, dynamic>) fromJson) async {
    final response = await http.get(Uri.parse(apiUrl),
        headers: BaseCommon.instance.headerRequest());
    log('$apiUrl - StatusCode ${response.statusCode} - $apiUrl');
    log('$apiUrl - Body ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return fromJson(data);
    }
    throw Exception(json.decode(response.body)['message']);
  }

  Future<List<T>> fetchDataListWithPost<T>(
      String apiUrl, T Function(Map<String, dynamic>) fromJson,
      {required Object body, bool isUsingToken = true}) async {
    log(jsonEncode(body));
    final response = await http.post(Uri.parse(apiUrl),
        headers: BaseCommon.instance.headerRequest(isUsingToken: isUsingToken),
        body: jsonEncode(body));
    log('StatusCode ${response.statusCode} - $apiUrl');
    log('Body ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)["data"];
      return data.map<T>((item) => fromJson(item)).toList();
    }
    throw Exception(json.decode(response.body)['message']);
  }

  Future<T> fetchDataObjectWithPost<T>(
      String apiUrl, T Function(Map<String, dynamic>) fromJson,
      {required Object body, bool isUsingToken = true}) async {
    final response = await http.post(Uri.parse(apiUrl),
        headers: BaseCommon.instance.headerRequest(isUsingToken: false),
        body: jsonEncode(body));
    log("payload: ${jsonEncode(body)}");
    log('StatusCode ${response.statusCode} - $apiUrl');
    log('Body ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["data"];
      return fromJson(data);
    }
    throw Exception(json.decode(response.body)['message']);
  }

  Future<T> fetchDataObjectWithPut<T>(
      String apiUrl, T Function(Map<String, dynamic>) fromJson,
      {required Object body}) async {
    final response = await http.put(Uri.parse(apiUrl),
        headers: BaseCommon.instance.headerRequest(), body: jsonEncode(body));
    log("payload: ${body.toString()}");
    log('StatusCode ${response.statusCode} - $apiUrl');
    log('Body ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body)["data"];
      return fromJson(data);
    }
    throw Exception(json.decode(response.body)['message']);
  }

  Future<bool> validationWithPost(String apiUrl,
      {required Object body, bool is201 = false}) async {
    final response = await http.post(Uri.parse(apiUrl),
        headers: BaseCommon.instance.headerRequest(), body: jsonEncode(body));
    log("payload: ${body.toString()}");
    log('StatusCode ${response.statusCode} - $apiUrl');
    log('Body ${response.body}');
    if (response.statusCode == (is201 ? 201 : 200)) {
      return true;
    }
    throw Exception(json.decode(response.body)['message']);
  }

  Future<bool> validationWithDelete(String apiUrl,
      {required Object body, bool is201 = false}) async {
    final response = await http.delete(Uri.parse(apiUrl),
        headers: BaseCommon.instance.headerRequest(), body: jsonEncode(body));
    log("payload: ${body.toString()}");
    log('StatusCode ${response.statusCode} - $apiUrl');
    log('Body ${response.body}');
    if (response.statusCode == (is201 ? 201 : 200)) {
      return true;
    }
    throw Exception(json.decode(response.body)['message']);
  }

  Future<bool> validationWithPut(String apiUrl, {required Object body}) async {
    final response = await http.put(Uri.parse(apiUrl),
        headers: BaseCommon.instance.headerRequest(), body: jsonEncode(body));
    log("payload: ${jsonEncode(body)}");
    log('StatusCode ${response.statusCode} - $apiUrl');
    log('Body ${response.body}');
    if (response.statusCode == 200) {
      return true;
    }
    throw Exception(json.decode(response.body)['message']);
  }

  // Future<bool> validationWithGet(String apiUrl, {required Object body}) async {
  //   final response = await http.get(Uri.parse(apiUrl),
  //       headers: BaseCommon.instance.headerRequest());
  //   log("payload: ${jsonEncode(body)}");
  //   log('StatusCode ${response.statusCode} - $apiUrl');
  //   log('Body ${response.body}');
  //   if (response.statusCode == 200) {
  //     return true;
  //   }else{
  //     throw Exception(json.decode(response.body)['message']);
  //   }
  // }

  Future<bool> validationWithGet(String apiUrl, {required Object body}) async {
    try {
      final response = await http.get(Uri.parse(apiUrl),
          headers: BaseCommon.instance.headerRequest());
      log("payload: ${jsonEncode(body)}");
      log('StatusCode ${response.statusCode} - $apiUrl');
      log('Body ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        // Handle non-200status codes here
        // throw Exception('API request failed with status code ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Handle any other exceptions here
      print('Error during API request: $e');
      rethrow; // Re-throw the exception to be caught by the caller
    }
  }

  Future<bool> validationWithPutNoToken(String apiUrl, {required Object body}) async {
    final response = await http.put(Uri.parse(apiUrl),
        headers: BaseCommon.instance.headerRequest(isUsingToken: false), body: jsonEncode(body));
    log("payload: ${jsonEncode(body)}");
    log('StatusCode ${response.statusCode} - $apiUrl');
    log('Body ${response.body}');
    if (response.statusCode == 200) {
      return true;
    }
    throw Exception(json.decode(response.body)['message']);
  }
}
