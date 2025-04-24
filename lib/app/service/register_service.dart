import 'dart:convert';
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
  Future<Map<String, dynamic>> updateUserProfile({
    required String phone,
    required String name,
    required String gender,
    required String dob,
    required String address,
    required String email,
    File? avatarFile,
  }) async {
    try {
      var uri = Uri.parse('${ApiBaseUrl.baseUrl}/api/users/update');
      var request = http.MultipartRequest('PUT', uri);

      // Thêm các trường dữ liệu
      request.fields['phone'] = phone;
      request.fields['name'] = name;
      request.fields['gender'] = gender;
      request.fields['dob'] = dob;
      request.fields['address'] = address;
      request.fields['email'] = email;

      // Thêm file avatar nếu có
      if (avatarFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'avatar',
            avatarFile.path,
          ),
        );
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Cập nhật thành công',
          'data': jsonResponse
        };
      } else {
        return {
          'success': false,
          'message': jsonResponse['message'] ?? 'Cập nhật thất bại'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi kết nối: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> forgotPassword({
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final uri  = Uri.parse('${ApiBaseUrl.baseUrl}/api/users/forgot');
      final resp = await http.put(uri, body: {
        'phone'          : phone,
        'password'       : password,
        'confirmPassword': confirmPassword,
      });

      // Nếu BE trả về empty hoặc plain‑text, xử lý an toàn
      String body = resp.body.trim();
      String message;
      if (body.isEmpty) {
        message = resp.statusCode == 200
            ? 'Đặt lại mật khẩu thành công'
            : 'Có lỗi xảy ra';
      } else {
        // Thử parse JSON, nếu lỗi thì coi body là chuỗi thông báo
        try {
          final json = jsonDecode(body);
          message = json is Map && json.containsKey('message')
              ? json['message']
              : body;
        } catch (_) {
          message = body;
        }
      }

      return {
        'success': resp.statusCode == 200,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi kết nối: $e',
      };
    }
  }


}

