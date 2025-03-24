import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import '../models/shop_profile.dart';
import 'package:http_parser/http_parser.dart';

import '../models/bank.dart';

class ShopService {
  final String baseUrl = "http://10.0.2.2:8080/api";

  Future<List<Bank>> fetchBanks() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.vietqr.io/v2/banks'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((e) => Bank.fromJson(e)).toList();
      } else {
        print("Lỗi HTTP ${response.statusCode}: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Lỗi tải danh sách ngân hàng: $e");
      return [];
    }
  }

  Future<ApiResponse> registerShop({
    required String name,
    required String description,
    required String address,
    required String sellType,
    required String taxCode,
    required String citizenIDNumber,
    required DateTime citizenIDExpiredDate,
    required String userId,
    required File? logo,
    required String openTime,
    required String closeTime,
    required File? citizenIDFront,
    required File? citizenIDBack,
    required File? registrationCert,
    required File? foodSafetyCert,
    required List<File> menu,
    required String selectedBankBin,
    required String bankInfo,
  }) async {
    var uri = Uri.parse('$baseUrl/shop/register');
    var request = http.MultipartRequest('POST', uri);

    // Thêm dữ liệu dạng text vào request
    request.fields['name'] = name;
    request.fields['description'] = description.isNotEmpty ? description : "";
    request.fields['address'] = address;
    request.fields['sellType'] = sellType;
    request.fields['taxCode'] = taxCode;
    request.fields['citizenIDNumber'] = citizenIDNumber;
    request.fields['citizenIDExpiredDate'] =
        "${citizenIDExpiredDate.year}-${citizenIDExpiredDate.month.toString().padLeft(2, '0')}-${citizenIDExpiredDate.day.toString().padLeft(2, '0')}";
    request.fields['userId'] = "2";
    request.fields['openTime'] = openTime; // Gửi giờ mở cửa
    request.fields['closeTime'] = closeTime; // Gửi giờ đóng cửa
    request.fields['bankBin'] = selectedBankBin;
    request.fields['bankInfo'] = bankInfo;

    // Upload file ảnh (nếu có)
    if (logo != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'logo',
        logo.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }
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
    if (registrationCert != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'registrationCert',
        registrationCert.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }
    if (foodSafetyCert != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'foodSafetyCert',
        foodSafetyCert.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    // Upload danh sách ảnh menu
    for (var image in menu) {
      request.files.add(await http.MultipartFile.fromPath(
        'menu',
        image.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print("📥 HTTP Status Code: ${response.statusCode}");
      print("📥 Response Body: $responseBody"); // ✅ Debug dữ liệu API trả về

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResponse(success: true, message: "Đăng ký thành công!");
      } else {
        // ✅ Kiểm tra responseBody có dữ liệu không trước khi decode
        if (responseBody.isNotEmpty) {
          var decodedResponse = jsonDecode(responseBody);
          return ApiResponse(
              success: false,
              message: decodedResponse['message'] ?? "Lỗi không xác định.");
        } else {
          return ApiResponse(
              success: false,
              message: "Lỗi không xác định (phản hồi rỗng từ server).");
        }
      }
    } catch (e) {
      print("❌ Lỗi khi gửi request: $e"); // ✅ In lỗi chi tiết lên console
      return ApiResponse(
          success: false, message: "Lỗi khi kết nối tới server.");
    }
  }

  Future<Map<String, int>> fetchOrderCounts(int shopId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/order/count?id=$shopId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Kiểm tra nếu data không phải là null và có các khóa mong muốn
        if (data != null) {
          Map<String, int> orderCounts = {
            'pending': data['pending'] ?? 0,
            'processing': data['processing'] ?? 0,
            'shipPending': data['shipPending'] ?? 0,
            'shipping': data['shipping'] ?? 0,
            'delivered': data['delivered'] ?? 0,
            'cancelled': data['cancelled'] ?? 0,
            'returned': data['returned'] ?? 0,
            'rejected': data['rejected'] ?? 0,
            'returnPending': data['returnPending'] ?? 0,
            'returnRejected': data['returnRejected'] ?? 0,
          };

          return orderCounts; // Trả về Map chứa số lượng đơn theo trạng thái
        } else {
          print('Dữ liệu trả về không hợp lệ');
          return {}; // Trả về map rỗng nếu dữ liệu không hợp lệ
        }
      } else {
        print('Lỗi HTTP: ${response.statusCode}');
        return {}; // Trả về map rỗng nếu lỗi HTTP
      }
    } catch (e) {
      print('Lỗi khi gọi API: $e');
      return {}; // Trả về map rỗng nếu có lỗi trong quá trình gọi API
    }
  }
}

class ApiResponse {
  final bool success;
  final String message;

  ApiResponse({required this.success, required this.message});
}
