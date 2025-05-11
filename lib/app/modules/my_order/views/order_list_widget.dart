import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../../../models/order.dart';
import '../../../models/order_item_option.dart';

typedef ActionWidgetBuilder = Widget Function(Order order, double total);

class OrderListWidget extends StatelessWidget {
  final List<Order> orders;
  final String status;
  final Color Function(String) getStatusColor;
  final ActionWidgetBuilder? actionWidgetBuilder;
  final bool isShopView; // ✅ THÊM MỚI


  const OrderListWidget({
    Key? key,
    required this.orders,
    required this.status,
    required this.getStatusColor,
    this.actionWidgetBuilder,
    this.isShopView = false, // ✅ mặc định false

  }) : super(key: key);

  // Hàm định dạng giá theo kiểu tiền Việt Nam, ví dụ: 30.000₫
  String formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  String _mapStatusToText(String status) {
    switch (status) {
      case "PENDING":
        return "Chờ xác nhận";
      case "PROCESSING":
        return "Đang chuẩn bị";
      case "SHIP_PENDING":
        return "Chờ vận chuyển";
      case "SHIPPING":
        return "Đang giao";
      case "DELIVERED":
        return "Đã giao";
      case "CANCELLED":
        return "Đã huỷ";
      case "RETURN_PENDING":
        return "Đang trả hàng";
      case "RETURNED":
        return "Đã trả hàng";
      case "REJECTED":
        return "Bị tứ chối";
      case "RETURN_REJECTED":
        return "Từ chối trả";
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          "Không có đơn hàng $status",
          style: const TextStyle(fontSize: 10),
        ),
      );
    }

    return ListView.builder(
      itemCount: isShopView ? orders.length : orders.length + 1,
      itemBuilder: (context, index) {
        if (index < orders.length) {
          final order = orders[index];
          // Lấy tổng tiền của đơn hàng từ back-end
          final double total = order.total;

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
                          isShopView ? "Đơn hàng #${order.id}" : (order.shopName ?? ''),
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
                    itemCount: order.orderItem.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, itemIndex) {
                      final item = order.orderItem[itemIndex];

                      // Tách option và size từ danh sách options
                      final List<OrderItemOption> optionGroup =
                      item.orderItemOptions.where((opt) => opt.typeId == 1).toList();
                      final List<OrderItemOption> sizeGroup =
                      item.orderItemOptions.where((opt) => opt.typeId == 2).toList();

                      // Tính tổng giá của các option (chỉ typeId = 1)
                      double optionTotal = 0;
                      for (var opt in optionGroup) {
                        optionTotal += opt.price * opt.quantity;
                      }
                      // Giá gốc của món (chưa discount) = giá món + tổng giá option (chỉ typeId = 1)
                      final double basePrice = item.price;
                      // Giá mới (đã discount) được lấy từ back-end (item.total)
                      final double finalPrice = item.total;
                      double discountedPrice = basePrice;
                      if (item.discount != null && item.discount!.isNotEmpty && item.discount!.first.amount > 0) {
                        discountedPrice = basePrice * (1 - item.discount!.first.amount);
                      }
                      final double itemSubtotal = discountedPrice + optionTotal;


                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hình ảnh món ăn
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                item.image,
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
                                    item.productName,
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  // Hiển thị option và size: mỗi nhóm một dòng riêng biệt
                                  if (item.productName.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (optionGroup.isNotEmpty)
                                            Text(
                                              "Option: " +
                                                  optionGroup.map((opt) {
                                                    if (opt.quantity >= 1) {
                                                      return "x${opt.quantity} ${opt.optionName} (${formatPrice(opt.price * opt.quantity)})";
                                                    } else {
                                                      return "${opt.optionName} (${formatPrice(opt.price)})";
                                                    }
                                                  }).join(', '),
                                              style: const TextStyle(fontSize: 8, color: Colors.grey),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          if (sizeGroup.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2.0),
                                              child: Text(
                                                "Size: " +
                                                    sizeGroup.map((opt) {
                                                      if (opt.quantity > 1) {
                                                        return "x${opt.quantity} ${opt.optionName} ";
                                                      } else {
                                                        return "${opt.optionName} ";
                                                      }
                                                    }).join(', '),
                                                style: const TextStyle(fontSize: 8, color: Colors.grey),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  // Hiển thị số lượng món
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
                                  // Hiển thị giá: nếu có discount thì hiển thị giá cũ (basePrice) và giá mới (finalPrice) cùng phần trăm discount
                                  // if (item.discount != null && item.discount!.isNotEmpty && item.discount!.first.amount > 0)
                                  //   Column(
                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                  //     children: [
                                  //       Row(
                                  //         children: [
                                  //           Text(
                                  //             "${formatPrice(basePrice)}",
                                  //             style: const TextStyle(
                                  //               fontSize: 8,
                                  //               color: Colors.grey,
                                  //               decoration: TextDecoration.lineThrough,
                                  //             ),
                                  //           ),
                                  //           const SizedBox(width: 4),
                                  //           Text(
                                  //             "${formatPrice(finalPrice)}",
                                  //             style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w500),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //       const SizedBox(height: 2),
                                  //       Row(
                                  //         children: [
                                  //           const Icon(Icons.percent, size: 10, color: Colors.red),
                                  //           const SizedBox(width: 4),
                                  //           Text(
                                  //             "Giảm: ${(item.discount!.first.amount * 100).toStringAsFixed(0)}%",
                                  //             style: const TextStyle(fontSize: 8, color: Colors.red),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ],
                                  //   )
                                  // else
                                  //   Text(
                                  //     "${formatPrice(basePrice)}",
                                  //     style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w500),
                                  //   ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Thành tiền: ${formatPrice(item.total)}", // Dùng itemSubtotal đã tính
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
                  // Hiển thị voucher và tổng tiền của đơn hàng
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (order.voucherAmount > 0)
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
                                  "-${(order.voucherAmount * 100).toStringAsFixed(0)}%",
                                  style: const TextStyle(fontSize: 10, color: Colors.red),
                                ),
                              ],
                            ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (order.voucherAmount >= 0)
                                Row(
                                  children: [
                                    const Icon(Icons.local_offer, size: 10, color: Colors.red),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Voucher giảm: -${(order.voucherAmount * 100).toInt()}%",
                                      style: const TextStyle(fontSize: 10, color: Colors.red),
                                    ),
                                  ],
                                ),
                              if ((order.shippingFee ?? 0) >= 0)
                                Row(
                                  children: [
                                    const Icon(Icons.delivery_dining, size: 10, color: Colors.green),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Phí giao hàng: ${formatPrice(order.shippingFee ?? 0)}",
                                      style: const TextStyle(fontSize: 10, color: Colors.green),
                                    ),
                                  ],
                                ),
                              Text(
                                "Tổng tiền: ${formatPrice(total)}",
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )

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
          if (isShopView) return const SizedBox(); // ❌ Không hiển thị ở shop
        }
      },
    );
  }
}
