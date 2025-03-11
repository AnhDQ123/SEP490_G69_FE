import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/product.dart';
import '../../../service/product_service.dart';


class ProductListShopController extends GetxController {
  var products = <Product>[].obs;
  var isLoading = true.obs;
  final ProductService productService = ProductService();

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      var fetchedProducts = await productService.fetchProducts();
      products.value = fetchedProducts;
    } catch (e) {
      Get.snackbar("Lỗi", e.toString());
    } finally {
      isLoading(false);
    }
  }

//  Đếm số lượng sản phẩm theo từng nhóm
//  Map<String, int> getStatusCounts() {
//    int availableCount = 0;
//    int outOfStockCount = 0;
//    int pendingCount = 0;
//    int deactivatedCount = 0;
//
//    for (var product in products) {
//      if (product.status == 'active') {
//        if (product.stockQuantity > 0) {
//          availableCount++; // Còn hàng
//        } else {
//          outOfStockCount++; // Hết hàng
//        }
//      } else if (product.status == 'pending') {
//        pendingCount++;
//      } else if (product.status == 'deactivated') {
//        deactivatedCount++;
//      }
//    }
//
//    return {
//      'available': availableCount,
//      'out_of_stock': outOfStockCount,
//      'pending': pendingCount,
//      'deactivated': deactivatedCount,
//    };
//  }


  // void deleteProduct(String productId) {
  //   products.removeWhere((product) => product.productId == productId);
  // }



}


