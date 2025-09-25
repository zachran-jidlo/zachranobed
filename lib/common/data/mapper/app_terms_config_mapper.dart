import 'package:zachranobed/common/data/dto/app_terms_config_dto.dart';
import 'package:zachranobed/common/domain/model/app_terms_config.dart';

/// DTO to domain mapper for [AppTermsConfig].
extension AppConfigMapper on AppTermsConfigDto {
  /// Maps DTO to domain representation.
  AppTermsConfig toDomain() {
    return AppTermsConfig(
      lastVersion: lastVersion,
    );
  }
}
