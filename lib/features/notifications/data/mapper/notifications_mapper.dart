import 'package:zachranobed/features/notifications/domain/model/notification.dart';
import 'package:zachranobed/models/dto/notification_dto.dart';

/// DTO to domain mapper for [Notification].
extension NotificationsMapper on NotificationDto {
  /// Maps DTO to domain representation.
  Notification toDomain() {
    return Notification(
      id: id,
      title: title,
      message: message,
      timestamp: timestamp,
      read: read,
    );
  }
}
