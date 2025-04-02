import 'package:ffb_fe_flutter/app/service/cart_api_service.dart';
import 'package:ffb_fe_flutter/app/service/order_service.dart';
import 'package:get/get.dart';
import '../../../base/base_common.dart';
import '../../../models/cart.dart';
import '../../../models/cart_item.dart';
import '../../../models/cart_item_option.dart';
import '../../../models/order.dart';
import '../../../models/product.dart';
import '../../../routes/app_pages.dart';
import '../../../service/notification_service.dart';
import '../../../service/product_detail_service.dart';

class CartController extends GetxController {
  var carts = <CartDTO>[].obs;
  var isLoading = true.obs;
  final CartApiService cartService = CartApiService();
  final ProductDetailApiService productDetailService = ProductDetailApiService();
  var selectedItems = <int, List<int>>{}.obs;
  var productOptions = <int, List<CartItemOptionDTO>>{}.obs;
  var isLoadingOptions = false.obs;

  Future<void> fetchProductOptions(int productId) async {
    try {
      isLoadingOptions(true);
      Product product = await productDetailService.getProductDetail(productId.toString());

      if (product.foodOptions == null) {
        print("⚠️ Không có foodOptions cho productId: $productId");
        return;
      }

      // Lọc các size (typeId == 2)
      List<CartItemOptionDTO> sizes = product.foodOptions
          .where((opt) => opt.typeId == 2) // Lấy các size
          .map((opt) => CartItemOptionDTO(
        optionId: opt.id,
        typeId: opt.typeId ?? 0,
        optionName: opt.name,
        image: opt.image ?? '',
        price: opt.price ?? 0.0,
        totalPrice: opt.price ?? 0.0,
        quantity: 1,
        cartItemId: 0,
      ))
          .toList();

      // Lọc các topping (typeId == 1)
      List<CartItemOptionDTO> toppings = product.foodOptions
          .where((opt) => opt.typeId == 1) // Lấy các topping
          .map((opt) => CartItemOptionDTO(
        optionId: opt.id,
        typeId: opt.typeId ?? 0,
        optionName: opt.name,
        image: opt.image ?? '',
        price: opt.price ?? 0.0,
        totalPrice: opt.price ?? 0.0,
        quantity: 1,
        cartItemId: 0,
      ))
          .toList();

      // Cập nhật lại các tùy chọn size và topping cho sản phẩm này
      productOptions[productId] = {...sizes, ...toppings}.toList();
      carts.refresh();
    } catch (e) {
      print('❌ Lỗi khi lấy các tùy chọn sản phẩm $productId: $e');
    } finally {
      isLoadingOptions(false);
    }
  }


  void updateSize(int shopId, int productId, CartItemOptionDTO newSize) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    var item = shop.cartItemDTOList.firstWhere((item) => item.productId == productId);
    item.cartItemOptionDTOList.removeWhere((opt) => opt.typeId == 2);
    item.cartItemOptionDTOList.add(newSize);
    item.totalPrice = newSize.price * item.quantity.value;
    carts.refresh();
  }

  void updateProductQuantity(int shopId, int productId, int quantity) {
    if (quantity < 1) return;
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    var item = shop.cartItemDTOList.firstWhere((item) => item.productId == productId);
    item.quantity.value = quantity;
    var selectedSize = item.cartItemOptionDTOList.firstWhereOrNull((opt) => opt.typeId == 2);
    double sizePrice = selectedSize?.price ?? 0;
    item.totalPrice = sizePrice * quantity;
    carts.refresh();
  }

  void increaseQuantity(int shopId, int productId) {
    var shop = carts.firstWhereOrNull((s) => s.shopId == shopId);
    var item = shop?.cartItemDTOList.firstWhereOrNull((i) => i.productId == productId);
    if (item != null) {
      updateProductQuantity(shopId, productId, item.quantity.value + 1);
    }
  }

  void decreaseQuantity(int shopId, int productId) {
    var shop = carts.firstWhereOrNull((s) => s.shopId == shopId);
    var item = shop?.cartItemDTOList.firstWhereOrNull((i) => i.productId == productId);
    if (item != null && item.quantity.value > 1) {
      updateProductQuantity(shopId, productId, item.quantity.value - 1);
    }
  }

  void updateOptionQuantity(int shopId, int productId, int optionId, int newQuantity) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    var item = shop.cartItemDTOList.firstWhere((p) => p.productId == productId);
    var option = item.cartItemOptionDTOList.firstWhereOrNull((opt) => opt.optionId == optionId);
    if (option != null && newQuantity >= 0) {
      option.quantity = newQuantity;
      option.totalPrice = option.price * option.quantity;
      item.totalPrice = _calculateTotalPrice(item);
    }
    carts.refresh();
  }

  void addFoodOption(int shopId, int productId, CartItemOptionDTO option) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    var item = shop.cartItemDTOList.firstWhere((p) => p.productId == productId);
    var existingOption = item.cartItemOptionDTOList.firstWhereOrNull((opt) => opt.optionId == option.optionId);

    if (existingOption == null) {
      item.cartItemOptionDTOList.add(option);
    } else {
      existingOption.quantity += 1;
      existingOption.totalPrice = existingOption.price * existingOption.quantity;
    }

    item.totalPrice = _calculateTotalPrice(item);
    carts.refresh();
  }

  double _calculateTotalPrice(CartItemDTO item) {
    double sizePrice = item.cartItemOptionDTOList.firstWhereOrNull((opt) => opt.typeId == 2)?.price ?? 0;
    double foodOptionsPrice = item.cartItemOptionDTOList
        .where((opt) => opt.typeId == 1)
        .fold(0.0, (sum, opt) => sum + (opt.price * opt.quantity));
    return (sizePrice * item.quantity.value) + foodOptionsPrice;
  }

  double getTotalAmount() {
    double total = 0;
    for (var shop in carts) {
      for (var item in shop.cartItemDTOList) {
        if (selectedItems[shop.shopId]?.contains(item.productId) ?? false) {
          var selectedSize = item.cartItemOptionDTOList.firstWhereOrNull((opt) => opt.typeId == 2);
          double sizePrice = selectedSize?.price ?? 0;
          double foodOptionsPrice = item.cartItemOptionDTOList
              .where((opt) => opt.typeId == 1)
              .fold(0.0, (sum, opt) => sum + (opt.price * opt.quantity));
          total += (sizePrice * item.quantity.value) + foodOptionsPrice;
        }
      }
    }
    return total;
  }

  String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}' 'đ';
  }

  @override
  void onInit() {
    fetchCart();
    super.onInit();
  }

  Future<void> fetchCart() async {
    try {
      isLoading(true);
      final userId = int.tryParse(BaseCommon.instance.userId ?? '') ?? 0;
      print("📥 Đang fetch cart cho userId: $userId");

      var cartData = await cartService.getCartByOwner(userId);
      print("✅ Nhận được ${cartData.length} cart(s)");

      carts.assignAll(cartData);

      // ✅ Đếm tổng sản phẩm để gửi notification
      int totalItems = 0;
      for (var shop in cartData) {
        totalItems += shop.cartItemDTOList.length;
      }

      if (totalItems > 0) {
        await NotificationService.showCartReminderNotification(totalItems);
      }

      for (var shop in carts) {
        for (var item in shop.cartItemDTOList) {
          try {
            print("🔍 Xử lý productId: ${item.productId}");
            await fetchProductOptions(item.productId);

            CartItemOptionDTO? selectedSize =
            item.cartItemOptionDTOList.firstWhereOrNull((opt) => opt.typeId == 2);

            item.totalPrice = selectedSize != null
                ? selectedSize.price * item.quantity.value
                : 0;
          } catch (e, st) {
            print("❌ [ERROR] Lỗi trong xử lý item ${item.productId}: $e");
            print("📛 $st");
          }
        }
      }
    } catch (e, st) {
      print('❌ [ERROR] Lỗi trong fetchCart(): $e');
      print('📛 $st');
    } finally {
      isLoading(false);
      print("✅ Đã kết thúc fetchCart(), đóng loading");
    }



  }

  void toggleSelectAll(bool isSelected) {
    for (var shop in carts) {
      selectedItems[shop.shopId] = isSelected ? shop.cartItemDTOList.map((item) => item.productId).toList() : [];
    }
    selectedItems.refresh();
  }

  bool isAllSelected() {
    for (var shop in carts) {
      if (!isShopSelected(shop.shopId)) {
        return false;
      }
    }
    return true;
  }

  bool isShopSelected(int shopId) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    return selectedItems[shopId]?.length == shop.cartItemDTOList.length;
  }

  void toggleShopSelection(int shopId, bool isSelected) {
    var shop = carts.firstWhere((s) => s.shopId == shopId);
    selectedItems[shopId] = isSelected ? shop.cartItemDTOList.map((item) => item.productId).toList() : [];
    selectedItems.refresh();
  }

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

  // void proceedToCheckout() {
  //   bool hasSelectedProduct = selectedItems.values.any((products) => products.isNotEmpty);
  //   if (!hasSelectedProduct) {
  //     Get.snackbar("Thông báo", "Vui lòng chọn ít nhất một sản phẩm để thanh toán", snackPosition: SnackPosition.BOTTOM);
  //     return;
  //   }
  //   Get.toNamed(Routes.CHECK_OUT,
  //       arguments: carts.where((shop) => selectedItems[shop.shopId]?.isNotEmpty ?? false).toList());
  // }

  Future<void> proceedToCheckout() async {
    bool hasSelectedProduct = selectedItems.values.any((products) => products.isNotEmpty);

    print("🔥 Debugging Proceed to Checkout:");
    print("Selected Items: $selectedItems");

    if (!hasSelectedProduct) {
      Get.snackbar("Thông báo", "Vui lòng chọn ít nhất một sản phẩm để thanh toán",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Lọc danh sách giỏ hàng đã chọn
    List<CartDTO> selectedCarts =
    carts.where((shop) => selectedItems[shop.shopId]?.isNotEmpty ?? false).toList();

    if (selectedCarts.isEmpty) {
      Get.snackbar("Thông báo", "Không có sản phẩm được chọn",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      // 🧾 Tạo Order từ dữ liệu giỏ hàng
      Order newOrder = selectedCarts
          .map((cart) => cart.toOrder(
        shipMethodId: 1,
        paymentMethodId: 1,
      ))
          .first;

      print("📦 Đang gửi Order: ${newOrder.toJson()}");

      // ✅ Gọi API để lưu đơn hàng – chỉ 1 lần
      // await OrderService().createOrder(newOrder);
      //
      // // ✅ Truyền lại `newOrder` (đầy đủ items) sang CheckOutView
      // Get.toNamed(Routes.CHECK_OUT, arguments: newOrder);
      final createdOrders = await OrderService().createOrder(newOrder);

      if (createdOrders.isNotEmpty) {
        final createdOrder = createdOrders.first;
        Get.toNamed(Routes.CHECK_OUT, arguments: createdOrder); // dùng đơn đã được gán id từ backend
      } else {
        Get.snackbar("Lỗi", "Không tạo được đơn hàng");
      }

    } catch (e) {
      print("❌ Lỗi trong việc tạo đơn hàng: $e");
      Get.snackbar("Lỗi", "Không thể tạo đơn hàng, vui lòng thử lại",
          snackPosition: SnackPosition.BOTTOM);
    }
  }


}