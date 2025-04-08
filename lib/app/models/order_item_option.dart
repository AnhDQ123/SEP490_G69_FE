class OrderItemOption {
  final int id;
  final int orderItemId;
  final int optionId;
  final String optionName;
  final String? image;
  final int typeId;
  final double price;
  final double? total;
  final int quantity;

  OrderItemOption({
    required this.id,
    required this.orderItemId,
    required this.optionId,
    required this.optionName,
    this.image,
    required this.typeId,
    required this.price,
    this.total,
    required this.quantity,
  });

  factory OrderItemOption.fromJson(Map<String, dynamic> json) {
    return OrderItemOption(
      id: (json['id'] as int?) ?? 0,
      orderItemId: (json['orderItemId'] as int?) ?? 0,
      optionId: (json['optionId'] as int?) ?? 0,
      optionName: json['optionName'] as String , // Parse optionName từ JSON
      image: json['image'],
      typeId: (json['typeId'] as int?) ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      total: json['total'] != null ? (json['total'] as num).toDouble() : null,
      quantity: (json['quantity'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      // 'orderItemId': orderItemId,
      'optionId': optionId,
      'typeId': typeId,
      'optionName': optionName, // Xuất optionName
      'price': price,
      'total': total,
      'quantity': quantity,
    };
  }
}
