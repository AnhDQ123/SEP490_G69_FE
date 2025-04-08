import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductSelectionView extends StatelessWidget {
  // Danh sách sản phẩm mẫu với id và tên
  final List<Map<String, String>> products = [
    {'id': '71', 'name': 'Sản phẩm A'},
    {'id': '72', 'name': 'Sản phẩm B'},
    {'id': '73', 'name': 'Sản phẩm C'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn Sản Phẩm'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product['name']!),
            onTap: () {
              // Khi người dùng bấm vào sản phẩm, điều hướng tới route /product-detail
              // và truyền product id qua arguments
              Get.toNamed('/product-detail', arguments: product['id']);
            },
          );
        },
      ),
    );
  }
}
