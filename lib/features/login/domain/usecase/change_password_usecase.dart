import 'package:zachranobed/common/domain/repository/auth_repository.dart';

/// Use case to change the current user's password.
///
/// Re-authenticates the user with [currentPassword], applies [newPassword],
/// then signs out so the user re-authenticates with the new credentials.
class ChangePasswordUseCase {
  final AuthRepository _repository;

  ChangePasswordUseCase(this._repository);

  Future<void> invoke(String? entityId, String currentPassword, String newPassword) async {
    await _repository.reauthenticateUser(currentPassword);
    await _repository.changePassword(newPassword);
    await _repository.signOut(entityId);
  }
}
