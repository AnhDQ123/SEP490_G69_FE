import 'package:get/get.dart';

import '../modules/shipper_home/bindings/shipper_home_binding.dart';
import '../modules/shipper_home/views/shipper_home_view.dart';
import '../modules/shipper_order_detail/bindings/shipper_order_detail_binding.dart';
import '../modules/shipper_order_detail/views/shipper_order_detail_view.dart';
import '../modules/shipper_order_list/bindings/shipper_order_list_binding.dart';
import '../modules/shipper_order_list/views/shipper_order_list_view.dart';
import '../modules/shipper_register/bindings/shipper_register_binding.dart';
import '../modules/shipper_register/views/shipper_register_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SHIPPER_REGISTER;

  static final routes = [
    GetPage(
      name: _Paths.SHIPPER_REGISTER,
      page: () => ShipperRegisterView(),
      binding: ShipperRegisterBinding(),
    ),
    GetPage(
      name: _Paths.SHIPPER_HOME,
      page: () => ShipperHomeView(),
      binding: ShipperHomeBinding(),
    ),
    GetPage(
      name: _Paths.SHIPPER_ORDER_LIST,
      page: () => ShipperOrderListView(),
      binding: ShipperOrderListBinding(),
    ),
    GetPage(
      name: _Paths.SHIPPER_ORDER_DETAIL,
      page: () => ShipperOrderDetailView(),
      binding: ShipperOrderDetailBinding(),
    ),
  ];
}
