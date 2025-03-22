import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../models/order.dart';
import '../../../../service/order_service.dart';
import '../../controllers/my_order_controller.dart';
import '../order_list_widget.dart';

class ShippingOrderWidget extends StatelessWidget {
  final List<Order> orders;
  final Color Function(String) getStatusColor;

  const ShippingOrderWidget({
    Key? key,
    required this.orders,
    required this.getStatusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrderListWidget(
      orders: orders,
      status: "Đang giao",
      getStatusColor: getStatusColor,
      actionWidgetBuilder: (order, total) {
        return TextButton(
          onPressed: () async {
            final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
            if (pickedFile == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vui lòng chọn ảnh xác nhận đã nhận hàng')),
              );
              return;
            }

            try {
              await OrderService().changeOrderStatus(
                id: order.id,
                status: "DELIVERED",
                userId: order.ownerId,
                avatarFile: File(pickedFile.path),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Cập nhật trạng thái thành công')),
              );

              Get.find<MyOrderController>().loadOrders();

            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('❌ Lỗi khi cập nhật trạng thái: $e')),
              );
            }
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.redAccent, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            "Đã nhận được hàng",
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.redAccent),
          ),
        );
      },
    );
  }
}
