// import 'dart:io';
// import 'package:ffb_fe_flutter/app/modules/user_profile/edit_profile/controllers/edit_profile_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// class EditProfileView extends StatelessWidget {
//   const EditProfileView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final EditProfileController userController = Get.find<EditProfileController>(); // Dùng Get.find()
//
//     final ImagePicker _picker = ImagePicker();
//
//     Future<void> _pickAvatar() async {
//       final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         userController.selectedAvatar.value = File(pickedFile.path);
//       }
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Chỉnh sửa Profile"),
//       ),
//       body: Obx(() {
//         if (userController.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               GestureDetector(
//                 onTap: _pickAvatar,
//                 child: Obx(() {
//                   return CircleAvatar(
//                     radius: 50,
//                     backgroundImage: userController.selectedAvatar.value != null
//                         ? FileImage(userController.selectedAvatar.value!)
//                         : userController.userProfile['avatarUrl'] != null
//                         ? NetworkImage(userController.userProfile['avatarUrl'])
//                     as ImageProvider
//                         : const AssetImage('assets/images/default_avatar.png'),
//                   );
//                 }),
//               ),
//               const SizedBox(height: 20),
//               _buildTextField("Họ và tên", TextEditingController(text: userController.userProfile['name'] ?? "")),
//               _buildTextField("Giới tính", TextEditingController(text: userController.userProfile['gender'] ?? "")),
//               _buildTextField("Ngày sinh", TextEditingController(text: userController.userProfile['dob'] ?? "")),
//               _buildTextField("Số điện thoại", TextEditingController(text: userController.userProfile['phone'] ?? "")),
//               _buildTextField("Email", TextEditingController(text: userController.userProfile['email'] ?? "")),
//               _buildTextField("Địa chỉ", TextEditingController(text: userController.userProfile['address'] ?? "")),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   Map<String, String> userData = {
//                     'name': userController.userProfile['name'] ?? "",
//                     'gender': userController.userProfile['gender'] ?? "",
//                     'dob': userController.userProfile['dob'] ?? "",
//                     'phone': userController.userProfile['phone'] ?? "",
//                     'email': userController.userProfile['email'] ?? "",
//                     'address': userController.userProfile['address'] ?? "",
//                   };
//                   if (userController.selectedAvatar.value == null) {
//                     Get.snackbar("Lỗi", "Vui lòng chọn ảnh đại diện");
//                     return;
//                   }
//                   userController.updateUserProfile(userData, userController.selectedAvatar.value!);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//                 child: const Text("Cập nhật", style: TextStyle(fontSize: 16)),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildTextField(String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:ffb_fe_flutter/app/modules/user_profile/edit_profile/controllers/edit_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditProfileController controller = Get.find<EditProfileController>();
    final ImagePicker _picker = ImagePicker();

    Future<void> _pickAvatar() async {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        controller.selectedAvatar.value = File(pickedFile.path);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa Profile"),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickAvatar,
                child: Obx(() {
                  return CircleAvatar(
                    radius: 50,
                    backgroundImage: controller.selectedAvatar.value != null
                        ? FileImage(controller.selectedAvatar.value!)
                        : controller.avatarUrl.value.isNotEmpty
                        ? NetworkImage(controller.avatarUrl.value)
                        : const AssetImage('assets/images/default_avatar.png')
                    as ImageProvider,
                  );
                }),
              ),
              const SizedBox(height: 20),
              _buildTextField("Họ và tên", controller.nameController),
              _buildTextField("Giới tính", controller.genderController),
              _buildTextField("Ngày sinh", controller.dobController),
              _buildTextField("Số điện thoại", controller.phoneController),
              _buildTextField("Email", controller.emailController),
              _buildTextField("Địa chỉ", controller.addressController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => controller.updateUserProfile(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Cập nhật", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

