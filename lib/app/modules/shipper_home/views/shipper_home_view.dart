import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/shipper_home_controller.dart';
import 'package:intl/intl.dart';

class ShipperHomeView extends GetView<ShipperHomeController> {
  const ShipperHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vận chuyển', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: const [Padding(padding: EdgeInsets.only(right: 16), child: Icon(Icons.notifications_none))],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
            const SizedBox(height: 16),
            _buildBusyToggle(),
            const SizedBox(height: 16),
            buildEarningsSummary(controller),
            const SizedBox(height: 16),
            Obx(() => _buildOrderSummary(context, controller),),
            const SizedBox(height: 16),
            _buildOrderTableHeader(),
            const SizedBox(height: 8),
            _buildOrderTable(context),
          ],
        ),
      )),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 24, child: Icon(Icons.person)),
          const SizedBox(width: 12),
          Text('Xin chào, ${controller.userName}', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildBusyToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Đang bận", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        Obx(() => Switch(
          value: controller.isBusy.value,
          onChanged: (value) => controller.toggleBusy(value),
        )),
      ],
    );
  }

  Widget _buildOrderSummary(BuildContext context, ShipperHomeController controller) {
    final ship_pending = controller.orders.where((o) => o.status == 'SHIP_PENDING').length;
    final delivering = controller.orders.where((o) => o.status == 'SHIPPING').length;
    final completed = controller.orders.where((o) => o.status == 'DELIVERED').length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSummaryItem(
          context,
          ship_pending.toString(),
          "Đơn chờ xác nhận",
              () => Get.offNamed(
                Routes.SHIPPER_ORDER_LIST,
                arguments: {
                  'orders': controller.orders,
                  'status': 'SHIP_PENDING', // hoặc lấy từ state đang chọn
                },
              ),
        ),
        _buildSummaryItem(
          context,
          delivering.toString(),
          "Đơn đang giao",
              () => Get.offNamed(
                Routes.SHIPPER_ORDER_LIST,
                arguments: {
                  'orders': controller.orders,
                  'status': 'SHIPPING', // hoặc lấy từ state đang chọn
                },
              ),
        ),
        _buildSummaryItem(
          context,
          completed.toString(),
          "Đơn đã giao",
              () => Get.offNamed(
                Routes.SHIPPER_ORDER_LIST,
                arguments: {
                  'orders': controller.orders,
                  'status': 'DELIVERED', // hoặc lấy từ state đang chọn
                },
              ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(BuildContext context, String count, String label, VoidCallback onTap) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = (screenWidth - 48) / 3;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: itemWidth,
        height: 100,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTableHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Đơn hàng của bạn", style: TextStyle(fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () async {
            await Get.toNamed(
              Routes.SHIPPER_ORDER_LIST,
              arguments: {
                'orders': controller.orders,
                'status': 'SHIP_PENDING',
              },
            );

            // ⏬ Cập nhật lại danh sách đơn sau khi quay về
            await controller.fetchOrders();
          },
          child: const Text("Xem thêm >", style: TextStyle(color: Colors.blueAccent)),
        ),
      ],
    );
  }

  Widget _buildOrderTable(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      child: DataTable(
        columnSpacing: 12, // 👈 Giảm khoảng cách giữa các cột
        columns: const [
          DataColumn(label: Expanded(child: Text("Mã đơn", style: TextStyle(fontWeight: FontWeight.bold)))),
          DataColumn(label: Expanded(child: Text("Tình trạng", style: TextStyle(fontWeight: FontWeight.bold)))),
          DataColumn(label: Expanded(child: Text("Ngày giao", style: TextStyle(fontWeight: FontWeight.bold)))),
          DataColumn(label: Expanded(child: Text("Tổng tiền", style: TextStyle(fontWeight: FontWeight.bold)))),
        ],
        rows: controller.orders.take(5).map((order) {
          final formattedDate = order.createdAt != null
              ? DateFormat('dd/MM/yyyy').format(order.createdAt!)
              : '';
          final formattedTotal = NumberFormat.currency(locale: 'vi_VN', symbol: '').format(order.total);

          return DataRow(cells: [
            DataCell(Text("#${order.id}")),
            DataCell(_buildStatusLabel(order.status)),
            DataCell(Text(formattedDate)),
            DataCell(Text("$formattedTotal đ")),
          ]);
        }).toList(),
      ),
    );
  }


  Widget buildEarningsSummary(ShipperHomeController controller) {
    return Obx(() => Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Doanh thu:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            "${controller.totalEarnings.value}đ",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[800]),
          ),
        ],
      ),
    ));
  }

  Widget _buildStatusLabel(String status) {
    Color color;
    String label;

    switch (status) {
      case 'SHIP_PENDING':
        color = Colors.orange;
        label = 'Chờ xác nhận';
        break;
      case 'SHIPPING':
        color = Colors.blue;
        label = 'Đang giao';
        break;
      case 'DELIVERED':
        color = Colors.green;
        label = 'Đã giao';
        break;
      default:
        color = Colors.grey;
        label = 'Không rõ';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12)),
    );
  }



}

