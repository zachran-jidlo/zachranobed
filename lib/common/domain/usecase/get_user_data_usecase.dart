import 'package:zachranobed/common/domain/repository/user_repository.dart';
import 'package:zachranobed/models/user_data.dart';

/// Use case to get the current user's data.
class GetUserDataUseCase {
  final UserRepository _userRepository;

  /// Creates a new instance of [GetUserDataUseCase].
  GetUserDataUseCase(
    this._userRepository,
  );

  /// Gets the current user's data.
  ///
  /// Returns a [Future] that completes with [UserData] for the authenticated user or null if the user is not
  /// authenticated or data cannot be retrieved.
  Future<UserData?> invoke() {
    return _userRepository.getUserData();
  }
}
