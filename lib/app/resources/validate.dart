class Validate {
  static String? validatePassword(String? value, {String? confirmPassword}) {
    if (value == null || value.isEmpty) {
      return "Mật khẩu không được để trống.";
    }

    if (confirmPassword != null) {
      if (value != confirmPassword) return "Mật khẩu nhập lại không khớp.";
    } else {
      // Regex kiểm tra mật khẩu: ít nhất 8 ký tự, chứa chữ thường, chữ hoa, số và ký tự đặc biệt (!@%^&*)
      final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@%^&*])[A-Za-z\d!@%^&*]{8,}$');
      if (!regex.hasMatch(value)) {
        return "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt (!@%^&*).";
      }
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Số điện thoại không được để trống.";
    }
    final phoneRegex = RegExp(r'^(?:\+84|0)[1-9][0-9]{8}$');
    if (!phoneRegex.hasMatch(value)) {
      return "Số điện thoại không hợp lệ! Định dạng hợp lệ: +84xxxxxxxxx hoặc 0xxxxxxxxx.";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email không được để trống.";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Email không hợp lệ! Vui lòng nhập đúng định dạng (vd: example@email.com).";
    }

    return null;
  }
}
