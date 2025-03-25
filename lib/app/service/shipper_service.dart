import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/order.dart';

class ShipperService {
  // final String baseUrl = "http://192.168.130.88:8080/api";
  final String baseUrl = "http://10.0.2.2:8080/api";

  Future<ApiResponse> registerShipper({
    required int userId, // ✅ Thêm userId vào API request
    required String name,
    required String gender,
    required String dob, // yyyy-MM-dd
    required String phone,
    required String email,
    required String citizenIDNumber,
    required String citizenIDExpiredDate, // yyyy-MM-dd
    required String drivingLicenseExpiredDate, // yyyy-MM-dd
    required File? citizenIDFront,
    required File? citizenIDBack,
    required File? drivingLicenseFront,
    required File? drivingLicenseBack,
    required File? judicialRecord,
  }) async {
    var uri = Uri.parse('$baseUrl/shippers/register/$userId');

    var request = http.MultipartRequest('POST', uri);

    // ✅ Gửi đúng tên trường theo Backend
    request.fields['name'] = name;
    request.fields['gender'] = gender;
    request.fields['dob'] = dob;
    request.fields['phone'] = phone;
    request.fields['email'] = email;
    request.fields['citizenIDNumber'] = citizenIDNumber;
    request.fields['citizenIDExpiredDate'] = citizenIDExpiredDate;
    request.fields['drivingLicenseExpiredDate'] = drivingLicenseExpiredDate;

    // ✅ Gửi đúng tên file theo Backend
    if (citizenIDFront != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'citizenIDFront',
        citizenIDFront.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    if (citizenIDBack != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'citizenIDBack',
        citizenIDBack.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    if (drivingLicenseFront != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'drivingLicenseFront',
        drivingLicenseFront.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    if (drivingLicenseBack != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'drivingLicenseBack',
        drivingLicenseBack.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    if (judicialRecord != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'judicialRecord',
        judicialRecord.path,
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
          return ApiResponse(
              success: false,
              message: decoded['message'] ?? "Đăng ký thất bại.");
        } else {
          return ApiResponse(
              success: false, message: "Phản hồi rỗng từ server.");
        }
      }
    } catch (e) {
      print("❌ Lỗi gửi API: $e");
      return ApiResponse(
          success: false, message: "Không thể kết nối tới server.");
    }
  }

  Future<List<Order>> fetchOrdersByShipper(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/order/shipper?id=$userId'),
      );

      if (response.statusCode == 200) {
        final data =
            jsonDecode(utf8.decode(response.bodyBytes)); // ✅ decode đúng UTF-8

        // Lấy danh sách đơn hàng từ trường "content"
        final List<dynamic> ordersJson = data['content'];

        // Convert từng item thành Order
        return ordersJson.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi khi lấy đơn hàng: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối tới server: $e');
    }
  }

  Future<ApiResponse> acceptShipping(
      {required int orderId, required int userId}) async {
    final url =
        Uri.parse('$baseUrl/order/acceptShip?id=$orderId&userId=$userId');

    try {
      final response = await http.post(url);

      print("📦 [acceptShipping] Status: ${response.statusCode}");
      print("📦 [acceptShipping] Body: ${response.body}");

      if (response.statusCode == 200) {
        return ApiResponse(success: true, message: "Nhận đơn thành công");
      } else {
        return ApiResponse(
            success: false, message: "Không thể nhận đơn: ${response.body}");
      }
    } catch (e) {
      print("❌ Lỗi khi gọi acceptShipping: $e");
      return ApiResponse(success: false, message: "Lỗi kết nối đến server.");
    }
  }

  Future<ApiResponse> confirmDelivery({
    required int orderId,
    required int userId,
    required String status,
    required File avatarImage,
  }) async {
    final uri = Uri.parse('$baseUrl/order/changeStatus');

    var request = http.MultipartRequest('POST', uri)
      ..fields['id'] = orderId.toString()
      ..fields['userId'] = userId.toString()
      ..fields['status'] = status
      ..files.add(await http.MultipartFile.fromPath(
        'avatar',
        avatarImage.path,
        contentType: MediaType('image', 'jpeg'), // hoặc 'png' tùy file
      ));

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("🚚 [confirmDelivery] Status: ${response.statusCode}");
      print("🚚 [confirmDelivery] Body: $responseBody");

      if (response.statusCode == 200) {
        return ApiResponse(
            success: true, message: "Đơn đã được xác nhận giao thành công.");
      } else {
        return ApiResponse(
            success: false, message: "Lỗi xác nhận đơn: $responseBody");
      }
    } catch (e) {
      print("❌ Lỗi khi gọi confirmDelivery: $e");
      return ApiResponse(success: false, message: "Lỗi kết nối đến server.");
    }
  }
}

class ApiResponse {
  final bool success;
  final String message;

  ApiResponse({required this.success, required this.message});
}
