import 'package:zachranobed/features/notifications/domain/model/notification.dart';
import 'package:zachranobed/features/notifications/domain/repository/notifications_repository.dart';
import 'package:zachranobed/models/user_data.dart';

/// A use case to observe notifications for a given user.
class ObserveNotificationsUseCase {
  final NotificationsRepository _repository;

  ObserveNotificationsUseCase(this._repository);

  /// Observes notifications for the given [user].
  Stream<List<Notification>> invoke(UserData user) {
    return _repository.observeNotifications(user: user);
  }
}
