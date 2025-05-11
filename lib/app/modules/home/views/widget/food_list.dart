import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../models/discount.dart';
import '../../../../models/product.dart';
import '../../../../resources/responsive_utils.dart';
import '../../../../resources/text_style.dart';
import '../../controllers/home_controller.dart';
import 'package:intl/intl.dart';

class FoodList extends StatelessWidget {
  final HomeController controller;
  const FoodList({Key? key, required this.controller}) : super(key: key);

  String getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return "";
    if (imagePath.startsWith("http")) {
      return imagePath;
    } else {
      return "https://your-server-domain.com" + imagePath;
    }
  }

  String formatPrice(double price) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);
    return formatter.format(price) + "đ";
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    print('Product: ${product.name} - Discounts: ${product.discount}'); // Debug
    // Lấy discount có trạng thái ACTIVE
    Discount? activeDiscount;
    for (var discount in product.discount) {
      print('Discount: ${discount.amount}%, Status: ${discount.status}'); // Debug
      if (discount.status == 'ACTIVE') {
        activeDiscount = discount;
        break; // Lấy discount đầu tiên có trạng thái ACTIVE
      }
    }

    // Nếu có discount có trạng thái ACTIVE, tính giá mới
    double discountValue = 0.0;
    if (activeDiscount != null) {
      // Nếu amount < 1 (đang là dạng 0.15), nhân 100 để thành 15%
      // Nếu amount >= 1 (đang là dạng 15), giữ nguyên
      discountValue = activeDiscount.amount < 1 ? activeDiscount.amount * 100 : activeDiscount.amount;
      discountValue = discountValue / 100; // Chuyển về dạng 0.15 để tính toán
    }

    final double newPrice = product.defaultPrice * (1 - discountValue);

    return InkWell(
      onTap: () {
        Get.toNamed('/product-detail', arguments: product.id);
      },
      child: Container(
        margin: UtilsReponsive.paddingAll(context, padding: 3),
        padding: UtilsReponsive.paddingAll(context, padding: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(UtilsReponsive.width(6, context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              spreadRadius: 0.5,
              blurRadius: 2,
              offset: Offset(0, UtilsReponsive.height(2, context)),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hình ảnh sản phẩm + Giảm giá
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(UtilsReponsive.width(6, context)),
                      child: Image.network(
                        getFullImageUrl(product.image),
                        width: double.infinity,
                        height: UtilsReponsive.height(100, context),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: double.infinity,
                          height: UtilsReponsive.height(100, context),
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image, color: Colors.white, size: 30),
                        ),
                      ),
                    ),
                    // Nếu có discount ACTIVE, hiển thị banner giảm giá
                    if (activeDiscount != null)
                      Positioned(
                        top: UtilsReponsive.height(2, context),
                        left: UtilsReponsive.width(2, context),
                        child: Container(
                          padding: UtilsReponsive.padding(context, horizontal: 3, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: TextConstant.subTile3(
                            context,
                            text: '-${(activeDiscount.amount < 1 ? activeDiscount.amount * 100 : activeDiscount.amount).toStringAsFixed(0)}%',
                            size: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: UtilsReponsive.height(8, context)),

                // Thông tin sản phẩm
                Row(
                  children: [
                    Expanded(  // Thêm Expanded để cho phép tên sản phẩm co giãn
                      child: TextConstant.subTile2(
                        context,
                        text: product.name,
                        size: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),


                Row(
                  children: [
                    TextConstant.subTile2(
                      context,
                      text: product.shop,
                      size: 8,
                      color: const Color.fromRGBO(212, 163, 115, 1),
                    ),
                    SizedBox(width: UtilsReponsive.width(2, context)),
                    const Icon(Icons.verified, size: 10, color: Colors.blue),
                  ],
                ),
                SizedBox(height: UtilsReponsive.height(2, context)),

                if (product.rate != null)
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 10),
                      SizedBox(width: UtilsReponsive.width(2, context)),
                      TextConstant.subTile2(
                        context,
                        text: product.rate.toStringAsFixed(1),
                        size: 9,
                      ),
                    ],
                  ),
                SizedBox(height: UtilsReponsive.height(2, context)),
                // 🛒 Còn lại bao nhiêu
                if (product.quantity != null)
                  TextConstant.subTile2(
                    context,
                    text: product.quantity > 0
                        ? "Còn lại: ${product.quantity} suất"
                        : "Hết hàng",
                    size: 9,
                    fontWeight: FontWeight.w600,
                    color: product.quantity > 0 ? Colors.green : Colors.redAccent,
                  ),
                SizedBox(height: UtilsReponsive.height(2, context)),

                Row(
                  children: [
                    // Hiển thị giá cũ nếu có discount
                    if (activeDiscount != null)
                      Text(
                        formatPrice(product.defaultPrice),
                        style: TextConstant.textStyleDefine(
                          context,
                          size: 9,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ).copyWith(decoration: TextDecoration.lineThrough),
                      ),
                    SizedBox(width: UtilsReponsive.width(2, context)),
                    // Hiển thị giá mới
                    TextConstant.titleH2(
                      context,
                      text: formatPrice(newPrice),
                      size: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ],
            ),

            // ICON ADD TO CART ở góc dưới phải
            Positioned(
              bottom: 3, // Dịch nút lên một chút
              right: 3,  // Dịch nút vào gần cạnh hơn
              child: Container(
                width: UtilsReponsive.width(26, context),  // Giảm kích thước tổng thể của nút
                height: UtilsReponsive.width(26, context),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(212, 163, 115, 1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 3,  // Giảm độ mờ của bóng
                      spreadRadius: 0.5,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 14), // Giảm kích thước icon
                  padding: EdgeInsets.zero, // Loại bỏ padding dư thừa của IconButton
                  constraints: BoxConstraints(), // Giảm giới hạn kích thước
                  onPressed: () {
                    // Thêm sản phẩm vào giỏ hàng
                    Get.snackbar(
                      "Thành công!",
                      "${product.name} đã được thêm vào giỏ hàng.",
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.currentList;
      if (list.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        key: ValueKey<int>(controller.selectedFoodTab.value),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: UtilsReponsive.paddingAll(context, padding: 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: UtilsReponsive.height(8, context),
            crossAxisSpacing: UtilsReponsive.width(8, context),
            childAspectRatio: 0.6,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final product = list[index];
            return _buildProductCard(context, product);
          },
        ),
      );
    });
  }
}




