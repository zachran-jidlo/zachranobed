import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:zachranobed/app/data//firebase/firebase_options_stage.dart' as stage;
import 'package:zachranobed/app/data/firebase/firebase_options_dev.dart' as dev;
import 'package:zachranobed/app/data/firebase/firebase_options_prod.dart' as prod;
import 'package:zachranobed/common/domain/model/project_configuration.dart';

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
    switch (ProjectConfiguration.instance.apiConfiguration) {
      case ApiConfiguration.dev:
        return dev.DefaultFirebaseOptions.currentPlatform;
      case ApiConfiguration.stage:
        return stage.DefaultFirebaseOptions.currentPlatform;
      case ApiConfiguration.prod:
        return prod.DefaultFirebaseOptions.currentPlatform;
    }
  }
}
