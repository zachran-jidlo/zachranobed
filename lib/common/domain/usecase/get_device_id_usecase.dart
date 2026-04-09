import 'package:zachranobed/common/domain/repository/device_repository.dart';

/// Use case to get the device ID.
class GetDeviceIdUseCase {
  final DeviceRepository _repository;

  GetDeviceIdUseCase(this._repository);

  Future<String?> invoke() => _repository.getDeviceId();
}
