import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:zachranobed/features/notifications/domain/usecase/has_any_unread_notifications_use_case.dart';
import 'package:zachranobed/models/user_data.dart';
import 'package:zachranobed/ui/widgets/indicator.dart';

/// A button that displays a notification icon, with an indicator that shows if there are any unread notifications.
///
/// The indicator will only be displayed if the user is logged in and has any unread notifications.
class NotificationIconButton extends StatelessWidget {
  final _hasAnyUnreadNotifications = GetIt.I<HasAnyUnreadNotificationsUseCase>();

  /// The current user data.
  final UserData? user;

  /// Callback function to be executed when the button is pressed.
  final VoidCallback onPressed;

  /// Creates a [NotificationIconButton] widget.
  NotificationIconButton({
    super.key,
    required this.user,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = user;
    if (currentUser == null) {
      return const SizedBox();
    }

    return IconButton(
      onPressed: onPressed,
      icon: StreamBuilder(
        stream: _hasAnyUnreadNotifications.invoke(currentUser),
        builder: (context, snapshot) {
          return Indicator(
            isVisible: snapshot.data == true,
            child: const Icon(
              Icons.notifications_outlined,
            ),
          );
        },
      ),
    );
  }
}
