import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:zachranobed/common/domain/repository/device_repository.dart';
import 'package:zachranobed/common/domain/utils/platform_utils.dart';

/// Implementation of the [DeviceRepository] via platform functions.
class PlatformDeviceRepository implements DeviceRepository {
  @override
  Future<String?> getDeviceId() async {
    switch (RunningPlatform.current()) {
      case RunningPlatform.ios:
        return (await DeviceInfoPlugin().iosInfo).identifierForVendor;
      case RunningPlatform.android:
        return await const AndroidId().getId();
      case RunningPlatform.web:
        return 'web';
      default:
        return null;
    }
  }

  @override
  Future<String> getAppVersion() async {
    var info = await PackageInfo.fromPlatform();
    return "${info.version} (${info.buildNumber})";
  }

  @override
  Future<String> getAppSemanticVersion() async {
    var info = await PackageInfo.fromPlatform();
    return info.version;
  }

  @override
  Future<String> getAppBuildNumber() async {
    var info = await PackageInfo.fromPlatform();
    return info.buildNumber;
  }
}
