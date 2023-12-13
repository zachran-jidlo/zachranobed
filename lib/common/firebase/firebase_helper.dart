import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';

/// Helper class for Firebase Crashlytics integration in Flutter.
class FirebaseHelper {
  /// Initializes Crashlytics for Flutter error handling.
  static void initializeCrashlytics() {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  /// Sets the user identifier for Firebase Crashlytics.
  static void setUserIdentifier(String? uid) {
    FirebaseCrashlytics.instance.setUserIdentifier(uid ?? "");
  }
}
