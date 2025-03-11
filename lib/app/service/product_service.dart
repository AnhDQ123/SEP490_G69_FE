import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';


class ProductService {
  static const String BASE_URL = "http://10.0.2.2:8080/api";

  // Lấy danh sách sản phẩm
    Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse("$BASE_URL/shop/1"));

      if (response.statusCode == 200) {
        // Giải mã UTF-8 đúng cách
        String utf8Body = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(utf8Body);

        List<Product> products = (jsonData["content"] as List)
            .map((item) => Product.fromJson(item))
            .toList();

        return products;
      } else {
        throw Exception("Failed to load products. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }

  // Lấy chi tiết sản phẩm
  static Future<Product?> fetchProductDetail(int productId) async {
    try {
      final response = await http.get(Uri.parse("$BASE_URL/product/$productId"));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return Product.fromJson(data);
      }
      return null;
    } catch (e) {
      print("❌ Lỗi khi tải chi tiết sản phẩm: $e");
      return null;
    }
  }


  // Hàm gửi API tạo sản phẩm
  // Hàm gửi API tạo sản phẩm
  static Future<bool> createProduct(Product product, File? avatar, List<File> options) async {
    final String baseUrl = "http://10.0.2.2:8080/api/add"; // Thay thế bằng API thật của bạn

    try {
      var request = http.MultipartRequest("POST", Uri.parse(baseUrl));

      // 🟢 Thêm dữ liệu dạng `form-data`
      request.fields["name"] = product.name;
      request.fields["description"] = product.description ?? "";
      request.fields["category_id"] = product.category.toString();
      request.fields["quantity"] = product.quantity.toString();
      request.fields["expiryDate"] = product.expiryDate ?? ""; // Nếu null, gửi chuỗi rỗng
      request.fields["shop_id"] = "1"; // Shop ID có thể cần lấy từ `user session`
      request.fields["supplier"] = product.supplier ?? "";

      // 🟢 Gửi danh sách `foodOptions` theo dạng `form-data`
      for (int i = 0; i < product.foodOptions!.length; i++) {
        var option = product.foodOptions![i];
        request.fields["foodOption[$i].name"] = option.name ?? ""; // Nếu null, gửi chuỗi rỗng
        request.fields["foodOption[$i].price"] = option.price.toString();
      }

      // 🟢 Gửi ảnh đại diện (avatar) nếu có
      if (avatar != null) {
        request.files.add(await http.MultipartFile.fromPath("avatar", avatar.path));
      }

      // 🟢 Gửi danh sách ảnh `option`
      for (var optionFile in options) {
        request.files.add(await http.MultipartFile.fromPath("option", optionFile.path));
      }

      // 🟢 Debug dữ liệu gửi lên server
      print("📡 Dữ liệu gửi lên server: ${request.fields}");
      print("📡 Danh sách file đính kèm: ${request.files.map((f) => f.filename)}");

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print("📡 Response Status Code: ${response.statusCode}");
      print("📡 Response Body: $responseBody");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ Lỗi ngoại lệ khi gửi API: $e");
      return false;
    }
  }
}
