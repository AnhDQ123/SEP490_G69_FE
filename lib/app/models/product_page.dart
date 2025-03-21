import 'package:ffb_fe_flutter/app/models/product.dart';

class ProductPage {
  final List<Product> content;
  final int totalPages;
  final int totalElements;
  final int size;
  final int number;

  ProductPage({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.size,
    required this.number,
  });

  factory ProductPage.fromJson(Map<String, dynamic> json) => ProductPage(
    content: (json['content'] as List<dynamic>)
        .map((item) => Product.fromJson(item))
        .toList(),
    totalPages: json['totalPages'],
    totalElements: json['totalElements'],
    size: json['size'],
    number: json['number'],
  );
}