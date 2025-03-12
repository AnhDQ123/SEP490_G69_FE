import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/food_option.dart';
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
              onEdit: (size) => controller.editSizeOption(size), // 🆕 Thêm chức năng chỉnh sửa
              isSize: true, // 🆕 Xác định đây là kích cỡ
            )),

            _buildCard(buildFoodOptionSelector(
              title: "Lựa chọn sản phẩm",
              options: controller.options,
              onAdd: (option) => controller.addFoodOption(option),
              onRemove: (id) => controller.removeFoodOption(id),
              onEdit: (option) => controller.editFoodOption(option), // 🆕 Thêm chức năng chỉnh sửa
              isSize: false, // 🆕 Xác định đây là lựa chọn
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
    required RxList<FoodOption> options,
    required Function(FoodOption) onAdd,
    required Function(int) onRemove,
    required Function(FoodOption) onEdit,
    required bool isSize,
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
              onPressed: () => showFoodOptionBottomSheet(
                onSubmit: onAdd,
                isSize: isSize,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Obx(() => Column(
          children: options.isEmpty
              ? [Text("Chưa có lựa chọn nào", style: TextStyle(color: Colors.grey))]
              : options.map((option) => buildFoodOptionItem(option, onRemove, onEdit)).toList(),
        )),
      ],
    );
  }



  void showFoodOptionBottomSheet({
    required Function(FoodOption) onSubmit,
    FoodOption? existingOption, // Nếu có nghĩa là đang sửa
    bool isSize = false, // Xác định đây là kích cỡ hay lựa chọn
  }) {
    // Nếu là sửa, điền sẵn thông tin
    TextEditingController nameController =
    TextEditingController(text: existingOption?.name ?? "");
    TextEditingController priceController =
    TextEditingController(text: existingOption?.price.toString() ?? "");
    final ImagePicker _picker = ImagePicker();
    Rxn<File> selectedImage = Rxn<File>(existingOption?.image);

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
            // 🏷 Tiêu đề (Thêm hoặc Chỉnh sửa)
            Text(
              existingOption == null
                  ? (isSize ? "Thêm Kích Cỡ" : "Thêm Lựa Chọn")
                  : (isSize ? "Chỉnh Sửa Kích Cỡ" : "Chỉnh Sửa Lựa Chọn"),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            // 📌 Tiêu đề ảnh
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                isSize ? "Ảnh kích cỡ" : "Ảnh lựa chọn",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),

            // 🖼 Khu vực chọn ảnh
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
                          width: 120,
                          height: 120,
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
                          child:
                          Icon(Icons.close, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                if (selectedImage.value == null)
                  GestureDetector(
                    onTap: () async {
                      final XFile? pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        selectedImage.value = File(pickedFile.path);
                      }
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                      Icon(Icons.add_a_photo, size: 40, color: Colors.black54),
                    ),
                  ),
              ],
            )),
            SizedBox(height: 16),

            // ✏️ Tên lựa chọn / kích cỡ
            _buildBottomSheetTextField(
                isSize ? "Tên kích cỡ" : "Tên lựa chọn", nameController),

            // 💰 Giá
            _buildBottomSheetTextField("Giá", priceController, isNumber: true),

            SizedBox(height: 16),

            // ✅ Nút Lưu/Thêm
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

                onSubmit(FoodOption(
                  id: existingOption?.id ?? DateTime.now().millisecondsSinceEpoch,
                  name: name,
                  price: price,
                  image: selectedImage.value, // 📷 Lưu ảnh nếu có
                  typeId: isSize ? 2 : 3, // 🏷 Loại (2: kích cỡ, 3: lựa chọn)
                ));

                Future.delayed(Duration.zero, () {
                  Get.back();
                });
              },
              child: Text(existingOption == null
                  ? (isSize ? "Thêm Kích Cỡ" : "Thêm Lựa Chọn")
                  : "Lưu Chỉnh Sửa"),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget buildFoodOptionItem(FoodOption option, Function(int) onRemove, Function(FoodOption) onEdit) {
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
          // Nút sửa
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              showFoodOptionBottomSheet(
                onSubmit: onEdit,
                existingOption: option, // 🆕 Truyền dữ liệu để sửa
                isSize: option.typeId == 2, // Xác định đây là kích cỡ hay lựa chọn
              );
            },
          ),
          // Nút xoá
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
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
