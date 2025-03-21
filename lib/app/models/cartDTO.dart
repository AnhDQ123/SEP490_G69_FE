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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'shopId': shopId,
      'shopName': shopName,
      'price': price,
      'status': status,
      'cartItemDTOList': cartItemDTOList.map((item) => item.toJson()).toList(),
    };
  }
}

class CartItemDTO {
  int? id;
  int cartId;
  int productId;
  String productName;
  String image;
  double price;
  double totalPrice;
  int quantity;
  List<CartItemOptionDTO> cartItemOptionDTOList;

  CartItemDTO({
    this.id,
    required this.cartId,
    required this.productId,
    required this.productName,
    required this.image,
    required this.price,
    required this.totalPrice,
    required this.quantity,
    required this.cartItemOptionDTOList,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cartId': cartId,
      'productId': productId,
      'productName': productName,
      'image': image,
      'price': price,
      'totalPrice': totalPrice,
      'quantity': quantity,
      'cartItemOptionDTOList':
      cartItemOptionDTOList.map((option) => option.toJson()).toList(),
    };
  }
}

class CartItemOptionDTO {
  int? id;
  int optionId;
  int typeId;
  String optionName;
  String image;
  int cartItemId;
  double price;
  double totalPrice;
  int quantity;

  CartItemOptionDTO({
    this.id,
    required this.optionId,
    required this.typeId,
    required this.optionName,
    required this.image,
    required this.cartItemId,
    required this.price,
    required this.totalPrice,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'optionId': optionId,
      'typeId': typeId,
      'optionName': optionName,
      'image': image,
      'cartItemId': cartItemId,
      'price': price,
      'totalPrice': totalPrice,
      'quantity': quantity,
    };
  }
}
