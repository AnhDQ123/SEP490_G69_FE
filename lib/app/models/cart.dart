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
  double? discountPrice;
  List<CartItemDTO> cartItemDTOList;

  CartDTO({
    this.id,
    required this.userId,
    required this.shopId,
    required this.shopName,
    required this.price,
    required this.status,
    this.discountPrice,
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

  Order toOrder({
    required int shipMethodId,
    required int paymentMethodId,
    required String address,

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
      shipMethodName: 'Delivery',
      shippingFee: 0.0,
      paymentMethodId: paymentMethodId,
      voucherAmount: 0.0,
      voucherId: null,
      address: address,
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
