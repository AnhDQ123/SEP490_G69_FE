class TopProduct {
  final String name;
  final int totalQuantity;
  final double totalValue;

  TopProduct({
    required this.name,
    required this.totalQuantity,
    required this.totalValue,
  });

  factory TopProduct.fromJson(Map<String, dynamic> json) {
    return TopProduct(
      name: json['name'] ?? '',
      totalQuantity: json['totalQuantity'] ?? 0,
      totalValue: (json['totalValue'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
