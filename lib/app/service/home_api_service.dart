import 'package:get/get.dart';
import '../modules/cart/controllers/cart_controller.dart';

// Hàm chuyển đổi giá từ chuỗi "40.000đ" sang số int (40000)
int parsePrice(String priceStr) {
  // Loại bỏ các ký tự không phải số
  final cleaned = priceStr.replaceAll(RegExp(r'[^\d]'), '');
  return int.tryParse(cleaned) ?? 0;
}

// Fake API để thêm sản phẩm vào giỏ hàng
Future<bool> addProductToCart(Map<String, String> product) async {
  // Giả lập độ trễ của API (ví dụ 500ms)
  await Future.delayed(const Duration(milliseconds: 500));

  // Lấy CartController từ GetX
  final CartController cartController = Get.find<CartController>();

  // Tạo đối tượng CartItem từ dữ liệu sản phẩm
  final newItem = CartItem(
    itemName: product['name'] ?? '',
    price: parsePrice(product['price'] ?? '0'),
    quantity: 1,
  );

  // Giả sử sử dụng vendor mặc định, ví dụ "Cửa hàng mặc định"
  const defaultVendor = "Cửa hàng mặc định";

  // Tìm xem vendor mặc định đã tồn tại trong cartList chưa
  final existingVendor = cartController.cartList.firstWhere(
        (vendor) => vendor.vendorName == defaultVendor,
    orElse: () => CartVendor(vendorName: defaultVendor, items: []),
  );

  // Nếu vendor chưa có trong cartList, thêm nó vào
  if (!cartController.cartList.contains(existingVendor)) {
    cartController.cartList.add(existingVendor);
  }

  // Thêm sản phẩm vào danh sách item của vendor đó
  existingVendor.items.add(newItem);
  cartController.cartList.refresh();

  return true;
}
