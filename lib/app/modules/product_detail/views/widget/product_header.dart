import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_detail_controller.dart';
import 'size_option.dart';
import 'review_item.dart';

// Helper function: Xây dựng URL ảnh đầy đủ
String buildImageUrl(String imageUrl) {
  if (imageUrl.isEmpty) return 'assets/images/placeholder.png';
  if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
    return imageUrl;
  }
  return 'http://your-backend-url/images/$imageUrl';
}

class ProductHeader extends StatelessWidget {
  final ProductDetailController controller;
  const ProductHeader({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1) Ảnh sản phẩm
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Obx(() {
            final imgUrl = buildImageUrl(controller.currentProduct.imageUrl);
            return imgUrl.startsWith('assets/')
                ? Image.asset(imgUrl, fit: BoxFit.cover)
                : Image.network(imgUrl, fit: BoxFit.cover);
          }),
        ),
        const SizedBox(height: 8),

        // 2) Các icon: Shop, Yêu thích, Báo cáo (giữ nguyên kích cỡ)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              IconButton(
                onPressed: controller.goToShop,
                icon: const Icon(Icons.store),
                tooltip: 'Xem Shop',
              ),
              IconButton(
                onPressed: controller.addToFavorite,
                icon: const Icon(Icons.favorite_border),
                tooltip: 'Yêu thích',
              ),
              IconButton(
                onPressed: controller.reportProduct,
                icon: const Icon(Icons.report),
                tooltip: 'Báo cáo',
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),

        // 3) Tên sản phẩm và đánh giá (rate)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.currentProduct.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    height: 0.9,
                  ),
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -18),
                  child: Row(
                    children: [
                      ...List.generate(5, (index) {
                        double rating = controller.currentProduct.rating;
                        if (rating >= index + 1) {
                          return const Icon(Icons.star, color: Colors.amber, size: 14);
                        } else if (rating > index && rating < index + 1) {
                          return const Icon(Icons.star_half, color: Colors.amber, size: 14);
                        } else {
                          return const Icon(Icons.star_border, color: Colors.amber, size: 14);
                        }
                      }),
                      const SizedBox(width: 4),
                      Text(
                        '${controller.currentProduct.rating}',
                        style: const TextStyle(fontSize: 12), // Giảm số của rating
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
        const SizedBox(height: 8),

        // 4) Tiêu đề "Mô tả sản phẩm" và nội dung (không có nền, bố cục đẹp hơn)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Obx(() {
            final isExpanded = controller.isDescriptionExpanded.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.info_outline, size: 18, color: Color.fromRGBO(212, 163, 115, 1)), // Icon màu đồng
                    SizedBox(width: 6), // Khoảng cách giữa icon và chữ
                    Text(
                      'Mô tả sản phẩm',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 6), // Khoảng cách nhỏ giữa tiêu đề và nội dung
                Text(
                  controller.currentProduct.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700], // Màu chữ xám
                    height: 1.4, // Khoảng cách giữa các dòng
                  ),
                  maxLines: isExpanded ? null : 3,
                  overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: controller.toggleDescription,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      isExpanded ? 'Thu gọn ▲' : 'Xem thêm ▼',
                      style: const TextStyle(
                        color: Color.fromRGBO(212, 163, 115, 1), // Màu theo yêu cầu
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),


        const SizedBox(height: 8),

        // 7) Đánh giá sản phẩm
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Đánh giá sản phẩm (3)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Obx(() => IconButton(
                    icon: Icon(
                      controller.isReviewExpanded.value
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                    ),
                    onPressed: controller.toggleReviews,
                  )),
                ],
              ),
              Obx(() {
                if (!controller.isReviewExpanded.value) return const SizedBox.shrink();
                return Column(
                  children: [
                    ReviewItem(review: controller.reviews[0]),
                    const Divider(),
                    ReviewItem(review: controller.reviews[1]),
                    const Divider(),
                    ReviewItem(review: controller.reviews[2]),
                  ],
                );
              }),
            ],
          ),
        ),

        // 5) Hiển thị giá và số lượng mua (đẹp hơn)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Giá sản phẩm (to và nổi bật hơn)
                Text(
                  'Giá: ${(controller.currentPrice * controller.quantity.value).toStringAsFixed(0)}đ',
                  style: const TextStyle(
                    fontSize: 18, // Tăng kích thước chữ
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                // Bộ đếm số lượng sản phẩm
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30), // Bo tròn viền
                    border: Border.all(color: Colors.grey.shade300), // Viền xám nhẹ
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: controller.decrementQuantity,
                        icon: const Icon(Icons.remove, size: 18, color: Colors.black54), // Giảm màu icon
                        splashRadius: 20, // Tạo hiệu ứng bấm đẹp hơn
                      ),
                      Text(
                        '${controller.quantity.value}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: controller.incrementQuantity,
                        icon: const Icon(Icons.add, size: 18, color: Colors.black54), // Giảm màu icon
                        splashRadius: 20, // Tạo hiệu ứng bấm đẹp hơn
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),

        const SizedBox(height: 8),



        // 6) Hiển thị lựa chọn Size (tối ưu giao diện, giảm khoảng trắng)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Giảm padding dọc
          child: Obx(() {
            final availableSizes = controller.currentProduct.foodOptions
                .where((option) => option.typeId == 2)
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề có icon
                Row(
                  children: const [
                    Icon(Icons.format_size, size: 18, color: Color.fromRGBO(212, 163, 115, 1)), // Icon size
                    SizedBox(width: 6),
                    Text(
                      'Chọn Size:',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4), // Giảm khoảng cách giữa tiêu đề và size

                // Các tùy chọn size
                Wrap(
                  spacing: 8.0, // Khoảng cách ngang giữa các size
                  runSpacing: 4.0, // Giảm khoảng cách dọc nếu xuống hàng
                  children: List.generate(availableSizes.length, (index) {
                    final isSelected = controller.selectedSizeIndex.value == index;
                    return GestureDetector(
                      onTap: () => controller.selectSize(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color.fromRGBO(212, 163, 115, 1) : Colors.white,
                          border: Border.all(
                            color: isSelected ? const Color.fromRGBO(212, 163, 115, 1) : Colors.grey.shade300,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(20), // Bo góc
                          boxShadow: isSelected
                              ? [
                            BoxShadow(
                              color: Colors.orange.shade200.withOpacity(0.5),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                              : [],
                        ),
                        child: Text(
                          availableSizes[index].name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          }),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
