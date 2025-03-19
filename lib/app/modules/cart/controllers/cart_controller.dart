import 'package:get/get.dart';
import '../../../models/cart.dart';
import '../../../models/cart_item_option.dart';
import '../../../services/cart_service.dart';

class CartController extends GetxController {
  var carts = <Cart>[].obs;
  var isLoading = true.obs;
  final CartService cartService = CartService();
  var selectedItems = <int, List<int>>{}.obs;

  @override
  void onInit() {
    fetchCart();
    super.onInit();
  }

  void fetchCart() async {
    try {
      isLoading(true);
      var cartData = await cartService.fetchCartList();
      if (cartData != null) {
        carts.assignAll(cartData);
      }
    } catch (e) {
      print('❌ Lỗi trong CartController: $e');
    } finally {
      isLoading(false);
    }
  }

  bool isAllSelected() {
    for (var shop in carts) {
      if (!isShopSelected(shop.shopId)) {
        return false;
      }
    }
    return true;
  }

  void toggleSelectAll(bool isSelected) {
    for (var shop in carts) {
      selectedItems[shop.shopId] = isSelected
          ? shop.cartItemDTOList.map((item) => item.productId).toList()
          : [];
    }
    selectedItems.refresh();
  }

  bool isShopSelected(int shopId) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    return selectedItems[shopId]?.length == shop.cartItemDTOList.length;
  }

  void toggleShopSelection(int shopId, bool isSelected) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    selectedItems[shopId] = isSelected
        ? shop.cartItemDTOList.map((item) => item.productId).toList()
        : [];
    selectedItems.refresh();
  }

  void toggleItemSelection(int shopId, int productId, bool isSelected) {
    if (!selectedItems.containsKey(shopId)) {
      selectedItems[shopId] = []; // Khởi tạo danh sách nếu chưa có
    }

    if (isSelected) {
      if (!selectedItems[shopId]!.contains(productId)) {
        selectedItems[shopId]!.add(productId);
      }
    } else {
      selectedItems[shopId]!.remove(productId);
    }

    selectedItems.refresh(); // Cập nhật UI
  }


  bool isItemSelected(int shopId, int productId) {
    return selectedItems[shopId]?.contains(productId) ?? false;
  }

  void updateProductQuantity(int shopId, int productId, int quantity) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    var item = shop.cartItemDTOList.firstWhere((item) => item.productId == productId);
    item.quantity = quantity;
    item.totalPrice = (item.price! * quantity)!;
    carts.refresh();
  }

  void updateOptionQuantity(int shopId, int productId, int optionId, int quantity) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    var item = shop.cartItemDTOList.firstWhere((item) => item.productId == productId);
    var option = item.cartItemOptionDTOList.firstWhere((opt) => opt.optionId == optionId);
    option.quantity = quantity;
    carts.refresh();
  }

  void updateSize(int shopId, int productId, CartItemOption newSize) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    var item = shop.cartItemDTOList.firstWhere((item) => item.productId == productId);
    item.cartItemOptionDTOList.removeWhere((opt) => opt.typeId == 2);
    item.cartItemOptionDTOList.add(newSize);
    carts.refresh();
  }

  void removeItem(int shopId, int productId) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    if (shop != null) {
      shop.cartItemDTOList.removeWhere((item) => item.productId == productId);

      // Nếu shop không còn sản phẩm nào, xóa shop khỏi giỏ hàng
      if (shop.cartItemDTOList.isEmpty) {
        carts.removeWhere((s) => s.shopId == shopId);
      }

      carts.refresh();
    }
  }

  void removeShop(int shopId) {
    carts.removeWhere((s) => s.shopId == shopId);
    carts.refresh();
  }

  double getTotalAmount() {
    double total = 0;
    for (var shop in carts) {
      for (var item in shop.cartItemDTOList) {
        if (selectedItems[shop.shopId]?.contains(item.productId) ?? false) {
          total += item.totalPrice;
          for (var option in item.cartItemOptionDTOList) {
            total += (option.price ?? 0) * option.quantity;
          }
        }
      }
    }
    return total;
  }



  String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}đ';
  }

}
