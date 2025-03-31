import 'dart:convert';
import 'dart:io';
import 'package:ffb_fe_flutter/app/models/product_discount.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import '../models/discount.dart';
import '../models/product.dart';
import '../models/shop_profile.dart';
import 'package:http_parser/http_parser.dart';

import '../models/bank.dart';
import '../models/voucher.dart';

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
    required File? backgroundImage,
    required File? logo,
    required String openTime,
    required String closeTime,
    required File? citizenIDFront,
    required File? citizenIDBack,
    required File? registrationCert,
    required File? foodSafetyCert,
    required File? menu,
    required String selectedBankBin,
    required String bankInfo,
  }) async {
    var uri = Uri.parse('$baseUrl/shops/register');
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
    if (backgroundImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'background',
        backgroundImage.path,
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

    if (menu != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'menu',
        menu.path,
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

  Future<ShopProfile> fetchShopProfile(int shopId) async {
    final url = Uri.parse('$baseUrl/shops/$shopId');
    print('👉 Đang gọi API: $url');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // ✅ Giải mã UTF-8 thủ công
      final decodedBody = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedBody);

      print('✅ Dữ liệu JSON nhận được: $data');

      final shop = ShopProfile.fromJson(data);

      print('🔍 Thông tin cửa hàng:');
      print('📌 Tên: ${shop.name}');
      print('📍 Địa chỉ: ${shop.address}');
      print('📞 SĐT: ${shop.phone}');
      print('🕖 Giờ mở cửa: ${shop.openTime} - ${shop.closeTime}');
      print('🚚 Giao hàng: ${shop.isShipping ? "Có" : "Không"}');
      print('👤 Chủ shop: ${shop.owner.profile.name} (${shop.owner.email})');
      print('⭐ Đánh giá: ${shop.rate} | Lượt xem: ${shop.viewCount}');

      return shop;
    } else {
      print('❌ Lỗi khi gọi API: ${response.statusCode}');
      throw Exception('Không thể tải dữ liệu cửa hàng');
    }
  }

  Future<void> updateShop({
    required int shopId,
    required String name,
    required String description,
    required String phone,
    required String address,
    required TimeOfDay openTime,
    required TimeOfDay closeTime,
    String? taxCode,
    String? citizenIDNumber,
    String? accountNumber,
    String? bankCode,
    String? citizenIDExpiredDate, // định dạng yyyy-MM-dd
    File? logoFile,
    File? backgroundFile,
    File? menuFile,
    File? citizenIDFront,
    File? citizenIDBack,
    File? registrationCert,
    File? foodSafetyCert,
  }) async {
    var uri = Uri.parse('$baseUrl/shops/$shopId');
    var request = http.MultipartRequest('PUT', uri);

    // ⏰ Convert TimeOfDay -> HH:mm:ss
    String formatTime(TimeOfDay t) =>
        "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00";

    // 📝 Add form fields
    request.fields.addAll({
      'name': name,
      'description': description,
      'phone': phone,
      'address': address,
      'openTime': formatTime(openTime),
      'closeTime': formatTime(closeTime),
      'taxCode': taxCode ?? '',
      'citizenIDNumber': citizenIDNumber ?? '',
      'accountNumber': accountNumber ?? '',
      'bankCode': bankCode ?? '',
      'citizenIDExpiredDate': citizenIDExpiredDate ?? '',
    });

    // 📎 Helper to attach file
    Future<void> attachFile(String fieldName, File? file) async {
      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath(
          fieldName,
          file.path,
          contentType: MediaType('image', 'jpeg'), // tùy định dạng
        ));
      }
    }

    await attachFile('logo', logoFile);
    await attachFile('background', backgroundFile);
    await attachFile('menu', menuFile);
    await attachFile('citizenIDFront', citizenIDFront);
    await attachFile('citizenIDBack', citizenIDBack);
    await attachFile('registrationCert', registrationCert);
    await attachFile('foodSafetyCert', foodSafetyCert);

    // 📤 Gửi request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      print("✅ Cập nhật shop thành công!");
    } else {
      print("❌ Lỗi cập nhật shop: ${response.statusCode}");
      print("💥 Body: ${response.body}");
      throw Exception("Cập nhật thất bại");
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

  Future<List<ProductDiscount>> fetchProductsByShop(int shopId) async {
    final response = await http.get(Uri.parse('$baseUrl/product/shop/$shopId'));

    if (response.statusCode == 200) {
      // Giải mã dữ liệu UTF-8
      final decodedBody = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(decodedBody);

      final List<dynamic> productList = jsonData['content'];

      // In log danh sách sản phẩm raw JSON để kiểm tra
      print('Danh sách sản phẩm (raw JSON): $productList');

      return productList.map((item) {
        // Parse discount như List<Discount>
        List<Discount> discountList = [];
        if (item['discount'] != null) {
          discountList = (item['discount'] as List).map((discountItem) {
            return Discount.fromJson(discountItem);
          }).toList();
        }

        // In log từng sản phẩm sau khi parse
        print('Đang xử lý sản phẩm: ${item['name']} - Trạng thái: ${item['status']}');

        return ProductDiscount(
          id: item['id'] ?? 0,
          name: item['name'] ?? '',
          manufacturer: item['manufacturer'] ?? '',
          supplier: item['supplier'] ?? '',
          quantity: item['quantity'] ?? 0,
          category: item['category'] ?? '',
          status: item['status'] ?? '',
          discount: discountList,  // Truyền discountList đã được parse đúng kiểu
          image: item['image'] ?? '',
          description: item['description'] ?? '',
          rate: (item['rate'] as num?)?.toDouble() ?? 0.0,
          shop: item['shopName'] ?? '',
          defaultPrice: (item['defaultPrice'] as num?)?.toDouble() ?? 0.0,
          foodOptions: [],
        );
      }).toList();
    } else {
      throw Exception('Không thể tải danh sách sản phẩm');
    }
  }


  ///Discount
  Future<ApiResponse> addDiscount({required Discount discount,required int productId}) async {
    try {
      final uri = Uri.parse('$baseUrl/discount/add?productId=$productId');
      final request = http.Request('POST', uri);

      final body = jsonEncode({
        'amount': discount.amount,  // Đã chia 100 trong controller rồi
        'startDate': discount.startDate, // Định dạng yyyy-MM-dd
        'endDate': discount.endDate,
      });

      request.body = body;
      request.headers['Content-Type'] = 'application/json';

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(success: true, message: "Discount added successfully!");
      } else {
        print("❌ Error: ${response.statusCode} - $responseBody");
        return ApiResponse(success: false, message: "Failed to add discount.");
      }
    } catch (e) {
      print("❌ Exception while adding discount: $e");
      return ApiResponse(success: false, message: "An error occurred while adding the discount.");
    }
  }

  Future<void> updateDiscountToProduct(int productId, Discount discount) async {
    final url = Uri.parse('$baseUrl/discount/add?productId=$productId');

    final body = jsonEncode({
      'id': discount.id,
      'amount': discount.amount,
      'startDate': discount.startDate, // phải là yyyy-MM-ddTHH:mm:ss
      'endDate': discount.endDate,
      'status': discount.status,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Cập nhật giảm giá thất bại');
    }
  }

  Future<ApiResponse> deleteDiscount(int discountId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/discount/$discountId'));

      if (response.statusCode == 200) {
        return ApiResponse(success: true, message: "Huỷ thành công");
      } else {
        return ApiResponse(success: false, message: "Xoá thất bại (${response.statusCode})");
      }
    } catch (e) {
      return ApiResponse(success: false, message: "Lỗi khi xoá: $e");
    }
  }


  ///Voucher
  Future<List<Voucher>> fetchVouchersByShop(int shopId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/vouchers/shop/$shopId'),  // API route mới cho voucher theo shop
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // In ra dữ liệu nhận được từ API
      print('Received data: $data');

      // Chuyển đổi dữ liệu thành danh sách Voucher
      List<Voucher> vouchers = data.map((item) => Voucher.fromJson(item)).toList();

      // In ra thông tin các Voucher sau khi chuyển đổi
      for (var voucher in vouchers) {
        print('Voucher: ${voucher.toString()}');  // In chi tiết từng voucher
      }

      return vouchers;
    } else {
      throw Exception('Failed to load vouchers');
    }
  }

  Future<ApiResponse> addVoucher(Voucher voucher) async {
    try {
      final uri = Uri.parse('$baseUrl/vouchers');

      final body = jsonEncode({
        'code': voucher.code,
        'discountType': voucher.discountType,
        'discountValue': voucher.discountValue,
        'minOrderValue': voucher.minOrderValue,
        'totalVouchers': voucher.totalVouchers,
        'usedVouchers': voucher.usedVouchers,
        'startDate': voucher.startDate,
        'endDate': voucher.endDate,
        'status': voucher.status,
        'maxUsagePerCustomer': voucher.maxUsagePerCustomer,
        'shopId': voucher.shopId,
      });

      final response = await http.post(
        uri,
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return ApiResponse(success: true, message: 'Voucher đã được tạo');
      } else {
        return ApiResponse(success: false, message: 'Tạo thất bại: ${response.body}');
      }
    } catch (e) {
      return ApiResponse(success: false, message: 'Lỗi: $e');
    }
  }

  Future<ApiResponse> updateVoucher(String code, Voucher voucher) async {
    try {
      final uri = Uri.parse('$baseUrl/vouchers/$code');

      final body = jsonEncode({
        'code': voucher.code,
        'discountType': voucher.discountType,
        'discountValue': voucher.discountValue,
        'minOrderValue': voucher.minOrderValue,
        'totalVouchers': voucher.totalVouchers,
        'usedVouchers': voucher.usedVouchers,
        'startDate': voucher.startDate, // "2025-03-30"
        'endDate': voucher.endDate,
        'status': voucher.status,
        'maxUsagePerCustomer': voucher.maxUsagePerCustomer,
        // ⚠️ Không cần gửi 'isStackable'
      });

      final response = await http.put(
        uri,
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return ApiResponse(success: true, message: 'Voucher đã được cập nhật');
      } else {
        return ApiResponse(success: false, message: 'Lỗi: ${response.body}');
      }
    } catch (e) {
      return ApiResponse(success: false, message: 'Lỗi: $e');
    }
  }

  Future<ApiResponse> deleteVoucher(String code) async {
    try {
      final uri = Uri.parse('$baseUrl/vouchers/$code');
      final response = await http.delete(uri);

      if (response.statusCode == 204) {
        return ApiResponse(success: true, message: 'Voucher đã xoá');
      } else {
        return ApiResponse(success: false, message: 'Xoá thất bại: ${response.body}');
      }
    } catch (e) {
      return ApiResponse(success: false, message: 'Lỗi: $e');
    }
  }


}

class ApiResponse {
  final bool success;
  final String message;

  ApiResponse({required this.success, required this.message});
}
