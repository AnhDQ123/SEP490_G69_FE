class OrderItemOption {
  final int id;
  final int orderItemId;
  final int optionId;
  final int typeId;
  final String optionName; // Thêm trường này
  final double price;
  final double total;
  final int quantity;

  OrderItemOption({
    required this.id,
    required this.orderItemId,
    required this.optionId,
    required this.typeId,
    required this.optionName, // Thêm vào constructor
    required this.price,
    required this.total,
    required this.quantity,
  });

  factory OrderItemOption.fromJson(Map<String, dynamic> json) {
    return OrderItemOption(
      id: json['id'] as int,
      orderItemId: json['orderItemId'] as int,
      optionId: json['optionId'] as int,
      typeId: json['typeId'] as int,
      optionName: json['optionName'] as String, // Parse optionName từ JSON
      price: (json['price'] as num).toDouble(),
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderItemId': orderItemId,
      'optionId': optionId,
      'typeId': typeId,
      'optionName': optionName, // Xuất optionName
      'price': price,
      'total': total,
      'quantity': quantity,
    };
  }
}
