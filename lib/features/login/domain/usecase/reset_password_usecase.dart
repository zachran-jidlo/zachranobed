import 'package:zachranobed/common/domain/repository/auth_repository.dart';

/// Use case to send a password reset email.
class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<void> invoke(String email) => _repository.resetPassword(email);
}
