// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../models/product.dart';
// import '../../controllers/home_controller.dart';
// import 'package:intl/intl.dart';
//
//
// class FoodList extends StatelessWidget {
//   final HomeController controller;
//   const FoodList({Key? key, required this.controller}) : super(key: key);
//
//   String getFullImageUrl(String? imagePath) {
//     if (imagePath == null || imagePath.isEmpty) return "";
//     if (imagePath.startsWith("http")) {
//       return imagePath;
//     } else {
//       return "https://your-server-domain.com" + imagePath;
//     }
//   }
//   String formatPrice(double price) {
//     // Tạo định dạng không có ký hiệu tiền tệ (symbol: '') và không có số thập phân (decimalDigits: 0)
//     final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);
//     return formatter.format(price) + "đ";
//   }
//
//
//   Widget _buildProductCard(Product product) {
//     final double discount = product.discount; // Discount (nếu có)
//     final double newPrice = product.defaultPrice * (1 - (discount / 100)); // Tính giá mới sau giảm
//
//     return InkWell(
//       onTap: () {
//         Get.toNamed('/product-detail', arguments: product.id);
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.07),
//               spreadRadius: 1,
//               blurRadius: 3,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             //Hình ảnh sản phẩm + Giảm giá
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.network(
//                     getFullImageUrl(product.image),
//                     width: 100,
//                     height: 95,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) => Container(
//                       width: 75,
//                       height: 75,
//                       color: Colors.grey.shade300,
//                       child: const Icon(Icons.image, color: Colors.white, size: 30),
//                     ),
//                   ),
//                 ),
//                 if (discount > 0)
//                   Positioned(
//                     top: 2,
//                     left: 2,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
//                       decoration: BoxDecoration(
//                         color: Colors.red,
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(6),
//                           bottomRight: Radius.circular(6),
//                         ),
//                       ),
//                       child: Text(
//                         '-${discount.toStringAsFixed(0)}%',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 8,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(width: 25),
//
//             // ✅ Thông tin sản phẩm + Giá
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product.name,
//                     style: const TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 2),
//
//                   Row(
//                     children: [
//                       Text(
//                         product.shop,
//                         style: const TextStyle(
//                           fontSize: 9,
//                           color: Color.fromRGBO(212, 163, 115, 1),
//                         ),
//                       ),
//                       const SizedBox(width: 3),
//                       const Icon(
//                         Icons.verified,
//                         size: 12,
//                         color: Colors.blue,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 2),
//
//                   if (product.rate != null)
//                     Row(
//                       children: [
//                         const Icon(Icons.star, color: Colors.orange, size: 11),
//                         const SizedBox(width: 2),
//                         Text(
//                           product.rate.toStringAsFixed(1),
//                           style: const TextStyle(fontSize: 9),
//                         ),
//                       ],
//                     ),
//
//                   Row(
//                     children: [
//                       if (discount > 0)
//                         Text(
//                           "${product.defaultPrice.toStringAsFixed(0)}đ",
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.normal,
//                             color: Colors.grey,
//                             decoration: TextDecoration.lineThrough,
//                           ),
//                         ),
//                       const SizedBox(width: 4),
//                       Text(
//                         formatPrice(newPrice), // Giá mới đã giảm, hiển thị với dấu chấm
//                         style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.redAccent,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final list = controller.currentList;
//       if (list.isEmpty) {
//         return const Center(child: CircularProgressIndicator());
//       }
//       return AnimatedSwitcher(
//         duration: const Duration(milliseconds: 250),
//         transitionBuilder: (child, animation) => FadeTransition(
//           opacity: animation,
//           child: child,
//         ),
//         key: ValueKey<int>(controller.selectedFoodTab.value),
//         child: ListView.builder(
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: list.length,
//           itemBuilder: (context, index) {
//             final product = list[index];
//             return _buildProductCard(product);
//           },
//         ),
//       );
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/product.dart';
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
    final formatter =
    NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);
    return formatter.format(price) + "đ";
  }

  Widget _buildProductCard(Product product) {
    final double discount = product.discount;
    final double newPrice =
        product.defaultPrice * (1 - (discount / 100));

    return InkWell(
      onTap: () {
        Get.toNamed('/product-detail', arguments: product.id);
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              spreadRadius: 0.5,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh sản phẩm + Giảm giá
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    getFullImageUrl(product.image),
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 100,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image,
                          color: Colors.white, size: 30),
                    ),
                  ),
                ),
                if (discount > 0)
                  Positioned(
                    top: 2,
                    left: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        '-${discount.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            // Thông tin sản phẩm
            Text(
              product.name,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.normal),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(
                  product.shop,
                  style: const TextStyle(
                    fontSize: 8,
                    color: Color.fromRGBO(212, 163, 115, 1),
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.verified,
                  size: 10,
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 2),
            if (product.rate != null)
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 10),
                  const SizedBox(width: 2),
                  Text(
                    product.rate.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 8),
                  ),
                ],
              ),
            const SizedBox(height: 2),
            Row(
              children: [
                if (discount > 0)
                  Text(
                    "${product.defaultPrice.toStringAsFixed(0)}đ",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                const SizedBox(width: 2),
                Text(
                  formatPrice(newPrice),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ],
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
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.6, // Giảm tỷ lệ để card có chiều cao lớn hơn
          ),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final product = list[index];
            return _buildProductCard(product);
          },
        ),
      );
    });
  }
}




