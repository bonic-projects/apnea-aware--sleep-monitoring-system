import 'package:apnea_aware/ui/views/alert/alert_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';


class AlertView extends StackedView<AlertViewModel> {
  const AlertView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AlertViewModel viewModel,
    Widget? child,
  ) {
    return AlertDialog(
      title: const Text('Are you sure?'),
      content: const Text(
        'Are you sure you want to stop video calling?',
      ),
      actions:[
        TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: viewModel.popPop,
            child: const Text('No')),
        TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            onPressed: viewModel.popback,
            child: const Text('Yes')),
      ],
    );
  }

  @override
  AlertViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AlertViewModel();
}