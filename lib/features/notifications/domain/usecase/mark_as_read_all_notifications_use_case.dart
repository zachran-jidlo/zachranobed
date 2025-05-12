import 'package:zachranobed/features/notifications/domain/repository/notifications_repository.dart';
import 'package:zachranobed/models/user_data.dart';

/// A use case to mark all unread notifications as read for the given [user].
class MarkAsReadAllNotificationsUseCase {
  final NotificationsRepository _repository;

  MarkAsReadAllNotificationsUseCase(this._repository);

  /// Marks all unread notifications as read for the given [user].
  Future<void> invoke(UserData user) {
    return _repository.markAllAsRead(user: user);
  }
}
