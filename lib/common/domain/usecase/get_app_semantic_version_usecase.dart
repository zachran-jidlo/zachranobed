import 'package:zachranobed/common/domain/repository/device_repository.dart';

/// Use case to get the semantic app version (e.g. "1.0.0").
class GetAppSemanticVersionUseCase {
  final DeviceRepository _repository;

  GetAppSemanticVersionUseCase(this._repository);

  Future<String> invoke() => _repository.getAppSemanticVersion();
}
