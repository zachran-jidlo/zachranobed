import 'package:zachranobed/common/domain/model/app_terms_config.dart';
import 'package:zachranobed/models/dto/app_terms_config_dto.dart';

/// DTO to domain mapper for [AppTermsConfig].
extension AppConfigMapper on AppTermsConfigDto {
  /// Maps DTO to domain representation.
  AppTermsConfig toDomain() {
    return AppTermsConfig(
      lastVersion: lastVersion,
    );
  }
}
