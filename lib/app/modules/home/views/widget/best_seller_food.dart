import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../resources/responsive_utils.dart';
import '../../../../resources/text_style.dart';
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
            padding: UtilsReponsive.padding(context, horizontal: 12, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Bọc tiêu đề trong Expanded để tránh tràn
                Expanded(
                  child: Text(
                    '🔥 Bán chạy theo ngày',
                    style: TextStyle(
                      fontSize: UtilsReponsive.formatFontSize(14, context),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: TextConstant.subTile3(
                    context,
                    text: 'Xem thêm',
                    size: UtilsReponsive.formatFontSize(9, context),
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: UtilsReponsive.height(6, context)),
          SizedBox(
            height: UtilsReponsive.height(110, context),
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
