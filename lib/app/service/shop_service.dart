import 'dart:convert';
import 'package:http/http.dart' as http;
import '../base/api_base_url.dart';
import '../models/shop.dart';  // Import ApiBaseUrl

class ShopService {
  // Thay thế baseUrl cứng bằng ApiBaseUrl
  final String baseUrl = ApiBaseUrl.baseUrl; // Lấy Base URL từ ApiBaseUrl

  // Gọi API để lấy thông tin shop theo shopId
  Future<ShopDTO> getShopById(int shopId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/shops/$shopId'));

    if (response.statusCode == 200) {
      // Chuyển đổi JSON thành ShopDTO
      return ShopDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load shop');
    }
  }
}
