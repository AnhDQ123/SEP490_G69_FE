import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modules/user_profile/profile/controllers/profile_controller.dart';
import '../../routes/app_pages.dart';

class UserHeader extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Color.fromRGBO(212, 163, 115, 1),
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.SETTING_LOGOUT),
                    child: const Icon(Icons.settings, size: 26, color: Colors.black54),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.EDIT_PROFILE),
                    child: const Icon(Icons.edit, size: 26, color: Colors.black54),
                  ),
                ],
              ),
            ),


            Positioned(
              left: 20,
              bottom: 40,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                        "Xin chào, ${controller.userName.value}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                      const SizedBox(height: 4),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
