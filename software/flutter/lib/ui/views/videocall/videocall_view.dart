import 'package:apnea_aware/widgets/meeting_screen.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'videocall_viewmodel.dart';

class VideocallView extends StackedView<VideocallViewModel> {
  const VideocallView(this.meetingid, {Key? key}) : super(key: key);
  final String meetingid;

  @override
  Widget builder(
    BuildContext context,
    VideocallViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopScope(
              canPop: false,
              onPopInvoked: (bool value) {
                return viewModel.alertdialog();
              },
              child: TextButton(
                  onPressed: viewModel.alertdialog,
                  child: const Text(
                    'Stop calling',
                    style: TextStyle(color: Colors.red),
                  )))
        ],
      ),
      body: SafeArea(
        child: Center(
          child: viewModel.isBusy
              ? CircularProgressIndicator() // Show a loader while busy
              : MeetingScreen(
                  meetingId: meetingid,
                  token: viewModel.sdkToken,
                ),
        ),
      ),
    );
  }

  @override
  VideocallViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      VideocallViewModel();
}
