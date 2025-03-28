import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../resources/snackbar.dart';
import '../../../../resources/validate.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  double _passwordStrength = 0;
  String _passwordStrengthText = "Nhập mật khẩu";
  Color _passwordStrengthColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thay đổi mật khẩu"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: const Text(
                  "Mật khẩu của bạn phải có ít nhất 8 ký tự và bao gồm số, chữ cái và ký tự đặc biệt (!@%^&*).",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                  textAlign: TextAlign.left,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(height: 16),

              _buildPasswordField("Mật khẩu hiện tại:", currentPasswordController, false, () {}, validate: false),
              _buildPasswordField("Mật khẩu mới:", newPasswordController, _isNewPasswordVisible, () {
                setState(() {
                  _isNewPasswordVisible = !_isNewPasswordVisible;
                });
              }, onChanged: _checkPasswordStrength),

              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: _passwordStrength,
                      backgroundColor: Colors.grey.shade300,
                      color: _passwordStrengthColor,
                      minHeight: 6,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _passwordStrengthText,
                      style: TextStyle(color: _passwordStrengthColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              _buildPasswordField("Nhập lại mật khẩu mới:", confirmPasswordController, _isConfirmPasswordVisible, () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              }, isConfirmPassword: true),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton("Hủy", Colors.grey.shade300, Colors.black, () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Get.back();
                    }
                  }),

                  const SizedBox(width: 16),
                  _buildActionButton("Lưu", Colors.blue, Colors.white, () {
                    if (_formKey.currentState!.validate()) {
                      CustomSnackbar.showSuccess("Mật khẩu đã được cập nhật!");
                    } else {
                      CustomSnackbar.showError("Vui lòng kiểm tra lại mật khẩu.");
                    }
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      String label, TextEditingController controller, bool isPasswordVisible, VoidCallback toggleVisibility,
      {bool validate = true, bool isConfirmPassword = false, Function(String)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: !isPasswordVisible,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
          suffixIcon: IconButton(
            icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: toggleVisibility,
          ),
          errorMaxLines: 3,
        ),
        validator: validate
            ? (value) => Validate.validatePassword(value, confirmPassword: isConfirmPassword ? newPasswordController.text : null)
            : null,
      ),
    );
  }

  void _checkPasswordStrength(String password) {
    setState(() {
      if (password.isEmpty) {
        _passwordStrength = 0;
        _passwordStrengthText = "Nhập mật khẩu";
        _passwordStrengthColor = Colors.grey;
      } else if (password.length < 6) {
        _passwordStrength = 0.2;
        _passwordStrengthText = "Rất yếu";
        _passwordStrengthColor = Colors.red;
      } else if (password.length < 8) {
        _passwordStrength = 0.4;
        _passwordStrengthText = "Yếu";
        _passwordStrengthColor = Colors.orange;
      } else if (RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(password)) {
        _passwordStrength = 0.6;
        _passwordStrengthText = "Trung bình";
        _passwordStrengthColor = Colors.yellow;
      } else if (RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@%^&*])[A-Za-z\d!@%^&*]{8,}$').hasMatch(password)) {
        _passwordStrength = 0.8;
        _passwordStrengthText = "Mạnh";
        _passwordStrengthColor = Colors.green;
      } else {
        _passwordStrength = 1.0;
        _passwordStrengthText = "Rất mạnh";
        _passwordStrengthColor = Colors.blue;
      }
    });
  }

  Widget _buildActionButton(String text, Color backgroundColor, Color textColor, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}
