import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/similar_product.dart';
import '../../controllers/product_detail_controller.dart';

class ProductListWidget extends StatelessWidget {
  final RxList<SimilarProduct> products;
  const ProductListWidget({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lấy controller từ GetX
    final controller = Get.find<ProductDetailController>();
    return Obx(() {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = products[index];
          return Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Hiển thị ảnh của sản phẩm tương tự
                Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(item.shopName, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${item.price.toStringAsFixed(0)}đ',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
                          ),
                          Row(
                            children: [
                              // Giả sử controller có các phương thức xử lý số lượng cho sản phẩm tương tự
                              IconButton(
                                onPressed: () => controller.decrementSimilarQuantity(products, index),
                                icon: const Icon(Icons.remove, size: 16),
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                onPressed: () => controller.incrementSimilarQuantity(products, index),
                                icon: const Icon(Icons.add, size: 16),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () => controller.addProductToCart(item),
                                icon: const Icon(Icons.add_shopping_cart, size: 20, color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}


