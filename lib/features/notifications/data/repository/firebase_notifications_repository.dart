import 'package:zachranobed/features/notifications/data/mapper/notifications_mapper.dart';
import 'package:zachranobed/features/notifications/domain/model/notification.dart';
import 'package:zachranobed/features/notifications/domain/repository/notifications_repository.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/services/entity_notification_service.dart';

/// Implementation of the [NotificationsRepository] via Firebase services.
class FirebaseNotificationsRepository implements NotificationsRepository {
  final EntityNotificationService _entityNotificationService;

  FirebaseNotificationsRepository(
    this._entityNotificationService,
  );

  @override
  Stream<List<Notification>> observeNotifications({
    required UserData user,
    bool? read,
  }) {
    final stream = _entityNotificationService.observeNotifications(
      entityId: user.entityId,
      read: read,
    );
    return stream.map((notifications) => notifications.map((e) => e.toDomain()).toList());
  }

  @override
  Future<void> markAllAsRead({
    required UserData user,
  }) {
    return _entityNotificationService.markAllAsRead(
      entityId: user.entityId,
    );
  }
}
