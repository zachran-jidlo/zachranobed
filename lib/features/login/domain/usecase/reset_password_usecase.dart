import 'package:zachranobed/common/domain/repository/user_repository.dart';

/// Use case to send a password reset email.
class ResetPasswordUseCase {
  final UserRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<void> invoke(String email) => _repository.resetPassword(email);
}
