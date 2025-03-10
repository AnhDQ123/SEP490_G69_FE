import 'dart:io';
import 'package:ffb_fe_flutter/app/modules/shop_detail/controllers/shop_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_form.dart';

class ShopDetailView extends GetView<ShopDetailController> {
  const ShopDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết cửa hàng'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Mở dialog chỉnh sửa
              _showEditDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        // Đặt crossAxisAlignment.stretch để con trong Column mở rộng toàn bộ width
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card cho ảnh bìa
            Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ảnh bìa',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      final coverPath = controller.coverImagePath.value;
                      if (coverPath == null) {
                        return Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      } else {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(coverPath),
                            fit: BoxFit.cover,
                            height: 120,
                            width: double.infinity,
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
            // Card cho logo cửa hàng
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Text(
                      'Logo cửa hàng',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Obx(() {
                      final logoPath = controller.logoImagePath.value;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.grey.shade200,
                            child: logoPath == null
                                ? Icon(
                              Icons.store,
                              size: 32,
                              color: Colors.grey.shade600,
                            )
                                : ClipOval(
                              child: Image.file(
                                File(logoPath),
                                fit: BoxFit.cover,
                                width: 64,
                                height: 64,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            // Các card thông tin khác
            _buildReadOnlyCard('Tên cửa hàng', controller.storeName),
            _buildReadOnlyCard('Giờ hoạt động', controller.operatingHours),
            _buildReadOnlyCard('Mô tả', controller.description),
            _buildReadOnlyCard('Địa chỉ', controller.address),
            _buildReadOnlyCard('Số điện thoại', controller.phone),
            _buildReadOnlyCard('Email', controller.email),
          ],
        ),
      ),
    );
  }

  /// Hàm hiển thị card với text read-only (mỗi card sẽ có chiều rộng đầy đủ)
  Widget _buildReadOnlyCard(String title, RxString value) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() {
              return Text(
                value.value,
                style: const TextStyle(fontSize: 16),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Khi bấm vào nút Edit, mở dialog chỉnh sửa
  void _showEditDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Chỉnh sửa thông tin'),
        content: SingleChildScrollView(
          child: EditForm(),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
