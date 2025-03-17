import 'dart:convert';
import 'package:http/http.dart' as http;
import '../base/base_api_url.dart';
import '../models/product_detail_model.dart';
import '../models/similar_product.dart';

class ProductDetailApiService {
  // Sử dụng baseUrl từ ApiBaseUrl
  final String baseUrl = ApiBaseUrl.baseUrl + "/api/product";

  Future<ProductDetailModel> getProductDetail(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = jsonDecode(response.body);
      if (data == null) {
        throw Exception("Response data is null");
      }
      return ProductDetailModel.fromJson(data);
    } else {
      throw Exception("Failed to load product detail: ${response.statusCode}");
    }
  }

  Future<List<SimilarProduct>> getSimilarProducts(String keyword) async {
    final uri = Uri.parse("$baseUrl/similar").replace(queryParameters: {"search": keyword});
    final response = await http.get(uri);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => SimilarProduct.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load similar products: ${response.statusCode}");
    }
  }

  Future<List<SimilarProduct>> getProductsByShop(String shopId, {int page = 1, int size = 20}) async {
    final uri = Uri.parse("$baseUrl/shop/$shopId").replace(queryParameters: {
      "page": page.toString(),
      "size": size.toString(),
    });
    final response = await http.get(uri);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => SimilarProduct.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load products by shop: ${response.statusCode}");
    }
  }



}
