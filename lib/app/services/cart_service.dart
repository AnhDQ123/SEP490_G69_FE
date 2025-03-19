import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart.dart';

class CartService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/cart/owner/1';

  /// Lấy danh sách giỏ hàng (hỗ trợ nhiều cửa hàng)
  Future<List<Cart>?> fetchCartList() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final List<dynamic> jsonResponse = jsonDecode(decodedResponse);

        return jsonResponse.map((cartJson) => Cart.fromJson(cartJson)).toList();
      } else {
        print('❌ Lỗi khi gọi API: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Lỗi: $e');
    }
    return null;
  }

  Future<Product> fetchProductDetails(int productId) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/product/$productId'));
      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      print('❌ Lỗi khi lấy chi tiết sản phẩm: $e');
      rethrow;
    }
  }

}
