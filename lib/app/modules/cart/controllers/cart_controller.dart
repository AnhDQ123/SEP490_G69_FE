import 'package:get/get.dart';

// Model đơn giản cho subItem (ví dụ: topping, extra, ...)
class SubItem {
  String name;
  int price; // Giá tiền
  int quantity;

  SubItem({
    required this.name,
    required this.price,
    this.quantity = 1,
  });
}

// Model đơn giản cho item trong cart
class CartItem {
  String itemName;
  int price;        // Giá gốc
  int discount;     // % giảm giá, nếu có
  int quantity;     // Số lượng
  bool isSelected;  // Check người dùng chọn hay bỏ
  String note;      // Ghi chú
  List<SubItem> subItems;

  CartItem({
    required this.itemName,
    required this.price,
    this.discount = 0,
    this.quantity = 1,
    this.isSelected = true,
    this.note = '',
    this.subItems = const [],
  });

  /// Tính giá cuối cùng cho 1 item (đã trừ discount nếu có)
  /// Lưu ý: discount tính trên giá chính, chưa tính subItems
  int get finalItemPrice {
    final discounted = price - (price * discount ~/ 100);
    return discounted;
  }

  /// Tính tổng tiền của subItems
  int get subItemsPrice {
    int total = 0;
    for (var sub in subItems) {
      total += (sub.price * sub.quantity);
    }
    return total;
  }

  /// Tổng tiền = (giá item sau discount + subItems) * quantity
  int get totalPrice {
    return (finalItemPrice + subItemsPrice) * quantity;
  }
}

// Model nhóm item theo quán (vendor)
class CartVendor {
  String vendorName;
  List<CartItem> items;

  CartVendor({
    required this.vendorName,
    required this.items,
  });
}

class CartController extends GetxController {
  // Danh sách giỏ hàng theo quán
  // final cartList = <CartVendor>[
  //   CartVendor(
  //     vendorName: "Cơm rang Minh Nhật",
  //     items: [
  //       CartItem(
  //         itemName: "Cơm rang thập cẩm",
  //         price: 30000,
  //         quantity: 1,
  //       ),
  //       CartItem(
  //         itemName: "Quẩy",
  //         price: 3000,
  //         quantity: 1,
  //       ),
  //     ],
  //   ),
  //   CartVendor(
  //     vendorName: "Trà sữa Anh Đức",
  //     items: [
  //       CartItem(
  //         itemName: "Hồng trà",
  //         price: 40000,
  //         discount: 50, // giảm giá 50%
  //         quantity: 1,
  //         subItems: [
  //           SubItem(name: "Trân châu sương mai", price: 3000),
  //           SubItem(name: "Thạch", price: 6000),
  //         ],
  //       ),
  //     ],
  //   ),
  // ].obs;
  final cartList = <CartVendor>[].obs;


  /// Checkbox "Chọn tất cả"
  RxBool isSelectAll = true.obs;

  /// Tính tổng tiền toàn giỏ hàng
  int get totalCartPrice {
    int sum = 0;
    for (var vendor in cartList) {
      for (var item in vendor.items) {
        if (item.isSelected) {
          sum += item.totalPrice;
        }
      }
    }
    return sum;
  }

  /// Hàm check/uncheck tất cả items
  void toggleSelectAll(bool value) {
    isSelectAll.value = value;
    for (var vendor in cartList) {
      for (var item in vendor.items) {
        item.isSelected = value;
      }
    }
    // Bắn update UI
    cartList.refresh();
  }

  /// Khi 1 item thay đổi check => cập nhật isSelectAll
  void toggleItemSelected(CartVendor vendor, CartItem item, bool value) {
    item.isSelected = value;
    // Nếu có bất kỳ item nào chưa chọn thì isSelectAll = false
    if (cartList.any((v) => v.items.any((i) => i.isSelected == false))) {
      isSelectAll.value = false;
    } else {
      isSelectAll.value = true;
    }
    cartList.refresh();
  }

  /// Thay đổi số lượng
  void changeItemQuantity(CartVendor vendor, CartItem item, bool isIncrement) {
    if (isIncrement) {
      item.quantity++;
    } else {
      if (item.quantity > 1) {
        item.quantity--;
      }
    }
    cartList.refresh();
  }

  /// Ghi chú cho item
  void updateNote(CartItem item, String note) {
    item.note = note;
    cartList.refresh();
  }

  /// Thanh toán
  void checkout() {
    // Xử lý logic thanh toán tùy ý
    Get.snackbar("Thanh toán", "Tổng tiền: $totalCartPrice đ");
  }
}
