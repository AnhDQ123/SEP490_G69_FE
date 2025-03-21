import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ShipperService {
  Future<ApiResponse> registerShipper({
    required String fullName,
    required String gender,
    required String dateOfBirth,
    required String phone,
    required String email,
    required String idNumber,
    required String idExpiryDate,
    required String licenseNumber,
    required String licenseExpiry,
    required File? idFrontImage,
    required File? idBackImage,
    required File? licenseFrontImage,
    required File? licenseBackImage,
    required File? legalRecordImage,
  }) async {
    var uri = Uri.parse('http://10.0.2.2:8080/api/shippers/register'); // đổi URL theo server của bạn
    var request = http.MultipartRequest('POST', uri);

    // Text fields
    request.fields['fullName'] = fullName;
    request.fields['gender'] = gender;
    request.fields['dateOfBirth'] = dateOfBirth;
    request.fields['phone'] = phone;
    request.fields['email'] = email;
    request.fields['idNumber'] = idNumber;
    request.fields['idExpiryDate'] = idExpiryDate;
    request.fields['licenseNumber'] = licenseNumber;
    request.fields['licenseExpiry'] = licenseExpiry;

    // File fields
    if (idFrontImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'idFrontImage',
        idFrontImage.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    if (idBackImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'idBackImage',
        idBackImage.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    if (licenseFrontImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'licenseFrontImage',
        licenseFrontImage.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    if (licenseBackImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'licenseBackImage',
        licenseBackImage.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    if (legalRecordImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'legalRecordImage',
        legalRecordImage.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print("📥 HTTP Status Code: ${response.statusCode}");
      print("📥 Response Body: $responseBody");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(success: true, message: "Đăng ký thành công!");
      } else {
        if (responseBody.isNotEmpty) {
          var decoded = jsonDecode(responseBody);
          return ApiResponse(success: false, message: decoded['message'] ?? "Đăng ký thất bại.");
        } else {
          return ApiResponse(success: false, message: "Phản hồi rỗng từ server.");
        }
      }
    } catch (e) {
      print("❌ Lỗi gửi API: $e");
      return ApiResponse(success: false, message: "Không thể kết nối tới server.");
    }
  }
}

class ApiResponse {
  final bool success;
  final String message;

  ApiResponse({required this.success, required this.message});
}
