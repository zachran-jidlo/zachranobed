import 'package:zachranobed/common/domain/repository/device_repository.dart';

/// Use case to get the app version string including build number.
class GetAppVersionUseCase {
  final DeviceRepository _repository;

  GetAppVersionUseCase(this._repository);

  Future<String> invoke() => _repository.getAppVersion();
}
