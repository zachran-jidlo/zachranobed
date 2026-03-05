import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/repository/user_repository.dart';

/// Use case to observe changes in user data.
class ObserveUserDataUseCase {
  final UserRepository _userRepository;

  /// Creates a new instance of [ObserveUserDataUseCase].
  ObserveUserDataUseCase(
    this._userRepository,
  );

  /// Observes changes in user data.
  ///
  /// Returns a [Stream] that emits [UserData] whenever the user data changes
  /// (e.g., after login or logout).
  Stream<UserData?> invoke() {
    return _userRepository.observeUserData();
  }
}
