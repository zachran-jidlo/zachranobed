import 'package:zachranobed/common/domain/model/user_data.dart';
import 'package:zachranobed/features/notifications/domain/model/notification.dart';
import 'package:zachranobed/features/notifications/domain/repository/notifications_repository.dart';

/// A use case to observe notifications for a given user.
class ObserveNotificationsUseCase {
  final NotificationsRepository _repository;

  ObserveNotificationsUseCase(this._repository);

  /// Observes notifications for the given [user].
  Stream<List<Notification>> invoke(UserData user) {
    return _repository.observeNotifications(user: user);
  }
}
