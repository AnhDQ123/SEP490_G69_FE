import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/shop_detail_model.dart';

class ShopService {
  final String baseUrl = 'https://api.example.com'; // Thay bằng API thực tế của bạn

  Future<ShopDetailModel> fetchShopDetail() async {
    final response = await http.get(Uri.parse('$baseUrl/shopdetail'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ShopDetailModel.fromJson(jsonData);
    } else {
      throw Exception('Lỗi fetch API: ${response.statusCode}');
    }
  }

  Future<void> updateShopDetail(ShopDetailModel model) async {
    final response = await http.put(
      Uri.parse('$baseUrl/shopdetail'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(model.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Lỗi cập nhật API: ${response.statusCode}');
    }
  }
}
