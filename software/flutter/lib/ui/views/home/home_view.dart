import 'package:apnea_aware/widgets/option.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apnea Aware'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: viewModel.logout,
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            Option(
                name: 'Heart Rate',
                onTap: viewModel.heartRateView,
                file: 'assets/lottie/heartrate.json'),
            Option(
                name: 'Detailed View',
                onTap: viewModel.detailed,
                file: 'assets/lottie/sp02.json'),
            Option(
                name: 'Movement',
                onTap: viewModel.accerelatorView,
                file: 'assets/lottie/accrelator.json'),
            Option(
                name: 'Video Chat',
                onTap: viewModel.patientView,
                file: 'assets/lottie/videocall.json'),
          ],
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}
