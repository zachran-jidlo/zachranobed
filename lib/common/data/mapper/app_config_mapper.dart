import 'package:zachranobed/common/domain/model/app_config.dart';
import 'package:zachranobed/models/dto/app_config_dto.dart';

/// DTO to domain mapper for [AppConfig].
extension AppConfigMapper on AppConfigDto {
  /// Maps DTO to domain representation.
  AppConfig toDomain() {
    return AppConfig(
      minimumAppVersion: minimumAppVersion,
    );
  }
}
