import 'package:zachranobed/common/domain/repository/user_repository.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/services/auth_service.dart';

/// Implementation of the [UserRepository] via Firebase services.
class FirebaseUserRepository implements UserRepository {
  final AuthService _authService;

  /// Creates a new instance of [FirebaseUserRepository].
  FirebaseUserRepository(this._authService);

  @override
  Future<UserData?> getUserData() {
    return _authService.getUserData();
  }
}
