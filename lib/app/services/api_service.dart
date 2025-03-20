class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  static String getCartByOwner(int ownerId) => '$baseUrl/cart/owner/1';
  static String getProductDetails(int productId) => '$baseUrl/product/$productId';
}
