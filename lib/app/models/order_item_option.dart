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
      id: json['id'],
      orderItemId: json['orderItemId'],
      optionId: json['optionId'],
      optionName: json['optionName'],
      image: json['image'],
      typeId: json['typeId'],
      price: (json['price'] ?? 0).toDouble(),
      total: json['total'] != null ? (json['total'] as num).toDouble() : null,
      quantity: json['quantity'],
    );
  }
}
