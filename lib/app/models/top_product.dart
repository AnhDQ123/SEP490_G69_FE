class TopProduct {
  final String name;
  final int totalQuantity;
  final double totalValue;
  final String? image;


  TopProduct({
    required this.name,
    required this.totalQuantity,
    required this.totalValue,
    this.image,

  });

  factory TopProduct.fromJson(Map<String, dynamic> json) {
    return TopProduct(
      name: json['name'] ?? '',
      totalQuantity: json['totalQuantity'] ?? 0,
      totalValue: (json['totalValue'] as num?)?.toDouble() ?? 0.0,
      image: json['image'],
    );
  }
}
