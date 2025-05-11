import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import '../base/api_base_url.dart';
import '../models/product.dart';
import '../models/product_discount.dart';
import '../models/top_product.dart';
import '../modules/shop_menu/controllers/shop_controller.dart';


class ProductService {
  // Lấy danh sách sản phẩm
  Future<List<Product>> fetchProducts(productId) async {
    try {
      final response = await http.get(Uri.parse("${ApiBaseUrl.baseUrl}/api/shop/${productId}"));

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
  static Future<ProductDiscount?> fetchProductDetail(int productId) async {
    try {
      final response = await http.get(Uri.parse("${ApiBaseUrl.baseUrl}/api/product/$productId"));
      print('🟢 [1.API RAW RESPONSE] ProductID: $productId | Options: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        ProductDiscount product = ProductDiscount.fromJson(data);
        print('🟢 [2.PARSED OPTIONS] Product: ${product.name}');
        product.foodOptions?.forEach((opt) {
          print('      → OptionID: ${opt.id} | Name: ${opt.name} | Price: ${opt.price}');
        });
        return product;
      }
      return null;
    } catch (e) {
      print("❌ Lỗi khi tải chi tiết sản phẩm: $e");
      return null;
    }
  }

  // Hàm gửi API tạo sản phẩm
  static Future<bool> createProduct(ProductDiscount product, File? avatar, List<File> options) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse("${ApiBaseUrl.baseUrl}/api/product/add"));

      // 🟢 Thêm dữ liệu dạng `form-data`
      request.fields["name"] = product.name ?? "Default Name";
      request.fields["description"] = product.description ?? "";
      request.fields["category"] = product.category.toString();
      request.fields["quantity"] = product.quantity.toString();
      request.fields["shopId"] =  Get.find<ShopController>().shopId.toString();
      request.fields["supplier"] = product.supplier ?? "";
      request.fields["manufacturer"] = product.manufacturer ?? "";
      request.fields["foodType"] = product.type.toString();

      // 🟢 Gửi danh sách `foodOptions` theo dạng `form-data`
      for (int i = 0; i < product.foodOptions!.length; i++) {
        var option = product.foodOptions![i];
        request.fields["foodOption[$i].name"] = option.name ??  "Default Option Name";
        request.fields["foodOption[$i].price"] = option.price.toString();
        request.fields["foodOption[$i].type_id"] = option.typeId.toString();
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

  static Future<bool> updateProduct(ProductDiscount product, File? avatar, List<File> options, productId) async {
    try {
      var request = http.MultipartRequest("PUT", Uri.parse("${ApiBaseUrl.baseUrl}/api/product/update/$productId"));

      // 🟢 Thêm dữ liệu dạng `form-data`
      request.fields["name"] = product.name;
      request.fields["description"] = product.description ?? "";
      request.fields["category"] = product.category.toString();
      request.fields["foodType"] = product.type.toString();
      request.fields["quantity"] = product.quantity.toString();
      request.fields["shopId"] = Get.find<ShopController>().shopId.toString(); ///Change here
      request.fields["supplier"] = product.supplier ?? "";
      request.fields["manufacturer"] = product.manufacturer ?? "";

      // 🟢 Gửi danh sách `foodOptions` theo dạng `form-data`
      for (int i = 0; i < product.foodOptions!.length; i++) {
        var option = product.foodOptions![i];
        request.fields["foodOption[$i].id"] = option.id.toString();
        request.fields["foodOption[$i].name"] = option.name ?? ""; // Nếu null, gửi chuỗi rỗng
        request.fields["foodOption[$i].price"] = option.price.toString();
        request.fields["foodOption[$i].type_id"] = option.typeId.toString();
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
      print("📡 ID sản phẩm: ${productId}");
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

  Future<List<Map<String, dynamic>>> getTopSellingProductsToday(String shopId) async {
    final uri = Uri.parse('${ApiBaseUrl.baseUrl}/api/product/top-selling/today?shopId=$shopId');

    final response = await http.get(uri);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((product) {
        return {
          'id': product[0],
          'name': product[1],
          'totalQuantity': product[2],
        };
      }).toList();
    } else {
      throw Exception('Failed to load top-selling products today');
    }
  }

  Future<List<TopProduct>> getTopSellingProductsThisMonth(String shopId) async {
    final uri = Uri.parse('${ApiBaseUrl.baseUrl}/api/product/top-selling/month?shopId=$shopId');

    final response = await http.get(uri);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TopProduct.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load top-selling products');
    }
  }


  // API để lấy sản phẩm bán chạy nhất trong năm nay
  Future<List<Map<String, dynamic>>> getTopSellingProductsThisYear(String shopId) async {
    final uri = Uri.parse('${ApiBaseUrl.baseUrl}/api/product/top-selling/year?shopId=$shopId');

    final response = await http.get(uri);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((product) {
        return {
          'id': product[0],
          'name': product[1],
          'totalQuantity': product[2],
        };
      }).toList();
    } else {
      throw Exception('Failed to load top-selling products this year');
    }
  }

  Future<List<Product>> fetchAllProducts({int page = 1, int size = 20}) async {
    try {
      final uri = Uri.parse(
          "${ApiBaseUrl.baseUrl}/api/product/all?page=$page&size=$size"
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Giải mã dữ liệu trả về, giả sử cấu trúc JSON có trường "content" chứa danh sách sản phẩm
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

  Future<bool> deleteProduct(int id) async {
    try {
      final uri = Uri.parse("${ApiBaseUrl.baseUrl}/api/product/delete/$id");

      final response = await http.put(uri);

      if (response.statusCode == 200) {
        print("✅ Sản phẩm đã được xóa: ID = $id");
        return true;
      } else {
        print("❌ Lỗi khi xóa sản phẩm. Mã lỗi: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("❌ Lỗi ngoại lệ khi xóa sản phẩm: $e");
      return false;
    }
  }

}


