import 'package:apnea_aware/app/constants/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomLineChart extends StatelessWidget {
  const CustomLineChart({
    super.key,
    required this.x,
    required this.y,
    required this.z,
  });
  final List<FlSpot> x;
  final List<FlSpot> y;
  final List<FlSpot> z;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: LineChart(LineChartData(
        minX: 0,
        maxX: 14,
        maxY: 4,
        minY: 0,
        lineBarsData: [
          LineChartBarData(
              isCurved: true,
              color: AppColors.contentColorGreen,
              barWidth: 8,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
              spots: x),
          LineChartBarData(
              isCurved: true,
              color: AppColors.contentColorPink,
              barWidth: 8,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: false,
                color: AppColors.contentColorPink.withOpacity(0),
              ),
              spots: y),
          LineChartBarData(
              isCurved: true,
              color: AppColors.contentColorCyan,
              barWidth: 8,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
              spots: z),
        ],
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: bottomTitles,
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: leftTitles(),
          ),
        ),
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          ),
        ),
      )),
    );
  }
}

SideTitles leftTitles() => const SideTitles(
      showTitles: true,
      interval: 1,
      reservedSize: 40,
    );

SideTitles get bottomTitles => const SideTitles(
      showTitles: true,
      reservedSize: 32,
      interval: 1,
    );

FlBorderData get borderData => FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(color: AppColors.primary.withOpacity(0.2), width: 4),
        left: const BorderSide(color: Colors.transparent),
        right: const BorderSide(color: Colors.transparent),
        top: const BorderSide(color: Colors.transparent),
      ),
    );
