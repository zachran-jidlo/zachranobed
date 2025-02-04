import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zachranobed/common/di/common_dependency_container.dart';
import 'package:zachranobed/common/logger/zo_logger.dart';
import 'package:zachranobed/common/firebase/firebase_helper.dart';
import 'package:zachranobed/features/activepair/di/active_pair_dependency_container.dart';
import 'package:zachranobed/features/appConfiguration/app_configuration.dart';
import 'package:zachranobed/features/appConfiguration/mapper/app_configuration_mapper.dart';
import 'package:zachranobed/features/appTerms/di/app_terms_dependency_container.dart';
import 'package:zachranobed/features/foodboxes/di/food_box_dependency_container.dart';
import 'package:zachranobed/features/forceupdate/domain/di/force_update_dependency_container.dart';
import 'package:zachranobed/features/login/di/login_dependency_container.dart';
import 'package:zachranobed/features/menu/di/menu_dependency_container.dart';
import 'package:zachranobed/features/offeredfood/di/offered_food_dependency_container.dart';
import 'package:zachranobed/firebase/firebase_options.dart';
import 'package:zachranobed/firebase/notifications.dart';
import 'package:zachranobed/services/di/services_dependency_container.dart';
import 'package:zachranobed/ui/widgets/app_root.dart';


void main() async {
  AppConfiguration.instance.set(
      AppConfigurationMapper.mapBuildConfiguration(appFlavor),
      AppConfigurationMapper.mapApiConfiguration(appFlavor),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // DI Setup
  CommonDependencyContainer.setup();
  AppTermsDependencyContainer.setup();
  ServicesDependencyContainer.setup();
  LoginDependencyContainer.setup();
  FoodBoxDependencyContainer.setup();
  OfferedFoodDependencyContainer.setup();
  MenuDependencyContainer.setup();
  ActivePairDependencyContainer.setup();
  ForceUpdateDependencyContainer.setup();

  ZOLogger.init();

  await Notifications().initNotifications();

  initializeDateFormatting();

  FirebaseHelper.initializeCrashlytics();

  // Lock system preferences to portrait orientation only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(AppRoot());
}
