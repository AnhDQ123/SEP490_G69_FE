import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../resources/widget/bottom_nav.dart';
import '../../../../resources/widget/order_status_scroll.dart';
import '../../../../resources/widget/user_header.dart';
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
              padding: EdgeInsets.all(16),
              children: [
                _buildCard(
                  icon: Icons.store,
                  title: "Cửa hàng của tôi",
                  subtitle: "Tham gia với chúng tôi với tư cách nhà bán hàng",
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
      bottomNavigationBar: BottomNav(
        currentIndex: 3,
        onItemSelected: (index) {
          // Xử lý sự kiện khi item được chọn, ví dụ chuyển trang:
          // Get.toNamed(AppPages.routes[index]);
          // Hoặc bạn có thể thực hiện hành động khác tại đây.
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/home'),
        backgroundColor: Colors.blue,
        child: Icon(Icons.home, size: 30, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildCard({required IconData icon, required String title, required String subtitle}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
