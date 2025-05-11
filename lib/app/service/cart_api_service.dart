import 'dart:convert';
import 'package:http/http.dart' as http;

import '../base/api_base_url.dart';
import '../models/cart.dart';

class CartApiService {
  final String baseUrl = ApiBaseUrl.baseUrl;

  /// 🛒 1. Thêm giỏ hàng
  Future<bool> addToCart(CartDTO cartDTO) async {
    final url = Uri.parse("$baseUrl/api/cart/add");
    print('🔴 [5.CART BEFORE API] Danh sách items trong giỏ:');
    cartDTO.cartItemDTOList.forEach((item) {
      print('   ProductID: ${item.productId} | ${item.productName}');
      item.cartItemOptionDTOList.forEach((opt) {
        print(
            '      → CartOptionID: ${opt.optionId} | Name: ${opt.optionName}');
      });
    });

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
      throw Exception(
          "❌ Failed to load carts by owner: ${response.statusCode}");
    }
  }

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

  // Tăng số lượng tùy chọn
  Future<void> increaseOptionQuantity(int cartItemOptionId) async {
    final url =
    Uri.parse("$baseUrl/api/cart/option/increase?id=$cartItemOptionId");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json", // Đảm bảo rằng header là json
      },
    );

    // Kiểm tra xem phản hồi có thành công không
    if (response.statusCode != 200) {
      throw Exception("Failed to increase option quantity");
    }
  }

  // Tăng số lượng tùy chọn
  Future<void> decreaseOptionQuantity(int cartItemOptionId) async {
    final url =
    Uri.parse("$baseUrl/api/cart/option/decrease?id=$cartItemOptionId");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json", // Đảm bảo rằng header là json
      },
    );

    // Kiểm tra xem phản hồi có thành công không
    if (response.statusCode != 200) {
      throw Exception("Failed to increase option quantity");
    }
  }

  Future<void> addOptionToItem(int cartItemId, int optionId) async {
    final url = Uri.parse("$baseUrl/api/cart/add/option");

    // Log thông tin trước khi gửi yêu cầu
    print("📤 Gửi yêu cầu API để thêm tùy chọn vào sản phẩm:");
    print("   CartItemId: $cartItemId");
    print("   OptionId: $optionId");

    final response = await http.post(
      url,
      body: {
        'cartItemId': cartItemId.toString(),
        'optionId': optionId.toString(),
      },
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
    );

    // Log thông tin phản hồi từ API
    print("📦 Response từ API: ${response.statusCode}");
    print("   Body: ${response.body}");

    // Kiểm tra xem phản hồi có thành công không
    if (response.statusCode != 200) {
      print("❌ Không thể thêm tùy chọn vào sản phẩm!");
      throw Exception("Failed to add option to item");
    } else {
      print("✅ Thêm tùy chọn thành công vào sản phẩm!");
    }
  }

  Future<void> changeSize(int cartItemOptionId, int newSizeId) async {
    final url = Uri.parse("$baseUrl/api/cart/size/change");

    final response = await http.post(
      url,
      body: {
        'id': cartItemOptionId.toString(),
        'newId': newSizeId.toString(),
      },
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
    );

    // Kiểm tra phản hồi từ API
    if (response.statusCode != 200) {
      throw Exception("Failed to change size");
    } else {
      print("✅ Size changed successfully");
    }
  }

  Future<void> deleteItemFromCart(int cartId, int productId) async {
    final url = Uri.parse("$baseUrl/api/cart/item/delete?cartId=$cartId&id=$productId");

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception("❌ Failed to delete item from cart: ${response.statusCode}");
    } else {
      print("✅ Sản phẩm đã được xóa khỏi giỏ hàng");
    }
  }


}