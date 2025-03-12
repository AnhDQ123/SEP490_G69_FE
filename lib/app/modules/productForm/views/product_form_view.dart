import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
            _buildCard(_buildTextField(label: "Tên sản phẩm",value:  controller.productName)),
            _buildCard(_buildTextField(label: "Mô tả sản phẩm",value:  controller.productDescription)),
            _buildCard(_buildCategoryDropdown()), // Danh mục sản phẩm
            _buildCard(_buildQuantity()), // Số lượng sản phẩm
            _buildCard(_buildExpirationDate()), // Hạn sử dụng
            _buildCard(buildFoodOptionSelector(
              title: "Kích cỡ sản phẩm",
              options: controller.sizes,
              onAdd: (size) => controller.addSizeOption(size),
              onRemove: (id) => controller.removeSizeOption(id),
            )),
            _buildCard(buildFoodOptionSelector(
              title: "Lựa chọn sản phẩm",
              options: controller.options,
              onAdd: (option) => controller.addFoodOption(option),
              onRemove: (id) => controller.removeFoodOption(id),
            )),

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

  Widget _buildTextField({required String label, required RxString value}) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 6),
        TextField(
          controller: TextEditingController(text: value.value)
            ..selection = TextSelection.collapsed(offset: value.value.length),
          onChanged: (text) => value.value = text,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
        SizedBox(height: 12),
      ],
    ));
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

  Widget buildFoodOptionSelector({
    required String title,
    required List<FoodOption> options,
    required Function(FoodOption) onAdd,
    required Function(int) onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: Colors.black),
              onPressed: () => showAddFoodOptionBottomSheet(onAdd),
            ),
          ],
        ),
        SizedBox(height: 8),
        Obx(() => Column(
          children: options.isEmpty
              ? [Text("Chưa có lựa chọn nào", style: TextStyle(color: Colors.grey))]
              : options.map((option) => buildFoodOptionItem(option, onRemove)).toList(),
        )),
      ],
    );
  }

  void showAddFoodOptionBottomSheet(Function(FoodOption) onAdd) {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    final ImagePicker _picker = ImagePicker();
    Rxn<File> selectedImage = Rxn<File>();

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

            // Khu vực chọn ảnh
            Obx(() => Column(
              children: [
                if (selectedImage.value != null)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          selectedImage.value!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => selectedImage.value = null,
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
                if (selectedImage.value == null)
                  GestureDetector(
                    onTap: () async {
                      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        selectedImage.value = File(pickedFile.path);
                      }
                    },
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
            SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                String name = nameController.text.trim();
                String priceText = priceController.text.trim();

                if (name.isEmpty || priceText.isEmpty) {
                  Get.snackbar("Lỗi", "Tên và giá không được để trống");
                  return;
                }

                double? price = double.tryParse(priceText);
                if (price == null) {
                  Get.snackbar("Lỗi", "Giá phải là số hợp lệ");
                  return;
                }

                onAdd(FoodOption(
                  id: DateTime.now().millisecondsSinceEpoch,
                  name: name,
                  price: price,
                  image: selectedImage.value, // Lưu ảnh vào option
                  typeId: 3, // Đây là option (hoặc có thể là size tùy vào nơi gọi hàm)
                ));

                Future.delayed(Duration.zero, () {
                  Get.back();
                });
              },
              child: Text("Thêm"),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget buildFoodOptionItem(FoodOption option, Function(int) onRemove) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Hiển thị ảnh nếu có
          if (option.image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                option.image!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(option.name, style: TextStyle(fontSize: 16)),
                Text("${option.price.toStringAsFixed(0)} đ", style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.grey),
            onPressed: () => onRemove(option.id),
          ),
        ],
      ),
    );
  }


  Widget _buildSupplierManufacturerFields() {
    return Column(
      children: [
        _buildTextField(label: "Nhà sản xuất", value: controller.manufacturer),
        _buildTextField(label: "Nhà cung cấp", value: controller.supplier),
      ],
    );
  }
}
