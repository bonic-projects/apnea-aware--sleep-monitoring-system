import 'package:apnea_aware/widgets/movement_line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../app/constants/app_colors.dart';

class MovementChart extends StatelessWidget {
  const MovementChart(
      {super.key,
      required this.x,
      required this.y,
      required this.z,
      required this.text});

  final List<FlSpot> x;
  final List<FlSpot> y;
  final List<FlSpot> z;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              Text(
                text,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 37,
              ),
              Expanded(
                child: MovementLineChart(
                  gyroX: x,
                  gyroY: y,
                  gyroZ: z,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
