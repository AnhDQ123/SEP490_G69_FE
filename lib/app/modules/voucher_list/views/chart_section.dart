import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/voucher_list_controller.dart';

class ChartSection extends StatelessWidget {
  const ChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VoucherListController>();
    final vouchers = controller.vouchers;

    if (vouchers.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lượt sử dụng theo từng voucher',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipMargin: 8,
                  tooltipPadding: const EdgeInsets.all(8),
                  tooltipRoundedRadius: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final voucherCode = vouchers[group.x.toInt()].code;
                    return BarTooltipItem(
                      '$voucherCode\n',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: '${rod.toY.toInt()} lượt dùng',
                          style: const TextStyle(
                            color: Colors.yellowAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                ),

              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= vouchers.length) return const SizedBox();
                      final code = vouchers[index].code;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          code,
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: false),
              barGroups: vouchers.asMap().entries.map((entry) {
                final index = entry.key;
                final voucher = entry.value;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: (voucher.usedCount ?? 0).toDouble(),
                      width: 18,
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
