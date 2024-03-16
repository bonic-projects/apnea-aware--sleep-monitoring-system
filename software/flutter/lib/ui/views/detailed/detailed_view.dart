import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'detailed_viewmodel.dart';

class DetailedView extends StackedView<DetailedViewModel> {
  const DetailedView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DetailedViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      ),
    );
  }

  @override
  DetailedViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DetailedViewModel();
}
