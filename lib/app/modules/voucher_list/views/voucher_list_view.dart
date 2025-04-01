import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart'; // Đừng quên thêm vào pubspec.yaml
import '../../../models/voucher_model.dart';
import '../../add_voucher/views/add_voucher_view.dart';
import '../controllers/voucher_list_controller.dart';
import 'chart_section.dart';

class VoucherListView extends GetView<VoucherListController> {
  const VoucherListView({super.key});

  Color statusColor(VoucherStatus status) {
    switch (status) {
      case VoucherStatus.PENDING:
        return Colors.orange;
      case VoucherStatus.ACTIVE:
        return Colors.green;
      case VoucherStatus.INACTIVE:
        return Colors.grey;
      case VoucherStatus.REJECTED:
        return Colors.redAccent;
      case VoucherStatus.DELETED:
        return Colors.red;
    }
  }

  String statusLabel(VoucherStatus status) {
    switch (status) {
      case VoucherStatus.PENDING:
        return 'Chờ duyệt';
      case VoucherStatus.ACTIVE:
        return 'Hoạt động';
      case VoucherStatus.INACTIVE:
        return 'Không hoạt động';
      case VoucherStatus.REJECTED:
        return 'Bị từ chối';
      case VoucherStatus.DELETED:
        return 'Đã xoá';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voucher của Shop')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.vouchers.isEmpty) {
          return const Center(child: Text('Chưa có voucher nào.'));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                // Hiển thị từng voucher dưới dạng card
                ...controller.vouchers.map((voucher) => _buildVoucherCard(voucher)).toList(),

                const SizedBox(height: 24),

                // Biểu đồ tổng hợp ở cuối danh sách
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ChartSection(),
                ),
              ],
            ),
          ),
        );
      }),
        // Đầu file thêm import:

    floatingActionButton: FloatingActionButton(
    onPressed: () {
      Get.to(() => const AddVoucherView());
    },
    child: const Icon(Icons.add),
    ),

    );
  }

  Widget _buildVoucherCard(VoucherModel voucher) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.discount, size: 16, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        voucher.code,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor(voucher.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 10, color: statusColor(voucher.status)),
                      const SizedBox(width: 4),
                      Text(
                        statusLabel(voucher.status),
                        style: TextStyle(
                          fontSize: 12,
                          color: statusColor(voucher.status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(Icons.percent, 'Giảm', '${voucher.discountPercentage.toStringAsFixed(0)}%'),
                _buildInfoItem(Icons.access_time, 'Thời hạn', voucher.remainingDays),
                _buildInfoItem(Icons.check_circle_outline, 'Lượt dùng', voucher.usageProgress),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Xác nhận xoá',
                    middleText: 'Bạn có chắc muốn xoá voucher này?',
                    textCancel: 'Huỷ',
                    textConfirm: 'Xoá',
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      controller.deleteVoucher(voucher.id);
                      Get.back();
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}