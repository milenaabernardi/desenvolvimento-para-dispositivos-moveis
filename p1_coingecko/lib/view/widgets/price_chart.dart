import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriceChart extends StatelessWidget {
  final double minPrice;
  final double maxPrice;
  final double currentPrice;
  final bool isPositive;

  const PriceChart({
    super.key,
    required this.minPrice,
    required this.maxPrice,
    required this.currentPrice,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? const Color(0xFF00FFA3) : const Color(0xFFFF5555);

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false), 
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, minPrice),
                FlSpot(1, (minPrice + currentPrice) / 2),
                FlSpot(2, maxPrice),
                FlSpot(3, (maxPrice + currentPrice) / 2),
                FlSpot(4, currentPrice),
              ],
              isCurved: true,
              color: color,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.3),
                    color.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}