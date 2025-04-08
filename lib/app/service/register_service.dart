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
      String phone, String email, String password) async {
    try {
      final response = await _apiService.fetchDataObjectWithPost<Map<String, dynamic>>(
        "${ApiBaseUrl.baseUrl}/api/users/add",
            (json) => json, // Không cần parse, trả về nguyên bản
        body: {
          "phone": phone,
          "email": email,
          "password": password
        },
        isUsingToken: false,
      );

      // Debug response
      print('API Response: $response');

      // Xử lý cả trường hợp response có hoặc không có key 'data'
      final responseData = response.containsKey('data') ? response['data'] : response;

      if (responseData.containsKey('id') || responseData.containsKey('user_id')) {
        return {
          'success': true,
          'message': 'Đăng ký thành công!',
          'user_id': responseData['id'] ?? responseData['user_id'],
          'phone': phone
        };
      } else {
        // Nếu không có id, dùng phone làm identifier
        return {
          'success': true,
          'message': 'Đăng ký thành công!',
          'phone': phone
        };
      }
    } catch (e) {
      print('Error in registerUser: $e');
      return {
        'success': false,
        'message': e.toString().contains('Exception:')
            ? e.toString().split('Exception:')[1]
            : 'Đăng ký thất bại'
      };
    }
  }


  Future<Map<String, dynamic>> updateUserProfile(
      String phone, // Nhận phone thay vì userId
      String name,
      String gender,
      String dob,
      String address,
      dynamic avatar,
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

      // Sử dụng phone thay vì userId trong fields
      Map<String, String> fields = {
        "phone": phone, // Thay id bằng phone
        "name": name,
        "gender": gender,
        "dob": dob,
        "address": address,
      };

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
        return {'success': false, 'message': 'Cập nhật thất bại'};
      }
    } catch (e) {
      print("Error in updateUserProfile: $e");
      return {'success': false, 'message': 'Lỗi hệ thống: $e'};
    }
  }
}

