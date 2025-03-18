import 'package:get/get.dart';
import '../../../models/cart.dart';
import '../../../models/cart_item_option.dart';
import '../../../services/cart_service.dart';

class CartController extends GetxController {
  var carts = <Cart>[].obs; // Danh sách giỏ hàng
  var isLoading = true.obs; // Trạng thái tải dữ liệu
  final CartService cartService = CartService(); // Gọi service

  // Map để theo dõi các mục đã chọn: {shopId: [productId1, productId2, ...]}
  var selectedItems = <int, List<int>>{}.obs;

  @override
  void onInit() {
    fetchCart();
    super.onInit();
  }

  /// **Hàm lấy dữ liệu giỏ hàng**
  void fetchCart() async {
    try {
      isLoading(true); // Hiển thị loading
      var cartData = await cartService.fetchCartList(); // Gọi API từ service
      if (cartData != null) {
        carts.assignAll(cartData); // Cập nhật danh sách giỏ hàng
      }
    } catch (e) {
      print('❌ Lỗi trong CartController: $e');
    } finally {
      isLoading(false); // Tắt loading
    }
  }

  /// **Kiểm tra xem tất cả các mục trong giỏ hàng đã được chọn chưa**
  bool isAllSelected() {
    for (var shop in carts) {
      if (!isShopSelected(shop.shopId)) {
        return false;
      }
    }
    return true;
  }

  /// **Chọn hoặc bỏ chọn tất cả các mục trong giỏ hàng**
  void toggleSelectAll(bool isSelected) {
    for (var shop in carts) {
      selectedItems[shop.shopId] = isSelected
          ? shop.cartItemDTOList.map((item) => item.productId).toList()
          : [];
    }
    selectedItems.refresh();
  }

  /// **Kiểm tra xem tất cả các mục trong một shop đã được chọn chưa**
  bool isShopSelected(int shopId) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    return selectedItems[shopId]?.length == shop.cartItemDTOList.length;
  }

  /// **Chọn hoặc bỏ chọn tất cả các mục trong một shop**
  void toggleShopSelection(int shopId, bool isSelected) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    selectedItems[shopId] = isSelected
        ? shop.cartItemDTOList.map((item) => item.productId).toList()
        : [];
    selectedItems.refresh();
  }

  /// **Chọn hoặc bỏ chọn một mục cụ thể**
  void toggleItemSelection(int shopId, int productId, bool isSelected) {
    if (isSelected) {
      selectedItems[shopId]?.add(productId);
    } else {
      selectedItems[shopId]?.remove(productId);
    }
    selectedItems.refresh();
  }

  /// **Kiểm tra xem một mục cụ thể đã được chọn chưa**
  bool isItemSelected(int shopId, int productId) {
    return selectedItems[shopId]?.contains(productId) ?? false;
  }

  // /// **Cập nhật số lượng sản phẩm**
  // void updateQuantity(int shopId, int productId, int quantity, {int? optionId}) async {
  //   try {
  //     // Gọi API để cập nhật số lượng
  //     await cartService.updateCartItemQuantity(shopId, productId, quantity, optionId: optionId);
  //
  //     // Cập nhật số lượng trong danh sách giỏ hàng
  //     var shop = carts.firstWhere((s) => s.shopId == shopId);
  //     var item = shop.cartItemDTOList.firstWhere((item) => item.productId == productId);
  //
  //     if (optionId != null) {
  //       // Cập nhật số lượng cho tùy chọn (topping)
  //       var option = item.cartItemOptionDTOList.firstWhere((opt) => opt.optionId == optionId);
  //       option.quantity = quantity;
  //     } else {
  //       // Cập nhật số lượng cho sản phẩm chính
  //       item.quantity = quantity;
  //       item.totalPrice = item.price * quantity;
  //     }
  //
  //     carts.refresh();
  //   } catch (e) {
  //     print('❌ Lỗi khi cập nhật số lượng: $e');
  //   }
  // }

  /// **Xóa một sản phẩm khỏi giỏ hàng**
  void removeItem(int shopId, int productId) async {
    try {
      // Gọi API để xóa sản phẩm
      ///  await cartService.removeCartItem(shopId, productId);

      // Cập nhật danh sách giỏ hàng
      var shop = carts.firstWhere((s) => s.shopId == shopId);
      shop.cartItemDTOList.removeWhere((item) => item.productId == productId);

      // Nếu shop không còn sản phẩm nào, xóa shop khỏi giỏ hàng
      if (shop.cartItemDTOList.isEmpty) {
        carts.removeWhere((s) => s.shopId == shopId);
      }

      carts.refresh();
    } catch (e) {
      print('❌ Lỗi khi xóa sản phẩm: $e');
    }
  }

  /// **Xóa toàn bộ shop khỏi giỏ hàng**
  void removeShop(int shopId) async {
    try {
      // Gọi API để xóa toàn bộ shop
      /// await cartService.removeShop(shopId);

      // Cập nhật danh sách giỏ hàng
      carts.removeWhere((s) => s.shopId == shopId);
      carts.refresh();
    } catch (e) {
      print('❌ Lỗi khi xóa shop: $e');
    }
  }

  /// **Tính tổng tiền của các mục đã chọn**
  double getTotalAmount() {
    double total = 0;
    for (var shop in carts) {
      for (var item in shop.cartItemDTOList) {
        if (selectedItems[shop.shopId]?.contains(item.productId) ?? false) {
          total += item.totalPrice;
        }
      }
    }
    return total;
  }

  /// **Định dạng tiền tệ**
  String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0)}đ';
  }
}