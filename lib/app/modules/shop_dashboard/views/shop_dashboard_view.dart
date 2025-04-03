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
      body: _buildMainContent(controller),
    );
  }

  Widget _buildMainContent(ShopDashboardController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      return ListView(
        children: [
          if (controller.orders_S.isNotEmpty || controller.orders_F.isNotEmpty)
            _buildOrderChartCard(controller),
          if (controller.topProducts.isNotEmpty)
            _buildTopProductsCard(controller),
        ],
      );
    });
  }

  Widget _buildOrderChartCard(ShopDashboardController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          height: MediaQuery.of(Get.context!).size.height / 2,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Số lượng đơn hàng theo tháng',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildChartLegend(),
              SizedBox(height: 16),
              Expanded(
                child: _buildOrderChart(controller),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(Colors.green, 'Thành công'),
        SizedBox(width: 20),
        _buildLegendItem(Colors.red, 'Thất bại'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  Widget _buildOrderChart(ShopDashboardController controller) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _calculateMaxY(controller.orders_S, controller.orders_F),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(fontSize: 12),
                );
              },
            ),
            axisNameWidget: Text(
              'Số đơn hàng',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  'Tháng ${value.toInt()}',
                  style: TextStyle(fontSize: 12),
                );
              },
            ),
            axisNameWidget: Text(
              'Tháng',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        gridData: FlGridData(show: true),
        barGroups: _buildBarGroups(controller.orders_S, controller.orders_F),
      ),
    );
  }

  Widget _buildTopProductsCard(ShopDashboardController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sản phẩm bán chạy theo tháng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ...controller.topProducts.map((product) =>
                  _buildProductItem(controller, product)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductItem(
      ShopDashboardController controller,
      Map<String, dynamic> product) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          _buildProductRank(controller, product),
          SizedBox(width: 16),
          _buildProductInfo(product),
          _buildOrderCount(product),
        ],
      ),
    );
  }

  Widget _buildProductRank(
      ShopDashboardController controller,
      Map<String, dynamic> product) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        '#${controller.topProducts.indexOf(product) + 1}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildProductInfo(Map<String, dynamic> product) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product['productName'],
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'ID: ${product['productId']}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCount(Map<String, dynamic> product) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '${product['quantitySold']} đơn',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  double _calculateMaxY(
      List<Map<String, dynamic>> successOrders,
      List<Map<String, dynamic>> failedOrders)
  {
    double maxSuccess = successOrders.fold(0, (max, order) =>
    order['orderCount'] > max ? order['orderCount'].toDouble() : max);
    double maxFailed = failedOrders.fold(0, (max, order) =>
    order['orderCount'] > max ? order['orderCount'].toDouble() : max);
    return (maxSuccess > maxFailed ? maxSuccess : maxFailed) * 1.2;
  }

  List<BarChartGroupData> _buildBarGroups(
      List<Map<String, dynamic>> successOrders,
      List<Map<String, dynamic>> failedOrders)
  {
    final successMap = {for (var order in successOrders) order['month']: order};
    final failedMap = {for (var order in failedOrders) order['month']: order};

    final allMonths = {
      ...successOrders.map((e) => e['month']),
      ...failedOrders.map((e) => e['month']),
    }.toList()..sort();

    return allMonths.map((month) {
      final successOrder = successMap[month];
      final failedOrder = failedMap[month];

      return BarChartGroupData(
        x: month,
        barRods: [
          BarChartRodData(
            toY: successOrder?['orderCount']?.toDouble() ?? 0,
            color: Colors.green,
            width: 15,
          ),
          BarChartRodData(
            toY: failedOrder?['orderCount']?.toDouble() ?? 0,
            color: Colors.red,
            width: 15,
          ),
        ],
        barsSpace: 4,
      );
    }).toList();
  }
}