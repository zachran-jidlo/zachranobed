import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:zachranobed/features/appConfiguration/app_configuration.dart';
import 'package:zachranobed/features/appConfiguration/entity/api_configuration.dart';
import 'package:zachranobed/firebase/firebase_options_dev.dart' as dev;
import 'package:zachranobed/firebase/firebase_options_stage.dart' as stage;
import 'package:zachranobed/firebase/firebase_options_prod.dart' as prod;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (AppConfiguration.instance.apiConfiguration) {
      case ApiConfiguration.dev:
        return dev.DefaultFirebaseOptions.currentPlatform;
      case ApiConfiguration.stage:
        return stage.DefaultFirebaseOptions.currentPlatform;
      case ApiConfiguration.prod:
        return prod.DefaultFirebaseOptions.currentPlatform;
    }
  }
}
