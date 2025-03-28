import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../routes/app_pages.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print("SplashScreenController onInit()");
    _checkLoginStatus();
  }

  // Hàm kiểm tra trạng thái đăng nhập
  void _checkLoginStatus() async {
    // Delay hiển thị Splash Screen (2 giây)
    await Future.delayed(Duration(seconds: 2));
    print("Kiểm tra token trong SplashController");

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print("Token lấy được: $token");


    if (token != null && token.isNotEmpty) {
      // Nếu có token, chuyển hướng đến Home
      Get.offAllNamed(Routes.HOME);
    } else {
      // Nếu không có token, chuyển hướng đến Login
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
