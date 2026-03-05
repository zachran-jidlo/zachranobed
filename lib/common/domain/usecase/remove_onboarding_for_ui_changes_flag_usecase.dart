import 'package:zachranobed/common/domain/repository/user_repository.dart';

/// Use case to remove the onboarding for UI changes flag.
class RemoveOnboardingForUiChangesFlagUseCase {
  final UserRepository _userRepository;

  /// Creates a new instance of [RemoveOnboardingForUiChangesFlagUseCase].
  RemoveOnboardingForUiChangesFlagUseCase(
    this._userRepository,
  );

  /// Removes the onboarding for UI changes flag from the entity document.
  Future<void> invoke(String entityId) {
    return _userRepository.removeOnboardingForUiChangesFlag(entityId);
  }
}
