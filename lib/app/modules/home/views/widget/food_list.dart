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
    final double originalPrice = 100000; // Giá cũ cố định: 100.000đ
    final double discount = product.discount ?? 0; // Discount (nếu có)
    final double newPrice = originalPrice * (1 - (discount / 100)); // Tính giá mới sau giảm

    return InkWell(
      onTap: () {
        Get.toNamed('/product-detail', arguments: product.id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Hình ảnh sản phẩm + Giảm giá
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    getFullImageUrl(product.image),
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 75,
                      height: 75,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image, color: Colors.white, size: 30),
                    ),
                  ),
                ),
                if (discount > 0)
                  Positioned(
                    top: 2,
                    left: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                      ),
                      child: Text(
                        '-${discount.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // ✅ Thông tin sản phẩm + Giá cố định
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Tên sản phẩm
                  Text(
                    product.name ?? '',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),

                  // 🔹 Hiển thị tên shop + Icon xác minh
                  Row(
                    children: [
                      Text(
                        "${product.shop ?? 'Không xác định'}",
                        style: const TextStyle(
                          fontSize: 9,
                          color: Color.fromRGBO(212, 163, 115, 1),
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.verified,
                        size: 12,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),

                  // 🔹 Hiển thị đánh giá sản phẩm
                  if (product.rate != null)
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 11),
                        const SizedBox(width: 2),
                        Text(
                          product.rate!.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 9),
                        ),
                      ],
                    ),

                  // 🔹 Hiển thị Giá (Gồm giá cũ và giá mới nếu có giảm giá)
                  Row(
                    children: [
                      if (discount > 0)
                        Text(
                          "${originalPrice.toStringAsFixed(0)}đ",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough, // 🔹 Gạch ngang giá cũ
                          ),
                        ),
                      const SizedBox(width: 4),
                      Text(
                        "${newPrice.toStringAsFixed(0)}đ",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
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
        duration: const Duration(milliseconds: 250),
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
