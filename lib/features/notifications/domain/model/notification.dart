import 'package:freezed_annotation/freezed_annotation.dart';

/*
 * Command to rebuild the notification.freezed.dart file:
 * flutter packages pub run build_runner build --delete-conflicting-outputs
 */
part 'notification.freezed.dart';

/// Represents a notification sent to the user.
///
/// This model includes basic notification metadata such as the title, message body,
/// read status, and timestamp.
@Freezed()
class Notification with _$Notification {
  const factory Notification({
    required String id,
    required String title,
    required String message,
    required DateTime timestamp,
    required bool read,
  }) = $Notification;
}
