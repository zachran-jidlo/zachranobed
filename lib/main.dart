import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zachranobed/features/appConfiguration/AppConfiguration.dart';
import 'package:zachranobed/features/appConfiguration/mapper/AppConfigurationMapper.dart';
import 'package:zachranobed/features/login/di/LoginDependencyContainer.dart';
import 'package:zachranobed/firebase/firebase_options.dart';
import 'package:zachranobed/firebase/notifications.dart';
import 'package:zachranobed/services/ioc_container.dart';
import 'package:zachranobed/ui/widgets/app_root.dart';

import 'common/firebase/firebase_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // DI Setup
  IoCContainer.setup();
  LoginDependencyContainer.setup();

  await Notifications().initNotifications();

  initializeDateFormatting();

  FirebaseHelper.initializeCrashlytics();

  // App configuration setup from current runtime app flavor
  const String? appFlavor = String.fromEnvironment('FLUTTER_APP_FLAVOR') != '' ?
  String.fromEnvironment('FLUTTER_APP_FLAVOR') : null;
  AppConfiguration.instance.set(
      AppConfigurationMapper.mapBuildConfiguration(appFlavor),
      AppConfigurationMapper.mapApiConfiguration(appFlavor)
  );

  runApp(AppRoot());
}
