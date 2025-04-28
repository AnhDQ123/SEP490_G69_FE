import 'package:get/get.dart';

import '../modules/add_banner/bindings/add_banner_binding.dart';
import '../modules/add_banner/views/add_banner_view.dart';
import '../modules/add_blog/bindings/add_blog_binding.dart';
import '../modules/add_blog/views/add_blog_view.dart';
import '../modules/auth/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/auth/forgot_password/views/forgot_password_view.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/otp_verification/bindings/otp_verification_binding.dart';
import '../modules/auth/otp_verification/views/otp_verification_view.dart';
import '../modules/auth/password_verification/bindings/password_verification_binding.dart';
import '../modules/auth/password_verification/views/password_verification_view.dart';
import '../modules/auth/register/bindings/register_binding.dart';
import '../modules/auth/register/views/register_view.dart';
import '../modules/auth/reset_password/bindings/reset_password_binding.dart';
import '../modules/auth/reset_password/views/reset_password_view.dart';
import '../modules/auth/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/auth/splash_screen/views/splash_screen_view.dart';
import '../modules/auth/user_info/bindings/user_info_binding.dart';
import '../modules/auth/user_info/views/user_info_view.dart';
import '../modules/blog_detail/bindings/blog_detail_binding.dart';
import '../modules/blog_detail/views/blog_detail_view.dart';
import '../modules/blog_list/bindings/blog_list_binding.dart';
import '../modules/blog_list/views/blog_list_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/category/bindings/category_binding.dart';
import '../modules/category/views/category_view.dart';
import '../modules/check_out/bindings/check_out_binding.dart';
import '../modules/check_out/views/check_out_view.dart';
import '../modules/filter/bindings/filter_binding.dart';
import '../modules/filter/views/filter_view.dart';
import '../modules/google_map_page/bindings/google_map_page_binding.dart';
import '../modules/google_map_page/views/google_map_page_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/map_picker/bindings/map_picker_binding.dart';
import '../modules/map_picker/views/map_picker_view.dart';
import '../modules/my_order/bindings/my_order_binding.dart';
import '../modules/my_order/views/my_order_view.dart';
import '../modules/product_detail/bindings/product_detail_binding.dart';
import '../modules/product_detail/views/product_detail_view.dart';
import '../modules/qr_payment/bindings/qr_payment_binding.dart';
import '../modules/qr_payment/views/qr_payment_view.dart';
import '../modules/return_order_detail_page/bindings/return_order_detail_page_binding.dart';
import '../modules/return_order_detail_page/views/return_order_detail_page_view.dart';
import '../modules/search_screen/bindings/search_screen_binding.dart';
import '../modules/search_screen/views/search_screen_view.dart';
import '../modules/send_report/bindings/send_report_binding.dart';
import '../modules/send_report/views/send_report_view.dart';
import '../modules/shipper_home/bindings/shipper_home_binding.dart';
import '../modules/shipper_home/views/shipper_home_view.dart';
import '../modules/shipper_order_detail/bindings/shipper_order_detail_binding.dart';
import '../modules/shipper_order_detail/views/shipper_order_detail_view.dart';
import '../modules/shipper_order_list/bindings/shipper_order_list_binding.dart';
import '../modules/shipper_order_list/views/shipper_order_list_view.dart';
import '../modules/shipper_register/bindings/shipper_register_binding.dart';
import '../modules/shipper_register/views/shipper_register_view.dart';
import '../modules/shop_add_discount/bindings/shop_add_discount_binding.dart';
import '../modules/shop_add_discount/views/shop_add_discount_view.dart';
import '../modules/shop_add_product/bindings/shop_add_product_binding.dart';
import '../modules/shop_add_product/views/shop_add_product_view.dart';
import '../modules/shop_banner/bindings/shop_banner_binding.dart';
import '../modules/shop_banner/views/shop_banner_view.dart';
import '../modules/shop_dashboard/bindings/shop_dashboard_binding.dart';
import '../modules/shop_dashboard/views/shop_dashboard_view.dart';
import '../modules/shop_detail/bindings/shop_detail_binding.dart';
import '../modules/shop_detail/views/shop_detail_view.dart';
import '../modules/shop_manage_shipper/bindings/shop_manage_shipper_binding.dart';
import '../modules/shop_manage_shipper/views/shop_manage_shipper_view.dart';
import '../modules/shop_menu/bindings/shop_binding.dart';
import '../modules/shop_menu/views/shop_view.dart';
import '../modules/shop_order/bindings/shop_order_binding.dart';
import '../modules/shop_order/views/shop_order_view.dart';
import '../modules/shop_product_discount_list/bindings/product_discount_binding.dart';
import '../modules/shop_product_discount_list/views/product_discount_view.dart';
import '../modules/shop_product_list/bindings/shop_product_list_binding.dart';
import '../modules/shop_product_list/views/shop_product_list_view.dart';
import '../modules/shop_profile/bindings/shop_profile_binding.dart';
import '../modules/shop_profile/views/shop_profile_view.dart';
import '../modules/shop_register/bindings/shop_register_binding.dart';
import '../modules/shop_register/views/shop_register_view.dart';
import '../modules/shop_report/bindings/shop_report_binding.dart';
import '../modules/shop_report/views/shop_report_view.dart';
import '../modules/shop_report_list/bindings/shop_report_list_binding.dart';
import '../modules/shop_report_list/views/shop_report_list_view.dart';
import '../modules/shop_voucher_add/bindings/shop_voucher_add_binding.dart';
import '../modules/shop_voucher_add/views/shop_voucher_add_view.dart';
import '../modules/shop_voucher_list/bindings/shop_voucher_list_binding.dart';
import '../modules/shop_voucher_list/views/shop_voucher_list_view.dart';
import '../modules/user_map/bindings/user_map_binding.dart';
import '../modules/user_map/views/user_map_view.dart';
import '../modules/user_profile/change_password/bindings/change_password_binding.dart';
import '../modules/user_profile/change_password/views/change_password_view.dart';
import '../modules/user_profile/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/user_profile/edit_profile/views/edit_profile_view.dart';
import '../modules/user_profile/profile/bindings/profile_binding.dart';
import '../modules/user_profile/profile/views/profile_view.dart';
import '../modules/user_profile/setting_logout/bindings/setting_logout_binding.dart';
import '../modules/user_profile/setting_logout/views/setting_logout_view.dart';
import '../modules/user_view_shop_detail/bindings/user_view_shop_detail_binding.dart';
import '../modules/user_view_shop_detail/views/user_view_shop_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

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
      name: _Paths.OTP_VERIFICATION,
      page: () => const OtpVerificationView(),
      binding: OtpVerificationBinding(), // Tạo file binding riêng
    ),
    GetPage(
      name: _Paths.PASSWORD_VERIFICATION,
      page: () => const PasswordVerificationView(),
      binding: PasswordVerificationBinding(), // Tạo file binding riêng
    ),
    GetPage(
      name: _Paths.USER_INFO,
      page: () => const UserInfoView(),
      binding: UserInfoBinding(), // Tạo file binding riêng
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
    GetPage(
      name: _Paths.SHOP_PRODUCT_LIST,
      page: () => ShopProductListView(),
      binding: ShopProductListBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAIL,
      page: () => const ProductDetailView(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: _Paths.FILTER,
      page: () => FilterView(),
      binding: FilterBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.MY_ORDER,
      page: () => const MyOrderView(),
      binding: MyOrderBinding(),
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
      name: _Paths.QR_PAYMENT,
      page: () => const QrPaymentView(),
      binding: QrPaymentBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_SCREEN,
      page: () => const SearchScreenView(),
      binding: SearchScreenBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_PROFILE,
      page: () => const ShopProfileView(),
      binding: ShopProfileBinding(),
    ),
    GetPage(
      name: _Paths.USER_VIEW_SHOP_DETAIL,
      page: () => UserViewShopDetailView(),
      binding: UserViewShopDetailBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_REPORT,
      page: () => ShopReportView(),
      binding: ShopReportBinding(),
    ),
    GetPage(
      name: _Paths.SEND_REPORT,
      page: () => SendReportView(),
      binding: SendReportBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_REPORT_LIST,
      page: () => ShopReportListView(),
      binding: ShopReportListBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_ADD_PRODUCT,
      page: () => ShopAddProductView(),
      binding: ShopAddProductBinding(),
    ),
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
    GetPage(
      name: _Paths.SHOP_BANNER,
      page: () => ShopBannerView(),
      binding: ShopBannerBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_MANAGE_SHIPPER,
      page: () => ShopManageShipperView(),
      binding: ShopManageShipperBinding(),
    ),
    GetPage(
      name: _Paths.BLOG_LIST,
      page: () => const BlogListView(),
      binding: BlogListBinding(),
    ),
    GetPage(
      name: _Paths.BLOG_DETAIL,
      page: () => BlogDetailView(),
      binding: BlogDetailBinding(),
    ),
    GetPage(
      name: _Paths.ADD_BLOG,
      page: () => const AddBlogView(),
      binding: AddBlogBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORY,
      page: () => const CategoryView(),
      binding: CategoryBinding(),
    ),
    // GetPage(
    //   name: _Paths.MAP_PICKER,
    //   page: () => OsmMapPickerScreen(),
    //   binding: MapPickerBinding(),
    // ),
    GetPage(
      name: _Paths.GOOGLE_MAP_PAGE,
      page: () => GoogleMapPageView(),
      binding: GoogleMapPageBinding(),
    ),
    GetPage(
      name: _Paths.USER_MAP,
      page: () =>  UserMapView(),
      binding: UserMapBinding(),
    ),
  ];
}
