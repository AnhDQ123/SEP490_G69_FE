import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/shop_voucher_add_controller.dart';
import '../../../routes/app_pages.dart';
import 'package:intl/intl.dart';

class ShopVoucherAddView extends StatelessWidget {
  final controller = Get.put(ShopVoucherAddController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tạo Mới Voucher"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: controller.codeController,
                decoration: InputDecoration(labelText: 'Mã giảm giá'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: controller.discountType.value,
                onChanged: (value) => controller.discountType.value = value!,
                items: ['PERCENTAGE', 'AMOUNT'].map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Loại giảm giá'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: controller.discountValueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Giá trị giảm giá'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: controller.minOrderValueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Giá trị đơn hàng tối thiểu'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: controller.totalVouchersController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Số lượng voucher'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: controller.maxUsagePerCustomerController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Giới hạn sử dụng trên mỗi khách hàng'),
              ),
              SizedBox(height: 16),
              _datePickerField(
                label: "Ngày bắt đầu",
                controller: controller.startDateController,
              ),
              SizedBox(height: 16),
              _datePickerField(
                label: "Ngày kết thúc",
                controller: controller.endDateController,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  controller.addVoucher();  // Chỉ thêm mới
                },
                child: Text("Tạo mới Voucher"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _datePickerField({
    required String label,
    required TextEditingController controller,
  }) {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: Get.context!,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          controller.text = DateFormat('yyyy-MM-dd').format(picked);
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }


}
