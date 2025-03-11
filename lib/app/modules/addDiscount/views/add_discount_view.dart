import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_discount_controller.dart';

class AddDiscountView extends GetView<AddDiscountController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tạo giảm giá', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildCard(_buildProductInfo()),
            _buildCard(_buildDiscountInput()),
            _buildCard(_buildQuantitySelection()),
            _buildCard(_buildTimeSelection()),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: () {
            // Xử lý áp dụng giảm giá
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text('Áp dụng giảm giá cho sản phẩm', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildCard(Widget child) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: child,
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRowInfo("Tên sản phẩm", "Cơm rang thập cẩm"),
        SizedBox(height: 8),
        _buildRowInfo("Giá gốc", "30.000 đồng"),
      ],
    );
  }

  Widget _buildRowInfo(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
      ],
    );
  }

  Widget _buildDiscountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField("Giá trị giảm", controller.discountValue, "đồng", onChanged: (val) {
          controller.calculateDiscount();
        }),
        SizedBox(height: 8),
        Obx(() => _buildRowInfo("Giá sau khi giảm", controller.finalPrice.value)),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String suffix,
      {Function(String)? onChanged}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.end,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "__",
              suffixText: suffix,
              suffixStyle: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Số lượng sản phẩm được giảm giá", style: TextStyle(fontWeight: FontWeight.bold)),
        Obx(() => Column(
          children: [
            RadioListTile(
              title: Text("Số lượng cụ thể"),
              value: "specific",
              groupValue: controller.quantityOption.value,
              onChanged: (value) => controller.quantityOption.value = value!,
            ),
            if (controller.quantityOption.value == "specific")
              TextField(
                controller: controller.specificQuantity,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(border: InputBorder.none, hintText: "___"),
              ),
            RadioListTile(
              title: Text("Toàn bộ số lượng còn lại"),
              value: "all",
              groupValue: controller.quantityOption.value,
              onChanged: (value) => controller.quantityOption.value = value!,
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Thời gian áp dụng:", style: TextStyle(fontWeight: FontWeight.bold)),
        Obx(() => Column(
          children: [
            RadioListTile(
              title: Text("Trong hôm nay"),
              value: "today",
              groupValue: controller.timeOption.value,
              onChanged: (value) => controller.timeOption.value = value!,
            ),
            RadioListTile(
              title: Text("Từ:"),
              value: "range",
              groupValue: controller.timeOption.value,
              onChanged: (value) => controller.timeOption.value = value!,
            ),
            if (controller.timeOption.value == "range")
              Row(
                children: [
                  Expanded(child: _buildDateSelector("Chọn ngày bắt đầu")),
                  SizedBox(width: 8),
                  Expanded(child: _buildDateSelector("Chọn ngày kết thúc")),
                ],
              ),
            RadioListTile(
              title: Text("Trong vòng"),
              value: "duration",
              groupValue: controller.timeOption.value,
              onChanged: (value) => controller.timeOption.value = value!,
            ),
            if (controller.timeOption.value == "duration")
              _buildTextField(" ", controller.duration, "giờ"),
          ],
        )),
      ],
    );
  }

  Widget _buildDateSelector(String hint) {
    return TextField(
      decoration: InputDecoration(border: InputBorder.none, hintText: hint),
    );
  }
}
