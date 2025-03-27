class DashboardData {
  final double totalRevenue;  // Tổng doanh thu
  final int totalOrders;  // Tổng đơn hàng
  final List<OrderStats> orderStats;  // Số lượng đơn hàng mỗi ngày
  final List<BestSellingFood> bestSellingFoods;  // Các món ăn bán chạy nhất
  final List<Rating> ratings;  // Đánh giá từ khách hàng

  DashboardData({
    required this.totalRevenue,
    required this.totalOrders,
    required this.orderStats,
    required this.bestSellingFoods,
    required this.ratings,
  });
}

class OrderStats {
  final String date;
  final int ordersCount;

  OrderStats({
    required this.date,
    required this.ordersCount,
  });
}

class BestSellingFood {
  final String name;
  final int quantity;

  BestSellingFood({
    required this.name,
    required this.quantity,
  });
}

class Rating {
  final double score;
  final int count;

  Rating({
    required this.score,
    required this.count,
  });
}
