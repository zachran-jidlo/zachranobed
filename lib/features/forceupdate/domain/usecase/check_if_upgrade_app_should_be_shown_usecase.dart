import 'package:pub_semver/pub_semver.dart';
import 'package:zachranobed/common/logger/zo_logger.dart';
import 'package:zachranobed/common/utils/device_utils.dart';
import 'package:zachranobed/common/utils/platform_utils.dart';
import 'package:zachranobed/features/appConfiguration/domain/repository/app_configuration_repository.dart';

/// Use case to check if upgrade app should be shown.
class CheckIfUpgradeAppShouldBeShownUseCase {
  final AppConfigurationRepository _repository;

  CheckIfUpgradeAppShouldBeShownUseCase(this._repository);

  /// Fetches available application configuration.
  Future<bool> invoke() async {
    if (!RunningPlatform.isMobile()) {
      return false;
    }

    final appConfig = await _repository.getAppConfig();

    final currentVersion =
        Version.parse(await DeviceUtils.getAppSemanticVersion());
    final minimumVersion = Version.parse(appConfig.minimumAppVersion);

    ZOLogger.logMessage(
        'Check if upgrade app should be shown: currentVersion: $currentVersion, minimumVersion: $minimumVersion');

    return currentVersion < minimumVersion;
  }
}
