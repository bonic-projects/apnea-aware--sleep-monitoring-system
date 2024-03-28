import 'package:apnea_aware/ui/common/ui_helpers.dart';

import 'package:apnea_aware/ui/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'patient_viewmodel.dart';

class PatientView extends StackedView<PatientViewModel> {
  const PatientView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PatientViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient'),
        actions: [
          IconButton(
              onPressed: viewModel.logoutUser, icon: const Icon(Icons.logout))
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            verticalSpaceMedium,
            ElevatedButton(
              onPressed: viewModel.createVideoCall,
              child: const Text('Create Meeting'),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  PatientViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PatientViewModel();
}
