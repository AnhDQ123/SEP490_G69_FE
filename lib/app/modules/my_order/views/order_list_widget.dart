import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../models/order.dart';
import '../../recommended_products/controllers/recommended_products_controller.dart';
import '../../recommended_products/views/recommend_with_products.dart'; // thêm import widget RecommendWithProducts

typedef ActionWidgetBuilder = Widget Function(Order order, double total);

class OrderListWidget extends StatelessWidget {
  final List<Order> orders;
  final String status;
  final Color Function(String) getStatusColor;
  final ActionWidgetBuilder? actionWidgetBuilder;

  const OrderListWidget({
    Key? key,
    required this.orders,
    required this.status,
    required this.getStatusColor,
    this.actionWidgetBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      // Nếu không có đơn hàng, có thể hiện thông báo (và có thể thêm cả recommend_section nếu muốn)
      return Center(
        child: Text(
          "Không có đơn hàng $status",
          style: const TextStyle(fontSize: 10),
        ),
      );
    }

    return ListView.builder(
      itemCount: orders.length + 1, // thêm 1 cho phần recommend
      itemBuilder: (context, index) {
        if (index < orders.length) {
          final order = orders[index];

          // Tính tổng tiền của đơn hàng:
          double itemsTotal = 0;
          for (var item in order.items) {
            final double discountAmount = item.price * (item.discount / 100);
            final double priceAfterDiscount = item.price - discountAmount;
            itemsTotal += priceAfterDiscount * item.quantity;
          }
          final double total = itemsTotal - (order.voucher?.value ?? 0);

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thông tin cửa hàng và trạng thái
                  Row(
                    children: [
                      const Icon(Icons.store, size: 12),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          order.shopName,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: getStatusColor(status),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Danh sách món trong đơn
                  ListView.builder(
                    itemCount: order.items.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, itemIndex) {
                      final item = order.items[itemIndex];
                      final double discountAmount = item.price * (item.discount / 100);
                      final double priceAfterDiscount = item.price - discountAmount;
                      final double itemTotal = priceAfterDiscount * item.quantity;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hình ảnh món ăn
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                item.imageUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error, size: 24),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Thông tin món ăn
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.dishName,
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if ((item.option?.isNotEmpty ?? false) || (item.size?.isNotEmpty ?? false))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        "${item.option != null && item.option!.isNotEmpty ? "Option: ${item.option}" : ""}"
                                            "${(item.option != null && item.option!.isNotEmpty) && (item.size != null && item.size!.isNotEmpty) ? " - " : ""}"
                                            "${item.size != null && item.size!.isNotEmpty ? "Size: ${item.size}" : ""}",
                                        style: const TextStyle(fontSize: 8, color: Colors.grey),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  // Hiển thị số lượng với icon
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.confirmation_number, size: 10, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Số lượng: ${item.quantity}",
                                          style: const TextStyle(fontSize: 8, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Hiển thị giá (với giảm giá nếu có)
                                  if (item.discount > 0)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "${item.price.toStringAsFixed(0)}đ",
                                              style: const TextStyle(
                                                fontSize: 8,
                                                color: Colors.grey,
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${priceAfterDiscount.toStringAsFixed(0)}đ",
                                              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            const Icon(Icons.percent, size: 10, color: Colors.red),
                                            const SizedBox(width: 4),
                                            Text(
                                              "Giảm: ${item.discount}%",
                                              style: const TextStyle(fontSize: 8, color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  else
                                    Text(
                                      "${item.price.toStringAsFixed(0)}đ",
                                      style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w500),
                                    ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Thành tiền: ${itemTotal.toStringAsFixed(0)}đ",
                                        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w500),
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
                  ),
                  const Divider(),
                  // Thông tin voucher, tổng tiền và nút hành động
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (order.voucher != null)
                            Row(
                              children: [
                                const Icon(Icons.local_offer, size: 10, color: Colors.red),
                                const SizedBox(width: 4),
                                const Text(
                                  "Voucher:",
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  order.voucher!.name,
                                  style: const TextStyle(fontSize: 10, color: Colors.red),
                                ),
                              ],
                            ),
                          Text(
                            "Tổng tiền: ${total.toStringAsFixed(0)}đ",
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      actionWidgetBuilder != null
                          ? actionWidgetBuilder!(order, total)
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          // Trả về widget kết hợp RecommendedSection và danh sách sản phẩm khuyến nghị
          if (!Get.isRegistered<RecommendedProductsController>()) {
            Get.put(RecommendedProductsController());
          }
          return const RecommendWithProducts();
        }
      },
    );
  }
}
