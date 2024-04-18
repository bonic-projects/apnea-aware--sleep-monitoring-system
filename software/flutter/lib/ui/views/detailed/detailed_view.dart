import 'package:apnea_aware/app/constants/constants.dart';
import 'package:apnea_aware/widgets/custom_chart.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

import 'detailed_viewmodel.dart';

class DetailedView extends StackedView<DetailedViewModel> {
  DetailedView({Key? key}) : super(key: key);

  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget builder(
    BuildContext context,
    DetailedViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        body: ListView(
      children: [
        SizedBox(
          height: 400,
          child: CustomChart(
              horizontalaxisTileText: 'Time',
              verticalaxisTileText: 'Blood Pressure',
              gradientColors: gradientColors,
              spots: viewModel.heartRateSpots),
        ),
        SizedBox(
          height: 400,
          child: CustomChart(
              horizontalaxisTileText: 'Time',
              verticalaxisTileText: 'Spo2',
              gradientColors: gradientColors,
              spots: viewModel.spo2Spots),
        ),
        Card(
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 20),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            color: scaffoldColor,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: "${viewModel.node?.avgBpm}",
                                style: appText(
                                    size: 23,
                                    color: heartColor,
                                    weight: FontWeight.w500)),
                            TextSpan(
                              text: ' BPM',
                              style: appText(
                                  color: heartColor, weight: FontWeight.w500),
                            ),
                            TextSpan(
                              text: '\nAVERAGE',
                              style: appText(
                                  size: 30,
                                  color: waveColor,
                                  weight: FontWeight.w500),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const Spacer(),
                      Lottie.asset(
                        "assets/lottie/heartrate.json",
                        height: MediaQuery.of(context).size.height * 0.235,
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.white.withOpacity(0.3),
                  endIndent: 20,
                  indent: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 60,
                    right: 60,
                    top: 30,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: '112',
                                style: appText(
                                    size: 23,
                                    color: heartColor,
                                    weight: FontWeight.w500)),
                            const TextSpan(
                              text: ' BPM',
                            ),
                            TextSpan(
                              text: '\nMAX',
                              style: appText(
                                  color: waveColor, weight: FontWeight.w500),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: '0',
                                style: appText(
                                    color: heartColor,
                                    weight: FontWeight.w500)),
                            TextSpan(
                              text: 'BPM',
                              style: appText(
                                  color: waveColor, weight: FontWeight.w500),
                            ),
                            TextSpan(
                                text: '\nMIN',
                                style: appText(
                                    size: 30,
                                    color: waveColor,
                                    weight: FontWeight.w500)),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              ],
            )),
      ],
    ));
  }

  @override
  DetailedViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DetailedViewModel();

  @override
  void onViewModelReady(DetailedViewModel viewModel) {
    viewModel.onModelReady();
    super.onViewModelReady(viewModel);
  }
}
