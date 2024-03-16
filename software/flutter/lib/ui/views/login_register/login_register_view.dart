import 'package:apnea_aware/widgets/login_register.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'login_register_viewmodel.dart';

class LoginRegisterView extends StackedView<LoginRegisterViewModel> {
  const LoginRegisterView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginRegisterViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 15),
                child: Image.asset(
                  'assets/images/apnaAware.png',
                  height: 400,
                ),
              ),
              LoginRegisterWidget(
                onLogin: viewModel.openLoginView,
                onRegister: viewModel.openRegisterView,
                loginText: "Existing Doctor",
                registerText: "Doctor registration",
              ),
            ],
          ),
        ));
  }

  @override
  LoginRegisterViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginRegisterViewModel();
}
