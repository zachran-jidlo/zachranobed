import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Device related utility functions.
class DeviceUtils {
  PackageInfo? info;

  /// Retrieves device ID for Android or iOS.
  static Future<String?> getId() async {
    switch (Platform.operatingSystem) {
      case 'ios':
        return (await DeviceInfoPlugin().iosInfo).identifierForVendor;
      case 'android':
        return await const AndroidId().getId();
      default:
        return null;
    }
  }

  static Future<String> getAppVersion() async {
    var info = await PackageInfo.fromPlatform();
    return "${info.version} (${info.buildNumber})";
  }
}
