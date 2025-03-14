import 'package:flutter/material.dart';
import '../../../../models/product.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int index;
  final int total;
  const ProductCard({
    Key? key,
    required this.product,
    required this.index,
    required this.total,
  }) : super(key: key);

  String getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return "";
    if (imagePath.startsWith("http")) {
      return imagePath;
    } else {
      return "https://your-server-domain.com" + imagePath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Điều hướng tới trang product_detail và truyền id sản phẩm qua arguments
        Get.toNamed('/product-detail', arguments: product.id);
      },
      child: Container(
        width: 140,
        height: 105,
        margin: EdgeInsets.only(
          left: (index == 0) ? 16 : 8,
          right: (index == total - 1) ? 16 : 0,
        ),
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name ?? '',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        product.rate != null
                            ? product.rate!.toStringAsFixed(1)
                            : '0.0',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 1),
                image: (product.image != null && product.image!.isNotEmpty)
                    ? DecorationImage(
                  image: NetworkImage(getFullImageUrl(product.image)),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: (product.image == null || product.image!.isEmpty)
                  ? const Icon(Icons.image, size: 20)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
