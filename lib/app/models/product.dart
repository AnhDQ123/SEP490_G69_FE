import 'food_option.dart';

class Product {
  final int productId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String description;
  final DateTime? expiredDate;
  final bool isActive;
  final String manufacturer;
  final String productName;
  final int quantity;
  final double rate;
  final String supplier;
  final int? discountId;
  final int shopId;
  final List<FoodOption> options; // Danh sách size & option

  Product({
    required this.productId,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
    this.expiredDate,
    required this.isActive,
    required this.manufacturer,
    required this.productName,
    required this.quantity,
    required this.rate,
    required this.supplier,
    this.discountId,
    required this.shopId,
    required this.options,
  });

  /// Trả về giá của **size** sản phẩm (bắt buộc phải có size)
  double getBasePrice() {
    return options.firstWhere((option) => option.isSize, orElse: () {
      throw Exception("Không tìm thấy size cho sản phẩm $productName");
    }).price;
  }

  double getTotalPrice() {
    // Lấy size của sản phẩm
    FoodOption sizeOption = options.firstWhere((option) => option.isSize, orElse: () {
      throw Exception("Không tìm thấy size cho sản phẩm $productName");
    });

    double sizePrice = sizeOption.price;
    int sizeQuantity = sizeOption.quantity; // Số lượng size chính là số lượng sản phẩm trong giỏ hàng

    // Tính tổng giá của các option (option chỉ nhân với số lượng của chính nó, không phụ thuộc vào size quantity)
    double optionTotal = options
        .where((option) => !option.isSize) // Chỉ lấy các option (không phải size)
        .fold(0, (sum, option) => sum + (option.price * option.quantity));

    // Tổng tiền = (size price * size quantity) + option total
    double totalPrice = (sizePrice * sizeQuantity) + optionTotal;

    // In ra log để kiểm tra
    print("💰 [TOTAL PRODUCT] $productName - Size Quantity: $sizeQuantity, Size Price: $sizePrice, Option Total: $optionTotal, Total: $totalPrice");

    return totalPrice;
  }

  // Sample data
  static List<Product> sampleProducts = [
    Product(
      productId: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      description: "Cơm rang thập cẩm thơm ngon, đầy đủ topping.",
      expiredDate: null,
      isActive: true,
      manufacturer: "Nhà hàng Minh Nhật",
      productName: "Cơm rang thập cẩm",
      quantity: 1,
      rate: 4.5,
      supplier: "Nhật Food",
      discountId: null,
      shopId: 1,
      options: [
        FoodOption(
          foodOptionId: 1,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          image: "assets/size_m.png",
          name: "Size M",
          price: 30000,
          quantity: 1,
          isActive: true,
          productId: 1,
          typeId: 1,
        ),
        FoodOption(
          foodOptionId: 2,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          image: "assets/beef.png",
          name: "Thêm bò",
          price: 5000,
          quantity: 1,
          isActive: true,
          productId: 1,
          typeId: 2,
        ),
      ],
    ),
    Product(
      productId: 2,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      description: "Quẩy giòn rụm, ngon miệng.",
      expiredDate: null,
      isActive: true,
      manufacturer: "Bếp Việt",
      productName: "Quẩy",
      quantity: 5,
      rate: 4.0,
      supplier: "Bếp Việt Food",
      discountId: null,
      shopId: 1,
      options: [
        FoodOption(
          foodOptionId: 3,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          image: "assets/size_l.png",
          name: "Quẩy",
          price: 6000,
          quantity: 1,
          isActive: true,
          productId: 2,
          typeId: 1,
        ),
      ],
    ),
    Product(
      productId: 3,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      description: "Hồng trà nguyên chất, hương vị đậm đà.",
      expiredDate: null,
      isActive: true,
      manufacturer: "Anh Đức Tea",
      productName: "Hồng trà",
      quantity: 7,
      rate: 4.8,
      supplier: "Anh Đức",
      discountId: null,
      shopId: 2,
      options: [
        FoodOption(
          foodOptionId: 5,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          image: "assets/size_m.png",
          name: "Size M",
          price: 40000,
          quantity: 1,
          isActive: true,
          productId: 3,
          typeId: 1,
        ),
      ],
    ),
    Product(
      productId: 4,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      description: "Trân châu sương mai handmade, dẻo ngon.",
      expiredDate: null,
      isActive: true,
      manufacturer: "Anh Đức Tea",
      productName: "Trân châu sương mai",
      quantity: 1,
      rate: 4.6,
      supplier: "Anh Đức",
      discountId: null,
      shopId: 2,
      options: [
        FoodOption(
          foodOptionId: 6,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          image: "assets/size_m.png",
          name: "Size M",
          price: 6000,
          quantity: 1,
          isActive: true,
          productId: 4,
          typeId: 1,
        ),
        FoodOption(
          foodOptionId: 7,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          image: "assets/pearl_white.png",
          name: "Thêm trân châu trắng",
          price: 5000,
          quantity: 1,
          isActive: true,
          productId: 4,
          typeId: 2,
        ),
      ],
    ),
  ];
}
