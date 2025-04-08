import 'dart:io';

import 'package:get/get.dart';
import '../base/api_base_url.dart';
import '../models/user_profile.dart';
import '../models/user_role_profile.dart';

class UserService extends GetConnect {
  Future<UserProfile?> fetchUserProfile(int userId) async {
    final response = await get('${ApiBaseUrl.baseUrl}/api/users/$userId');
    if (response.statusCode == 200) {
      return UserProfile.fromJson(response.body);
    } else {
      print("Error fetching user profile: ${response.statusCode}");
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateUserProfile(Map<String, String> userData,
      File avatar) async {
    final formData = FormData({
      ...userData,
      'avatar': MultipartFile(
        avatar,
        filename: avatar.path
            .split('/')
            .last,
        contentType: "image/jpeg",
      ),
    });

    final response =
    await post('${ApiBaseUrl.baseUrl}/api/users/update', formData);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print("Error updating user profile: ${response.statusCode}");
      return null;
    }
  }

  Future<dynamic> fetchUserShop(int userId) async {
    final response = await get('${ApiBaseUrl.baseUrl}/api/users/shop?id=$userId');

    if (response.statusCode == 200) {
      if (response.body is String) {
        // Kiểm tra nếu body trả về là một chuỗi
        print("Thông báo lỗi từ API: ${response.body}");  // In ra thông báo từ API
        return response.body;  // Trả về thông báo lỗi nếu là chuỗi
      } else if (response.body is Map<String, dynamic>) {
        // Nếu body trả về là một Map, bạn có thể xử lý dữ liệu cửa hàng
        print("Thông tin cửa hàng: ${response.body}");
        return response.body;  // Trả về thông tin cửa hàng
      } else {
        // Nếu body có định dạng khác, bạn sẽ không xử lý được, trả về thông báo lỗi
        print("Error: Unexpected response body format.");
        return "Error: Unexpected response body format.";
      }
    } else {
      print("Error fetching user shop: ${response.statusCode}");
      return null;
    }
  }

  Future<UserRoleProfile?> fetchUserRoleProfile(int userId) async {
    try {
      final response = await get('${ApiBaseUrl.baseUrl}/api/users/profile/$userId');

      if (response.statusCode == 200) {
        return UserRoleProfile.fromJson(response.body);
      } else if (response.statusCode == 404) {
        print("User not found");
        return null;
      } else {
        print("Error fetching user role profile: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception in fetchUserRoleProfile: $e");
      return null;
    }
  }


}

