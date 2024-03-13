import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Device related utility functions.
class DeviceUtils {

  /// Retrieves device ID for Android or iOS.
  static Future<String?> getId() async {
    if (Platform.isIOS) {
      final info = await DeviceInfoPlugin().iosInfo;
      return info.identifierForVendor;
    } else if (Platform.isAndroid) {
      return await const AndroidId().getId();
    }
    return null;
  }
}
