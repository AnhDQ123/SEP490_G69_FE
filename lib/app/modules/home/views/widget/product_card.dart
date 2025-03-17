import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int index;
  final int total;
  final bool isCompact;

  const ProductCard({
    Key? key,
    required this.product,
    required this.index,
    required this.total,
    this.isCompact = false,
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
    double cardWidth = isCompact ? 180 : 210; // ✅ Tăng chiều rộng thêm 20px
    double cardHeight = isCompact ? 85 : 110;
    double imageSize = isCompact ? 70 : 80; // ✅ Tăng nhẹ kích thước ảnh
    double fontSize = isCompact ? 10 : 12;

    return InkWell(
      onTap: () {
        Get.toNamed('/product-detail', arguments: product.id);
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: EdgeInsets.only(left: (index == 0) ? 12 : 6, right: (index == total - 1) ? 12 : 6), // ✅ Giảm margin một chút
        padding: const EdgeInsets.all(8.0), // ✅ Tăng padding để thoáng hơn
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: Row(
          children: [
            // Ảnh sản phẩm (Bên trái)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                getFullImageUrl(product.image),
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10), // ✅ Giữ khoảng cách hợp lý

            // Thông tin sản phẩm (Bên phải)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ✅ Tên sản phẩm
                  Text(
                    product.name ?? 'Tên sản phẩm',
                    style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4), // 🔹 Khoảng cách giữa tên và Rate

                  // ✅ Row hiển thị rating
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: fontSize),
                      const SizedBox(width: 2),
                      Text(
                        product.rate != null ? product.rate!.toStringAsFixed(1) : '0.0',
                        style: TextStyle(fontSize: fontSize - 1, color: Colors.grey.shade700),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4), // 🔹 Khoảng cách giữa Rate và Quantity

                  // ✅ `Đã bán` luôn nằm dưới `Rate`
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Đã bán: ${product.quantity}",
                      style: TextStyle(fontSize: fontSize - 1, color: Colors.green, fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
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
}