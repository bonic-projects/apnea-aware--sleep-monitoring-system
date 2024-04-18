import 'package:apnea_aware/app/constants/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomChart extends StatelessWidget {
  const CustomChart({
    super.key,
    required this.gradientColors,
    required this.spots,
    required this.verticalaxisTileText,
    required this.horizontalaxisTileText,
  });

  final List<Color> gradientColors;
  final List<FlSpot> spots;

  final String verticalaxisTileText;
  final String horizontalaxisTileText;

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      // minX: 0,
      // maxX: 11,
      minY: 0,
      maxY: 120,
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          axisNameWidget: Text(
            horizontalaxisTileText,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          sideTitles: const SideTitles(
            showTitles: true,
            // reservedSize: 50,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: Text(
            verticalaxisTileText,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          sideTitles: const SideTitles(
              showTitles: true,
              // interval: 20,
              // getTitlesWidget: leftTitleWidgets,
              reservedSize: 42,
          ),
        ),
      ),
      gridData: FlGridData(
        show: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        drawVerticalLine: true,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      // borderData: FlBorderData(
      //   show: true,
      //   border: Border.all(color: const Color(0xff37434d), width: 2),
      // ),
      lineBarsData: [
        LineChartBarData(
          show: spots.isNotEmpty,
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 5,
          belowBarData: BarAreaData(
            gradient: LinearGradient(
                colors: gradientColors
                    .map((color) => color.withOpacity(.3))
                    .toList()),
            show: true,
          ),
        ),
      ],
    ));
  }
}
