import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Helper class for Firebase Crashlytics integration in Flutter.
class FirebaseHelper {
  /// Initializes Crashlytics for Flutter error handling.
  static void initializeCrashlytics() {
    if (!isCrashlyticsSupported()) {
      return;
    }

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
    if (!isCrashlyticsSupported()) {
      return;
    }

    FirebaseCrashlytics.instance.setUserIdentifier(uid ?? "");
  }

  /// Checks if Firebase Crashlytics is supported on the current platform.
  ///
  /// This method returns `true` if the application is not running on the web,
  /// indicating that Firebase Crashlytics can be used. Firebase Crashlytics
  /// is not currently supported for web platform.
  ///
  /// See: https://github.com/firebase/firebase-js-sdk/issues/710
  static bool isCrashlyticsSupported() {
    return !kIsWeb;
  }
}
