import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/filter_controller.dart';
import 'product_item.dart';

class ProductList extends GetView<FilterController> {
  const ProductList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final products = controller.products;
      if (products.isEmpty) {
        return const Center(child: Text('Không có sản phẩm'));
      }
      return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,             // 2 cột
          mainAxisSpacing: 8,            // Khoảng cách giữa các hàng
          crossAxisSpacing: 8,           // Khoảng cách giữa các cột
          childAspectRatio: 0.6,         // Tỉ lệ khung hình, điều chỉnh cho phù hợp
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final item = products[index];
          return ProductItem(item: item);
        },
      );
    });
  }
}
