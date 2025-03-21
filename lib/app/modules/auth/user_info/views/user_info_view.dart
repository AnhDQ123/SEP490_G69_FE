import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../resources/widget/header_widget.dart';
import '../controllers/user_info_controller.dart';
import 'package:intl/intl.dart';

class UserInfoView extends GetView<UserInfoController> {
  const UserInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cập nhật thông tin cá nhân",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // HeaderWidget được đặt ở đầu màn hình
          HeaderWidget(backgroundColor: Color.fromRGBO(249, 244, 241, 1)),
          // Phần form cập nhật thông tin
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Dòng tiêu đề cho avatar
                      Text(
                        "Avatar",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      // Hiển thị avatar hoặc placeholder
                      GetBuilder<UserInfoController>(
                        builder: (controller) {
                          return GestureDetector(
                            onTap: controller.pickAvatar,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: controller.avatarFile != null
                                  ? FileImage(controller.avatarFile!)
                                  : null,
                              backgroundColor: Colors.grey.shade200,
                              child: controller.avatarFile == null
                                  ? Icon(Icons.camera_alt,
                                  size: 50, color: theme.primaryColor)
                                  : null,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 30),
                      // TextField nhập tên
                      TextField(
                        controller: controller.nameController,
                        decoration: InputDecoration(
                          labelText: "Tên",
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.primaryColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // TextField nhập địa chỉ
                      TextField(
                        controller: controller.addressController,
                        decoration: InputDecoration(
                          labelText: "Địa chỉ",
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.primaryColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // Dropdown chọn giới tính
                      Obx(() {
                        return InputDecorator(
                          decoration: InputDecoration(
                            labelText: "Giới tính",
                            prefixIcon: Icon(Icons.wc),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: controller.selectedGender.value,
                              items: <String>["Nam", "Nữ", "Khác"]
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                controller.selectedGender.value = newValue!;
                              },
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 20),
                      // Phần chọn ngày sinh được thiết kế giống TextField
                      Obx(() {
                        String dobText = controller.dob.value != null
                            ? DateFormat('yyyy-MM-dd')
                            .format(controller.dob.value!)
                            : "";
                        return GestureDetector(
                          onTap: () => controller.pickDate(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: theme.primaryColor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  dobText.isEmpty
                                      ? "Nhập năm/tháng/ngày"
                                      : dobText,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: dobText.isEmpty
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),
                                Icon(Icons.calendar_today,
                                    color: theme.primaryColor),
                              ],
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 30),
                      // Nút submit cập nhật profile
                      Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.submitProfileUpdate,
                        child: controller.isLoading.value
                            ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                            : Text("Lưu thông tin",
                            style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          Color.fromRGBO(212, 163, 115, 1),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          minimumSize: Size(double.infinity, 50),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
