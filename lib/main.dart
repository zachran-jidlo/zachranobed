import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zachranobed/app/data/firebase/firebase_options.dart';
import 'package:zachranobed/app/data/logger/zo_logger_initializer.dart';
import 'package:zachranobed/app/di/app_dependency_container.dart';
import 'package:zachranobed/app/presentation/app_root.dart';
import 'package:zachranobed/common/data/utils/firebase_helper.dart';
import 'package:zachranobed/common/domain/model/project_configuration.dart';
import 'package:zachranobed/common/presentation/utils/ui_constants.dart';
import 'package:zachranobed/features/notifications/data/firebase/notifications.dart';

void main() async {
  const webAppFlavor = String.fromEnvironment('WEB_APP_FLAVOR');
  const flavor = webAppFlavor != '' ? webAppFlavor : appFlavor;
  ProjectConfiguration.instance.set(
    ProjectConfigurationMapper.mapBuildConfiguration(flavor),
    ProjectConfigurationMapper.mapApiConfiguration(flavor),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // DI Setup
  AppDependencyContainer.setup();

  ZoLoggerInitializer.init();

  await Notifications().initNotifications(ZOColors.primary);

  initializeDateFormatting();

  FirebaseHelper.initializeCrashlytics();

  // Lock system preferences to portrait orientation only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(AppRoot());
}
