import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zachranobed/features/appConfiguration/app_configuration.dart';
import 'package:zachranobed/features/appConfiguration/mapper/app_configuration_mapper.dart';
import 'package:zachranobed/features/login/di/login_dependency_container.dart';
import 'package:zachranobed/firebase/firebase_options.dart';
import 'package:zachranobed/firebase/notifications.dart';
import 'package:zachranobed/services/ioc_container.dart';
import 'package:zachranobed/ui/widgets/app_root.dart';

import 'common/firebase/firebase_helper.dart';

void main() async {
  AppConfiguration.instance.set(
      AppConfigurationMapper.mapBuildConfiguration(appFlavor),
      AppConfigurationMapper.mapApiConfiguration(appFlavor)
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // DI Setup
  IoCContainer.setup();
  LoginDependencyContainer.setup();

  await Notifications().initNotifications();

  initializeDateFormatting();

  FirebaseHelper.initializeCrashlytics();

  // Lock system preferences to portrait orientation only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(AppRoot());
}
