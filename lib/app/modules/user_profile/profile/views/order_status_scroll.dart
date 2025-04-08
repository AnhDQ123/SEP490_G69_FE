import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Đảm bảo bạn có get package để điều hướng
import '../../../../base/base_common.dart';  // Đảm bảo import BaseCommon

class OrderStatusScroll extends StatelessWidget {
  // Cập nhật danh sách trạng thái theo enum OrderStatus với tên tiếng Việt
  final List<Map<String, dynamic>> statuses = [
    {"icon": Icons.access_time, "label": "Chờ xác nhận"},        // PENDING
    {"icon": Icons.local_shipping, "label": "Đang chuẩn bị"},    // PROCESSING
    {"icon": Icons.delivery_dining, "label": "Chờ vận chuyển"},  // SHIP_PENDING
    {"icon": Icons.directions_car, "label": "Đang giao"},         // SHIPPING
    {"icon": Icons.done, "label": "Đã giao"},                     // DELIVERED
    {"icon": Icons.cancel, "label": "Đã huỷ"},                    // CANCELLED
    {"icon": Icons.replay, "label": "Đã trả hàng"},               // RETURNED
    {"icon": Icons.cancel, "label": "Đơn hàng bị từ chối"},       // REJECTED
    {"icon": Icons.refresh, "label": "Chờ trả hàng"},            // RETURN_PENDING
    {"icon": Icons.cancel, "label": "Trả hàng bị từ chối"},      // RETURN_REJECTED
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      color: Colors.grey.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề "Đơn hàng của bạn" và "Xem thêm" trên cùng một hàng
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Để "Xem thêm" nằm ở bên phải
              children: [
                Text(
                  "Đơn mua",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // Thêm TextButton cho "Xem thêm"
                TextButton(
                  onPressed: () {
                    // Lấy userId từ BaseCommon.instance
                    final userIdStr = BaseCommon.instance.userId;
                    if (userIdStr != null) {
                      final userId = int.tryParse(userIdStr);
                      if (userId != null) {
                        Get.toNamed('/my-order', arguments: userId);
                      }
                    }
                  },
                  child: Text(
                    "Xem lịch sử mua hàng",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Phần scroll trạng thái
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: statuses.map((status) {
                return Container(
                  width: 110,
                  height: 100,
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(status["icon"], color: Colors.black54, size: 28),
                      SizedBox(height: 5),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return SizedBox(
                            height: 40,
                            child: IntrinsicWidth(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      status["label"],  // Hiển thị trạng thái bằng tiếng Việt
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
