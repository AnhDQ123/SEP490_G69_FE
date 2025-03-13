import 'product.dart';
import 'food_option.dart';

class CartItem {
  final Product product;
  final List<FoodOption> selectedOptions; // Không cần quantity riêng

  CartItem({
    required this.product,
    required this.selectedOptions,
  });

  /// Tính tổng giá của sản phẩm (gồm giá size + các option)
  double getTotalPrice() {
    FoodOption sizeOption = selectedOptions.firstWhere((option) => option.isSize, orElse: () {
      throw Exception("Không tìm thấy size cho sản phẩm ${product.productName}");
    });

    double sizePrice = sizeOption.price;
    int sizeQuantity = sizeOption.quantity; // Dùng size quantity làm số lượng sản phẩm

    double optionTotal = selectedOptions
        .where((option) => !option.isSize)
        .fold(0, (sum, option) => sum + (option.price * option.quantity));

    double totalPrice = (sizePrice * sizeQuantity) + optionTotal;

    print("🛒 [CART ITEM] ${product.productName} - Size Quantity: $sizeQuantity, Size Price: $sizePrice, Option Total: $optionTotal, Total: $totalPrice");

    return totalPrice;
  }
}

