import 'dart:io';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';
import '../base/api_base_url.dart';

class UserService extends GetConnect {
  Future<Map<String, dynamic>?> fetchUserProfile(int userId) async {
    final response = await get('${ApiBaseUrl.baseUrl}/api/users/$userId');
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print("Error fetching user profile: ${response.statusCode}");
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateUserProfile(
      Map<String, String> userData, File avatar) async {
    final formData = FormData({
      ...userData,
      'avatar': MultipartFile(
        avatar,
        filename: avatar.path.split('/').last,
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
}
