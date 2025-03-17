import 'checkout_option.dart';
import 'voucher.dart';  // File voucher.dart chứa class Voucher

class CheckoutInfo {
  String userName; // Tên người nhận
  String phoneNumber; // Số điện thoại
  String address; // Địa chỉ giao hàng
  DateTime? deliveryTime; // Thời gian giao dự kiến (có thể null)
  List<CheckoutItem> items; // Danh sách sản phẩm/món ăn
  int shippingFee; // Phí ship
  String shippingMethod; // Phương thức vận chuyển đã chọn
  // Dùng vouchers theo shop: key: shopName, value: voucher của shop đó
  Map<String, Voucher> vouchers;
  bool needTools; // Cần dụng cụ ăn uống không
  String note; // Ghi chú cho người giao hàng
  PaymentMethod paymentMethod; // Phương thức thanh toán
  int subTotal; // Tổng tiền sản phẩm (chưa gồm phí ship, voucher)

  CheckoutInfo({
    required this.userName,
    required this.phoneNumber,
    required this.address,
    required this.items,
    required this.subTotal,
    required this.shippingFee,
    this.deliveryTime,
    Map<String, Voucher>? vouchers,
    this.needTools = false,
    this.note = '',
    this.paymentMethod = PaymentMethod.bank,
    this.shippingMethod = "Shipper (10,000 đồng)", // Giá trị mặc định
  }) : vouchers = vouchers ?? {};

  // Tổng tiền thanh toán cuối cùng được tính toán tự động:
  int get total {
    final discountTotal = vouchers.values.fold(
        0, (int prev, voucher) => prev + voucher.value.toInt());
    return (subTotal - discountTotal) + shippingFee;
  }
}

/// Mỗi sản phẩm hoặc món ăn trong giỏ
class CheckoutItem {
  final String name; // Tên sản phẩm
  final int quantity; // Số lượng
  final int price; // Đơn giá
  final int discount; // Phần trăm giảm giá (nếu có)
  final String imageUrl; // Ảnh sản phẩm
  final String shopName; // Tên shop cung cấp sản phẩm
  final String size;
  final List<CheckoutOption> options; // Các tùy chọn kèm theo (có thể nhiều hơn 1)

  CheckoutItem({
    required this.name,
    required this.quantity,
    required this.price,
    this.discount = 0,
    required this.imageUrl,
    required this.shopName,
    this.size = '',
    this.options = const [],
  });
}

/// Phương thức thanh toán
enum PaymentMethod {
  bank,
  momo,
  cod, // thanh toán khi nhận hàng
  // Thêm các phương thức khác nếu cần
}
