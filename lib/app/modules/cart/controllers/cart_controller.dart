import 'package:get/get.dart';
import '../../../models/cart.dart';
import '../../../models/cart_item_option.dart';
import '../../../models/product.dart';
import '../../../routes/app_pages.dart';
import '../../../services/cart_service.dart';

class CartController extends GetxController {
  var carts = <Cart>[].obs;
  var isLoading = true.obs;
  final CartService cartService = CartService();
  var selectedItems = <int, List<int>>{}.obs;

  /// **Lưu danh sách Size của sản phẩm từ API**
  var productOptions = <int, List<CartItemOption>>{}.obs;
  var isLoadingOptions = false.obs;

  /// **Lấy danh sách Size từ API và cập nhật giá**
  Future<void> fetchProductOptions(int productId) async {
    try {
      isLoadingOptions(true);

      Product product = await cartService.fetchProductDetails(productId);

      // 🔥 Tìm Size đã chọn trong giỏ hàng
      CartItemOption? selectedSize;
      for (var shop in carts) {
        for (var item in shop.cartItemDTOList) {
          if (item.productId == productId) {
            selectedSize = item.cartItemOptionDTOList
                .firstWhereOrNull((opt) => opt.typeId == 2); // Lấy Size từ giỏ hàng
            break;
          }
        }
      }

      // 🔥 Lấy danh sách Size từ API nhưng giữ nguyên giá từ giỏ hàng nếu có
      List<CartItemOption> sizes = product.foodOptions
          .where((opt) => opt.typeId == 2)
          .map((opt) => CartItemOption(
        optionId: opt.id,
        typeId: opt.typeId,
        optionName: opt.name,
        price: (selectedSize != null && selectedSize.optionId == opt.id)
            ? selectedSize.price // ✅ Giữ nguyên giá từ giỏ hàng
            : opt.price, // Nếu chưa có, lấy từ API
        totalPrice: (selectedSize != null && selectedSize.optionId == opt.id)
            ? selectedSize.price// ✅ Cập nhật tổng giá
            : opt.price * 1,
        quantity: 1,
        cartItemId: 0,
      ))
          .toList();

      productOptions[productId] = sizes;
      carts.refresh(); // ✅ Cập nhật UI

    } catch (e) {
      print('❌ Lỗi khi lấy option sản phẩm: $e');
    } finally {
      isLoadingOptions(false);
    }
  }

  /// **Thay đổi Size của sản phẩm trong giỏ hàng**
  void updateSize(int shopId, int productId, CartItemOption newSize) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    var item = shop.cartItemDTOList.firstWhere((item) => item.productId == productId);

    // 🔹 Xóa size cũ và cập nhật size mới
    item.cartItemOptionDTOList.removeWhere((opt) => opt.typeId == 2);
    item.cartItemOptionDTOList.add(newSize);

    // 🔹 Cập nhật lại giá sản phẩm theo size mới (tránh lỗi LateInitializationError)
    item.totalPrice = (newSize.price ?? 0) * item.quantity;
    carts.refresh();
  }



  /// **Thay đổi số lượng sản phẩm**
  void updateProductQuantity(int shopId, int productId, int quantity) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    var item = shop.cartItemDTOList.firstWhere((item) => item.productId == productId);

    item.quantity = quantity;

    // 🔹 Cập nhật lại giá theo số lượng và Size
    var selectedSize = item.cartItemOptionDTOList.firstWhereOrNull((opt) => opt.typeId == 2);
    double sizePrice = selectedSize?.price ?? 0;
    item.totalPrice = sizePrice * quantity;

    carts.refresh();
  }

  /// **Lấy tổng tiền của giỏ hàng**
  double getTotalAmount() {
    double total = 0;

    for (var shop in carts) {
      for (var item in shop.cartItemDTOList) {
        if (selectedItems[shop.shopId]?.contains(item.productId) ?? false) {
          var selectedSize = item.cartItemOptionDTOList
              .firstWhereOrNull((opt) => opt.typeId == 2);
          double sizePrice = selectedSize?.price ?? 0;

          total += sizePrice * item.quantity;
        }
      }
    }
    return total;
  }



  /// **Định dạng tiền VNĐ**
  String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}đ';
  }

  @override
  void onInit() {
    fetchCart();
    super.onInit();
  }

  /// **Lấy giỏ hàng từ API**
  void fetchCart() async {
    try {
      isLoading(true);
      var cartData = await cartService.fetchCartList(1);
      if (cartData != null) {
        carts.assignAll(cartData);

        for (var shop in carts) {
          for (var item in shop.cartItemDTOList) {
            await fetchProductOptions(item.productId); // ✅ Lấy danh sách Size trước

            // ✅ Chỉ lấy giá từ `cartItemOptionDTOList`
            CartItemOption? selectedSize = item.cartItemOptionDTOList
                .firstWhereOrNull((opt) => opt.typeId == 2);

            print("🔍 DEBUG | Sản phẩm: ${item.productName}, Size: ${selectedSize?.optionName}, Giá: ${selectedSize?.price}");

            if (selectedSize != null) {
              item.totalPrice = (selectedSize.price ?? 0) * item.quantity;
            } else {
              item.totalPrice = 0; // Nếu không có size, giá mặc định = 0
            }
          }
        }
      }
    } catch (e) {
      print('❌ Lỗi trong CartController: $e');
    } finally {
      isLoading(false);
    }
  }


  /// **Chọn tất cả sản phẩm**
  void toggleSelectAll(bool isSelected) {
    for (var shop in carts) {
      selectedItems[shop.shopId] = isSelected
          ? shop.cartItemDTOList.map((item) => item.productId).toList()
          : [];
    }
    selectedItems.refresh();
  }

  /// **Kiểm tra nếu tất cả sản phẩm đều được chọn**
  bool isAllSelected() {
    for (var shop in carts) {
      if (!isShopSelected(shop.shopId)) {
        return false;
      }
    }
    return true;
  }


  /// **Chọn cửa hàng**
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

  /// **Chọn từng sản phẩm**
  void toggleItemSelection(int shopId, int productId, bool isSelected) {
    if (!selectedItems.containsKey(shopId)) {
      selectedItems[shopId] = [];
    }
    if (isSelected) {
      if (!selectedItems[shopId]!.contains(productId)) {
        selectedItems[shopId]!.add(productId);
      }
    } else {
      selectedItems[shopId]!.remove(productId);
    }
    selectedItems.refresh();
  }

  void removeShop(int shopId) {
    carts.removeWhere((shop) => shop.shopId == shopId);
    carts.refresh();
  }

  void removeItem(int shopId, int productId) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    shop.cartItemDTOList.removeWhere((item) => item.productId == productId);

    if (shop.cartItemDTOList.isEmpty) {
      carts.removeWhere((s) => s.shopId == shopId);
    }

    carts.refresh();
  }

  void proceedToCheckout() {
    bool hasSelectedProduct = selectedItems.values.any((products) => products.isNotEmpty);

    if (!hasSelectedProduct) {
      Get.snackbar("Thông báo", "Vui lòng chọn ít nhất một sản phẩm để thanh toán",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Get.toNamed(Routes.CHECKOUT, arguments: carts.where((shop) => selectedItems[shop.shopId]?.isNotEmpty ?? false).toList());
  }

}
