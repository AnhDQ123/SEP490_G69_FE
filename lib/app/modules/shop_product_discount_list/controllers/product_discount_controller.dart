import 'package:get/get.dart';
import 'package:ffb_fe_flutter/app/models/product_discount.dart';
import '../../../models/discount.dart';
import '../../../service/shop_service.dart';

enum SortType {
  none,
  priceAsc,
  priceDesc,
  quantityAsc,
  quantityDesc,
}

class ProductDiscountController extends GetxController {
  // Danh sách gốc
  List<ProductDiscount> originalActiveProducts = [];
  List<ProductDiscount> originalScheduledProducts = [];
  List<ProductDiscount> originalNoDiscountProducts = [];

  // Danh sách hiển thị
  var activeDiscountProducts = <ProductDiscount>[].obs;
  var scheduledDiscountProducts = <ProductDiscount>[].obs;
  var noDiscountProducts = <ProductDiscount>[].obs;

  // Sắp xếp
  var sortType = SortType.none.obs;

  final ShopService shopService = ShopService();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final products = await shopService.fetchProductsDiscountByShop(1);

      originalActiveProducts.clear();
      originalScheduledProducts.clear();
      originalNoDiscountProducts.clear();

      final now = DateTime.now();

      for (var product in products) {
        final activeDiscounts = product.discount.where((d) => d.status == 'ACTIVE').toList();

        if (activeDiscounts.isEmpty) {
          originalNoDiscountProducts.add(product);
          continue;
        }

        bool added = false;
        for (var d in activeDiscounts) {
          final start = DateTime.tryParse(d.startDate);
          final end = DateTime.tryParse(d.endDate);
          if (start == null || end == null) continue;

          if (now.isAfter(end)) {
            continue;
          } else if (now.isBefore(start)) {
            originalScheduledProducts.add(product);
            added = true;
            break;
          } else {
            originalActiveProducts.add(product);
            added = true;
            break;
          }
        }

        if (!added) originalNoDiscountProducts.add(product);
      }

      // Cập nhật danh sách hiển thị ban đầu
      activeDiscountProducts.value = [...originalActiveProducts];
      scheduledDiscountProducts.value = [...originalScheduledProducts];
      noDiscountProducts.value = [...originalNoDiscountProducts];

      applySort();
    } catch (e) {
      print('Lỗi khi tải sản phẩm: $e');
    }
  }

  void applySort() {
    void sortList(List<ProductDiscount> list) {
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
        default:
          break;
      }
    }

    sortList(activeDiscountProducts);
    sortList(scheduledDiscountProducts);
    sortList(noDiscountProducts);
  }

  Future<void> deleteDiscount(ProductDiscount product, Discount discount) async {
    try {
      final result = await shopService.deleteDiscount(discount.id);
      if (result.success) {
        Get.snackbar("Thành công", "Đã huỷ giảm giá");
        await fetchProducts();
      } else {
        Get.snackbar("Thất bại", result.message);
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể xoá: $e");
    }
  }
}
