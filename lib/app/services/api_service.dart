class ApiService {
  static const String baseUrl = "http://192.168.1.7:8080/api";

  static String getCartByOwner(int ownerId) => '$baseUrl/cart/owner/1';
  static String getProductDetails(int productId) => '$baseUrl/product/$productId';
}
