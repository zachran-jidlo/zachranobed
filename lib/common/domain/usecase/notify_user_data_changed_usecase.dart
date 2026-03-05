import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/repository/user_repository.dart';

/// Use case to notify that user data has changed.
class NotifyUserDataChangedUseCase {
  final UserRepository _userRepository;

  /// Creates a new instance of [NotifyUserDataChangedUseCase].
  NotifyUserDataChangedUseCase(
    this._userRepository,
  );

  /// Notifies listeners that user data has changed.
  ///
  /// Call this after successful login or logout to trigger observers
  /// like [AppRoot] to perform post-auth checks.
  void invoke(UserData? userData) {
    _userRepository.notifyUserDataChanged(userData);
  }
}
