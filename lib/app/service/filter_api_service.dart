import 'dart:convert';
import 'package:http/http.dart' as http;
import '../base/api_base_url.dart';

class FilterApiService {
  // Lấy baseUrl từ ApiBaseUrl
  final String baseUrl = ApiBaseUrl.baseUrl;

  Future<List<Map<String, dynamic>>> fetchProductsByCategory(String category) async {
    // Xây dựng URL với query parameter 'cat'
    final url = Uri.parse('$baseUrl/api/product/filter?cat=$category');

    // Gửi request GET
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Giải mã JSON trả về
      final List<dynamic> data = jsonDecode(response.body);
      // Chuyển đổi về List<Map<String, dynamic>>
      return data.map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item)).toList();
    } else {
      throw Exception('Lỗi khi lấy dữ liệu sản phẩm. Status code: ${response.statusCode}');
    }
  }
}
