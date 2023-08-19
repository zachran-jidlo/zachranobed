import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zachranobed/firebase/firebase_options.dart';
import 'package:zachranobed/firebase/notifications.dart';
import 'package:zachranobed/services/ioc_container.dart';
import 'package:zachranobed/ui/widgets/app_root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  IoCContainer.setup();
  await Notifications().initNotifications();

  initializeDateFormatting();

  runApp(AppRoot());
}
