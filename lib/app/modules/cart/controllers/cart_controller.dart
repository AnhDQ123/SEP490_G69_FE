// Controller quản lý giỏ hàng
import 'package:get/get.dart';

import '../../../models/cart_item.dart';
import '../../../models/food_option.dart';
import '../../../models/product.dart';
import '../../../models/shop.dart';

class CartController extends GetxController {
  var cartItems = <int, RxList<CartItem>>{}.obs;


  var selectedShops = <int>[].obs; // Danh sách shop được chọn

  List<Shop> shops = []; // Danh sách tất cả shop

  // Giả lập dữ liệu
  @override
  void onInit() {
    super.onInit();
    loadDummyData();
  }

  void loadDummyData() {
    var shop1 = Shop.sampleShops[0];
    var shop2 = Shop.sampleShops[1];

    shops = [shop1, shop2];

    cartItems[shop1.shopId] = <CartItem>[
      CartItem(product: Product.sampleProducts[0], selectedOptions: Product.sampleProducts[0].options),
      CartItem(product: Product.sampleProducts[1], selectedOptions: Product.sampleProducts[1].options),
    ].obs;

    cartItems[shop2.shopId] = <CartItem>[
      CartItem(product: Product.sampleProducts[2], selectedOptions: Product.sampleProducts[2].options),
      CartItem(product: Product.sampleProducts[3], selectedOptions: Product.sampleProducts[3].options),
    ].obs;

  }

  void updateProductQuantity(int shopId, int productId, int newQuantity) {
    if (newQuantity < 1) return; // Không cho giảm xuống dưới 1

    var item = cartItems[shopId]?.firstWhere((item) => item.product.productId == productId);
    if (item != null) {
      var sizeOption = item.selectedOptions.firstWhere((opt) => opt.isSize);
      sizeOption.quantity = newQuantity; // Cập nhật số lượng size

      // In ra log để theo dõi số lượng
      print("🔹 [UPDATE SIZE] ${item.product.productName} - Size: ${sizeOption.name}, New Quantity: $newQuantity");
    }
    cartItems.refresh(); // Cập nhật UI
  }

  void updateOptionQuantity(int shopId, int productId, int optionId, int newQuantity) {
    if (newQuantity < 0) return; // Không cho phép số lượng âm

    var item = cartItems[shopId]?.firstWhere((item) => item.product.productId == productId);
    if (item != null) {
      var option = item.selectedOptions.firstWhere((opt) => opt.foodOptionId == optionId);
      option.quantity = newQuantity; // Cập nhật số lượng option

      // In ra log để theo dõi số lượng option
      print("🟡 [UPDATE OPTION] ${item.product.productName} - Option: ${option.name}, New Quantity: $newQuantity");
    }
    cartItems.refresh(); // Cập nhật UI
  }

  void removeItem(int shopId, int productId) {
    if (cartItems.containsKey(shopId)) {
      cartItems[shopId]!.removeWhere((item) => item.product.productId == productId);

      // Nếu shop không còn sản phẩm nào, xóa luôn shop khỏi giỏ hàng
      if (cartItems[shopId]!.isEmpty) {
        cartItems.remove(shopId);
      }

      cartItems.refresh(); // Cập nhật UI
    }
  }

  void updateSize(int shopId, int productId, FoodOption newSize) {
    if (cartItems.containsKey(shopId)) {
      List<CartItem> items = cartItems[shopId]!;

      for (var item in items) {
        if (item.product.productId == productId) {
          // Xóa size cũ trong selectedOptions
          item.selectedOptions.removeWhere((option) => option.isSize);
          // Thêm size mới
          item.selectedOptions.add(newSize);
          cartItems.refresh();
          break;
        }
      }
    }
  }

  double getTotalAmount() {
    double total = 0;
    cartItems.forEach((shopId, items) {
      for (var item in items) {
        double itemTotal = item.getTotalPrice();
        total += itemTotal;

        // In ra log để theo dõi từng sản phẩm
        print("🛒 [CART ITEM] ${item.product.productName} - Total: $itemTotal");
      }
    });

    // In ra log để theo dõi tổng tiền giỏ hàng
    print("💵 [TOTAL CART] Tổng tiền giỏ hàng: $total");

    return total;
  }


}