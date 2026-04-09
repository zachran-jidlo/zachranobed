import 'package:zachranobed/common/domain/repository/auth_repository.dart';

/// Use case to sign out the current user.
class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<void> invoke(String? entityId) => _repository.signOut(entityId);
}
