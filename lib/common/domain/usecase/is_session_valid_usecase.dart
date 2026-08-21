import 'package:zachranobed/common/domain/repository/user_repository.dart';

/// Use case to check whether the current session is still valid.
class IsSessionValidUseCase {
  final UserRepository _repository;

  IsSessionValidUseCase(this._repository);

  Future<bool> invoke() => _repository.isSessionValid();
}
