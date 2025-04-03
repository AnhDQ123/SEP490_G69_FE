import 'dart:convert';
import 'package:ffb_fe_flutter/app/base/api_base_url.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class DashboardService {
  // Hàm hiện có
  Future<List<Map<String, dynamic>>> fetchOrdersByStatusByMonth(int shopId, String status) async {
    final url = '${ApiBaseUrl.baseUrl}/api/shops/count/order/month?status=$status&shopId=$shopId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Thêm giải mã UTF-8
      final responseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> data = json.decode(responseBody);
      return data.map((e) => {
        'month': e[0],
        'year': e[1],
        'orderCount': e[2],
      }).toList();
    } else {
      throw Exception('Failed to load $status orders by month');
    }
  }

  // Hàm lấy top sản phẩm bán chạy với giải mã UTF-8
  Future<List<Map<String, dynamic>>> fetchTopSellingProductsByMonth(int shopId) async {
    final url = '${ApiBaseUrl.baseUrl}/api/product/top-selling/month?shopId=$shopId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Thêm giải mã UTF-8
      final responseBody = utf8.decode(response.bodyBytes);
      final List<dynamic> data = json.decode(responseBody);
      return data.map((e) => {
        'productId': e[0],
        'productName': e[1],
        'quantitySold': e[2],
      }).toList();
    } else {
      throw Exception('Failed to load top selling products');
    }
  }
}