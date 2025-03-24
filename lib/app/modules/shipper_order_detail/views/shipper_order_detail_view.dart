import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/order.dart';
import '../../../models/order_item_option.dart';
import '../controllers/shipper_order_detail_controller.dart';

class ShipperOrderDetailView extends GetView<ShipperOrderDetailController> {
  ShipperOrderDetailView({super.key});

  final currency = NumberFormat.currency(locale: 'vi_VN', symbol: '');

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final order = controller.order.value;
      if (order == null) {
        return Scaffold(
          appBar: AppBar(title: const Text("Chi tiết đơn")),
          body: const Center(child: Text("Không tìm thấy đơn hàng")),
        );
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text("Chi tiết đơn hàng"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderCard(order),
              const SizedBox(height: 24),
              if (order.status == 'SHIP_PENDING') _buildActionButtons()
            ],
          ),
        ),
      );
    });
  }

  Widget _buildOrderCard(Order order) {
    // ✅ Tính tổng gốc: item.price + topping options (typeId == 1)
    final double originalTotal = order.orderItem.fold(0, (sum, item) {
      final options = List<OrderItemOption>.from(item.orderItemOptions);
      final extraOptions = options.where((o) => o.typeId == 1).toList();

      final extraTotal = extraOptions.fold<double>(
        0,
        (optSum, o) => optSum + (o.price * o.quantity),
      );

      return sum + ((item.price + extraTotal) * item.quantity);
    });

    final discountRate = order.voucherAmount ?? 0;
    final discountAmount = originalTotal * discountRate;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mã đơn: #${order.id}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            const SizedBox(height: 6),
            Text("👤 Người nhận: ${order.ownerName}",
                style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 6),
            Text("📞 SĐT: ${order.phone}",
                style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 6),
            Text("🏠 Địa chỉ người nhận: ${order.address}",
                style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 6),
            Text("🏪 Địa chỉ quán: ${order.shopAddress}",
                style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 12),
            const Text("🧾 Sản phẩm:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            ...order.orderItem.map(_buildOrderItem),
            const Divider(),
            Text("💵 Tổng giá gốc: ${currency.format(originalTotal)}đ",
                style: const TextStyle(fontSize: 15)),
            Text(
                "🔻 Giảm giá: ${discountRate * 100}% (-${currency.format(discountAmount)}đ)",
                style: const TextStyle(fontSize: 15)),
            Text(
              "💰 Tổng tiền thanh toán: ${currency.format(order.total)}đ",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text("🚚 Trạng thái đơn hàng: ${_translateStatus(order.status)}",
                style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(orderItem) {
    final List<OrderItemOption> options =
        List<OrderItemOption>.from(orderItem.orderItemOptions);
    final sizeOption = options.firstWhereOrNull((o) => o.typeId == 2);
    final extraOptions = options.where((o) => o.typeId == 1).toList();
    final sizeText =
        sizeOption != null ? " (Size: ${sizeOption.optionName})" : "";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "x${orderItem.quantity} ${orderItem.productName}$sizeText - ${currency.format(orderItem.price)}đ",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          ...extraOptions.map((opt) => Padding(
                padding: const EdgeInsets.only(left: 12, top: 2),
                child: Text(
                    "- Thêm: ${opt.optionName} x${opt.quantity} (${currency.format(opt.price)}đ)"),
              )),
        ],
      ),
    );
  }

  String _translateStatus(String? status) {
    switch (status) {
      case 'SHIP_PENDING':
        return 'Chờ xác nhận';
      case 'SHIPPING':
        return 'Đang vận chuyển';
      case 'DELIVERED':
        return 'Hoàn thành';
      default:
        return 'Không xác định';
    }
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Gọi API từ chối
            Get.snackbar("Từ chối", "Bạn đã từ chối đơn");
          },
          icon: const Icon(Icons.close),
          label: const Text("Từ chối"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            const int shipperId = 3;
            await controller.acceptOrder(shipperId);
            Get.back(result: true); // ✅ báo cho màn trước biết là cần cập nhật
          },
          icon: const Icon(Icons.check),
          label: const Text("Xác nhận"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
      ],
    );
  }
}
