import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/order.dart';
import '../../../routes/app_pages.dart';
import '../controllers/shipper_order_list_controller.dart';

class ShipperOrderListView extends GetView<ShipperOrderListController> {
  const ShipperOrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách đơn hàng',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Obx(() => _buildOrderStatus()),
            const SizedBox(height: 16),
            Obx(() {
              final filteredOrders = controller.filteredOrders;
              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () => controller.refreshOrders(),
                  child: ListView.builder(
                    itemCount: controller.filteredOrders.length,
                    itemBuilder: (context, index) =>
                        _buildOrderCard(controller.filteredOrders[index]),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatus() {
    final pendingCount =
        controller.orders.where((o) => o.status == 'SHIP_PENDING').length;
    final shippingCount =
        controller.orders.where((o) => o.status == 'SHIPPING').length;
    final deliveredCount =
        controller.orders.where((o) => o.status == 'DELIVERED').length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _statusBox("Đơn chờ xác nhận", "SHIP_PENDING", pendingCount),
        _statusBox("Đơn đang giao", "SHIPPING", shippingCount),
        _statusBox("Đơn đã giao", "DELIVERED", deliveredCount),
      ],
    );
  }

  Widget _statusBox(String label, String status, int count) {
    return Obx(() {
      final isSelected = controller.selectedStatus.value == status;
      return GestureDetector(
        onTap: () => controller.setStatus(status),
        child: Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? Color.fromRGBO(212, 163, 115, 1) : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildOrderCard(Order order) {
    final formattedTotal =
        NumberFormat.currency(locale: 'vi_VN', symbol: '').format(order.total);

    // Các biến style chung
    const textStyleDefault = TextStyle(fontSize: 16);
    const textStyleBold = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    const textStyleSmall = TextStyle(fontSize: 15);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 👇 Phần clickable
          GestureDetector(
            onTap: () async {
              final result = await Get.toNamed(
                Routes.SHIPPER_ORDER_DETAIL,
                arguments: {
                  'orderId': order.id,
                  'orders': controller.orders,
                },
              );
              // ✅ Nếu result là 1 đơn đã cập nhật
              if (result is Order) {
                controller
                    .updateOrderInList(result); // cập nhật đơn trong danh sách
                Get.snackbar(
                  "✅ Thành công",
                  "Đơn hàng #${result.id} đã được xác nhận.",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.green.shade50,
                  colorText: Colors.green.shade800,
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  duration: const Duration(seconds: 2),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Mã đơn: #${order.id}", style: textStyleBold),
                const SizedBox(height: 6),
                _textWithIcon(Icons.store, "Địa chỉ quán: ${order.shopAddress}",
                    style: textStyleDefault),
                _textWithIcon(Icons.location_on,
                    "Địa chỉ người nhận: ${order.address ?? 'Không rõ'}",
                    style: textStyleDefault),
                _textWithIcon(Icons.phone, "SĐT: ${order.phone}",
                    style: textStyleDefault),
                const SizedBox(height: 6),
                Text("Sản phẩm:", style: textStyleBold),
                ...order.orderItem.map((item) {
                  final sizes = item.orderItemOptions
                      .where((o) => o.typeId == 2)
                      .map((o) => "x${o.quantity} ${o.optionName}")
                      .join(', ');
                  final extras = item.orderItemOptions
                      .where((o) => o.typeId == 1)
                      .map((o) => "x${o.quantity} ${o.optionName}")
                      .join(', ');
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            "${item.productName}${sizes.isNotEmpty ? " - $sizes" : ""}"
                            "${extras.isNotEmpty ? "\n    -  $extras" : ""}",
                            style: textStyleSmall,
                            softWrap: false,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 6),
                Text("Tổng tiền: $formattedTotalđ", style: textStyleBold),
              ],
            ),
          ),
          if (order.status == 'SHIPPING')
            buildOrderImagePicker(
              orderId: order.id,
              deliveryImages: controller.deliveryImages,
              onPickImage: controller.pickDeliveryImage,
              onRemoveImage: controller.removeDeliveryImage,
            ),
          const Divider(height: 20),
          _buildActionButtonsByStatus(order), // 📦 Nút theo trạng thái
        ],
      ),
    );
  }

  Widget buildOrderImagePicker({
    required int orderId,
    required RxMap<int, Rxn<File>> deliveryImages,
    required void Function(int orderId) onPickImage,
    required void Function(int orderId) onRemoveImage,
  }) {
    return Obx(() {
      final Rxn<File>? imageRx = deliveryImages[orderId];
      final File? image = imageRx?.value;
      return GestureDetector(
        onTap: () => onPickImage(orderId),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Ảnh khi giao sản phẩm",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[100],
                  ),
                  child: image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(image,
                              width: 150, height: 150, fit: BoxFit.cover),
                        )
                      : const Icon(Icons.camera_alt,
                          size: 40, color: Colors.grey),
                ),
                if (image != null)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => onRemoveImage(orderId),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.close,
                            size: 16, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _textWithIcon(IconData icon, String text, {TextStyle? style}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 6),
        Expanded(child: Text(text, style: style)),
      ],
    );
  }

  Widget _actionButton(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildActionButtonsByStatus(Order order) {
    final status = order.status;
    if (status == 'SHIP_PENDING') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _actionButton(Icons.call, "Gọi", onTap: () {
            controller.callPhoneNumber(order.phone);
          }),
          _actionButton(Icons.close, "Từ chối", onTap: () {
            Get.snackbar("Từ chối", "Bạn đã từ chối đơn hàng.");
          }),
          _actionButton(Icons.check, "Xác nhận", onTap: () {

            controller.handleAcceptOrder(order);
          }),
        ],
      );
    } else if (status == 'SHIPPING') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _actionButton(Icons.call, "Gọi", onTap: () {
            controller.callPhoneNumber(order.phone);
          }),
          _actionButton(Icons.chat, "Nhắn tin", onTap: () {
            Get.snackbar("Chat", "Tính năng đang phát triển.");
          }),
          _actionButton(Icons.check, "Đã giao", onTap: () async {
            final imageRx = controller.deliveryImages[order.id];
            final file = imageRx?.value;

            if (file == null) {
              Get.snackbar(
                  "Thiếu ảnh", "Vui lòng chụp ảnh trước khi xác nhận.");
              return;
            }
            await controller.handleConfirmDelivered(
              order: order,
              imageFile: file,
            );
          }),
        ],
      );
    } else {
      return const SizedBox(); // Không hiển thị nếu trạng thái khác
    }
  }
}
