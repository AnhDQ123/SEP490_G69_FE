import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/product.dart';
import '../../controllers/filter_controller.dart';
import 'product_item.dart';

class ProductList extends GetView<FilterController> {
  const ProductList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<Product> products = controller.products;

      if (products.isEmpty) {
        return const Center(child: Text('Không có sản phẩm'));
      }

      return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.6,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final Product item = products[index];
          return ProductItem(item: item); // Truyền đúng kiểu Product
        },
      );
    });
  }
}
