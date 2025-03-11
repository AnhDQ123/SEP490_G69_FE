class FoodOption {
  final int id;
  final String? name;
  final double? price;
  final String? description;
  final String? image;
  final int? typeId; // Phân loại (2 = Size, 3 = Option)
  final String? status;

  FoodOption({
    required this.id,
    this.name,
    this.price,
    this.description,
    this.image,
    this.typeId,
    this.status,
  });

  factory FoodOption.fromJson(Map<String, dynamic> json) {
    return FoodOption(
      id: json['id'] ?? 0,
      name: json['name'],
      price: json['price']?.toDouble(),
      description: json['description'],
      image: json['image'],
      typeId: json['type_id'], // Giữ nguyên typeId để phân biệt Size / Option
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "description": description,
      "image": image,
      "type_id": typeId, // Đảm bảo gửi đúng type_id khi gọi API
      "status": status,
    };
  }
}