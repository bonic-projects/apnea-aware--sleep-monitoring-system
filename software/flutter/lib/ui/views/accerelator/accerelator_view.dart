import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'accerelator_viewmodel.dart';

class AccerelatorView extends StackedView<AccerelatorViewModel> {
  const AccerelatorView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AccerelatorViewModel viewModel,
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
  AccerelatorViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AccerelatorViewModel();
}
