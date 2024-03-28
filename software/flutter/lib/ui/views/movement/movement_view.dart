import 'package:apnea_aware/widgets/Movementchart.dart';

import 'package:apnea_aware/widgets/reading_card.dart';

import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'movement_viewmodel.dart';

class MovementView extends StackedView<MovementViewModel> {
  const MovementView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    MovementViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.count(
              mainAxisSpacing: 50,
              crossAxisSpacing: 50,
              shrinkWrap: true,
              crossAxisCount: 3,
              children: [
                ReadingCard(
                  text: "      AccelerationX ",
                  value: viewModel.node!.acclX,
                ),
                ReadingCard(
                  text: "AccelerationY",
                  value: viewModel.node!.acclY,
                ),
                ReadingCard(
                  text: "AccelerationZ",
                  value: viewModel.node!.acclY,
                ),
                ReadingCard(
                  text: " GyroX ",
                  value: viewModel.node!.gyroX,
                ),
                ReadingCard(text: "GyroY", value: viewModel.node!.gyroY),
                ReadingCard(text: "GyroZ", value: viewModel.node!.gyroZ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: MovementChart(
                    text: 'Acceleration',
                    x: viewModel.gyroXSpots,
                    y: viewModel.gyroYSpots,
                    z: viewModel.gyroZSpots,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: MovementChart(
                    text: 'Gyro',
                    x: viewModel.accelerationXSpots,
                    y: viewModel.accelerationYSpots,
                    z: viewModel.accelerationZSpots,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  MovementViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      MovementViewModel();

  @override
  void onViewModelReady(MovementViewModel viewModel) {
    viewModel.onModelReady();
    super.onViewModelReady(viewModel);
  }
}
