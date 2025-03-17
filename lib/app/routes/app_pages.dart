import 'package:get/get.dart';

import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/filter/bindings/filter_binding.dart';
import '../modules/filter/views/filter_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/productForm/bindings/product_form_binding.dart';
import '../modules/productForm/views/product_form_view.dart';
import '../modules/productListShop/bindings/product_list_shop_binding.dart';
import '../modules/productListShop/views/product_list_shop_view.dart';
import '../modules/product_detail/bindings/product_detail_binding.dart';
import '../modules/product_detail/views/product_detail_view.dart';
import '../modules/product_selection/bindings/product_selection_binding.dart';
import '../modules/product_selection/views/product_selection_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.FILTER,
      page: () => const FilterView(),
      binding: FilterBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAIL,
      page: () => const ProductDetailView(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_SELECTION,
      page: () =>  ProductSelectionView(),
      binding: ProductSelectionBinding(),
    ),
  ];
}
