import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../base/base_common.dart';
import '../../../../resources/widget/bottom_nav.dart';
import '../../../../routes/app_pages.dart';
import '../../../shipper_home/views/shipper_home_view.dart';
import 'order_status_scroll.dart';
import 'user_header.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ⏳ Hiển thị loading nếu đang load dữ liệu
      if (controller.isLoadingShopInfo.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      // ✅ Hiển thị nội dung khi dữ liệu đã sẵn sàng
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
                      final userIdStr = BaseCommon.instance.userId;
                      if (userIdStr != null) {
                        final userId = int.tryParse(userIdStr);
                        if (userId != null) {
                          if (controller.shopStatus.value == Status.PENDING) {
                            Get.snackbar(
                              "Thông báo",
                              "Cửa hàng của bạn đang chờ duyệt. Bạn không thể đăng ký lại cửa hàng.",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          } else if (controller.shopStatus.value == Status.ACTIVE) {
                            final shopId = controller.shopId.value;
                            Get.toNamed(Routes.SHOP, arguments: {
                              'userId': userId,
                              'shopId': shopId,
                            });
                          } else {
                            Get.toNamed(Routes.SHOP_REGISTER, arguments: {
                              'userId': userId,
                            });
                          }
                        }
                      }
                    },
                  ),

                  _buildCard(
                    icon: Icons.delivery_dining,
                    title: "Vận chuyển",
                    subtitle: _getShipperSubtitle(controller.shipperStatus.value),
                    onTap: () {
                      final userIdStr = BaseCommon.instance.userId;
                      if (userIdStr == null) {
                        Get.snackbar("Lỗi", "Vui lòng đăng nhập lại");
                        return;
                      }

                      final userId = int.tryParse(userIdStr);
                      if (userId == null) {
                        Get.snackbar("Lỗi", "ID người dùng không hợp lệ");
                        return;
                      }

                      if (controller.isShopOwner.value) {
                        Get.snackbar(
                          "Thông báo",
                          "Bạn không thể đăng ký làm shipper vì bạn đã là chủ cửa hàng.",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } else {
                        _handleShipperAction(userId, controller.shipperStatus.value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNav(initialIndex: 4),
      );
    });
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
        onTap: onTap,
      ),
    );
  }

  String _getShipperSubtitle(Status status) {
    switch (status) {
      case Status.ACTIVE:
        return "Bạn đã là đối tác giao hàng";
      case Status.PENDING:
        return "Đơn đăng ký của bạn đang chờ duyệt";
      case Status.REJECTED:
        return "Đơn đăng ký của bạn đã bị từ chối";
      default:
        return "Bạn có muốn đăng ký trở thành đối tác giao hàng không?";
    }
  }

  void _handleShipperAction(int userId, Status status) {
    switch (status) {
      case Status.ACTIVE:
        Get.toNamed(Routes.SHIPPER_HOME, arguments: {'userId': userId , 'userName': controller.userName.value});
        break;
      case Status.PENDING:
        Get.snackbar(
          "Thông báo",
          "Đơn đăng ký shipper của bạn đang chờ duyệt. Vui lòng đợi!",
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case Status.REJECTED:
        Get.snackbar(
          "Thông báo",
          "Đơn đăng ký của bạn đã bị từ chối. Vui lòng liên hệ hỗ trợ.",
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      default:
        Get.toNamed(Routes.SHIPPER_REGISTER, arguments: {'userId': userId});
    }
  }
}
