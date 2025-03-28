import 'cart_item.dart';
import 'order.dart';
import 'order_item.dart';
import 'order_item_option.dart';

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

  Order toOrder({required int shipMethodId, required int paymentMethodId}) {
    print("📜 Cart data for order conversion: ${this.toJson()}");

    List<OrderItem> orderItems = this.cartItemDTOList.map((cartItem) {
      print("📜 Converting CartItem to OrderItem: ${cartItem.toJson()}");

      return OrderItem(
        id: cartItem.id ?? 0,
        orderId: 0,  // Ensure this is set
        productId: cartItem.productId ?? 0,
        dishName: cartItem.productName ?? 'No name',
        imageUrl: cartItem.image ?? '',
        price: cartItem.price ?? 0.0,
        quantity: cartItem.quantity.value,
        total: cartItem.totalPrice ?? 0.0,
        discount: 0.0,
        createdAt: DateTime.now(),
        options: cartItem.cartItemOptionDTOList.map((opt) {
          return OrderItemOption(
            id: opt.id ?? 0,
            orderItemId: 0,
            optionId: opt.optionId ?? 0,
            typeId: opt.typeId ?? 0,
            optionName: opt.optionName ?? "No option",
            price: opt.price ?? 0.0,
            total: opt.totalPrice ?? 0.0,
            quantity: opt.quantity ?? 0,
          );
        }).toList(),
      );
    }).toList();

    // Return the order without the orderId, so the server will populate it
    return Order(
      id: 0, // Set id to 0 because it will be updated after the server response
      shopName: this.shopName,
      ownerId: this.userId,
      shipperId: 22,  // Default shipperId as 22
      shipMethodId: shipMethodId,  // Pass shipMethodId from parameter
      paymentMethodId: paymentMethodId,  // Pass paymentMethodId from parameter
      voucherAmount: 0.0,
      address: 'Some address',
      total: this.price,
      createdAt: DateTime.now(),
      status: 'PENDING',
      items: cartItemDTOList.map((item) => item.toOrderItem()).toList(),
      shopId: this.shopId,
      image: 'some image',
    );
  }




}
