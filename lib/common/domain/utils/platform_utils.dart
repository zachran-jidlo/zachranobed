import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

/// An enumeration of supported platforms the app can run on.
enum RunningPlatform {
  /// The app is running on the Web.
  web,

  /// The app is running on an Android device.
  android,

  /// The app is running on an iOS device.
  ios,

  /// The app is running on an unknown or unsupported platform.
  unknown;

  /// Returns the current [RunningPlatform] the app is executing on.
  ///
  /// This method checks platform-specific flags to determine whether the app is running on Web,
  /// Android, iOS, or an unknown platform.
  static RunningPlatform current() {
    if (kIsWeb) {
      return RunningPlatform.web;
    } else if (Platform.isAndroid) {
      return RunningPlatform.android;
    } else if (Platform.isIOS) {
      return RunningPlatform.ios;
    } else {
      return RunningPlatform.unknown;
    }
  }

  /// Returns `true` if the app is running on a mobile platform (Android or iOS).
  static bool isMobile() {
    final platform = RunningPlatform.current();
    return platform == RunningPlatform.android || platform == RunningPlatform.ios;
  }

  /// Returns `true` if the app is running on an Android device.
  static bool isAndroid() => current() == RunningPlatform.android;

  /// Returns `true` if the app is running on an iOS device.
  static bool isIOS() => current() == RunningPlatform.ios;

  /// Returns `true` if the app is running on the Web.
  static bool isWeb() => current() == RunningPlatform.web;
}
