import 'package:get/get.dart';

import '../modules/check_out/bindings/check_out_binding.dart';
import '../modules/check_out/views/check_out_view.dart';
import '../modules/my_order/bindings/my_order_binding.dart';
import '../modules/my_order/views/my_order_view.dart';
import '../modules/recommended_products/bindings/recommended_products_binding.dart';
import '../modules/recommended_products/views/recommended_products_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.CHECK_OUT;

  static final routes = [
    GetPage(
      name: _Paths.MY_ORDER,
      page: () => const MyOrderView(),
      binding: MyOrderBinding(),
    ),
    GetPage(
      name: _Paths.RECOMMENDED_PRODUCTS,
      page: () => const RecommendedProductsView(),
      binding: RecommendedProductsBinding(),
    ),
    GetPage(
      name: _Paths.CHECK_OUT,
      page: () => const CheckOutView(),
      binding: CheckOutBinding(),
    ),
  ];
}
