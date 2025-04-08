import 'cart_item.dart';
import 'discount.dart';
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
  double? discountPrice; // ✅ THÊM DÒNG NÀY nếu chưa có
  List<CartItemDTO> cartItemDTOList;

  CartDTO({
    this.id,
    required this.userId,
    required this.shopId,
    required this.shopName,
    required this.price,
    required this.status,
    this.discountPrice, // ✅ Đừng quên truyền ở constructor
    required this.cartItemDTOList,
  });

  factory CartDTO.fromJson(Map<String, dynamic> json) {
    return CartDTO(
      id: json['id'],
      userId: json['userId'] ?? 0, // Thêm xử lý null
      shopId: json['shopId'] ?? 0, // Thêm xử lý null
      shopName: json['shopName'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0, // Sửa thành as num?
      status: json['status'] ?? '',
      discountPrice: (json['discountPrice'] as num?)?.toDouble(), // ✅ Parse đúng kiểu
      cartItemDTOList: (json['cartItemDTOList'] as List?) // Thêm dấu ?
          ?.map((e) => CartItemDTO.fromJson(e))
          .toList() ?? [], // Thêm giá trị mặc định
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

  // Order toOrder({required int shipMethodId, required int paymentMethodId}) {
  //   print("📜 Cart data for order conversion: ${this.toJson()}");
  //
  //   List<OrderItem> orderItems = this.cartItemDTOList.map((cartItem) {
  //     print("📜 Converting CartItem to OrderItem: ${cartItem.toJson()}");
  //
  //     return OrderItem(
  //       id: cartItem.id ?? 0,
  //       orderId: 0,  // Ensure this is set
  //       productId: cartItem.productId ?? 0,
  //       dishName: cartItem.productName ?? 'No name',
  //       imageUrl: cartItem.image ?? '',
  //       price: cartItem.price ?? 0.0,
  //       quantity: cartItem.quantity.value,
  //       total: cartItem.totalPrice ?? 0.0,
  //       discount: 0.0,
  //       createdAt: DateTime.now(),
  //       options: cartItem.cartItemOptionDTOList.map((opt) {
  //         return OrderItemOption(
  //           id: opt.id ?? 0,
  //           orderItemId: 0,
  //           optionId: opt.optionId ?? 0,
  //           typeId: opt.typeId ?? 0,
  //           optionName: opt.optionName ?? "No option",
  //           price: opt.price ?? 0.0,
  //           total: opt.totalPrice ?? 0.0,
  //           quantity: opt.quantity ?? 0,
  //         );
  //       }).toList(),
  //     );
  //   }).toList();
  //
  //   // Return the order without the orderId, so the server will populate it
  //   return Order(
  //     id: 0, // Set id to 0 because it will be updated after the server response
  //     shopName: this.shopName,
  //     ownerId: this.userId,
  //     shipperId: 22,  // Default shipperId as 22
  //     shipMethodId: shipMethodId,  // Pass shipMethodId from parameter
  //     paymentMethodId: paymentMethodId,  // Pass paymentMethodId from parameter
  //     voucherAmount: 0.0,
  //     address: 'Some address',
  //     total: this.price,
  //     createdAt: DateTime.now(),
  //     status: 'PENDING',
  //     items: cartItemDTOList.map((item) => item.toOrderItem()).toList(),
  //     shopId: this.shopId,
  //     image: 'some image',
  //   );
  // }

  Order toOrder({
    required int shipMethodId,
    required int paymentMethodId,
  }) {
    print("📜 Cart data for order conversion: ${this.toJson()}");

    List<OrderItem> orderItems = cartItemDTOList.map((cartItem) {
      print("📜 Converting CartItem to OrderItem: ${cartItem.toJson()}");

      List<Discount>? discounts = cartItem.discount; // Sử dụng discount từ CartItemDTO


      return OrderItem(
        id:  0,
        orderId: 0,
        productId: cartItem.productId ?? 0,
        productName: cartItem.productName ?? 'No name',
        image: cartItem.image ?? '',
        price: cartItem.price ?? 0.0,
        quantity: cartItem.quantity.value,
        total: cartItem.totalPrice ?? 0.0,
        discount: discounts,
        createdAt: DateTime.now(),
        orderItemOptions: cartItem.cartItemOptionDTOList.map((opt) {
          return OrderItemOption(
            id: 0,
            orderItemId: 0,
            optionId: opt.optionId ?? 0,
            typeId: opt.typeId ?? 0,
            optionName: opt.optionName ?? '',
            price: opt.price ?? 0.0,
            total: opt.totalPrice ?? 0.0,
            quantity: opt.quantity ?? 1,
          );
        }).toList(),
      );
    }).toList();

    return Order(
      id: 0,
      shopId: shopId,
      shopName: shopName,
      ownerId: userId,
      shipMethodId: shipMethodId,
      paymentMethodId: paymentMethodId,
      voucherAmount: 0.0,
      voucherId: null,
      address: 'Some address',
      total: discountPrice ?? price,
      createdAt: DateTime.now(),
      status: 'PENDING',
      orderItem: orderItems,
      image: null,
      ownerName: 'Owner Name',
      phone: 'Phone Number',
    );
  }





}
