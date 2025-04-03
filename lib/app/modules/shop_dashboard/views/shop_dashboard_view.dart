import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/shop_dashboard_controller.dart';

class ShopDashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ShopDashboardController controller = Get.put(ShopDashboardController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Dashboard'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.orders.isEmpty) {
          return Center(child: Text('No orders available'));
        } else {
          return ListView(
            children: [
              // Card chứa biểu đồ
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2, // Chiều cao khoảng nửa màn hình
                    padding: const EdgeInsets.all(16),
                    child: BarChart(
                      BarChartData(
                        titlesData: FlTitlesData(show: true),
                        borderData: FlBorderData(show: true),
                        gridData: FlGridData(show: true),
                        barGroups: controller.orders.map((order) {
                          return BarChartGroupData(
                            x: order['month'],
                            barRods: [
                              BarChartRodData(
                                toY: order['orderCount'].toDouble(),
                                color: Colors.blue,
                                width: 20,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
              // Các phần khác của giao diện (nếu có)
            ],
          );
        }
      }),
    );
  }
}
