import 'package:get_it/get_it.dart';
import 'package:zachranobed/features/notifications/data/repository/firebase_notifications_repository.dart';
import 'package:zachranobed/features/notifications/domain/repository/notifications_repository.dart';
import 'package:zachranobed/features/notifications/domain/usecase/has_any_unread_notifications_use_case.dart';
import 'package:zachranobed/features/notifications/domain/usecase/observe_notifications_use_case.dart';
import 'package:zachranobed/services/entity_notification_service.dart';

class NotificationsDependencyContainer {
  const NotificationsDependencyContainer._();

  static void setup() {
    GetIt.I.registerFactory<NotificationsRepository>(
      () => FirebaseNotificationsRepository(
        GetIt.I<EntityNotificationService>(),
      ),
    );

    GetIt.I.registerFactory<ObserveNotificationsUseCase>(
      () => ObserveNotificationsUseCase(
        GetIt.I<NotificationsRepository>(),
      ),
    );

    GetIt.I.registerFactory<HasAnyUnreadNotificationsUseCase>(
      () => HasAnyUnreadNotificationsUseCase(
        GetIt.I<NotificationsRepository>(),
      ),
    );
  }
}
