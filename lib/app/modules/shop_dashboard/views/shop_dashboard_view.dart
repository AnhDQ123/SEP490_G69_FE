import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/shop_dashboard_controller.dart';

class ShopDashboardView extends StatelessWidget {
  const ShopDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShopDashboardController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê cửa hàng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshData,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: ListView(
            children: [
              _buildChartSection(controller),
              if (controller.topProducts.isNotEmpty)
                _buildTopProductsSection(controller),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildChartSection(ShopDashboardController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'THỐNG KÊ ĐƠN HÀNG',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis, // tránh lỗi tràn
                    ),
                  ),
                  _buildChartTypeDropdown(controller),
                ],
              ),

              const SizedBox(height: 16),
              _buildChartLegend(),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: Obx(() {
                  return controller.selectedChartType.value == 'monthly'
                      ? _buildMonthlyChart(controller)
                      : _buildDailyChart(controller);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartTypeDropdown(ShopDashboardController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: controller.selectedChartType.value,
        underline: const SizedBox(), // Loại bỏ gạch chân mặc định
        icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
        items: const [
          DropdownMenuItem(
            value: 'monthly',
            child: Text('Theo tháng'),
          ),
          DropdownMenuItem(
            value: 'daily',
            child: Text('Theo ngày'),
          ),
        ],
        onChanged: (String? newValue) {
          if (newValue != null) {
            controller.toggleChartType(newValue);
          }
        },
      ),
    );
  }

  Widget _buildChartLegend() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(color: Colors.green, text: 'Thành công'),
        SizedBox(width: 20),
        _LegendItem(color: Colors.red, text: 'Thất bại'),
      ],
    );
  }

  Widget _buildMonthlyChart(ShopDashboardController controller) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _calculateMaxY(controller.orders_S, controller.orders_F),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  'Tháng ${value.toInt()}',
                  style: const TextStyle(fontSize: 12),
                );
              },
              reservedSize: 30,
            ),
          ),
          topTitles:
          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        gridData: const FlGridData(show: true),
        barGroups:
        _buildMonthlyBarGroups(controller.orders_S, controller.orders_F),
      ),
    );
  }

  Widget _buildDailyChart(ShopDashboardController controller) {
    final dailyData = controller.orders_S_Daily;
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _calculateMaxY(
            controller.orders_S_Daily, controller.orders_F_Daily),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < dailyData.length) {
                  final date =
                      dailyData[index]['date'].toString().split('-').last;
                  return Text(date, style: const TextStyle(fontSize: 10));
                }
                return const Text('');
              },
              reservedSize: 30,
            ),
          ),
          topTitles:
          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        gridData: const FlGridData(show: true),
        barGroups: _buildDailyBarGroups(
          controller.orders_S_Daily,
          controller.orders_F_Daily,
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildMonthlyBarGroups(
      List<Map<String, dynamic>> successOrders,
      List<Map<String, dynamic>> failedOrders,
      )
  {
    final successMap = {for (var e in successOrders) e['month']: e};
    final failedMap = {for (var e in failedOrders) e['month']: e};

    final allMonths = {
      ...successOrders.map((e) => e['month']),
      ...failedOrders.map((e) => e['month']),
    }.toList()
      ..sort();

    return allMonths.map((month) {
      return BarChartGroupData(
        x: month,
        barRods: [
          BarChartRodData(
            toY: (successMap[month]?['orderCount'] ?? 0).toDouble(),
            color: Colors.green,
            width: 12,
          ),
          BarChartRodData(
            toY: (failedMap[month]?['orderCount'] ?? 0).toDouble(),
            color: Colors.red,
            width: 12,
          ),
        ],
        barsSpace: 8,
      );
    }).toList();
  }

  List<BarChartGroupData> _buildDailyBarGroups(
      List<Map<String, dynamic>> successOrders,
      List<Map<String, dynamic>> failedOrders,
      )
  {
    final successMap = {for (var e in successOrders) e['date']: e};
    final failedMap = {for (var e in failedOrders) e['date']: e};

    final allDates = {
      ...successOrders.map((e) => e['date']),
      ...failedOrders.map((e) => e['date']),
    }.toList()
      ..sort();

    return allDates.asMap().entries.map((entry) {
      final date = entry.value;
      final index = entry.key;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (successMap[date]?['orderCount'] ?? 0).toDouble(),
            color: Colors.green,
            width: 8,
          ),
          BarChartRodData(
            toY: (failedMap[date]?['orderCount'] ?? 0).toDouble(),
            color: Colors.red,
            width: 8,
          ),
        ],
        barsSpace: 4,
      );
    }).toList();
  }

  double _calculateMaxY(
      List<Map<String, dynamic>> successOrders,
      List<Map<String, dynamic>> failedOrders,
      ) {
    final maxSuccess = successOrders.fold<double>(
      0,
          (max, e) => e['orderCount'] > max ? e['orderCount'].toDouble() : max,
    );
    final maxFailed = failedOrders.fold<double>(
      0,
          (max, e) => e['orderCount'] > max ? e['orderCount'].toDouble() : max,
    );

    // Nhân với 1.1 rồi làm tròn lên số nguyên gần nhất
    final calculatedMax = (maxSuccess > maxFailed ? maxSuccess : maxFailed) * 1.1;
    return calculatedMax.ceilToDouble(); // Làm tròn lên thành số nguyên
  }

  Widget _buildTopProductsSection(ShopDashboardController controller) {
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
              const Text(
                'TOP SẢN PHẨM BÁN CHẠY TRONG THÁNG',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...controller.topProducts.map(
                    (product) => _buildProductItem(
                    product, controller.topProducts.indexOf(product) + 1),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product, int rank) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh sản phẩm
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product['image'] ?? '',
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 48,
                  height: 48,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          // Nội dung chính
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] ?? 'Không có tên',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                    children: [
                      TextSpan(
                        text: '${product['totalQuantity']} đã bán - ',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      TextSpan(
                        text: _formatCurrency(product['totalValue']),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Huy hiệu thứ hạng
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getRankColor(rank),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(dynamic value) {
    if (value == null) return '';
    final formatted = (value as num).toStringAsFixed(0);
    return '${formatted.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')} đ';
  }


  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber[700]!;
      case 2:
        return Colors.grey[600]!;
      case 3:
        return Colors.brown[500]!;
      default:
        return Colors.blue;
    }
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}