import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import 'product_card.dart';

class BestSellerFoods extends StatelessWidget {
  final HomeController controller;
  const BestSellerFoods({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final popularProducts = controller.popularProductList;
      if (popularProducts.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '🔥 Bán chạy theo ngày',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Xem thêm',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          SizedBox(
            height: 110, // 🔹 Tăng nhẹ để hiển thị cân đối hơn
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: popularProducts.length,
              itemBuilder: (context, index) {
                final product = popularProducts[index];
                return ProductCard(
                  product: product,
                  index: index,
                  total: popularProducts.length,
                  isCompact: true,
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

