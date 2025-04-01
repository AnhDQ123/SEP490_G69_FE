import 'dart:convert';
import 'package:http/http.dart' as http;

import '../base/api_base_url.dart';
import '../models/cart.dart';

class CartApiService {
  final String baseUrl = ApiBaseUrl.baseUrl;

  /// 🛒 1. Thêm giỏ hàng
  Future<bool> addToCart(CartDTO cartDTO) async {
    final url = Uri.parse("$baseUrl/api/cart/add");

    // 🔍 In dữ liệu trước khi gửi
    print("📦 Gửi dữ liệu: ${jsonEncode(cartDTO.toJson())}");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cartDTO.toJson()),
    );
    // 🔍 In response để kiểm tra status và nội dung
    print("📦 Response: ${response.statusCode}, body: ${response.body}");

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("❌ Failed to add to cart: ${response.statusCode}");
    }
  }

  /// 🛒 2. Lấy danh sách giỏ hàng theo userId
  Future<List<CartDTO>> getCartByOwner(int userId) async {
    final url = Uri.parse("$baseUrl/api/cart/owner/$userId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return decoded.map((e) => CartDTO.fromJson(e)).toList();
    } else {
      throw Exception("❌ Failed to load carts by owner: ${response.statusCode}");
    }
  }

  /// 🛒 3. Lấy giỏ hàng theo ID giỏ hàng
  Future<CartDTO> getCartById(int cartId) async {
    final url = Uri.parse("$baseUrl/api/cart/$cartId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return CartDTO.fromJson(decoded);
    } else {
      throw Exception("❌ Failed to load cart by ID: ${response.statusCode}");
    }
  }

  // /// 🛒 4. Cập nhật giỏ hàng
  // Future<bool> updateCart(CartDTO cartDTO) async {
  //   final url = Uri.parse("$baseUrl/api/cart");
  //   final response = await http.put(
  //     url,
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode(cartDTO.toJson()),
  //   );
  //
  //   if (response.statusCode == 200 || response.statusCode == 204) {
  //     return true;
  //   } else {
  //     throw Exception("❌ Failed to update cart: ${response.statusCode}");
  //   }
  // }
}
