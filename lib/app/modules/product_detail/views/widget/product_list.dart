import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/discount.dart';
import '../../../../models/product.dart';
import '../../controllers/product_detail_controller.dart';
import 'package:intl/intl.dart';

class ProductListWidget extends StatelessWidget {
  final RxList<Product> products;
  const ProductListWidget({Key? key, required this.products}) : super(key: key);

  String formatPrice(double price) {
    final formatter =
    NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);
    return formatter.format(price) + "đ";
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailController>();

    return Obx(() {
      return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 cột
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          // Sử dụng childAspectRatio nhỏ hơn (ví dụ 0.6) để cell có chiều cao lớn hơn
          childAspectRatio: 0.6,
        ),
        itemBuilder: (context, index) {
          final item = products[index];

          double originalPrice = item.defaultPrice;

          // Lọc discount có trạng thái ACTIVE và lấy discount đầu tiên
          final activeDiscount = item.discount.firstWhere(
                (discount) => discount.status == 'ACTIVE',
            orElse: () => Discount(  // Nếu không có discount ACTIVE, trả về discount mặc định
              id: 0,
              amount: 0.0,  // Mặc định là không có giảm giá
              startDate: '',
              endDate: '',
              status: 'INACTIVE',  // Mặc định là INACTIVE
            ),
          );

          // Tính giá mới sau discount (nếu có)
          double discountedPrice = originalPrice * (1 - activeDiscount.amount);


          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        item.image,
                        width: double.infinity,
                        height: 120, // tăng chiều cao ảnh lên 100
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: double.infinity,
                          height: 100,
                          color: Colors.grey[300],
                          child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 20),
                        ),
                      ),
                    ),
                    if (activeDiscount.amount > 0)
                      Positioned(
                        top: 3,
                        left: 3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            '-${(activeDiscount.amount * 100).toStringAsFixed(0)}%',
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
                const SizedBox(height: 8),
                // Tên sản phẩm
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                // Đánh giá sản phẩm
                Row(
                  children: [
                    ...List.generate(5, (starIndex) {
                      if (item.rate >= starIndex + 1) {
                        return const Icon(
                            Icons.star, color: Colors.amber, size: 12);
                      } else if (item.rate > starIndex &&
                          item.rate < starIndex + 1) {
                        return const Icon(
                            Icons.star_half,
                            color: Colors.amber,
                            size: 12);
                      } else {
                        return const Icon(
                            Icons.star_border,
                            color: Colors.amber,
                            size: 12);
                      }
                    }),
                    const SizedBox(width: 3),
                    Text(
                      '${item.rate.toStringAsFixed(1)}',
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Giá gốc và giá giảm (nếu có)
                Row(
                  children: [
                    if (activeDiscount.amount > 0)
                      Text(
                        formatPrice(originalPrice),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    const SizedBox(width: 4),
                    Text(
                      formatPrice(discountedPrice),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Số lượng và nút thêm vào giỏ
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border:
                          Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          'Số lượng: ${item.quantity}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    ElevatedButton(
                      onPressed: () => controller.addProductToCart(item),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        backgroundColor: const Color.fromRGBO(
                            212, 163, 115, 1),
                        elevation: 1,
                        minimumSize: const Size(28, 28),
                      ),
                      child: const Icon(
                        Icons.add_shopping_cart,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
