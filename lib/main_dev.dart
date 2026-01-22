import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/app/presentation/app_root.dart';
import 'package:zachranobed/common/presentation/model/app_flavor_data.dart';
import 'package:zachranobed/common/presentation/widget/quick_login_button.dart';
import 'package:zachranobed/main_base.dart';

void main() async {
  await mainBase();

  GetIt.I.registerSingleton(
    AppFlavorData(
      quickLoginButton: (emailController, passwordController) {
        return QuickLoginButton(
          emailController: emailController,
          passwordController: passwordController,
        );
      },
    ),
  );

  runApp(AppRoot());
}
