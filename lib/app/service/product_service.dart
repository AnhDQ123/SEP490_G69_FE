import 'dart:convert';
import 'package:http/http.dart' as http;
import '../base/api_base_url.dart';

class ProductService {
  // API để lấy sản phẩm bán chạy nhất hôm nay
  Future<List<Map<String, dynamic>>> getTopSellingProductsToday(String shopId) async {
    final uri = Uri.parse('${ApiBaseUrl.baseUrl}/api/product/top-selling/today?shopId=$shopId');

    final response = await http.get(uri);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((product) {
        return {
          'id': product[0],
          'name': product[1],
          'totalQuantity': product[2],
        };
      }).toList();
    } else {
      throw Exception('Failed to load top-selling products today');
    }
  }

  // API để lấy sản phẩm bán chạy nhất trong tháng này
  Future<List<Map<String, dynamic>>> getTopSellingProductsThisMonth(String shopId) async {
    final uri = Uri.parse('${ApiBaseUrl.baseUrl}/api/product/top-selling/month?shopId=$shopId');

    final response = await http.get(uri);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((product) {
        return {
          'id': product[0],
          'name': product[1],
          'totalQuantity': product[2],
        };
      }).toList();
    } else {
      throw Exception('Failed to load top-selling products this month');
    }
  }

  // API để lấy sản phẩm bán chạy nhất trong năm nay
  Future<List<Map<String, dynamic>>> getTopSellingProductsThisYear(String shopId) async {
    final uri = Uri.parse('${ApiBaseUrl.baseUrl}/api/product/top-selling/year?shopId=$shopId');

    final response = await http.get(uri);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((product) {
        return {
          'id': product[0],
          'name': product[1],
          'totalQuantity': product[2],
        };
      }).toList();
    } else {
      throw Exception('Failed to load top-selling products this year');
    }
  }
}
