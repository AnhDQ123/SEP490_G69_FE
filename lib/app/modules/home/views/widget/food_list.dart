import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/product.dart';
import '../../controllers/home_controller.dart';

class FoodList extends StatelessWidget {
  final HomeController controller;
  const FoodList({Key? key, required this.controller}) : super(key: key);

  String getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return "";
    if (imagePath.startsWith("http")) {
      return imagePath;
    } else {
      return "https://your-server-domain.com" + imagePath;
    }
  }

  Widget _buildProductCard(Product product) {
    return InkWell(
      onTap: () {
        Get.toNamed('/product-detail', arguments: product.id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Hình ảnh sản phẩm
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey.shade300,
                image: (product.image != null && product.image!.isNotEmpty)
                    ? DecorationImage(
                  image: NetworkImage(getFullImageUrl(product.image)),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: (product.image == null || product.image!.isEmpty)
                  ? const Icon(Icons.image, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 8),
            // Thông tin sản phẩm
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên sản phẩm
                  Text(
                    product.name ?? '',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  // Hiển thị số lượng
                  Text(
                    "Số lượng: ${product.quantity ?? 0}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  // Hiển thị discount nếu có (chỉ hiển thị nếu discount > 0)
                  if ((product.discount ?? 0) > 0)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '-${product.discount?.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.currentList;
      if (list.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        key: ValueKey<int>(controller.selectedFoodTab.value),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            final product = list[index];
            return _buildProductCard(product);
          },
        ),
      );
    });
  }
}
