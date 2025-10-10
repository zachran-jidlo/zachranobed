import 'package:zachranobed/common/domain/model/user_data.dart';

/// Repository to manage user data operations.
abstract class UserRepository {
  /// Gets the current user's data.
  ///
  /// Returns a [Future] that completes with [UserData] for the authenticated user or null if the user is not
  /// authenticated or data cannot be retrieved.
  Future<UserData?> getUserData();
}
