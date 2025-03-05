import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingLogoutView extends StatelessWidget {
  const SettingLogoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Tài khoản của tôi"),
              _buildSettingItem("Tài khoản và bảo mật", onTap: () => Get.toNamed('/account-security')),
              _buildSettingItem("Địa chỉ", onTap: () => Get.toNamed('/address')),
              _buildSettingItem("Thẻ ngân hàng", onTap: () => Get.toNamed('/bank-cards')),
              _buildSettingItem("Bài đăng của tôi", onTap: () => Get.toNamed('/my-posts')),

              _buildSectionTitle("Setting"),
              _buildSettingItem("Thông báo", onTap: () => Get.toNamed('/notifications')),
              _buildSettingItem("Ngôn ngữ", onTap: () => Get.toNamed('/language')),

              _buildSectionTitle("Support"),
              _buildSettingItem("Tiêu chuẩn cộng đồng", onTap: () => Get.toNamed('/community-standards')),
              _buildSettingItem("Để lại đánh giá", onTap: () => Get.toNamed('/leave-review')),
              _buildSettingItem("Thông tin về Fast F&B", onTap: () => Get.toNamed('/fast-fnb-info')),
              _buildSettingItem("Yêu cầu hủy tài khoản", onTap: () => Get.toNamed('/account-deletion-request')),

              const SizedBox(height: 20),

              Center(
                child: OutlinedButton(
                  onPressed: () => Get.offAllNamed('/login'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    side: const BorderSide(color: Colors.black),
                  ),
                  child: const Text("Đăng xuất", style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              ),


              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSettingItem(String title, {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
