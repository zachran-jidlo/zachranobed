import 'package:zachranobed/common/domain/repository/user_repository.dart';
import 'package:zachranobed/common/domain/utils/platform_utils.dart';

/// Use case to check if the onboarding for UI changes should be shown.
class ShouldShowOnboardingForUiChangesUseCase {
  final UserRepository _userRepository;

  /// Creates a new instance of [ShouldShowOnboardingForUiChangesUseCase].
  ShouldShowOnboardingForUiChangesUseCase(
    this._userRepository,
  );

  /// Checks if the onboarding for UI changes should be shown for the given entity.
  ///
  /// Returns `true` if the app is running on mobile and the flag is set to `true`,
  /// otherwise returns `false` (including when the flag is `null` or missing,
  /// or when running on web).
  Future<bool> invoke(String entityId) async {
    if (!RunningPlatform.isMobile()) {
      return false;
    }
    return _userRepository.shouldShowOnboardingForUiChanges(entityId);
  }
}
