import 'package:apnea_aware/ui/common/ui_helpers.dart';
import 'package:apnea_aware/widgets/ip.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:stacked/stacked.dart';

import 'heart_rate_viewmodel.dart';

class HeartRateView extends StackedView<HeartRateViewModel> {
  const HeartRateView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HeartRateViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/graph.jpg',
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Lottie.asset('assets/lottie/heart_beat.json', height: 350),
                Text(
                  viewModel.node?.heartrate != null
                      ? "${viewModel.node!.heartrate} BPM"
                      : "_",
                  style: GoogleFonts.sora()
                      .copyWith(color: Colors.white, fontSize: 36),
                ),
                verticalSpaceMedium,
                Text(
                  viewModel.node?.heartrate != null
                      ? "${viewModel.node!.spo2}%"
                      : "_",
                  style: GoogleFonts.abel()
                      .copyWith(color: Colors.white, fontSize: 36),
                ),
                verticalSpaceMedium,
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)),
                  child: const Icon(
                    Icons.fingerprint_rounded,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
                verticalSpaceLarge,
                Text(
                  viewModel.node!=null && viewModel.node!.heartrate  > 40 ? "Reading BPM & SPO2" :  'Please wear your band',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sora()
                      .copyWith(color: Colors.white, fontSize: 36),
                ),
                SiriWaveform.ios9(
                  options: const IOS9SiriWaveformOptions(
                    showSupportBar: true,
                    height: 200,
                    width: 250,
                  ),
                ),
                Text(
                  "${viewModel.node?.dB ?? 0} dB",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sora()
                      .copyWith(color: Colors.white, fontSize: 36),
                ),
                SizedBox(height: 100),
                if(viewModel.predictedClass!=null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            viewModel.predictedClass!.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                          ),
                          if (viewModel.predictions != null && viewModel.predictions!.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            ...viewModel.predictions!.map((prediction) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Status: ${prediction['status']}'),
                                Text('Probability: ${prediction['probability']}'),
                                const Divider(), // Add a divider between predictions
                              ],
                            )),
                          ] else
                            const Center(
                              child: Text('No predictions available'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if(viewModel.predictedClass!=null && viewModel.isAuto)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "AHI",
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                            ),
                            if (viewModel.predictions != null && viewModel.predictions!.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Total number of events: ${viewModel.eventNo}'),
                                  Text('Total sleep time in minute: ${viewModel.sleepTimeInMinute}'),
                                  Text('Apnea Hypopnea Index (AHI): ${viewModel.ahi} event/hour', style: const TextStyle(fontWeight: FontWeight.w600),),
                                  const Divider(), // Add a divider between predictions
                                ],
                              ),
                            ] else
                              const Center(
                                child: Text('No predictions available'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              viewModel.getPredictions().then((predictions) {
                                // Handle predictions
                                // print(predictions);
                              }).catchError((error) {
                                // Handle errors
                                // print(error);
                              });
                            },
                            child: const Text('Get Predictions'),
                          ),

                        ],
                      ),
                    ),
                  ),

                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Automatic mode: '),
                          Switch(
                            value: viewModel.isAuto,
                            onChanged: (newValue) {
                              viewModel.switchValueChanged(newValue);

                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  HeartRateViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HeartRateViewModel();
}