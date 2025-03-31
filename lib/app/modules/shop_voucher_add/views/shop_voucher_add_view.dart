import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/shop_voucher_add_controller.dart';
import '../../../models/voucher.dart';

class ShopVoucherAddView extends StatelessWidget {
  final controller = Get.put(ShopVoucherAddController());

  @override
  Widget build(BuildContext context) {
    final Voucher? voucherArg = Get.arguments;
    if (voucherArg != null) controller.initialize(voucherArg);

    return Scaffold(
      appBar: AppBar(
        title: Text(voucherArg == null ? "Tạo mới Voucher" : "Chỉnh sửa Voucher"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(controller.codeController, "Mã giảm giá"),
              SizedBox(height: 12),
              Obx(() => DropdownButtonFormField<String>(
                value: controller.discountType.value,
                onChanged: (val) => controller.discountType.value = val!,
                items: ['PERCENTAGE', 'AMOUNT'].map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Loại giảm giá'),
              )),
              SizedBox(height: 4),
              Obx(() => Align(
                alignment: Alignment.centerRight,
                child: Text(
                  controller.discountType.value == 'PERCENTAGE'
                      ? '(%) Phần trăm'
                      : '(₫) Số tiền',
                  style: TextStyle(color: Colors.grey),
                ),
              )),
              SizedBox(height: 12),
              _buildTextField(controller.discountValueController, "Giá trị giảm", isNumber: true),
              _buildTextField(controller.minOrderValueController, "Đơn hàng tối thiểu", isNumber: true),
              _buildTextField(controller.totalVouchersController, "Số lượng", isNumber: true),
              _buildTextField(controller.maxUsagePerCustomerController, "Giới hạn / khách", isNumber: true),
              _buildDatePicker(controller.startDateController, "Ngày bắt đầu"),
              _buildDatePicker(controller.endDateController, "Ngày kết thúc"),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: controller.submitVoucher,
                child: Text(voucherArg == null ? "Tạo mới" : "Cập nhật"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _buildDatePicker(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => Get.find<ShopVoucherAddController>().pickDate(controller),
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              suffixIcon: Icon(Icons.calendar_today),
            ),
          ),
        ),
      ),
    );
  }
}
