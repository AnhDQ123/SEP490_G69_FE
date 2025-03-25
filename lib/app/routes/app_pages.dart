import 'package:get/get.dart';

import '../modules/add_voucher/bindings/add_voucher_binding.dart';
import '../modules/add_voucher/views/add_voucher_view.dart';
import '../modules/check_out/bindings/check_out_binding.dart';
import '../modules/check_out/views/check_out_view.dart';
import '../modules/my_order/bindings/my_order_binding.dart';
import '../modules/my_order/views/my_order_view.dart';
import '../modules/recommended_products/bindings/recommended_products_binding.dart';
import '../modules/recommended_products/views/recommended_products_view.dart';
import '../modules/return_order_detail_page/bindings/return_order_detail_page_binding.dart';
import '../modules/return_order_detail_page/views/return_order_detail_page_view.dart';
import '../modules/shop_order/bindings/shop_order_binding.dart';
import '../modules/shop_order/views/shop_order_view.dart';
import '../modules/voucher_list/bindings/voucher_list_binding.dart';
import '../modules/voucher_list/views/voucher_list_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SHOP_ORDER;

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
    GetPage(
      name: _Paths.SHOP_ORDER,
      page: () => const ShopOrderView(),
      binding: ShopOrderBinding(),
    ),
    GetPage(
      name: _Paths.RETURN_ORDER_DETAIL_PAGE,
      page: () => const ReturnOrderDetailPageView(),
      binding: ReturnOrderDetailPageBinding(),
    ),
    GetPage(
      name: _Paths.VOUCHER_LIST,
      page: () => const VoucherListView(),
      binding: VoucherListBinding(),
    ),
    GetPage(
      name: _Paths.ADD_VOUCHER,
      page: () => const AddVoucherView(),
      binding: AddVoucherBinding(),
    ),
  ];
}
