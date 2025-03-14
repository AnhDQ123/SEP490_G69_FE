import 'package:get/get.dart';
import '../base/api_base_url.dart';
import '../models/category.dart';
import '../models/product.dart';

class HomeApiService extends GetConnect {
  final String baseUrl = ApiBaseUrl.baseUrl;

  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
    super.onInit();
  }

  /// Lấy danh sách category từ API: GET /api/category
  Future<List<Category>> fetchCategories() async {
    final response = await get('/api/category');
    if (response.status.hasError) {
      return Future.error('Error fetching categories: ${response.statusText}');
    } else {
      // Ép kiểu về List<dynamic> trước
      final List<dynamic> rawData = response.body;
      // Map mỗi phần tử JSON thành đối tượng Category
      return rawData.map((json) => Category.fromJson(json)).toList();
    }
  }


  Future<List<Product>> fetchAllProducts() async {
    final response = await get('/api/product/all');
    if (response.status.hasError) {
      return Future.error('Error fetching all products: ${response.statusText}');
    } else {
      // Giả sử API trả về danh sách JSON của các sản phẩm
      final List<dynamic> rawData = response.body;
      return rawData.map((json) => Product.fromJson(json)).toList();
    }
  }

  Future<List<Product>> fetchPopularProducts() async {
    final response = await get('/api/product/getPopular');
    if (response.status.hasError) {
      return Future.error('Error fetching popular products: ${response.statusText}');
    } else {
      final List<dynamic> rawData = response.body;
      return rawData.map((json) => Product.fromJson(json)).toList();
    }
  }

  Future<List<Product>> fetchFreshProducts() async {
    final response = await get('/api/product/getFresh');
    if (response.status.hasError) {
      return Future.error('Error fetching fresh products: ${response.statusText}');
    } else {
      final List<dynamic> rawData = response.body;
      return rawData.map((json) => Product.fromJson(json)).toList();
    }
  }

  Future<List<Product>> fetchCookedProducts() async {
    final response = await get('/api/product/getCooked');
    if (response.status.hasError) {
      return Future.error('Error fetching cooked products: ${response.statusText}');
    } else {
      final List<dynamic> rawData = response.body;
      return rawData.map((json) => Product.fromJson(json)).toList();
    }
  }



}
