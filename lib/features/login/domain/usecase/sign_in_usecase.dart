import 'package:zachranobed/common/domain/repository/auth_repository.dart';

/// Use case to sign in with email and password.
class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  /// Returns `true` on success, `false` on invalid credentials.
  Future<bool> invoke(String email, String password) => _repository.signIn(email, password);
}
