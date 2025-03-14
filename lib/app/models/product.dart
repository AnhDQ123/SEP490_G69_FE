class Product {
  final int? id;
  final String? name;
  final String? manufacturer;
  final String? supplier; // tên cửa hàng
  final int? quantity;
  final String? category;
  final String? status;
  final double? discount;
  final String? image;
  final dynamic foodOption;
  final double? rate; // thêm trường rate

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
    this.rate,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      name: json['name'] as String?,
      manufacturer: json['manufacturer'] as String?,
      supplier: json['supplier'] as String?, // tên cửa hàng
      quantity: json['quantity'] as int?,
      category: json['category'] as String?,
      status: json['status'] as String?,
      discount: (json['discount'] != null)
          ? double.tryParse(json['discount'].toString()) ?? 0.0
          : 0.0,
      image: json['image'] as String?,
      foodOption: json['foodOption'],
      rate: (json['rate'] != null)
          ? double.tryParse(json['rate'].toString()) ?? 0.0
          : 0.0,
    );
  }

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
      'rate': rate,
    };
  }
}
