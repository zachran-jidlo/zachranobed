import 'package:zachranobed/common/data/service/auth_service.dart';
import 'package:zachranobed/common/domain/repository/auth_repository.dart';

/// Implementation of the [AuthRepository] via Firebase services.
class FirebaseAuthRepository implements AuthRepository {
  final AuthService _authService;

  FirebaseAuthRepository(this._authService);

  @override
  Future<bool> signIn(String email, String password) async {
    return await _authService.signIn(email, password) != null;
  }

  @override
  Future<void> signOut(String? entityId) => _authService.signOut(entityId);

  @override
  Future<void> reauthenticateUser(String password) => _authService.reauthenticateUser(password);

  @override
  Future<void> changePassword(String password) => _authService.changePassword(password);

  @override
  Future<void> resetPassword(String email) => _authService.resetPassword(email);
}
