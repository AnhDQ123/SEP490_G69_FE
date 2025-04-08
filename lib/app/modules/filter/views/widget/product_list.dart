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

      // Nếu danh sách rỗng và đang load, hiển thị loading indicator
      if (products.isEmpty && controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // Nếu không có sản phẩm nào
      if (products.isEmpty) {
        return const Center(child: Text('Không có sản phẩm'));
      }

      return GridView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.6,
        ),
        // Tăng thêm 1 item nếu còn dữ liệu để load (để hiển thị loading indicator)
        itemCount: products.length + (controller.hasMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < products.length) {
            return ProductItem(item: products[index]);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    });
  }
}
