import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../models/order.dart';
import '../../../../service/order_service.dart';
import '../../controllers/my_order_controller.dart';
import '../order_list_widget.dart';
import 'package:ffb_fe_flutter/app/modules/my_order/views/status_widget/return_reason.dart';

class DeliveredOrderWidget extends StatefulWidget {
  final List<Order> orders;
  final Color Function(String) getStatusColor;

  const DeliveredOrderWidget({
    Key? key,
    required this.orders,
    required this.getStatusColor,
  }) : super(key: key);

  @override
  State<DeliveredOrderWidget> createState() => _DeliveredOrderWidgetState();
}

class _DeliveredOrderWidgetState extends State<DeliveredOrderWidget> {
  final Map<int, Map<String, dynamic>> returnDetails = {}; // { orderId: { reason, image } }

  @override
  Widget build(BuildContext context) {
    return OrderListWidget(
      orders: widget.orders,
      status: "Đã giao",
      getStatusColor: widget.getStatusColor,
      actionWidgetBuilder: (order, total) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    // Hiển thị bottom sheet chọn lý do
                    final reason = await showModalBottomSheet<String>(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (_) => ReturnReasonSheet(),
                    );

                    if (reason == null || reason.isEmpty) return;

                    // Chọn ảnh
                    final picker = ImagePicker();
                    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

                    if (pickedFile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng chọn ảnh minh chứng')),
                      );
                      return;
                    }

                    final file = File(pickedFile.path);

                    // Gọi API
                    try {
                      final orderService = OrderService();
                      await orderService.returnOrder(
                        orderId: order.id,
                        userId: order.ownerId,
                        reason: reason,
                        avatarFile: file,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('🎉 Đã gửi yêu cầu trả hàng thành công')),
                      );

                      setState(() {
                        returnDetails[order.id] = {
                          'reason': reason,
                          'image': file,
                        };
                      });

                      Get.find<MyOrderController>().loadOrders();



                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('❌ Lỗi gửi yêu cầu trả hàng: $e')),
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
                    "Trả hàng",
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.redAccent),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    // TODO: Đánh giá đơn hàng
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey, width: 1.5),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "Đánh giá",
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                ),
              ],
            ),

            if (returnDetails.containsKey(order.id)) ...[
              const SizedBox(height: 8),
              Text(
                "📝 Lý do trả hàng: ${returnDetails[order.id]!['reason']}",
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  returnDetails[order.id]!['image'],
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover, // hoặc BoxFit.contain nếu muốn giữ tỉ lệ
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
