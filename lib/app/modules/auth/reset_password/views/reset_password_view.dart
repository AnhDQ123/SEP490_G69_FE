import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đặt lại mật khẩu'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tạo mật khẩu mới',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            Text(
              'Vui lòng nhập mật khẩu mới cho số điện thoại ${controller.phone.value}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 32),

            /// ── Mật khẩu mới ───────────────────────────────────────────────
            Obx(() => TextField(
              controller: controller.newPasswordController,
              obscureText: !controller.showPassword.value,
              decoration: InputDecoration(
                labelText: 'Mật khẩu mới',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.showPassword.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            )),
            const SizedBox(height: 16),

            /// ── Nhập lại mật khẩu ─────────────────────────────────────────
            Obx(() => TextField(
              controller: controller.confirmPasswordController,
              obscureText: !controller.showConfirmPassword.value,
              decoration: InputDecoration(
                labelText: 'Nhập lại mật khẩu',
                prefixIcon: const Icon(Icons.lock_reset),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.showConfirmPassword.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  onPressed: controller.toggleConfirmPasswordVisibility,
                ),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            )),
            const SizedBox(height: 8),
            Text(
              'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 32),

            /// ── Nút xác nhận ──────────────────────────────────────────────
            Obx(() => SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.submit,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white)
                    : const Text('Đặt lại mật khẩu',
                    style: TextStyle(fontSize: 16)),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
