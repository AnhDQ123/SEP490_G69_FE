import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import '../controllers/shop_dashboard_controller.dart';

class ShopDashboardView extends StatelessWidget {
  final ShopDashboardController controller = Get.put(ShopDashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thống kê')),
      body: Obx(() {
        if (controller.dashboardData.value == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doanh thu hôm nay
                Text(
                    'Doanh thu hôm nay: ${controller.dashboardData.value.totalRevenue}đ'),
                SizedBox(height: 10),
                // Biểu đồ doanh thu theo ngày
                _buildRevenueChart(),
                SizedBox(height: 20),
                // Đơn hàng hôm nay
                Text(
                    'Đơn hàng hôm nay: ${controller.dashboardData.value.totalOrders} đơn'),
                SizedBox(height: 10),
                // Biểu đồ đơn hàng mỗi ngày
                _buildOrdersChart(),
                SizedBox(height: 20),
                // Món ăn bán chạy nhất
                Text('Món ăn bán chạy nhất:'),
                _buildBestSellingFoods(),
                SizedBox(height: 20),
                // Đánh giá trung bình
                Text('Đánh giá trung bình:'),
                _buildRatingsChart(),
              ],
            ),
          );
        }
      }),
    );
  }

  // Biểu đồ doanh thu theo ngày
  Widget _buildRevenueChart() {
    return Expanded(
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(show: true),
          gridData: FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          maxY: 20000,
          barGroups: controller.dashboardData.value.orderStats.map((data) {
            return BarChartGroupData(
              x: int.parse(data.date.split('/')[0]),
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  // Điểm bắt đầu
                  toY: data.ordersCount * 1000.toDouble(),
                  // Điểm kết thúc (doanh thu)
                  color: Colors.blue,
                  width: 10,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildOrdersChart() {
    return BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(show: true),
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 50,
        barGroups: controller.dashboardData.value.orderStats.map((data) {
          return BarChartGroupData(
            x: int.parse(data.date.split('/')[0]),
            barRods: [
              BarChartRodData(
                fromY: 0, // Điểm bắt đầu
                toY: data.ordersCount.toDouble(), // Điểm kết thúc
                color: Colors.cyan,
                width: 10,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // Món ăn bán chạy nhất
  Widget _buildBestSellingFoods() {
    return Column(
      children: controller.dashboardData.value.bestSellingFoods
          .map((food) => ListTile(
                title: Text(food.name),
                trailing: Text('${food.quantity} đơn'),
              ))
          .toList(),
    );
  }

  // Biểu đồ đánh giá
  Widget _buildRatingsChart() {
    return BarChart(
      BarChartData(
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(show: true),
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 150,
        barGroups: controller.dashboardData.value.ratings.map((rating) {
          return BarChartGroupData(
            x: rating.score.toInt(),
            barRods: [
              BarChartRodData(
                fromY: rating.count.toDouble(),
                color: Colors.green,
                width: 10,
                toY: rating.count.toDouble(), // Thêm tham số toY
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
