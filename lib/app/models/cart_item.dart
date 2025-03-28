import 'package:get/get.dart';
import 'cart_item_option.dart';

class CartItemDTO {
  int? id;
  int cartId;
  int productId;
  String productName;
  String image;
  double price;
  double totalPrice;
  RxInt quantity; // ✅ Chuyển sang RxInt
  List<CartItemOptionDTO> cartItemOptionDTOList;

  CartItemDTO({
    this.id,
    required this.cartId,
    required this.productId,
    required this.productName,
    required this.image,
    required this.price,
    required this.totalPrice,
    required int quantity, // Nhận int bình thường
    required this.cartItemOptionDTOList,
  }) : quantity = quantity.obs; // ✅ Gán vào RxInt

  factory CartItemDTO.fromJson(Map<String, dynamic> json) {
    return CartItemDTO(
      id: json['id'],
      cartId: json['cartId'],
      productId: json['productId'],
      productName: json['productName'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      cartItemOptionDTOList: (json['cartItemOptionDTOList'] as List)
          .map((e) => CartItemOptionDTO.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cartId': cartId,
      'productId': productId,
      'productName': productName,
      'image': image,
      'price': price,
      'totalPrice': totalPrice,
      'quantity': quantity.value, // ✅ Xuất ra int
      'cartItemOptionDTOList':
      cartItemOptionDTOList.map((option) => option.toJson()).toList(),
    };
  }
}
