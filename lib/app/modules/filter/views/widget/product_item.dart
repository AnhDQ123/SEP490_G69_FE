import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../resources/util_common.dart';

class ProductItem extends StatelessWidget {
  final Map<String, dynamic> item;
  const ProductItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double originalPrice =
        double.tryParse(item['defaultPrice']?.toString() ?? '0') ?? 0;
    final discount = (item['discount'] ?? 0); // discount là số thập phân, ví dụ 0.12 => 12%
    final bool hasDiscount = discount > 0;
    final double finalPrice =
    hasDiscount ? originalPrice * (1 - discount) : originalPrice;

    return InkWell(
      onTap: () {
        Get.toNamed('/product-detail', arguments: item['id']);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        // Sử dụng Stack để chồng thêm icon Add to Cart
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ảnh sản phẩm với nhãn giảm giá (nếu có)
                Container(
                  height: 150, // Kích thước cố định cho tất cả ảnh
                  width: double.infinity,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        child: item['image'] != null &&
                            item['image'].toString().isNotEmpty
                            ? Image.network(
                          item['image'],
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                            : Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey.shade200,
                          child:
                          const Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
                      if (hasDiscount)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '-${(discount * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                // Tên sản phẩm
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    item['name'] ?? '',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Thông tin shop và icon verify ngay bên cạnh
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Shop: ${item['shop'] ?? 'Không xác định'}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color.fromRGBO(212, 163, 115, 1),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, size: 12, color: Colors.blue),
                    ],
                  ),
                ),
                // Giá sản phẩm với vị trí đổi chỗ:
                // Giá cũ (nếu có giảm giá) hiển thị đầu tiên, sau đó là giá mới
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Row(
                    children: [
                      if (hasDiscount)
                        Text(
                          UtilCommon.formatMoney(originalPrice),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      if (hasDiscount) const SizedBox(width: 4),
                      Text(
                        UtilCommon.formatMoney(finalPrice),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
            // ICON ADD TO CART ở góc dưới bên phải
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(212, 163, 115, 1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 3,
                      spreadRadius: 0.5,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.add_shopping_cart,
                      color: Colors.white, size: 14),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    // Xử lý thêm sản phẩm vào giỏ hàng
                    Get.snackbar(
                      "Thành công!",
                      "${item['name']} đã được thêm vào giỏ hàng.",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
