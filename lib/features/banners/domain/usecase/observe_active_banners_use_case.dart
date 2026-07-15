import 'package:collection/collection.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/usecase/get_app_semantic_version_usecase.dart';
import 'package:zachranobed/common/domain/utils/platform_utils.dart';
import 'package:zachranobed/features/banners/domain/model/banner.dart';
import 'package:zachranobed/features/banners/domain/repository/banner_repository.dart';

/// Observes the banners that should be shown to [user] right now.
///
/// Combines the active-banner stream with the dismissed-IDs stream so a
/// dismissal (or a content change) re-runs the filter. A banner passes only
/// when every configured targeting rule matches (rules combine as AND). The
/// result is sorted by priority (lower first).
class ObserveActiveBannersUseCase {
  final BannerRepository _repository;
  final GetAppSemanticVersionUseCase _getAppSemanticVersion;

  ObserveActiveBannersUseCase(
    this._repository,
    this._getAppSemanticVersion,
  );

  Stream<List<Banner>> invoke({required UserData user}) {
    final platform = RunningPlatform.current();
    final currentVersion = _getAppSemanticVersion.invoke().asStream().map(_tryParseVersion);

    return Rx.combineLatest4<List<Banner>, Set<String>, Version?, void, List<Banner>>(
      _repository.observeActive(),
      _repository.observeDismissedIds(),
      currentVersion,
      _periodicTick(),
      (banners, dismissed, version, _) {
        final now = DateTime.now();
        return banners
            .where((banner) => _matches(banner, user, platform, version, dismissed, now))
            .sortedBy<num>((banner) => banner.priority);
      },
    );
  }

  /// Emits immediately, then every minute, so time-window boundaries
  /// (validFrom/validTo) take effect while the screen stays open, not only on
  /// stream events.
  Stream<void> _periodicTick() {
    return Stream<void>.periodic(const Duration(minutes: 1)).startWith(null);
  }

  bool _matches(
    Banner banner,
    UserData user,
    RunningPlatform platform,
    Version? currentVersion,
    Set<String> dismissed,
    DateTime now,
  ) {
    if (dismissed.contains(banner.id)) {
      return false;
    }

    final validFrom = banner.validFrom;
    if (validFrom != null && now.isBefore(validFrom)) {
      return false;
    }

    final validTo = banner.validTo;
    if (validTo != null && now.isAfter(validTo)) {
      return false;
    }

    if (!_roleMatches(banner.role, user)) {
      return false;
    }

    final entityIds = banner.entityIds;
    if (entityIds != null && entityIds.isNotEmpty && !entityIds.contains(user.entityId)) {
      return false;
    }

    final tags = banner.tags;
    if (tags != null && tags.isNotEmpty && !tags.any(user.tags.contains)) {
      return false;
    }

    final platforms = banner.platforms;
    if (platforms != null && platforms.isNotEmpty && !platforms.contains(platform)) {
      return false;
    }

    if (!_versionInRange(banner, currentVersion)) {
      return false;
    }

    return true;
  }

  bool _roleMatches(BannerRole role, UserData user) {
    return switch (role) {
      BannerRole.all => true,
      BannerRole.donor => user is Canteen,
      BannerRole.recipient => user is Charity,
    };
  }

  bool _versionInRange(Banner banner, Version? current) {
    if (current == null) {
      return true;
    }

    final min = _tryParseVersion(banner.minAppVersion);
    if (min != null && current < min) {
      return false;
    }

    final max = _tryParseVersion(banner.maxAppVersion);
    if (max != null && current > max) {
      return false;
    }

    return true;
  }

  Version? _tryParseVersion(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    try {
      return Version.parse(value);
    } on FormatException {
      return null;
    }
  }
}
