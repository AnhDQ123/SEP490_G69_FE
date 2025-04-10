import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/food_option.dart';
import '../../../resources/util_common.dart';
import '../controllers/shop_add_product_controller.dart';

class ShopAddProductView extends GetView<ShopAddProductController> {
  final ShopAddProductController controller = Get.put(ShopAddProductController());

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
            _buildCard(_buildImagePicker()),
            _buildCard(_buildTextField(label: "Tên sản phẩm",value:  controller.productName)),
            _buildCard(_buildTextField(label: "Mô tả sản phẩm",value:  controller.productDescription)),
            _buildCard(_buildExpiryDatePicker()),
            _buildCard(_buildQuantity()),
            _buildCard(_buildTypeDropdown()),
            _buildCard(_buildCategoryDropdown()), // Danh mục sản phẩm
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
          onPressed: controller.isLoading.value ? null : () => controller.saveProduct(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(251, 196, 139, 1.0),
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
    return Obx(() {
      final file = controller.avatar.value;
      final url = controller.avatarUrl.value;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
                image: file != null
                    ? DecorationImage(
                  image: FileImage(file),
                  fit: BoxFit.cover,
                )
                    : url != null
                    ? DecorationImage(
                  image: NetworkImage(url),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ảnh sản phẩm', style: TextStyle(fontSize: 16)),
                TextButton.icon(
                  onPressed: () => _showImagePickerOptions(controller),
                  icon: Icon(Icons.edit, size: 16),
                  label: Text('Chỉnh sửa'),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  void _showImagePickerOptions(ShopAddProductController controller) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Chọn từ thư viện"),
              onTap: () {
                controller.pickImageFromGallery(controller.avatar);
                Get.back(); // Đóng bottom sheet
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Chụp ảnh"),
              onTap: () {
                controller.pickImageFromCamera(controller.avatar);
                Get.back(); // Đóng bottom sheet
              },
            ),
          ],
        ),
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

  Widget _buildExpiryDatePicker() {
    return Obx(() {
      final date = controller.expiryDate.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ngày hết hạn *", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          InkWell(
            onTap: () async {
              DateTime now = DateTime.now();
              DateTime? pickedDate = await showDatePicker(
                context: Get.context!,
                initialDate: date ?? now,
                firstDate: now,
                lastDate: DateTime(now.year + 5),
              );
              if (pickedDate != null) {
                controller.expiryDate.value = pickedDate;
              }
            },
            child: Container(
              width: double.infinity,  // Chỉnh sửa để chiếm toàn bộ chiều ngang
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                date != null
                    ? "${date.day}/${date.month}/${date.year}"
                    : "Chọn ngày...",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 12),
        ],
      );
    });
  }


  Widget _buildTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Loại sản phẩm *", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Obx(() {
          return DropdownButtonFormField<String>(
            value: controller.type.value.isNotEmpty ? controller.type.value : null,  // Gán giá trị loại sản phẩm
            items: [
              DropdownMenuItem(
                value: "FRESH",
                child: Text("Thực phẩm tươi sống"),
              ),
              DropdownMenuItem(
                value: "COOKED",
                child: Text("Thực phẩm chế biến"),
              ),
            ],
            onChanged: (value) {
              controller.type.value = value!;  // Cập nhật giá trị khi người dùng thay đổi
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
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: controller.decreaseQuantity,
            ),
            Expanded(
              child: TextField(
                controller: controller.quantityController..text = controller.quantity.value.toString(),  // Đồng bộ giá trị quantity
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(border: OutlineInputBorder()),
                onChanged: (value) => controller.updateQuantity(value),  // Cập nhật số lượng khi người dùng thay đổi thủ công
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: controller.increaseQuantity,
            ),
          ],
        ),
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
  })
  {
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
    FoodOption? existingOption,
    bool isSize = false,
  })
  {
    TextEditingController nameController =
    TextEditingController(text: existingOption?.name ?? "");
    TextEditingController priceController =
    TextEditingController(text: existingOption?.price.toString() ?? "");
    final ImagePicker _picker = ImagePicker();

    // 🧠 Dùng dynamic để hỗ trợ cả File và String (URL)
    Rxn<dynamic> selectedImage = Rxn<dynamic>();

    if (existingOption?.image != null) {
      final img = existingOption!.image!;
      if (img.startsWith('http')) {
        selectedImage.value = img; // URL
      } else {
        selectedImage.value = File(img); // Local File
      }
    }

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
            Text(
              existingOption == null
                  ? (isSize ? "Thêm Kích Cỡ" : "Thêm Lựa Chọn")
                  : (isSize ? "Chỉnh Sửa Kích Cỡ" : "Chỉnh Sửa Lựa Chọn"),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                isSize ? "Ảnh kích cỡ" : "Ảnh lựa chọn",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),

            Obx(() => Column(
              children: [
                if (selectedImage.value != null)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: selectedImage.value is String
                            ? Image.network(
                          selectedImage.value,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        )
                            : Image.file(
                          selectedImage.value,
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
                          child: Icon(Icons.close, color: Colors.white, size: 20),
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
                      child: Icon(Icons.add_a_photo, size: 40, color: Colors.black54),
                    ),
                  ),
              ],
            )),
            SizedBox(height: 16),

            _buildBottomSheetTextField(
                isSize ? "Tên kích cỡ" : "Tên lựa chọn", nameController),
            _buildBottomSheetTextField("Giá", priceController, isNumber: true),

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

                // ✅ Lấy image path đúng kiểu
                String? imagePath;
                if (selectedImage.value != null) {
                  if (selectedImage.value is File) {
                    imagePath = (selectedImage.value as File).path;
                  } else if (selectedImage.value is String) {
                    imagePath = selectedImage.value;
                  }
                }

                onSubmit(FoodOption(
                  id: existingOption?.id ?? DateTime.now().millisecondsSinceEpoch,
                  name: name,
                  price: price,
                  image: imagePath,
                  typeId: isSize ? 2 : 1,
                  productId: 0,
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
              child: option.image!.startsWith("http")
                  ? Image.network(
                option.image!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
                  : Image.file(
                File(option.image!),
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
                Text(UtilCommon.formatMoney(option.price)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              showFoodOptionBottomSheet(
                onSubmit: onEdit,
                existingOption: option,
                isSize: option.typeId == 2,
              );
            },
          ),
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