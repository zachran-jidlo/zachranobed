import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zachranobed/common/domain/utils/platform_utils.dart';

/*
 * Command to rebuild the banner.freezed.dart file:
 * flutter pub run build_runner build --delete-conflicting-outputs
 */
part 'banner.freezed.dart';

/// Visual tone of a banner. Drives its icon and color.
enum BannerType { info, warning }

/// Role a banner targets. [all] means every role.
enum BannerRole { all, donor, recipient }

/// A message shown in-app, managed externally and filtered by targeting rules.
///
/// Null/empty targeting fields mean "no restriction". A banner is shown only
/// when the current user passes every targeting rule. Title and text are raw
/// strings from the database, not localized.
@freezed
abstract class Banner with _$Banner {
  const factory Banner({
    /// Unique identifier.
    required String id,

    /// Display order when several banners match. Lower shows first.
    required int priority,

    /// Banner headline.
    required String title,

    /// Banner body. Rendered as markdown.
    required String text,

    /// Target role. [BannerRole.all] means every role.
    required BannerRole role,

    /// Visual tone. Drives the icon and color. Null shows no icon.
    required BannerType? type,

    /// Start of the display window. Null means show immediately.
    required DateTime? validFrom,

    /// End of the display window. Null means no end.
    required DateTime? validTo,

    /// Specific entity IDs to target. Null/empty means no restriction.
    required List<String>? entityIds,

    /// Entity tags to target. Matches when the entity has at least one.
    /// Null/empty means no restriction.
    required List<String>? tags,

    /// Target platforms. Null/empty means all platforms.
    required List<RunningPlatform>? platforms,

    /// Lowest app version that shows the banner. Null means no lower bound.
    required String? minAppVersion,

    /// Highest app version that shows the banner. Null means no upper bound.
    required String? maxAppVersion,

    /// Whether the user can close the banner. Once closed it stays hidden.
    required bool closable,

    /// Label for the optional action button. Null hides the button.
    required String? actionLabel,

    /// Target of the action button. A deeplink or external URL.
    required String? actionUrl,
  }) = _Banner;
}
