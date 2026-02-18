import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/build_context_extensions.dart';

/// A temporary snackbar that displays a message and auto-dismisses. The snackbar appears as a floating element with
/// rounded corners and a close button.
///
/// Example usage:
/// ```dart
/// // Show an info message
/// UiTemporarySnackBar.show(context, message: 'Operation successful');
///
/// // Show an error message
/// UiTemporarySnackBar.showError(context, message: 'Something went wrong');
/// ```
class UiTemporarySnackBar {
  UiTemporarySnackBar._();

  /// Shows a temporary snackbar with the given [message].
  ///
  /// The snackbar uses [UiColors.textPrimary] as background color
  /// and [UiColors.textPrimaryInverse] as text color.
  ///
  /// Set [clearPrevious] to `false` to keep existing snackbars visible.
  /// The [duration] defaults to 5 seconds.
  static void show(
    BuildContext context, {
    required String message,
    bool clearPrevious = true,
    Duration duration = const Duration(seconds: 5),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    if (clearPrevious) {
      messenger.clearSnackBars();
    }
    messenger.showSnackBar(
      _buildSnackBar(
        message: message,
        backgroundColor: context.uiColors.textPrimary,
        textColor: context.uiColors.textPrimaryInverse,
        duration: duration,
      ),
    );
  }

  /// Shows a temporary error snackbar with the given [message].
  ///
  /// The snackbar uses [UiColors.error] as background color
  /// and [UiColors.textPrimaryInverse] as text color.
  ///
  /// Set [clearPrevious] to `false` to keep existing snackbars visible.
  /// The [duration] defaults to 5 seconds.
  static void showError(
    BuildContext context, {
    required String message,
    bool clearPrevious = true,
    Duration duration = const Duration(seconds: 5),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    if (clearPrevious) {
      messenger.clearSnackBars();
    }
    messenger.showSnackBar(
      _buildSnackBar(
        message: message,
        backgroundColor: context.uiColors.error,
        textColor: context.uiColors.textPrimaryInverse,
        duration: duration,
      ),
    );
  }

  static SnackBar _buildSnackBar({
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required Duration duration,
  }) {
    return SnackBar(
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(
        bottom: 32.0,
        left: 16.0,
        right: 16.0,
      ),
      showCloseIcon: true,
      closeIconColor: textColor,
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
