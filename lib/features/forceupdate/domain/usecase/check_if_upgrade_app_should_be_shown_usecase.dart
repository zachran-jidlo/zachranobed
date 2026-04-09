import 'package:pub_semver/pub_semver.dart';
import 'package:zachranobed/common/domain/repository/app_configuration_repository.dart';
import 'package:zachranobed/common/domain/usecase/get_app_semantic_version_usecase.dart';
import 'package:zachranobed/common/domain/utils/platform_utils.dart';
import 'package:zachranobed/common/domain/utils/zo_logger.dart';

/// Use case to check if upgrade app should be shown.
class CheckIfUpgradeAppShouldBeShownUseCase {
  final AppConfigurationRepository _repository;
  final GetAppSemanticVersionUseCase _getAppSemanticVersion;

  CheckIfUpgradeAppShouldBeShownUseCase(this._repository, this._getAppSemanticVersion);

  /// Fetches available application configuration.
  Future<bool> invoke() async {
    if (!RunningPlatform.isMobile() && !RunningPlatform.isWeb()) {
      return false;
    }

    final appConfig = await _repository.getAppConfig();

    final currentVersion = Version.parse(await _getAppSemanticVersion.invoke());
    final minimumVersion = Version.parse(appConfig.minimumAppVersion);

    ZOLogger.logMessage(
        'Check if upgrade app should be shown: currentVersion: $currentVersion, minimumVersion: $minimumVersion');

    return currentVersion < minimumVersion;
  }
}
