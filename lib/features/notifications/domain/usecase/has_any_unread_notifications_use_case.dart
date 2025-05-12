import 'package:zachranobed/features/notifications/domain/repository/notifications_repository.dart';
import 'package:zachranobed/models/user_data.dart';

/// A use case to check if there are any unread notifications.
class HasAnyUnreadNotificationsUseCase {
  final NotificationsRepository _repository;

  HasAnyUnreadNotificationsUseCase(this._repository);

  /// Checks if there are any unread notifications for the given [user].
  Stream<bool> invoke(UserData user) {
    final stream = _repository.observeNotifications(
      user: user,
      read: false,
    );

    return stream.map((notifications) => notifications.isNotEmpty);
  }
}
