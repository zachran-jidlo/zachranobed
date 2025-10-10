import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/features/notifications/domain/repository/notifications_repository.dart';

/// A use case to mark all unread notifications as read for the given [user].
class MarkAsReadAllNotificationsUseCase {
  final NotificationsRepository _repository;

  MarkAsReadAllNotificationsUseCase(this._repository);

  /// Marks all unread notifications as read for the given [user].
  Future<void> invoke(UserData user) {
    return _repository.markAllAsRead(user: user);
  }
}
