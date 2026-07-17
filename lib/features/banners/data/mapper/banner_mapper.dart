import 'package:zachranobed/common/domain/utils/iterable_utils.dart';
import 'package:zachranobed/common/domain/utils/platform_utils.dart';
import 'package:zachranobed/features/banners/data/dto/banner_dto.dart';
import 'package:zachranobed/features/banners/domain/model/banner.dart';

/// DTO to domain mapper for [Banner].
extension BannerMapper on BannerDto {
  /// Maps a DTO to its domain representation. Missing fields fall back to
  /// safe defaults, and enum-like strings are parsed case-insensitively.
  Banner toDomain() {
    return Banner(
      id: id,
      priority: priority ?? 0,
      title: title ?? '',
      text: text ?? '',
      role: _parseRole(role),
      type: _parseType(type),
      validFrom: validFrom,
      validTo: validTo,
      entityIds: entityIds,
      tags: tags,
      platforms: _parsePlatforms(platforms),
      minAppVersion: minAppVersion,
      maxAppVersion: maxAppVersion,
      closable: closable ?? false,
      actionLabel: actionLabel,
      actionUrl: actionUrl,
    );
  }
}

/// DTO to domain mapper for a list of [Banner].
extension BannerListMapper on List<BannerDto> {
  List<Banner> toDomain() => map((dto) => dto.toDomain()).toList();
}

BannerRole _parseRole(String? value) {
  return switch (value?.toLowerCase()) {
    'donor' => BannerRole.donor,
    'recipient' => BannerRole.recipient,
    _ => BannerRole.all,
  };
}

BannerType? _parseType(String? value) {
  return switch (value?.toLowerCase()) {
    'info' => BannerType.info,
    'warning' => BannerType.warning,
    _ => null,
  };
}

List<RunningPlatform>? _parsePlatforms(List<String>? values) {
  if (values == null) {
    return null;
  }

  return values
      .mapNotNull(
        (value) => switch (value.toLowerCase()) {
          'android' => RunningPlatform.android,
          'ios' => RunningPlatform.ios,
          'web' => RunningPlatform.web,
          _ => null,
        },
      )
      .toList();
}
