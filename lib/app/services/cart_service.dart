// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../models/cart.dart';
// import '../models/cart_item_option.dart';
// import '../models/product.dart';
// import '../modules/cart/controllers/cart_controller.dart';
// import '../services/api_service.dart';
//
// class CartService {
//   /// Lấy danh sách giỏ hàng (hỗ trợ nhiều cửa hàng)
//   Future<List<Cart>?> fetchCartList(int ownerId) async {
//     try {
//       final response = await http.get(Uri.parse(ApiService.getCartByOwner(ownerId)));
//
//       if (response.statusCode == 200) {
//         final decodedResponse = utf8.decode(response.bodyBytes);
//         final List<dynamic> jsonResponse = jsonDecode(decodedResponse);
//
//         return jsonResponse.map((cartJson) => Cart.fromJson(cartJson)).toList();
//       } else {
//         print('❌ Lỗi khi gọi API: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('❌ Lỗi: $e');
//     }
//     return null;
//   }
//
//   /// Lấy thông tin sản phẩm theo ID
//   Future<Product> fetchProductDetails(int productId) async {
//     try {
//       final response = await http.get(Uri.parse(ApiService.getProductDetails(productId)));
//
//       if (response.statusCode == 200) {
//         final utf8DecodedData = utf8.decode(response.bodyBytes);
//         return Product.fromJson(jsonDecode(utf8DecodedData));
//       } else {
//         throw Exception('❌ Failed to load product details - Mã lỗi: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('❌ Lỗi khi lấy chi tiết sản phẩm: $e');
//       rethrow;
//     }
//   }
//
//     /// Lấy danh sách Size của sản phẩm và cập nhật vào giỏ hàng
//     Future<void> fetchProductOptions(int productId) async {
//       try {
//         final controller = Get.find<CartController>();
//
//         print("🟢 Bắt đầu lấy thông tin sản phẩm ID: $productId");
//
//         Product product = await fetchProductDetails(productId);
//
//         // Lọc danh sách chỉ lấy option typeId = 2 (size)
//         List<CartItemOption> sizes = product.foodOptions
//             .where((opt) => opt.typeId == 2)
//             .map((opt) => CartItemOption(
//           optionId: opt.id,
//           typeId: opt.typeId,
//           optionName: opt.name,
//           price: opt.price,
//           cartItemId: 0,
//           quantity: 1,
//         ))
//             .toList();
//
//         // ✅ Log danh sách option của product
//         print("✅ Lấy được ${sizes.length} kích thước cho sản phẩm ID: $productId");
//
//         // Cập nhật danh sách option vào controller
//         controller.productOptions[productId] = sizes;
//
//         // ✅ Cập nhật giá hiển thị trong cart
//         for (var shop in controller.carts) {
//           for (var item in shop.cartItemDTOList) {
//             if (item.productId == productId) {
//               CartItemOption? selectedSize = item.cartItemOptionDTOList
//                   .firstWhereOrNull((opt) => opt.typeId == 2);
//
//               if (selectedSize != null) {
//                 CartItemOption? sizeFromProduct = sizes.firstWhereOrNull(
//                         (size) => size.optionId == selectedSize.optionId);
//
//                 if (sizeFromProduct != null) {
//                   print("🔹 Giá size '${sizeFromProduct.optionName}' của sản phẩm ID: $productId là ${sizeFromProduct.price}");
//                   item.totalPrice = sizeFromProduct.price ?? 0;
//                   print("✅ Đã cập nhật giá totalPrice = ${item.totalPrice} cho sản phẩm ID: $productId");
//                 } else {
//                   print("⚠️ Không tìm thấy giá cho size ID: ${selectedSize.optionId}");
//                 }
//               }
//             }
//           }
//         }
//
//         controller.carts.refresh();  // Cập nhật lại giỏ hàng
//
//       } catch (e) {
//         print("❌ Lỗi khi lấy danh sách Size: $e");
//       }
//     }
//
// }
