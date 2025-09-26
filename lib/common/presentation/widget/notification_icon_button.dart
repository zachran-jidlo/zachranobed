import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/widget/indicator.dart';

/// A button that displays a notification icon, with an indicator that shows if there are any unread notifications.
///
/// The indicator will only be displayed if the user is logged in and has any unread notifications.
class NotificationIconButton extends StatelessWidget {
  /// Stream of booleans indicating if there are any unread notifications.
  final Stream<bool> hasAnyUnreadNotifications;

  /// Callback function to be executed when the button is pressed.
  final VoidCallback onPressed;

  /// Creates a [NotificationIconButton] widget.
  const NotificationIconButton({
    super.key,
    required this.hasAnyUnreadNotifications,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: StreamBuilder(
        stream: hasAnyUnreadNotifications,
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
