import 'package:zachranobed/common/domain/repository/device_repository.dart';

/// Use case to get the app build number (e.g. "42").
class GetAppBuildNumberUseCase {
  final DeviceRepository _repository;

  GetAppBuildNumberUseCase(this._repository);

  Future<String> invoke() => _repository.getAppBuildNumber();
}
