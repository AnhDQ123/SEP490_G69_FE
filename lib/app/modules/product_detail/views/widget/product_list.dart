// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../models/product.dart';
// import '../../controllers/product_detail_controller.dart';
// import 'package:intl/intl.dart';
//
// class ProductListWidget extends StatelessWidget {
//   final RxList<Product> products;
//   const ProductListWidget({Key? key, required this.products}) : super(key: key);
//
//   String formatPrice(double price) {
//     // Tạo định dạng không có ký hiệu tiền tệ (symbol: '') và không có số thập phân (decimalDigits: 0)
//     final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);
//     return formatter.format(price) + "đ";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<ProductDetailController>();
//
//     return Obx(() {
//       return ListView.separated(
//         padding: const EdgeInsets.all(10),
//         itemCount: products.length,
//         separatorBuilder: (context, index) => const SizedBox(height: 8),
//         itemBuilder: (context, index) {
//           final item = products[index];
//
//           double originalPrice = item.defaultPrice; // Sử dụng defaultPrice thay vì giá cứng
//           double discountPercentage = (item.discount ?? 0).toDouble();
//           double discountedPrice = originalPrice * (1 - (discountPercentage / 100));
//
//
//           return Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 4,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Stack(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(6),
//                       child: Image.network(
//                         item.image,
//                         width: 70,
//                         height: 70,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) => Container(
//                           width: 70,
//                           height: 70,
//                           color: Colors.grey[300],
//                           child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 20),
//                         ),
//                       ),
//                     ),
//                     if (discountPercentage > 0)
//                       Positioned(
//                         top: 3,
//                         left: 3,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//                           decoration: BoxDecoration(
//                             color: Colors.red,
//                             borderRadius: BorderRadius.circular(3),
//                           ),
//                           child: Text(
//                             '-${discountPercentage.toStringAsFixed(0)}%',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 8,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         item.name,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: 13,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                       ),
//                       const SizedBox(height: 3),
//                       Row(
//                         children: [
//                           ...List.generate(5, (starIndex) {
//                             if (item.rate >= starIndex + 1) {
//                               return const Icon(Icons.star, color: Colors.amber, size: 12);
//                             } else if (item.rate > starIndex && item.rate < starIndex + 1) {
//                               return const Icon(Icons.star_half, color: Colors.amber, size: 12);
//                             } else {
//                               return const Icon(Icons.star_border, color: Colors.amber, size: 12);
//                             }
//                           }),
//                           const SizedBox(width: 3),
//                           Text(
//                             '${item.rate.toStringAsFixed(1)}',
//                             style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 3),
//                       Row(
//                         children: [
//                           if (discountPercentage > 0)
//                             Text(
//                               "${originalPrice.toStringAsFixed(0)}đ",
//                               style: const TextStyle(
//                                 fontSize: 11,
//                                 color: Colors.grey,
//                                 decoration: TextDecoration.lineThrough,
//                               ),
//                             ),
//                           const SizedBox(width: 4),
//                           Text(
//                             "${discountedPrice.toStringAsFixed(0)}đ",
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.redAccent,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(4),
//                               border: Border.all(color: Colors.grey.shade300),
//                             ),
//                             child: Text(
//                               'Số lượng: ${item.quantity}',
//                               style: const TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 6),
//                           ElevatedButton(
//                             onPressed: () => controller.addProductToCart(item),
//                             style: ElevatedButton.styleFrom(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//                               backgroundColor: const Color.fromRGBO(212, 163, 115, 1),
//                               elevation: 1,
//                               minimumSize: const Size(28, 28),
//                             ),
//                             child: const Icon(
//                               Icons.add_shopping_cart,
//                               size: 14,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/product.dart';
import '../../controllers/product_detail_controller.dart';
import 'package:intl/intl.dart';

class ProductListWidget extends StatelessWidget {
  final RxList<Product> products;
  const ProductListWidget({Key? key, required this.products}) : super(key: key);

  String formatPrice(double price) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);
    return formatter.format(price) + "đ";
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailController>();

    return Obx(() {
      return ListView.separated(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = products[index];
          double originalPrice = item.defaultPrice;
          double discountPercentage = (item.discount ?? 0).toDouble();
          double discountedPrice = originalPrice * (1 - (discountPercentage / 100));

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
            child: Row(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        item.image,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 70,
                          height: 70,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 20),
                        ),
                      ),
                    ),
                    if (discountPercentage > 0)
                      Positioned(
                        top: 3,
                        left: 3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            '-${discountPercentage.toStringAsFixed(0)}%',
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
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          ...List.generate(5, (starIndex) {
                            if (item.rate >= starIndex + 1) {
                              return const Icon(Icons.star, color: Colors.amber, size: 12);
                            } else if (item.rate > starIndex && item.rate < starIndex + 1) {
                              return const Icon(Icons.star_half, color: Colors.amber, size: 12);
                            } else {
                              return const Icon(Icons.star_border, color: Colors.amber, size: 12);
                            }
                          }),
                          const SizedBox(width: 3),
                          Text(
                            '${item.rate.toStringAsFixed(1)}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          if (discountPercentage > 0)
                            Text(
                              "${originalPrice.toStringAsFixed(0)}đ",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          const SizedBox(width: 4),
                          Text(
                            "${discountedPrice.toStringAsFixed(0)}đ",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(
                              'Số lượng: ${item.quantity}',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(width: 6),
                          ElevatedButton(
                            onPressed: () => controller.addProductToCart(item),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              backgroundColor: const Color.fromRGBO(212, 163, 115, 1),
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
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
