import 'dart:convert';
import 'dart:io';
import 'package:ffb_fe_flutter/app/models/product_discount.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/discount.dart';
import '../models/shop_profile.dart';
import 'package:http_parser/http_parser.dart';
import '../models/bank.dart';
import '../models/voucher.dart';
import '../base/api_base_url.dart';
import '../modules/shop_menu/controllers/shop_controller.dart';

class BannerService {
  final String baseUrl = ApiBaseUrl.baseUrl;


  Future<bool> addBanner(File banner) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse("${ApiBaseUrl.baseUrl}/api/shops/banner/upload"));

      // Thêm shopId vào request
      request.fields["shopId"] = Get.find<ShopController>().shopId.toString();

      // Thêm file vào request
      request.files.add(await http.MultipartFile.fromPath("file", banner.path));

      // Gửi request và nhận phản hồi
      var response = await request.send();

      // Đọc phản hồi từ server
      var responseBody = await response.stream.bytesToString();

      // In ra phản hồi để debug
      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');

      // Kiểm tra mã trạng thái và trả về true nếu thành công
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        // In ra thông báo lỗi nếu không thành công
        print('Upload failed with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // In ra lỗi nếu có
      print("❌ Lỗi ngoại lệ khi gửi API: $e");
      return false;
    }
  }

}

class ApiResponse {
  final bool success;
  final String message;

  ApiResponse({required this.success, required this.message});
}
