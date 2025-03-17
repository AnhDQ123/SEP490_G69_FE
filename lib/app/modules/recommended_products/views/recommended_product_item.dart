import 'package:flutter/material.dart';
import '../../../models/product.dart';

class RecommendedProductItem extends StatelessWidget {
  final Product product;

  const RecommendedProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sử dụng Stack để chồng overlay lên ảnh sản phẩm
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    product.imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (product.discount > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "-${product.discount}%",
                        style: const TextStyle(
                          fontSize: 8,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            // Tên sản phẩm
            Text(
              product.name,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Tên shop
            Text(
              product.shopName,
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Hiển thị đánh giá
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 10),
                const SizedBox(width: 4),
                Text(
                  product.rating.toString(),
                  style: const TextStyle(fontSize: 8),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Hiển thị giá sản phẩm
            Text(
              "${product.price.toStringAsFixed(0)}đ",
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
