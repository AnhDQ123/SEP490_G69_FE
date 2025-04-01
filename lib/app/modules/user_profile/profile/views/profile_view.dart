import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../base/base_common.dart';
import '../../../../resources/widget/bottom_nav.dart';
import '../../../../routes/app_pages.dart';
import 'order_status_scroll.dart';
import 'user_header.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          UserHeader(),
          OrderStatusScroll(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildCard(
                  icon: Icons.store,
                  title: "Cửa hàng của tôi",
                  subtitle: "Tham gia với chúng tôi với tư cách nhà bán hàng",
                  onTap: () {
                    // Truyền userId sang trang cửa hàng
                    final userIdStr = BaseCommon.instance.userId;
                    if (userIdStr != null) {
                      final userId = int.tryParse(userIdStr);
                      if (userId != null) {
                        // Chuyển đến trang cửa hàng và truyền userId
                        Get.toNamed(Routes.SHOP_REGISTER, arguments: {'userId': userId});
                      }
                    }
                  },
                ),
                _buildCard(
                  icon: Icons.delivery_dining,
                  title: "Vận chuyển",
                  subtitle: "Bạn có muốn đăng ký trở thành đối tác giao hàng không?",
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(
        initialIndex: 4, // Đánh dấu mục "Cá nhân" đang được chọn
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap, // Gọi onTap khi nhấn vào card
      ),
    );
  }
}
