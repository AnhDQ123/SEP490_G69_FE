import 'package:get/get.dart';

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
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/filter/bindings/filter_binding.dart';
import '../modules/filter/views/filter_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/user_profile/change_password/bindings/change_password_binding.dart';
import '../modules/user_profile/change_password/views/change_password_view.dart';
import '../modules/user_profile/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/user_profile/edit_profile/views/edit_profile_view.dart';
import '../modules/user_profile/profile/bindings/profile_binding.dart';
import '../modules/user_profile/profile/views/profile_view.dart';
import '../modules/user_profile/setting_logout/bindings/setting_logout_binding.dart';
import '../modules/user_profile/setting_logout/views/setting_logout_view.dart';
import '../modules/productForm/bindings/product_form_binding.dart';
import '../modules/productForm/views/product_form_view.dart';
import '../modules/productListShop/bindings/product_list_shop_binding.dart';
import '../modules/productListShop/views/product_list_shop_view.dart';
import '../modules/product_detail/bindings/product_detail_binding.dart';
import '../modules/product_detail/views/product_detail_view.dart';
import '../modules/product_selection/bindings/product_selection_binding.dart';
import '../modules/product_selection/views/product_selection_view.dart';
import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/checkout/views/checkout_view.dart';

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
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_LOGOUT,
      page: () => const SettingLogoutView(),
      binding: SettingLogoutBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VERIFICATION,
      page: () => const OtpVerificationView(),
      binding: OtpVerificationBinding(),
    ),
    GetPage(
      name: _Paths.PASSWORD_VERIFICATION,
      page: () => const PasswordVerificationView(),
      binding: PasswordVerificationBinding(),
    ),
    GetPage(
      name: _Paths.USER_INFO,
      page: () => const UserInfoView(),
      binding: UserInfoBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_SELECTION,
      page: () =>  ProductSelectionView(),
      binding: ProductSelectionBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAIL,
      page: () => const ProductDetailView(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: _Paths.FILTER,
      page: () => const FilterView(),
      binding: FilterBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.CHECKOUT,
      page: () => CheckoutView(),
      binding: CheckoutBinding(),
    ),
  ];
}
