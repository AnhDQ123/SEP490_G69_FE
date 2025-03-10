import 'dart:io';
import 'package:ffb_fe_flutter/app/modules/shop_detail/controllers/shop_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditForm extends StatefulWidget {
  const EditForm({Key? key}) : super(key: key);

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  // Lấy controller
  final controller = Get.find<ShopDetailController>();

  // Tạo TextEditingController để lưu tạm giá trị khi người dùng nhập
  late TextEditingController storeNameCtrl;
  late TextEditingController operatingHoursCtrl;
  late TextEditingController descriptionCtrl;
  late TextEditingController addressCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController emailCtrl;

  @override
  void initState() {
    super.initState();
    // Khởi tạo giá trị ban đầu từ controller
    storeNameCtrl = TextEditingController(text: controller.storeName.value);
    operatingHoursCtrl = TextEditingController(text: controller.operatingHours.value);
    descriptionCtrl = TextEditingController(text: controller.description.value);
    addressCtrl = TextEditingController(text: controller.address.value);
    phoneCtrl = TextEditingController(text: controller.phone.value);
    emailCtrl = TextEditingController(text: controller.email.value);
  }

  @override
  void dispose() {
    // Dispose TextEditingController
    storeNameCtrl.dispose();
    operatingHoursCtrl.dispose();
    descriptionCtrl.dispose();
    addressCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1) Chọn ảnh bìa
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Ảnh bìa:', style: TextStyle(fontWeight: FontWeight.bold)),
            Obx(() {
              final coverPath = controller.coverImagePath.value;
              return GestureDetector(
                onTap: () => controller.pickCoverImage(ImageSource.gallery),
                child: Container(
                  width: 80,
                  height: 50,
                  color: Colors.grey[300],
                  child: coverPath == null
                      ? const Icon(Icons.image, color: Colors.grey)
                      : Image.file(File(coverPath), fit: BoxFit.cover),
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 16),

        // 2) Chọn logo
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Logo:', style: TextStyle(fontWeight: FontWeight.bold)),
            Obx(() {
              final logoPath = controller.logoImagePath.value;
              return GestureDetector(
                onTap: () => controller.pickLogoImage(ImageSource.gallery),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: logoPath == null
                      ? const Icon(Icons.store, color: Colors.grey)
                      : ClipOval(
                    child: Image.file(
                      File(logoPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        const Divider(height: 24),

        // 3) TextFields cho các trường
        _buildTextField('Tên cửa hàng', storeNameCtrl),
        const SizedBox(height: 8),

        // 3a) Field Giờ hoạt động sử dụng time picker
        _buildOperatingHoursField(),
        const SizedBox(height: 8),

        _buildTextField('Mô tả', descriptionCtrl, maxLines: 3),
        const SizedBox(height: 8),
        _buildTextField('Địa chỉ', addressCtrl),
        const SizedBox(height: 8),
        _buildTextField('Số điện thoại', phoneCtrl),
        const SizedBox(height: 8),
        _buildTextField('Email', emailCtrl),
        const SizedBox(height: 16),

        // 4) Nút hành động
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                // Không lưu gì, đóng dialog
                Get.back();
              },
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              child: const Text('Lưu'),
              onPressed: () {
                // Cập nhật giá trị vào controller
                controller.storeName.value = storeNameCtrl.text;
                controller.operatingHours.value = operatingHoursCtrl.text;
                controller.description.value = descriptionCtrl.text;
                controller.address.value = addressCtrl.text;
                controller.phone.value = phoneCtrl.text;
                controller.email.value = emailCtrl.text;

                // Gọi hàm lưu thông tin (nếu cần)
                controller.saveStoreInfo();

                // Đóng dialog
                Get.back();
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Widget tạo TextField thông thường
  Widget _buildTextField(String label, TextEditingController textCtrl, {int maxLines = 1}) {
    return TextFormField(
      controller: textCtrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  /// Widget cho phần Giờ hoạt động dùng time picker thay vì nhập tay
  Widget _buildOperatingHoursField() {
    return GestureDetector(
      onTap: () async {
        // Chọn giờ bắt đầu
        TimeOfDay? startTime = await showTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 7, minute: 0),
        );
        if (startTime != null) {
          // Chọn giờ kết thúc
          TimeOfDay? endTime = await showTimePicker(
            context: context,
            initialTime: const TimeOfDay(hour: 22, minute: 0),
          );
          if (endTime != null) {
            String newValue = '${startTime.format(context)} - ${endTime.format(context)}';
            operatingHoursCtrl.text = newValue;
          }
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: operatingHoursCtrl,
          decoration: InputDecoration(
            labelText: 'Giờ hoạt động',
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.access_time),
          ),
        ),
      ),
    );
  }
}
