import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:developer';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

import '../service/notification_service.dart';


class BaseCommon {
  static BaseCommon? _instance;
  String? accessToken;
  String? refreshToken;
  String? deviceToken;
  String? ownPhone;
  String locale = 'en';
  String? userId;



  BaseCommon._internal();

  static BaseCommon get instance {
    _instance ??= BaseCommon._internal();
    return _instance!;
  }

  //cu
  // Map<String, String> headerRequest({bool isUsingToken = true}) {
  //   if (isUsingToken) {
  //     return {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Accept': 'application/json; charset=UTF-8',
  //       'Authorization': 'Bearer $accessToken'
  //     };
  //   }
  //   return {
  //     'Content-Type': 'application/json; charset=UTF-8',
  //     'Accept': 'application/json; charset=UTF-8'
  //   };
  // }

  Map<String, String> headerRequest({bool isUsingToken = true}) {
    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json; charset=UTF-8',
    };
    if (isUsingToken && accessToken != null && accessToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    return headers;
  }

  Future<void> saveToken(String jwt) async {
    accessToken = jwt;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', jwt);
    log("✅ Token mới đã được lưu: $jwt");

    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);

    // Lưu số điện thoại từ "sub"
    ownPhone = decodedToken['sub'];

    // Lưu userId nếu có
    if (decodedToken.containsKey("userId")) {
      userId = decodedToken["userId"].toString();
      await prefs.setString("userId", userId!);
      log("✅ userId đã được lấy từ token và lưu: $userId");
    } else {
      log("⚠️ Token không chứa userId!");
    }
  }


  Future<void> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = '';
    refreshToken = '';
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }

  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken') ?? '';
    refreshToken = prefs.getString('refreshToken') ?? '';
    locale = prefs.getString('locale') ?? 'en';
    userId = prefs.getString('userId'); // Lấy userId từ SharedPreferences

    log("accessToken: $accessToken");
    log("userId: $userId");

    log("Lấy accessToken từ SharedPreferences: $accessToken");
    if (accessToken == null || accessToken!.isEmpty) {
      log("⚠️ accessToken bị rỗng trong SharedPreferences!");
    } else {
      log("✅ accessToken hợp lệ: $accessToken");
    }

    // ✅ Gọi init NotificationService ở đây
    await NotificationService.init();
    log("✅ NotificationService đã được khởi tạo");
  }

  Future<void> changeLocale(String value) async {
    locale = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', value);
  }


  Map<String, String> headerRequestForMultipart({bool isUsingToken = false, bool isMultipart = false}) {
    var headers = <String, String>{
      'Accept': 'application/json; charset=UTF-8',
    };
    // Với multipart, ta không thêm Content-Type
    if (!isMultipart) {
      headers['Content-Type'] = 'application/json; charset=UTF-8';
    }
    if (isUsingToken && accessToken != null && accessToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    return headers;
  }

  Future<void> saveUserId(String id) async {
    userId = id;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', id);
    log("✅ userId đã được lưu: $id");
  }

  //khid dang xuat
  Future<void> removeUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = null;
    await prefs.remove('userId');
    log("✅ userId đã được xóa khỏi SharedPreferences!");
  }

}