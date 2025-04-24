import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/voucher.dart';
import '../../controllers/check_out_controller.dart';

class VoucherBottomSheet extends StatelessWidget {
  final CheckOutController controller;

  const VoucherBottomSheet({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Chọn Voucher",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Ô nhập mã voucher
          TextField(
            decoration: InputDecoration(
              hintText: "Nhập mã voucher",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  // Xử lý áp dụng voucher từ mã nhập
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Voucher có sẵn",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (controller.isLoadingVouchers.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.vouchers.isEmpty) {
                return const Center(child: Text("Không có voucher nào"));
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.vouchers.length,
                // Trong VoucherBottomSheet
                itemBuilder: (context, index) {
                  final voucher = controller.vouchers[index];
                  final discountPercent = (voucher.discountValue * 100).toInt();
                  final orderTotal = controller.order.value?.total ?? 0;
                  final isDisabled = orderTotal < voucher.minOrderValue;
                  final isSelected = controller.order.value?.voucherId == voucher.id;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                        title: Text(
                          voucher.code,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDisabled ? Colors.grey : Colors.green,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Giảm $discountPercent%'),
                            if (isDisabled)
                              Text(
                                "Đơn tối thiểu ${voucher.minOrderValue.toStringAsFixed(0)}đ",
                                style: const TextStyle(color: Colors.red, fontSize: 12),
                              ),
                          ],
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : null,
                        onTap: isDisabled
                            ? null
                            : () async {
                          // Cập nhật thông tin voucher đã chọn
                          controller.order.update((order) {
                            if (order != null) {
                              order.voucherId = voucher.id;
                              order.voucherAmount = voucher.discountValue; // Giảm giá của voucher
                            }
                          });

                          // Tính toán lại tổng tiền sau khi áp dụng voucher
                          double total = controller.order.value?.total ?? 0;
                          double discountAmount = total * voucher.discountValue;
                          double newTotal = total - discountAmount + (controller.order.value?.shippingFee ?? 0);

                          // Gọi API cập nhật total
                          await controller.updateOrderTotal(newTotal);

                          // Đóng bottom sheet sau khi áp dụng voucher
                          Get.back();
                        }

                    ),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Get.back(),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }
}