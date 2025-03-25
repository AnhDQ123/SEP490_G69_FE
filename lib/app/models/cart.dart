import 'cart_item.dart';

class CartDTO {
  int? id;
  int userId;
  int shopId;
  String shopName;
  double price;
  String status;
  List<CartItemDTO> cartItemDTOList;

  CartDTO({
    this.id,
    required this.userId,
    required this.shopId,
    required this.shopName,
    required this.price,
    required this.status,
    required this.cartItemDTOList,
  });

  factory CartDTO.fromJson(Map<String, dynamic> json) {
    return CartDTO(
      id: json['id'],
      userId: json['userId'],
      shopId: json['shopId'],
      shopName: json['shopName'] ??'',
      price: (json['price'] as num).toDouble(),
      status: json['status'] ??'',
      cartItemDTOList: (json['cartItemDTOList'] as List)
          .map((e) => CartItemDTO.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'shopId': shopId,
      'shopName': shopName,
      'price': price,
      'status': status,
      'cartItemDTOList':
      cartItemDTOList.map((item) => item.toJson()).toList(),
    };
  }
}
