import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/shop_detail_controller.dart';

class ShopDetailView extends GetView<ShopDetailController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text('Chỉnh sửa thông tin')),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildCoverImagePicker(),
                SizedBox(height: 16),
                _buildLogoPicker(),
                _buildTextField('Tên cửa hàng', controller.nameController),
                _buildTimeRow('Giờ hoạt động'),
                _buildTextField('Mô tả', controller.descriptionController, maxLines: 4),
                _buildTextField('Địa chỉ', controller.addressController),
                _buildDisabledField('Số điện thoại', controller.shop.phone),
                _buildDisabledField('Email', controller.shop.owner.email),
                SizedBox(height: 20),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
        if (controller.isLoading.value)
          Container(
            color: Colors.black26,
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    ));
  }

  Widget _buildCoverImagePicker() {
    return Obx(() {
      final file = controller.coverImage.value;
      return Stack(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: file != null
                    ? FileImage(file)
                    : NetworkImage(controller.shop.backgroundImage!) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: InkWell(
                onTap: controller.pickCoverImage,
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text('Chỉnh sửa', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildLogoPicker() {
    return Obx(() {
      final file = controller.logoImage.value;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: file != null
                  ? FileImage(file)
                  : NetworkImage(controller.shop.logo!),
              backgroundColor: Colors.grey[200],
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Logo cửa hàng', style: TextStyle(fontSize: 16)),
                TextButton.icon(
                  onPressed: controller.pickLogoImage,
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

  Widget _buildTimeRow(String label) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _selectTime(true),
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(
                      text: controller.openTime.value.format(Get.context!),
                    ),
                    decoration: InputDecoration(labelText: '$label từ'),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectTime(false),
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(
                      text: controller.closeTime.value.format(Get.context!),
                    ),
                    decoration: InputDecoration(labelText: 'đến'),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _selectTime(bool isOpenTime) async {
    final current = isOpenTime
        ? controller.openTime.value
        : controller.closeTime.value;

    final picked = await showTimePicker(
      context: Get.context!,
      initialTime: current,
    );

    if (picked != null) {
      if (isOpenTime) {
        controller.openTime.value = picked;
      } else {
        controller.closeTime.value = picked;
      }
    }
  }

  Widget _buildTextField(String label, TextEditingController textController,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: textController,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDisabledField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        enabled: false,
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Get.back(),
            child: Text('Huỷ bỏ'),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: controller.onSave,
            child: Text('Xác nhận'),
          ),
        ),
      ],
    );
  }
}
