import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zachranobed/firebase/firebase_options.dart';
import 'package:zachranobed/ui/widgets/app_root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const AppRoot());
}
