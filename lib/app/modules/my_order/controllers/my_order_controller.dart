import 'package:get/get.dart';
import '../../../models/order.dart';
import '../../../models/order_item.dart';
import '../../../models/voucher.dart'; // Import model Voucher

class MyOrderController extends GetxController {
  var currentIndex = 4.obs;

  final List<Order> pendingConfirmationOrders = [
    Order(
      shopName: "Cơm rang Minh Nhật",
      voucher: Voucher(name: "GIAM5K", value: 5000), // Voucher cho đơn này
      items: [
        OrderItem(
          imageUrl: "https://image.pngaaa.com/305/269305-middle.png",
          dishName: "Cơm rang thập cẩm",
          quantity: 1,
          price: 45000,
          discount: 20, // 20%
          option: "Cay",
          size: "Lớn",
        ),
        OrderItem(
          imageUrl: "https://image.pngaaa.com/305/269305-middle.png",
          dishName: "Cơm rang dưa bò",
          quantity: 1,
          price: 30000,
          discount: 0,
        ),
      ],
    ),
    // Thêm một đơn hàng mới từ shop "Pizza House"
    Order(
      shopName: "Pizza House",
      voucher: Voucher(name: "PIZZAGIAM", value: 8000),
      items: [
        OrderItem(
          imageUrl: "https://image.pngaaa.com/305/269305-middle.png",
          dishName: "Pizza Margherita",
          quantity: 2,
          price: 120000,
          discount: 15, // 15%
          option: "Extra Cheese",
          size: "Medium",
        ),
      ],
    ),
  ];

  final List<Order> preparingOrders = [
    Order(
      shopName: "Trà sữa Minh Nhật",
      voucher: null,
      items: [
        OrderItem(
          imageUrl: "https://image.pngaaa.com/305/269305-middle.png",
          dishName: "Trà sữa chocolate",
          quantity: 1,
          price: 30000,
          discount: 10,
          option: "Thêm trân châu",
          size: "Vừa",
        ),
      ],
    ),
  ];

  final List<Order> shippingOrders = [
    Order(
      shopName: "Quán bún bò",
      voucher: Voucher(name: "GIAM3K", value: 3000),
      items: [
        OrderItem(
          imageUrl: "https://image.pngaaa.com/305/269305-middle.png",
          dishName: "Bún bò Huế",
          quantity: 2,
          price: 40000,
          discount: 10,
        ),
      ],
    ),
  ];

  final List<Order> deliveredOrders = [
    Order(
      shopName: "Phở Thìn",
      voucher: null,
      items: [
        OrderItem(
          imageUrl: "https://image.pngaaa.com/305/269305-middle.png",
          dishName: "Phở tái",
          quantity: 1,
          price: 50000,
          discount: 0,
        ),
      ],
    ),
  ];

  final List<Order> canceledOrders = [
    Order(
      shopName: "Bánh mì Minh Nhật",
      voucher: null,
      items: [
        OrderItem(
          imageUrl: "https://image.pngaaa.com/305/269305-middle.png",
          dishName: "Bánh mì trứng",
          quantity: 1,
          price: 20000,
          discount: 0,
        ),
      ],
    ),
  ];

  final List<Order> returnedOrders = [
    Order(
      shopName: "Shop trả hàng",
      voucher: null,
      items: [
        OrderItem(
          imageUrl: "https://image.pngaaa.com/305/269305-middle.png",
          dishName: "Sản phẩm đã trả",
          quantity: 1,
          price: 80000,
          discount: 0,
        ),
      ],
    ),
  ];


  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}
