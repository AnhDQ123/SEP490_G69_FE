// class OrderItem {
//   final String imageUrl;
//   final String dishName;
//   final int quantity;
//   final double price;
//   final double discount;
//
//   OrderItem({
//     required this.imageUrl,
//     required this.dishName,
//     required this.quantity,
//     required this.price,
//     required this.discount,
//   });
//
//   // Chuyển từ JSON -> OrderItem
//   factory OrderItem.fromJson(Map<String, dynamic> json) {
//     return OrderItem(
//       imageUrl: json['imageUrl'] as String,
//       dishName: json['dishName'] as String,
//       quantity: json['quantity'] as int,
//       price: (json['price'] as num).toDouble(),
//       discount: (json['discount'] as num).toDouble(),
//     );
//   }
//
//   // Chuyển từ OrderItem -> JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'imageUrl': imageUrl,
//       'dishName': dishName,
//       'quantity': quantity,
//       'price': price,
//       'discount': discount,
//     };
//   }
// }

class OrderItem {
  final String imageUrl;
  final String dishName;
  final int quantity;
  final double price;
  final double discount;
  final String? option;
  final String? size;

  OrderItem({
    required this.imageUrl,
    required this.dishName,
    required this.quantity,
    required this.price,
    required this.discount,
    this.option,
    this.size,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      imageUrl: json['imageUrl'] as String,
      dishName: json['dishName'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      option: json['option'] as String?,
      size: json['size'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'dishName': dishName,
      'quantity': quantity,
      'price': price,
      'discount': discount,
      'option': option,
      'size': size,
    };
  }
}

