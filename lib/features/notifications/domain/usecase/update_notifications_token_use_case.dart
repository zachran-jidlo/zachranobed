import 'package:zachranobed/features/notifications/domain/repository/notifications_repository.dart';

/// A use case to update notifications token.
class UpdateNotificationsTokenUseCase {
  final NotificationsRepository _repository;

  UpdateNotificationsTokenUseCase(this._repository);

  /// Updates notifications token.
  Future<void> invoke() {
    return _repository.updateNotificationsToken();
  }
}
