import 'package:apnea_aware/app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MovementLineChart extends StatelessWidget {
  const MovementLineChart(
      {super.key,
      required this.gyroX,
      required this.gyroY,
      required this.gyroZ});
  final List<FlSpot> gyroX;
  final List<FlSpot> gyroY;
  final List<FlSpot> gyroZ;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 14,
        maxY: 4,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
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
      );

  List<LineChartBarData> get lineBarsData1 => [
        firstLineChartBarData,
        secondLineChartBarData,
        thirdLineChartBarData,
      ];

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

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom:
              BorderSide(color: AppColors.primary.withOpacity(0.2), width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get firstLineChartBarData => LineChartBarData(
      isCurved: true,
      color: AppColors.contentColorGreen,
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: gyroX);

  LineChartBarData get secondLineChartBarData => LineChartBarData(
      isCurved: true,
      color: AppColors.contentColorPink,
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: false,
        color: AppColors.contentColorPink.withOpacity(0),
      ),
      spots: gyroY);

  LineChartBarData get thirdLineChartBarData => LineChartBarData(
      isCurved: true,
      color: AppColors.contentColorCyan,
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: gyroZ);
}
