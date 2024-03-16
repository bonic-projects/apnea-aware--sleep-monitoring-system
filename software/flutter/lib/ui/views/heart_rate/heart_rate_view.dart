import 'package:apnea_aware/ui/common/ui_helpers.dart';

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
                  'Place your Finger Print on the device',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sora()
                      .copyWith(color: Colors.white, fontSize: 36),
                ),
                SiriWaveform.ios9(
                  options: const IOS9SiriWaveformOptions(
                    showSupportBar: true,
                    height: 300,
                    width: 250,
                  ),
                )
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
