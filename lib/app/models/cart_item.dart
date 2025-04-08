import 'package:get/get.dart';
import 'cart_item_option.dart';
import 'discount.dart';
import 'order_item.dart';

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
  List<Discount>? discount;  // Thêm trường discount


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
    this.discount
  }) : quantity = quantity.obs; // ✅ Gán vào RxInt


  factory CartItemDTO.fromJson(Map<String, dynamic> json) {
    return CartItemDTO(
      id: json['id'],
      cartId: json['cartId'] ?? 0, // Thêm xử lý null
      productId: json['productId'] ?? 0, // Thêm xử lý null
      productName: json['productName'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0, // Sửa thành as num?
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0, // Sửa thành as num?
      quantity: json['quantity'] ?? 1,
      cartItemOptionDTOList: (json['cartItemOptionDTOList'] as List?) // Thêm dấu ?
          ?.map((e) => CartItemOptionDTO.fromJson(e))
          .toList() ?? [], // Thêm giá trị mặc định
      discount: (json['discount'] as List<dynamic>?) // Thêm dấu ?
          ?.map((e) => Discount.fromJson(e))
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
      'discount': discount?.map((d) => d.toJson()).toList(),  // Nếu có discount, gửi danh sách

    };
  }

  OrderItem toOrderItem() {
    return OrderItem(
      id: id ?? 0,
      orderId: 0,
      productId: productId,
      productName: productName,
      image: image,
      price: price,
      discountId: null,
      quantity: quantity.value,
      total: totalPrice,
      discount: [],
      createdAt: DateTime.now(),
      orderItemOptions: cartItemOptionDTOList.map((opt) => opt.toOrderItemOption()).toList(),
    );
  }

}
