import 'package:zachranobed/common/data/service/auth_service.dart';
import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/common/domain/repository/user_repository.dart';

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
