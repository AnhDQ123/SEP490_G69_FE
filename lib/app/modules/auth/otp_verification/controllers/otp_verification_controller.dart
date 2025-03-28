import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../base/base_controller.dart';
import '../../../../resources/snackbar.dart';
import '../../../../service/register_service.dart';


class OtpVerificationController extends BaseController {
  var phoneNumber = ''.obs;
  final otp = List.generate(6, (_) => ''.obs);
  final isLoading = false.obs;
  final RegisterService _registerService = RegisterService();

  List<TextEditingController> textControllers =
  List.generate(6, (_) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  // Thêm biến flow để xác định luồng
  late String flow;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    phoneNumber.value = Get.arguments?['phone'] ?? 'Unknown';
    flow = args?['flow'] ?? 'register'; // mặc định là "register" nếu không có
  }

  void verifyOtp() async {
    final enteredOtp = otp.map((e) => e.value).join();

    if (enteredOtp.length < 6) {
      CustomSnackbar.showError("Vui lòng nhập đầy đủ mã OTP.");
      return;
    }

    isLoading(true);
    bool isVerified = await _registerService.verifyOtp(phoneNumber.value, enteredOtp);
    isLoading(false);

    // if (isVerified) {
    //   CustomSnackbar.showSuccess("Xác minh OTP thành công!");
    //   Get.toNamed('/password-verification', arguments: {"phone": phoneNumber.value});
    // } else {
    //   CustomSnackbar.showError("OTP không chính xác hoặc đã hết hạn.");
    // }

    if (isVerified) {
      CustomSnackbar.showSuccess("Xác minh OTP thành công!");
      if (flow == 'forgotPassword') {
        // Nếu là quên mật khẩu, chuyển sang màn Reset Password
        Get.toNamed('/reset-password', arguments: {"phone": phoneNumber.value});
      } else {
        // Nếu là đăng ký, chuyển sang màn password verification (hoặc màn đăng ký tiếp theo)
        Get.toNamed('/password-verification', arguments: {"phone": phoneNumber.value});
      }
    } else {
      CustomSnackbar.showError("OTP không chính xác hoặc đã hết hạn.");
    }

  }

  void resendOtp() async {
    isLoading(true);
    bool isOtpSent = await _registerService.sendOtp(phoneNumber.value);
    isLoading(false);

    if (isOtpSent) {
      CustomSnackbar.showSuccess("Mã OTP đã được gửi lại!");
    } else {
      CustomSnackbar.showError("Gửi lại OTP thất bại. Vui lòng thử lại.");
    }
  }
}

