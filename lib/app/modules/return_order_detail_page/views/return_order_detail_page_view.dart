import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/return_order_detail_page_controller.dart';

class ReturnOrderDetailPageView extends GetView<ReturnOrderDetailController> {
  const ReturnOrderDetailPageView({super.key});

  String formatPrice(double price) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return formatter.format(price);
  }

  String getOwnerRole(int ownerId, ReturnOrderDetailController controller) {
    if (ownerId == controller.returnOrder.value?.order.ownerId) return "👤 Người mua";
    if (ownerId == controller.returnOrder.value?.order.shipperId) return "🚚 Shipper";
    if (ownerId == controller.returnOrder.value?.order.shopId) return "🏪 Cửa hàng";
    return "❓ Không xác định";
  }

  @override
  Widget build(BuildContext context) {
    controller.fetchDetail();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết trả hàng'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final returnOrder = controller.returnOrder.value;
        if (returnOrder == null) {
          return const Center(child: Text("Không tìm thấy thông tin trả hàng"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🧾 Tổng quan đơn hàng
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Đơn hàng #${returnOrder.order.id}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("🪙 Tổng tiền: ${formatPrice(returnOrder.order.total)}"),
                      const SizedBox(height: 4),
                      Text("📝 Lý do trả hàng: ${returnOrder.order.reason ?? 'Không có'}"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Text("🍱 Chi tiết món ăn", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),

              ...returnOrder.order.orderItem.map((item) {
                final optionGroup = item.orderItemOptions.where((opt) => opt.typeId == 1).toList();
                final sizeGroup = item.orderItemOptions.where((opt) => opt.typeId == 2).toList();
                final optionTotal = optionGroup.fold<double>(0, (sum, e) => sum + e.price * e.quantity);
                final basePrice = item.price + optionTotal;
                final finalPrice = item.total;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.image,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.productName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              if (optionGroup.isNotEmpty)
                                Text("➕ Option: ${optionGroup.map((e) => "${e.optionName} x${e.quantity}").join(', ')}", style: const TextStyle(fontSize: 10)),
                              if (sizeGroup.isNotEmpty)
                                Text("📏 Size: ${sizeGroup.map((e) => "${e.optionName}").join(', ')}", style: const TextStyle(fontSize: 10)),
                              Text("🔢 Số lượng: ${item.quantity}", style: const TextStyle(fontSize: 10)),
                              const SizedBox(height: 4),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 16),
              const Text("🖼️ Ảnh minh chứng", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              ...returnOrder.images.map((img) {
                final role = getOwnerRole(img.ownerId, controller);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            img.url,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(role, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 4),
                              Text("Image ID: #${img.id}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                              Text("User ID: ${img.ownerId}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.cancel),
                    label: const Text("Từ chối"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                    onPressed: () async {
                      final confirm = await Get.dialog<bool>(
                        AlertDialog(
                          title: const Text("Xác nhận"),
                          content: const Text("Bạn chắc chắn muốn từ chối trả hàng?"),
                          actions: [
                            TextButton(onPressed: () => Get.back(result: false), child: const Text("Hủy")),
                            TextButton(onPressed: () => Get.back(result: true), child: const Text("Xác nhận")),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        try {
                          // Trong nút từ chối
                          await controller.rejectReturn();
                          Get.back(result: true); // ✅ Trả kết quả về màn trước
                          Get.snackbar("❌ Đã từ chối", "Yêu cầu trả hàng bị từ chối");
                        } catch (e) {
                          Get.snackbar("Lỗi", "Không thể từ chối trả hàng");
                        }
                      }
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle),
                    label: const Text("Đồng ý"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async {
                      final confirm = await Get.dialog<bool>(
                        AlertDialog(
                          title: const Text("Xác nhận"),
                          content: const Text("Xác nhận đồng ý trả hàng và tạo mã QR?"),
                          actions: [
                            TextButton(onPressed: () => Get.back(result: false), child: const Text("Hủy")),
                            TextButton(onPressed: () => Get.back(result: true), child: const Text("Xác nhận")),
                          ],
                        ),
                      );

                      // if (confirm == true) {
                      //   final order = controller.returnOrder.value?.order;
                      //   if (order == null) return;
                      //
                      //   final result = await Get.toNamed('/return-qr', arguments: {
                      //     'orderId': order.id,
                      //     'userId': order.ownerId, // hoặc sử dụng user hiện tại nếu khác
                      //   });
                      //
                      //   if (result == true) {
                      //     try {
                      //       await controller.acceptReturn();
                      //       Get.back(result: true); // Quay lại màn trước
                      //       Get.snackbar("✅ Đã đồng ý", "Đơn trả hàng đã được chấp nhận");
                      //     } catch (e) {
                      //       Get.snackbar("Lỗi", "Không thể chấp nhận trả hàng");
                      //     }
                      //   }
                      // }
                      if (confirm == true) {
                        try {
                          await controller.acceptReturn(); // Chấp nhận ngay tại đây
                          Get.back(result: true); // Quay về màn pending để gọi fetchAll()
                          Get.snackbar("✅ Đã đồng ý", "Đơn trả hàng đã chuyển sang 'Đã trả'");
                        } catch (e) {
                          Get.snackbar("Lỗi", "Không thể chấp nhận trả hàng");
                        }
                      }
                    },

                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
