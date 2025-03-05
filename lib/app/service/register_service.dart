import 'dart:io';
import 'dart:typed_data';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:http/http.dart' as http;
import '../base/api_service.dart';
import '../base/api_base_url.dart';

class RegisterService {
  final ApiService _apiService = ApiService();

  // Send OTP to phone
  Future<bool> sendOtp(String phone) async {
    try {
      final String apiUrl = "${ApiBaseUrl.baseUrl}/otp/send";
      bool result = await _apiService.validationWithPost(
        apiUrl,
        body: {"phone": phone},
        isUsingToken: false,
      );
      return result;
    } catch (e) {
      print("Error in sendOtp: $e");
      return false;
    }
  }

  // Verify OTP
  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      final String apiUrl = "${ApiBaseUrl.baseUrl}/otp/verify";
      bool result = await _apiService.validationWithPost(
        apiUrl,
        body: {"phone": phone, "otp": otp},
        isUsingToken: false,
      );
      return result;
    } catch (e) {
      print("Error in verifyOtp: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> registerUser(
      String phone, String email, String username, String password) async {
    try {
      final String apiUrl = "${ApiBaseUrl.baseUrl}/api/users/add";

      // Giả sử backend trả về JSON object chứa thông tin user
      final dynamic response = await _apiService.fetchDataObjectWithPost(
        apiUrl,
            (json) => json, // Trả về JSON Map
        body: {
          "phone": phone,
          "email": email,
          "username": username,
          "password": password
        },
        isUsingToken: false,
      );

      if (response is Map<String, dynamic> && response.containsKey('id')) {
        return {
          'success': true,
          'message': 'Đăng ký thành công!',
          'user_id': response['id']
        };
      } else {
        return {
          'success': false,
          'message': 'Lỗi: Không có user_id trong phản hồi.'
        };
      }
    } catch (e) {
      print("Error in registerUser: $e");
      return {
        'success': false,
        'message': 'Đăng ký thất bại. Vui lòng thử lại!'
      };
    }
  }


  Future<Map<String, dynamic>> updateUserProfile(
      String userId,
      String name,
      String gender,
      String dob,
      String address,
      dynamic avatar, // có thể là File (mobile) hoặc Uint8List (web)
      ) async {
    try {
      final String apiUrl = "${ApiBaseUrl.baseUrl}/api/users/update";

      Uint8List avatarBytes;
      String filename = "avatar.jpg";
      if (avatar is File) {
        avatarBytes = await avatar.readAsBytes();
      } else if (avatar is Uint8List) {
        avatarBytes = avatar;
      } else {
        throw Exception("Invalid avatar type");
      }

      // Tạo map các trường cần gửi
      Map<String, String> fields = {
        "id": userId,
        "name": name,
        "gender": gender,
        "dob": dob,
        "address": address,
        // "employee.id": userId,
        // "employee.name": name,
        // "employee.gender": gender,
        // "employee.dob": dob,
        // "employee.address": address,
      };
      print("Fields gửi đi: $fields");


      // Tạo multipart file từ avatarBytes
      var multipartFile = http.MultipartFile.fromBytes("avatar", avatarBytes, filename: filename);

      final response = await _apiService.postMultipart(
        apiUrl,
        fields: fields,
        files: [multipartFile],
        isUsingToken: false,
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Cập nhật thành công!'};
      } else {
        return {'success': false, 'message': 'Cập nhật thất bại, vui lòng thử lại.'};
      }
    } catch (e) {
      print("Error in updateUserProfile: $e");
      return {'success': false, 'message': 'Cập nhật thất bại.'};
    }
  }
}

