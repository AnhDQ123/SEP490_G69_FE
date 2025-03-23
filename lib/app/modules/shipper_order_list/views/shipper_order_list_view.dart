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
        title: const Text('Danh sách đơn hàng', style: TextStyle(fontWeight: FontWeight.bold)),
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
    final pendingCount = controller.orders.where((o) => o.status == 'SHIP_PENDING').length;
    final shippingCount = controller.orders.where((o) => o.status == 'SHIPPING').length;
    final deliveredCount = controller.orders.where((o) => o.status == 'DELIVERED').length;

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
          height: 80,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 16,
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
    final formattedTotal = NumberFormat.currency(locale: 'vi_VN', symbol: '').format(order.total);

    return GestureDetector(
        onTap: () async {
          final updatedOrder = await Get.toNamed(
            Routes.SHIPPER_ORDER_DETAIL,
            arguments: {
              'orderId': order.id,
              'orders': controller.orders,
            },
          );

          // ✅ Nếu có kết quả trả về → cập nhật trong danh sách
          if (updatedOrder != null && updatedOrder is Order) {
            controller.updateOrderInList(updatedOrder);
          }
        },

        child: Container(
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
          Text("Mã đơn: #${order.id}", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          _textWithIcon(Icons.store, "Địa chỉ quán: ${order.address ?? 'Không rõ'}"),
          _textWithIcon(Icons.location_on, "Địa chỉ người nhận: [Cập nhật sau]"),
          const SizedBox(height: 6),
          Text("Sản phẩm:", style: const TextStyle(fontWeight: FontWeight.bold)),
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
              child: Text(
                " ${item.productName}"
                    "${sizes.isNotEmpty ? " - $sizes" : ""}"
                    "${extras.isNotEmpty ? "\n    -  $extras" : ""}",
              ),
            );
          }),
          const SizedBox(height: 6),
          Text("Tổng tiền: $formattedTotalđ", style: const TextStyle(fontWeight: FontWeight.bold)),
          const Divider(height: 20),
          _buildActionButtonsByStatus(order),
        ],
      ),
    ),
    );
  }

  Widget _textWithIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 6),
        Expanded(child: Text(text)),
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
          _actionButton(Icons.close, "Từ chối", onTap: () {
            // TODO: gọi API từ chối đơn nếu có
            Get.snackbar("Từ chối", "Bạn đã từ chối đơn hàng.");
          }),
          _actionButton(Icons.check, "Xác nhận", onTap: () {
            int shipperId = 3; // ⚠️ nên lấy từ auth
            controller.handleAcceptOrder(order, shipperId);
          }),
        ],
      );
    } else if (status == 'SHIPPING') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _actionButton(Icons.call, "Gọi"),
          _actionButton(Icons.chat, "Nhắn tin"),
          _actionButton(Icons.check, "Đã giao", onTap: () {
            // TODO: gọi API xác nhận đã giao hàng
            Get.snackbar("Hoàn tất", "Bạn đã giao đơn thành công.");
          }),
        ],
      );
    } else {
      return const SizedBox(); // Trạng thái khác không hiện nút
    }
  }


}
