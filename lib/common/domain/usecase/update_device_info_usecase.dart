import 'package:zachranobed/common/domain/repository/user_repository.dart';
import 'package:zachranobed/common/domain/usecase/get_app_build_number_usecase.dart';
import 'package:zachranobed/common/domain/usecase/get_app_semantic_version_usecase.dart';
import 'package:zachranobed/common/domain/usecase/get_device_id_usecase.dart';
import 'package:zachranobed/common/domain/utils/platform_utils.dart';
import 'package:zachranobed/common/domain/utils/zo_logger.dart';

/// Use case to update the current device's info (ID, app version, build number, platform) in the entity document.
class UpdateDeviceInfoUseCase {
  final UserRepository _userRepository;
  final GetDeviceIdUseCase _getDeviceId;
  final GetAppSemanticVersionUseCase _getAppVersion;
  final GetAppBuildNumberUseCase _getAppBuildNumber;

  UpdateDeviceInfoUseCase(
    this._userRepository,
    this._getDeviceId,
    this._getAppVersion,
    this._getAppBuildNumber,
  );

  Future<void> invoke(String entityId) async {
    try {
      final deviceId = await _getDeviceId.invoke();
      if (deviceId == null) {
        ZOLogger.logMessage("Unable to update device info: device ID is null");
        return;
      }

      final appVersion = await _getAppVersion.invoke();
      final buildNumber = await _getAppBuildNumber.invoke();
      final platform = RunningPlatform.current().name;

      await _userRepository.updateDeviceInfo(
        entityId: entityId,
        deviceId: deviceId,
        appVersion: appVersion,
        buildNumber: buildNumber,
        platform: platform,
      );
    } on Exception catch (e) {
      ZOLogger.logException(e, "Unable to update device info");
    }
  }
}
