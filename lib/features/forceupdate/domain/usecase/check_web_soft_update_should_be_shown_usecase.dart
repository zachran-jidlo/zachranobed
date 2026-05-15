import 'package:pub_semver/pub_semver.dart';
import 'package:zachranobed/common/domain/repository/app_configuration_repository.dart';
import 'package:zachranobed/common/domain/usecase/get_app_semantic_version_usecase.dart';
import 'package:zachranobed/common/domain/utils/platform_utils.dart';

/// Use case to check if a soft (optional) web update banner should be shown.
///
/// Returns `true` when running on web and the current version is behind the latest available version but still meets
/// the minimum required version (the update is optional, not forced).
class CheckWebSoftUpdateShouldBeShownUseCase {
  final AppConfigurationRepository _repository;
  final GetAppSemanticVersionUseCase _getAppSemanticVersion;

  CheckWebSoftUpdateShouldBeShownUseCase(this._repository, this._getAppSemanticVersion);

  Future<bool> invoke() async {
    if (!RunningPlatform.isWeb()) return false;

    final appConfig = await _repository.getAppConfig();

    final current = Version.parse(await _getAppSemanticVersion.invoke());
    final latest = Version.parse(appConfig.latestAppVersion);
    final minimum = Version.parse(appConfig.minimumAppVersion);
    return current < latest && current >= minimum;
  }
}
