import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../models/foodOption.dart';
import '../controllers/product_form_controller.dart';

class ProductFormView extends GetView<ProductFormController> {
  final ProductFormController controller = Get.put(ProductFormController());

  @override
  Widget build(BuildContext context) {
    controller.loadCategories();
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.isEditing.value ? "Chỉnh sửa sản phẩm" : "Thêm sản phẩm")),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(_buildImagePicker()), // Ảnh sản phẩm
            _buildCard(_buildTextField("Tên sản phẩm", controller.productNameController, isRequired: true)),
            _buildCard(_buildTextField("Mô tả sản phẩm", controller.productDescriptionController)),
            _buildCard(_buildCategoryDropdown()), // Danh mục sản phẩm
            _buildCard(_buildQuantity()), // Số lượng sản phẩm
            _buildCard(_buildExpirationDate()), // Hạn sử dụng
            _buildCard(_buildSizeSelector()), // Kích cỡ sản phẩm
            _buildCard(_buildFoodOptionSelector()),// Lựa chọn sản phẩm
            _buildCard(_buildSupplierManufacturerFields()), // Nhà sản xuất & Nhà cung cấp
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () => controller.saveProduct(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Obx(() => Text(controller.isEditing.value ? "Lưu thay đổi" : "Thêm sản phẩm")),
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

  Widget _buildImagePicker() {
    final ImagePickerController imageController = Get.put( ImagePickerController());

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hình ảnh sản phẩm',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            'Hình ảnh không được phép vượt quá 10Mb. Tối đa 1 hình ảnh.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(height: 10),
          Obx(() => Row(
            children: [
              if (imageController.selectedMedia.value != null)
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Image.file(
                        imageController.selectedMedia.value!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    GestureDetector(
                      onTap: imageController.removeMedia,
                      child: Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              if (imageController.selectedMedia.value == null)
                GestureDetector(
                  onTap: imageController.pickMedia,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.add, size: 40, color: Colors.black54),
                  ),
                ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: "$label ",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            children: isRequired ? [TextSpan(text: "*", style: TextStyle(color: Colors.red))] : [],
          ),
        ),
        SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12)),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Danh mục sản phẩm *", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Obx(() {

          return DropdownButtonFormField<String>(
            value: controller.categories.any((c) => c.name == controller.selectedCategory.value)
                ? controller.selectedCategory.value
                : null, // Nếu giá trị không hợp lệ, đặt thành null
            items: controller.categories.map((category) {
              return DropdownMenuItem(
                value: category.name,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (value) {
              controller.selectedCategory.value = value!;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildQuantity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Số lượng *", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: [
            IconButton(icon: Icon(Icons.remove), onPressed: controller.decreaseQuantity),
            Expanded(
              child: TextField(
                controller: controller.quantityController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(border: OutlineInputBorder()),
                onChanged: (value) => controller.updateQuantity(value),
              ),
            ),
            IconButton(icon: Icon(Icons.add), onPressed: controller.increaseQuantity),
          ],
        ),
      ],
    );
  }

  Widget _buildExpirationDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Ngày hết hạn", style: TextStyle(fontWeight: FontWeight.bold)), // Đổi tên
        SizedBox(height: 8),
        Obx(() => Row(
          children: [
            InkWell(
              onTap: () => controller.selectDate(Get.context!), // Mở Date Picker
              child: Row(
                children: [
                  Text(
                    controller.expirationValue.value.isEmpty
                        ? "Chọn ngày"
                        : controller.expirationValue.value,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.calendar_today, size: 18, color: Colors.black),
                ],
              ),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildBottomSheetTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildSizeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Kích cỡ sản phẩm *", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: Colors.black),
              onPressed: () => _showAddSizeBottomSheet(),
            ),
          ],
        ),
        SizedBox(height: 8),
        Obx(() => Column(
          children: controller.sizes.isEmpty
              ? [Text("Chưa có kích cỡ nào", style: TextStyle(color: Colors.grey))]
              : controller.sizes.map((size) => _buildSizeItem(size)).toList(),
        )),
      ],
    );
  }
  void _showAddSizeBottomSheet() {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    RxString imageUrl = "".obs;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Thêm kích cỡ mới", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),

            _buildBottomSheetTextField("Tên kích cỡ", nameController),
            _buildBottomSheetTextField("Giá", priceController, isNumber: true),

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty || priceController.text.isEmpty) {
                  Get.snackbar("Lỗi", "Tên và giá không được để trống");
                  return;
                }
                controller.addSizeOption(
                  FoodOption(
                    id: DateTime.now().millisecondsSinceEpoch, // Fake ID để tránh trùng
                    name: nameController.text,
                    price: double.tryParse(priceController.text) ?? 0.0,
                    typeId: 2, // Type ID = 2 cho Size
                  ),
                );
                Get.back();
              },
              child: Text("Thêm"),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
  Widget _buildSizeItem(FoodOption sizeOption) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(sizeOption.name!, style: TextStyle(fontSize: 16)),
          Text("${sizeOption.price?.toStringAsFixed(0)} đ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          IconButton(icon: Icon(Icons.delete, color: Colors.grey), onPressed: () => controller.removeSizeOption(controller.sizes.indexOf(sizeOption))),
        ],
      ),
    );
  }

  Widget _buildFoodOptionSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Lựa chọn sản phẩm", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: Colors.black),
              onPressed: () => _showAddFoodOptionBottomSheet(),
            ),
          ],
        ),
        SizedBox(height: 8),
        Obx(() => Column(
          children: controller.foodOptions.isEmpty
              ? [Text("Chưa có lựa chọn nào", style: TextStyle(color: Colors.grey))]
              : controller.foodOptions.map((option) => _buildFoodOptionItem(option)).toList(),
        )),
      ],
    );
  }
  void _showAddFoodOptionBottomSheet() {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Thêm lựa chọn sản phẩm", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),

            _buildBottomSheetTextField("Tên lựa chọn", nameController),
            _buildBottomSheetTextField("Giá", priceController, isNumber: true),

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty || priceController.text.isEmpty) {
                  Get.snackbar("Lỗi", "Tên và giá không được để trống");
                  return;
                }

                // Thêm FoodOption
                controller.addFoodOption(
                  FoodOption(
                    id: DateTime.now().millisecondsSinceEpoch, // Fake ID
                    name: nameController.text,
                    price: double.tryParse(priceController.text) ?? 0.0,
                    typeId: 3, // Đánh dấu đây là Food Option
                  ),
                );

                Get.back();
              },
              child: Text("Thêm"),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
  Widget _buildFoodOptionItem(FoodOption FoodOption) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(FoodOption.name!, style: TextStyle(fontSize: 16)),
          Text("${FoodOption.price?.toStringAsFixed(0)} đ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          IconButton(icon: Icon(Icons.delete, color: Colors.grey), onPressed: () => controller.removeFoodOption(controller.sizes.indexOf(FoodOption))),
        ],
      ),
    );
  }

  Widget _buildSupplierManufacturerFields() {
    return Column(
      children: [
        _buildTextField("Nhà sản xuất", controller.manufacturerController),
        _buildTextField("Nhà cung cấp", controller.supplierController),
      ],
    );
  }
}
