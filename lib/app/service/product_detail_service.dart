import 'dart:convert';
import 'package:ffb_fe_flutter/app/models/product.dart';
import 'package:http/http.dart' as http;
import '../base/api_base_url.dart';


class ProductDetailApiService {
  // Sử dụng baseUrl từ ApiBaseUrl
  final String baseUrl = ApiBaseUrl.baseUrl + "/api/product";

  Future<Product> getProductDetail(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = jsonDecode(response.body);
      if (data == null) {
        throw Exception("Response data is null");
      }
      return Product.fromJson(data);
    } else {
      throw Exception("Failed to load product detail: ${response.statusCode}");
    }
  }

  // Future<List<SimilarProduct>> getSimilarProducts(String keyword) async {
  //   final uri = Uri.parse("$baseUrl/similar").replace(queryParameters: {"search": keyword});
  //   final response = await http.get(uri);
  //
  //   if (response.statusCode == 200 && response.body.isNotEmpty) {
  //     final List<dynamic> data = jsonDecode(response.body);
  //     return data.map((json) => SimilarProduct.fromJson(json)).toList();
  //   } else {
  //     throw Exception("Failed to load similar products: ${response.statusCode}");
  //   }
  // }

  Future<List<Product>> getSimilarProducts(String keyword) async {
    if (keyword.trim().length < 2) {
      return [];
    }

    final uri = Uri.parse("$baseUrl/similar").replace(queryParameters: {"search": keyword});
    final response = await http.get(uri);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load similar products: ${response.statusCode}");
    }
  }


  Future<List<Product>> getProductsByShop(String shopId, {int page = 1, int size = 20}) async {
    final uri = Uri.parse("$baseUrl/shop/$shopId").replace(queryParameters: {
      "page": page.toString(),
      "size": size.toString(),
    });
    final response = await http.get(uri);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load products by shop: ${response.statusCode}");
    }
  }

  Future<List<Product>> getMenuByShopId(String shopId, {int page = 1, int size = 20}) async {
    final uri = Uri.parse("$baseUrl/shop/$shopId").replace(queryParameters: {
      "page": page.toString(),
      "size": size.toString(),
    });

    final response = await http.get(uri);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load menu by shop: ${response.statusCode}");
    }
  }



}