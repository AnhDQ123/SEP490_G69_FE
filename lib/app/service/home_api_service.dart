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
  Future<List<Category>> fetchCategories({String? name, int page = 0, int size = 10}) async {
    String url = '/api/category?page=$page&size=$size';
    if (name != null && name.isNotEmpty) {
      url += '&name=$name';  // Nếu có name, thêm tham số vào URL
    }

    final response = await get(url);

    if (response.status.hasError) {
      return Future.error('Error fetching categories: ${response.statusText}');
    } else {
      // Truy cập vào phần 'content' của response để lấy danh sách category
      final Map<String, dynamic> data = response.body;
      final List<dynamic> rawData = data['content'];

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
      print('Dữ liệu trả về từ API: $rawData');  // In ra để kiểm tra trường discount
      return rawData.map((json) => Product.fromJson(json)).toList();
    }
  }




  Future<List<Product>> fetchFreshProducts({required int userId, int top = 10}) async {
    final response = await get('/api/product/getFresh/$userId?top=$top');
    if (response.status.hasError) {
      return Future.error('Error fetching fresh products: ${response.statusText}');
    } else {
      final List<dynamic> rawData = response.body;
      return rawData.map((json) => Product.fromJson(json)).toList();
    }
  }


  Future<List<Product>> fetchCookedProducts({required int userId, int top = 10}) async {
    final response = await get('/api/product/getCooked/$userId?top=$top');
    if (response.status.hasError) {
      return Future.error('Error fetching cooked products: ${response.statusText}');
    } else {
      final List<dynamic> rawData = response.body;
      return rawData.map((json) => Product.fromJson(json)).toList();
    }
  }

}
