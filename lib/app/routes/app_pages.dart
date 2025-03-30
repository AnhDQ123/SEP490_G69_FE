import 'package:get/get.dart';

import '../modules/add_banner/bindings/add_banner_binding.dart';
import '../modules/add_banner/views/add_banner_view.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/register/bindings/register_binding.dart';
import '../modules/auth/register/views/register_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/shop_add_discount/bindings/shop_add_discount_binding.dart';
import '../modules/shop_add_discount/views/shop_add_discount_view.dart';
import '../modules/shop_dashboard/bindings/shop_dashboard_binding.dart';
import '../modules/shop_dashboard/views/shop_dashboard_view.dart';
import '../modules/shop_detail/bindings/shop_detail_binding.dart';
import '../modules/shop_detail/views/shop_detail_view.dart';
import '../modules/shop_menu/bindings/shop_binding.dart';
import '../modules/shop_menu/views/shop_view.dart';
import '../modules/shop_product_discount_list/bindings/product_discount_binding.dart';
import '../modules/shop_product_discount_list/views/product_discount_view.dart';
import '../modules/shop_register/bindings/shop_register_binding.dart';
import '../modules/shop_register/views/shop_register_view.dart';
import '../modules/shop_voucher_add/bindings/shop_voucher_add_binding.dart';
import '../modules/shop_voucher_add/views/shop_voucher_add_view.dart';
import '../modules/shop_voucher_list/bindings/shop_voucher_list_binding.dart';
import '../modules/shop_voucher_list/views/shop_voucher_list_view.dart';
import '../modules/user_profile/change_password/bindings/change_password_binding.dart';
import '../modules/user_profile/change_password/views/change_password_view.dart';
import '../modules/user_profile/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/user_profile/edit_profile/views/edit_profile_view.dart';
import '../modules/user_profile/profile/bindings/profile_binding.dart';
import '../modules/user_profile/profile/views/profile_view.dart';
import '../modules/user_profile/setting_logout/bindings/setting_logout_binding.dart';
import '../modules/user_profile/setting_logout/views/setting_logout_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SHOP;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
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
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_REGISTER,
      page: () => ShopRegisterView(),
      binding: ShopRegisterBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_LOGOUT,
      page: () => const SettingLogoutView(),
      binding: SettingLogoutBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DISCOUNT,
      page: () => ProductDiscountView(),
      binding: ProductDiscountBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_DASHBOARD,
      page: () => ShopDashboardView(),
      binding: ShopDashboardBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_ADD_DISCOUNT,
      page: () => ShopAddDiscountView(),
      binding: ShopAddDiscountBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_VOUCHER_LIST,
      page: () => ShopVoucherListView(),
      binding: ShopVoucherListBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_VOUCHER_ADD,
      page: () => ShopVoucherAddView(),
      binding: ShopVoucherAddBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_DETAIL,
      page: () => ShopDetailView(),
      binding: ShopDetailBinding(),
    ),
  ];
}
