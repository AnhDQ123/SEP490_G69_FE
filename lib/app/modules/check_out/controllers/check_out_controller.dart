import 'package:get/get.dart';
import '../../../models/check_out.dart';
import '../../../models/checkout_option.dart';
import '../../../models/voucher.dart';

class CheckOutController extends GetxController {
  /// Dữ liệu checkout dưới dạng Rx (để lắng nghe và cập nhật UI)
  var checkoutInfo = CheckoutInfo(
    userName: 'Hoàng Hải Đăng',
    phoneNumber: '0969xxxxxx',
    address: 'Số nhà 88/155, Xuân Đỉnh, Hà Nội',
    deliveryTime: DateTime.now().add(const Duration(hours: 2)),
    items: [
      CheckoutItem(
        name: 'Cơm rang thập cẩm',
        quantity: 1,
        price: 45000,
        discount: 0,
        imageUrl: 'https://image.pngaaa.com/305/269305-middle.png',
        shopName: 'Cơm rang Minh Nhật',
        size: 'L',
        options: [
          CheckoutOption(
            name: 'Ít cay',
            price: 5000,
            imageUrl: 'https://image.pngaaa.com/305/269305-middle.png',
            quantity: 1,
          ),
          CheckoutOption(
            name: 'Thêm trứng',
            price: 10000,
            imageUrl: 'https://image.pngaaa.com/305/269305-middle.png',
            quantity: 2,
          ),
        ],
      ),
      CheckoutItem(
        name: 'Cơm rang thập cẩm',
        quantity: 1,
        price: 45000,
        discount: 0,
        imageUrl: 'https://image.pngaaa.com/305/269305-middle.png',
        shopName: 'Pho',
        size: 'L',
        options: [
          CheckoutOption(
            name: 'Ít cay',
            price: 5000,
            imageUrl: 'https://image.pngaaa.com/305/269305-middle.png',
            quantity: 1,
          ),
          CheckoutOption(
            name: 'Thêm trứng',
            price: 10000,
            imageUrl: 'https://image.pngaaa.com/305/269305-middle.png',
            quantity: 2,
          ),
        ],
      ),
    ],
    subTotal: 82000,
    shippingFee: 10000,
    // Không cần truyền total vì nó được tính qua getter
    vouchers: {
      'Cơm rang Minh Nhật': Voucher(name: 'SALE50', value: 5000),
      'Pho': Voucher(name: 'SALE20', value: 2000),
    },
    needTools: false,
    note: '',
    paymentMethod: PaymentMethod.bank,
    shippingMethod: "Shipper (10,000 đồng)", // Giá trị mặc định
  ).obs;

  /// Toggle dụng cụ ăn uống
  void toggleNeedTools(bool value) {
    checkoutInfo.update((val) {
      val?.needTools = value;
    });
  }

  /// Cập nhật ghi chú
  void updateNote(String newNote) {
    checkoutInfo.update((val) {
      val?.note = newNote;
    });
  }

  /// Cập nhật phương thức thanh toán
  void updatePaymentMethod(PaymentMethod method) {
    checkoutInfo.update((val) {
      val?.paymentMethod = method;
    });
  }

  /// Hàm xử lý đặt hàng
  Future<void> placeOrder() async {
    // TODO: Thực hiện logic gọi API, kiểm tra ràng buộc, v.v.
    await Future.delayed(const Duration(seconds: 2));
    // Sau khi thành công, điều hướng sang trang xác nhận
  }

  /// Áp dụng voucher cho shop cụ thể
  void applyVoucher(String shopName, Voucher voucher) {
    checkoutInfo.update((val) {
      if (val != null) {
        val.vouchers[shopName] = voucher;
      }
    });
  }

  /// Huỷ voucher của shop cụ thể
  void removeVoucher(String shopName) {
    checkoutInfo.update((val) {
      if (val != null) {
        val.vouchers.remove(shopName);
      }
    });
  }

  /// Cập nhật phương thức vận chuyển và phí ship
  void updateShippingMethod(String method) {
    checkoutInfo.update((val) {
      if (val != null) {
        if (method == "Shop tự ship (0 đồng)") {
          val.shippingFee = 0;
        } else if (method == "Shipper (10,000 đồng)") {
          val.shippingFee = 10000;
        }
        // Cập nhật tên phương thức vận chuyển
        val.shippingMethod = method;
        // Không cần cập nhật total thủ công vì getter total đã tự tính
      }
    });
  }
}
