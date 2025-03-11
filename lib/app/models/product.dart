class Product {
  final int? id;
  final String? name;
  final String? manufacturer;
  final String? supplier;
  final int? quantity;
  final String? category;
  final String? status;
  final double? discount;
  final String? image;
  final dynamic foodOption;

  Product({
    this.id,
    this.name,
    this.manufacturer,
    this.supplier,
    this.quantity,
    this.category,
    this.status,
    this.discount,
    this.image,
    this.foodOption,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      name: json['name'] as String?,
      manufacturer: json['manufacturer'] as String?,
      supplier: json['supplier'] as String?,
      quantity: json['quantity'] as int?,
      category: json['category'] as String?,
      status: json['status'] as String?,
      // discount có thể là int hoặc String, nên ép kiểu an toàn
      discount: (json['discount'] != null)
          ? double.tryParse(json['discount'].toString()) ?? 0.0
          : 0.0,
      image: json['image'] as String?,
      // Tuỳ vào kiểu dữ liệu thực tế của foodOption mà bạn có thể tuỳ chỉnh
      foodOption: json['foodOption'],
    );
  }

  // Nếu cần convert ngược lại sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'manufacturer': manufacturer,
      'supplier': supplier,
      'quantity': quantity,
      'category': category,
      'status': status,
      'discount': discount,
      'image': image,
      'foodOption': foodOption,
    };
  }
}
