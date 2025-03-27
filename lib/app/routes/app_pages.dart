import 'package:get/get.dart';

import '../modules/add_banner/bindings/add_banner_binding.dart';
import '../modules/add_banner/views/add_banner_view.dart';
import '../modules/product_discount/bindings/product_discount_binding.dart';
import '../modules/product_discount/views/product_discount_view.dart';
import '../modules/shop/bindings/shop_binding.dart';
import '../modules/shop/views/shop_view.dart';
import '../modules/shop_dashboard/bindings/shop_dashboard_binding.dart';
import '../modules/shop_dashboard/views/shop_dashboard_view.dart';
import '../modules/shop_register/bindings/shop_register_binding.dart';
import '../modules/shop_register/views/shop_register_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SHOP;

  static final routes = [
    GetPage(
      name: _Paths.SHOP,
      page: () => ShopView(),
      binding: ShopBinding(),
    ),
    GetPage(
      name: _Paths.ADD_BANNER,
      page: () => AddBannerView(),
      binding: AddBannerBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_REGISTER,
      page: () => ShopRegisterView(),
      binding: ShopRegisterBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DISCOUNT,
      page: () => ProductDiscountView(),
      binding: ProductDiscountBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_DASHBOARD,
      page: () => ShopDashboardView(),
      binding: ShopDashboardBinding(),
    ),
  ];
}
