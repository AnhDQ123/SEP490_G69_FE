import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/shop_profile_controller.dart';

class ShopProfileView extends GetView<ShopProfileController> {
  const ShopProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa cửa hàng'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,  // Thêm màu cho app bar
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              controller.toggleEditing(); // Toggle chế độ chỉnh sửa
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildCoverPhoto(),
          _buildShopLogo(),
          _buildShopName(),
          _buildShopHours(),
          _buildShopDescription(),
          _buildShopAddress(),
          _buildShopPhone(),
          _buildShopEmail(),
          _buildActions(),
        ],
      ),
    );
  }

  // Ảnh bìa
  Widget _buildCoverPhoto() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/shop1_logo.png'), // Thay thế bằng ảnh thực tế
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                // Chỉnh sửa ảnh bìa
              },
            ),
          ),
        ],
      ),
    );
  }

  // Logo cửa hàng
  Widget _buildShopLogo() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Logo cửa hàng',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/shop1_logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tên cửa hàng
  Widget _buildShopName() {
    return _buildEditableCard(
      'Tên cửa hàng',
      controller.shopName,
          (value) => controller.updateShopName(value),
      isTitle: true,
    );
  }

  Widget _buildShopHours() {
    return _buildEditableCard('Giờ hoạt động', controller.shopHours, (value) => controller.updateShopHours(value));
  }

  // Mô tả cửa hàng
  Widget _buildShopDescription() {
    return _buildEditableCard(
      'Mô tả',
      controller.shopDescription,
          (value) => controller.updateShopDescription(value),
      maxLength: 500,
    );
  }

  Widget _buildShopAddress() {
    return _buildEditableCard('Địa chỉ', controller.shopAddress, (value) => controller.updateShopAddress(value));
  }

  Widget _buildShopPhone() {
    return _buildEditableCard('Số điện thoại', controller.shopPhone, (value) => controller.updateShopPhone(value));
  }

  Widget _buildShopEmail() {
    return _buildEditableCard('Email', controller.shopEmail, (value) => controller.updateShopEmail(value));
  }

  // Tạo card chỉnh sửa cho các trường
  Widget _buildEditableCard(String title, RxString value, Function(String) onChanged, {int? maxLength, bool isTitle = false}) {
    return Obx(
          () => Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isTitle ? 16 : 14,
                ),
              ),
              const SizedBox(height: 5),
              controller.isEditing.value
                  ? TextField(
                controller: TextEditingController(text: value.value),
                onChanged: onChanged,
                maxLength: maxLength,
                style: TextStyle(fontSize: 12),
                decoration: const InputDecoration(hintText: 'Nhập thông tin'),
              )
                  : Text(
                value.value,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Nút Hủy bỏ và Xác nhận
  Widget _buildActions() {
    return Obx(
          () => controller.isEditing.value
          ? Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                controller.saveShopProfile();
              },
              child: const Text('Xác nhận'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,  // Màu xanh cho nút Xác nhận
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                controller.cancelEdit();
              },
              child: const Text('Hủy bỏ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,  // Màu đỏ cho nút Hủy bỏ
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      )
          : SizedBox.shrink(),  // Nếu không ở chế độ chỉnh sửa, không hiển thị gì
    );
  }
}
