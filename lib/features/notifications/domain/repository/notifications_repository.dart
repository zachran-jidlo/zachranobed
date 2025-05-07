import 'package:zachranobed/features/notifications/domain/model/notification.dart';
import 'package:zachranobed/models/user_data.dart';

/// Repository to fetch notifications information.
abstract class NotificationsRepository {
  /// Observes a stream of [Notification] objects for a given [user]. If [read]
  /// is provided, it filters the notifications based on the read status.
  Stream<List<Notification>> observeNotifications({
    required UserData user,
    bool? read,
  });

  /// Marks all unread notifications as read for the given [user].
  Future<void> markAllAsRead({
    required UserData user,
  });
}
