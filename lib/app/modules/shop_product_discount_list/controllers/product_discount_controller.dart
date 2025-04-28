import 'package:get/get.dart';
import 'package:ffb_fe_flutter/app/models/product_discount.dart';
import '../../../models/discount.dart';
import '../../../service/shop_service.dart';
import '../../shop_menu/controllers/shop_controller.dart';

enum SortType {
  none,
  priceAsc,
  priceDesc,
  quantityAsc,
  quantityDesc,
}

class ProductDiscountController extends GetxController {
  // Danh sách gốc
  final List<ProductDiscount> _originalActiveProducts = [];
  final List<ProductDiscount> _originalScheduledProducts = [];
  final List<ProductDiscount> _originalNoDiscountProducts = [];

  // Danh sách hiển thị
  final activeDiscountProducts = <ProductDiscount>[].obs;
  final scheduledDiscountProducts = <ProductDiscount>[].obs;
  final noDiscountProducts = <ProductDiscount>[].obs;

  // Sắp xếp
  final sortType = SortType.none.obs;
  final shopController = Get.find<ShopController>();
  late int shopId;


  final ShopService shopService = ShopService();

  @override
  void onInit() {
    super.onInit();
    shopId = shopController.shopId; // Lấy shopId từ ShopController
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final products = await shopService.fetchProductsByShop(shopId);

      _originalActiveProducts.clear();
      _originalScheduledProducts.clear();
      _originalNoDiscountProducts.clear();

      for (var product in products) {
        final discounts = product.discount;

        if (discounts.isEmpty) {
          _originalNoDiscountProducts.add(product);
          continue;
        }

        bool added = false;

        for (var d in discounts) {
          switch (d.status) {
            case 'ACTIVE':
              _originalActiveProducts.add(product);
              added = true;
              break;
            case 'PENDING':
              _originalScheduledProducts.add(product);
              added = true;
              break;
            case 'INACTIVE':
              break; // không thêm
          }

          if (added) break; // chỉ thêm 1 lần nếu đã phân loại
        }

        if (!added) {
          // Nếu tất cả đều là INACTIVE → xem như chưa có giảm giá
          _originalNoDiscountProducts.add(product);
        }
      }

      // Cập nhật danh sách hiển thị
      activeDiscountProducts.value = [..._originalActiveProducts];
      scheduledDiscountProducts.value = [..._originalScheduledProducts];
      noDiscountProducts.value = [..._originalNoDiscountProducts];

      applySort();
    } catch (e) {
      print('❌ Lỗi khi tải sản phẩm: $e');
    }
  }

  void applySort() {
    print("📦 Applying sort: ${sortType.value}");
    List<ProductDiscount> sortList(List<ProductDiscount> source) {
      final list = [...source]; // clone mới để không ảnh hưởng list gốc
      switch (sortType.value) {
        case SortType.priceAsc:
          list.sort((a, b) => a.defaultPrice.compareTo(b.defaultPrice));
          break;
        case SortType.priceDesc:
          list.sort((a, b) => b.defaultPrice.compareTo(a.defaultPrice));
          break;
        case SortType.quantityAsc:
          list.sort((a, b) => a.quantity.compareTo(b.quantity));
          break;
        case SortType.quantityDesc:
          list.sort((a, b) => b.quantity.compareTo(a.quantity));
          break;
        case SortType.none:
          break;
      }
      return list;
    }

    activeDiscountProducts.value = sortList(_originalActiveProducts);
    scheduledDiscountProducts.value = sortList(_originalScheduledProducts);
    noDiscountProducts.value = sortList(_originalNoDiscountProducts);
  }


  Future<void> deleteDiscount(ProductDiscount product, Discount discount) async {
    try {
      final result = await shopService.deleteDiscount(discount.id);
      if (result.success) {
        Get.snackbar("Thành công", "Đã huỷ giảm giá");
        await fetchProducts(); // Refresh sau khi xoá
      } else {
        Get.snackbar("Thất bại", result.message);
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể xoá: $e");
    }
  }
}
