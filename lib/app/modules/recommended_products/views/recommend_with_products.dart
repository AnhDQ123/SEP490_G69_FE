import 'package:ffb_fe_flutter/app/modules/my_order/views/recommend_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/recommended_products_controller.dart';
import 'recommended_products_grid.dart';

class RecommendWithProducts extends GetView<RecommendedProductsController> {
  const RecommendWithProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RecommendedSection(),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          } else if (controller.products.isEmpty) {
            return const Center(child: Text("Không có sản phẩm khuyến nghị"));
          } else {
            return RecommendedProductsGrid(products: controller.products);
          }
        }),
      ],
    );
  }
}
