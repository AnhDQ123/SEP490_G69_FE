import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../models/order.dart';
import '../../../../service/order_service.dart';
import '../../controllers/shop_order_controller.dart';
import '../../../my_order/views/order_list_widget.dart';

class ShopPreparingOrderWidget extends StatelessWidget {
  final List<Order> orders;
  final Color Function(String) getStatusColor;

  const ShopPreparingOrderWidget({
    Key? key,
    required this.orders,
    required this.getStatusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrderListWidget(
      orders: orders,
      status: "Đang chuẩn bị",
      getStatusColor: getStatusColor,
      isShopView: true, // ✅ THÊM VÀO ĐÂY
      actionWidgetBuilder: (order, total) {
        return ElevatedButton.icon(
          icon: const Icon(Icons.local_shipping_outlined, size: 18),
          label: const Text("Đã chuẩn bị xong", style: TextStyle(fontSize: 12)),
          onPressed: () async {
            final image = await ImagePicker().pickImage(source: ImageSource.gallery);
            if (image == null) return;

            try {
              await OrderService().changeOrderStatus(
                id: order.id,
                status: "SHIPPING",
                userId: order.shopId,
                avatarFile: File(image.path),
              );
              Get.snackbar("🚚 Gửi hàng", "Đơn đã chuyển sang 'Đang giao'");
              Get.find<ShopOrderController>().fetchAll();
            } catch (e) {
              Get.snackbar("❌ Lỗi", "Không thể cập nhật trạng thái đơn");
            }
          },
        );
      },
    );
  }
}
