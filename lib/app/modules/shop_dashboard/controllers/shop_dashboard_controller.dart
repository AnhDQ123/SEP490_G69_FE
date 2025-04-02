import 'package:get/get.dart';
import 'dashboard_data.dart';

class ShopDashboardController extends GetxController {
  var dashboardData = DashboardData(
    totalRevenue: 200000,
    totalOrders: 25,
    orderStats: [
      OrderStats(date: '01/01', ordersCount: 20),
      OrderStats(date: '02/01', ordersCount: 25),
      OrderStats(date: '03/01', ordersCount: 30),
      OrderStats(date: '04/01', ordersCount: 35),
      OrderStats(date: '05/01', ordersCount: 40),
    ],
    bestSellingFoods: [
      BestSellingFood(name: 'Burger', quantity: 120),
      BestSellingFood(name: 'Pizza', quantity: 90),
      BestSellingFood(name: 'Sushi', quantity: 80),
    ],
    ratings: [
      Rating(score: 5.0, count: 120),
      Rating(score: 4.5, count: 100),
      Rating(score: 4.0, count: 80),
    ],
  ).obs;  // Rx cho phép theo dõi các thay đổi trong dữ liệu

  // Hàm lấy dữ liệu từ API (ở đây là dữ liệu mẫu)
  Future<void> fetchDashboardData() async {
    // Giả lập một chút với delay
    await Future.delayed(Duration(seconds: 2));
    // Bạn có thể thay đổi dữ liệu ở đây nếu lấy từ API
  }
}
