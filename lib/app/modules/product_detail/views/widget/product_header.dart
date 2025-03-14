import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_detail_controller.dart';
import 'size_option.dart';
import 'review_item.dart';

// Helper function: Xây dựng URL ảnh đầy đủ
String buildImageUrl(String imageUrl) {
  // Nếu chuỗi rỗng, trả về asset placeholder
  if (imageUrl.isEmpty) return 'assets/images/placeholder.png';
  // Nếu đã là URL đầy đủ (bắt đầu bằng http hoặc https)
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
        // 1) Ảnh sản phẩm: Sử dụng URL từ currentProduct, nếu rỗng hiển thị placeholder
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Obx(() {
            final imgUrl = buildImageUrl(controller.currentProduct.imageUrl);
            if (imgUrl.startsWith('assets/')) {
              return Image.asset(
                imgUrl,
                fit: BoxFit.cover,
              );
            }
            return Image.network(
              imgUrl,
              fit: BoxFit.cover,
            );
          }),
        ),
        const SizedBox(height: 8),
        // 2) Các icon: Shop, Yêu thích, Báo cáo
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: controller.goToShop,
                icon: const Icon(Icons.store),
                tooltip: 'Xem Shop',
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: controller.addToFavorite,
                icon: const Icon(Icons.favorite_border),
                tooltip: 'Yêu thích',
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: controller.reportProduct,
                icon: const Icon(Icons.report),
                tooltip: 'Báo cáo',
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      double rating = controller.currentProduct.rating;
                      if (rating >= index + 1) {
                        return const Icon(Icons.star, color: Colors.amber, size: 16);
                      } else if (rating > index && rating < index + 1) {
                        return const Icon(Icons.star_half, color: Colors.amber, size: 16);
                      } else {
                        return const Icon(Icons.star_border, color: Colors.amber, size: 16);
                      }
                    }),
                    const SizedBox(width: 4),
                    Text('${controller.currentProduct.rating}', style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            );
          }),
        ),
        const SizedBox(height: 8),
        // 4) Miêu tả sản phẩm với nút "Xem thêm/Thu gọn"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Obx(() {
            final isExpanded = controller.isDescriptionExpanded.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.currentProduct.description,
                  maxLines: isExpanded ? null : 2,
                  overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
                GestureDetector(
                  onTap: controller.toggleDescription,
                  child: Text(
                    isExpanded ? 'Thu gọn' : 'Xem thêm',
                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          }),
        ),
        const SizedBox(height: 8),
        // 5) Hiển thị giá và số lượng mua
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Giá: ${(controller.currentPrice * controller.quantity.value).toStringAsFixed(0)}đ',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: controller.decrementQuantity,
                      icon: const Icon(Icons.remove),
                    ),
                    Text('${controller.quantity.value}'),
                    IconButton(
                      onPressed: controller.incrementQuantity,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                )
              ],
            );
          }),
        ),
        const SizedBox(height: 8),
        // 6) Hiển thị lựa chọn Size dựa trên foodOptions với typeId == 2
        // 6) Hiển thị lựa chọn Size dựa trên foodOptions với typeId == 2
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Obx(() {
            final availableSizes = controller.currentProduct.foodOptions
                .where((option) => option.typeId == 2)
                .toList();
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Text('Size: '),
                  const SizedBox(width: 8),
                  ...List.generate(availableSizes.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SizeOptionWidget(
                        label: availableSizes[index].name,
                        isSelected: controller.selectedSizeIndex.value == index,
                        onTap: () => controller.selectSize(index),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ),

        const SizedBox(height: 16),
        // 7) Phần đánh giá sản phẩm (hiển thị cứng)
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Obx(() => IconButton(
                    icon: Icon(
                      controller.isReviewExpanded.value
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
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
        const SizedBox(height: 16),
      ],
    );
  }
}
