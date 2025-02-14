import 'package:zachranobed/features/forceupdate/domain/model/app_config.dart';
import 'package:zachranobed/models/dto/appconfig_dto.dart';

/// DTO to domain mapper for [AppConfig].
extension AppConfigMapper on AppConfigDto {
  /// Maps DTO to domain representation.
  AppConfig toDomain() {
    return AppConfig(
      minimumAppVersion: minimumAppVersion,
    );
  }
}