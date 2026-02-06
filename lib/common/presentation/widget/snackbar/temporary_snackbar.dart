import 'package:flutter/material.dart';
import 'package:zachranobed/common/presentation/utils/ui_constants.dart';

class ZOTemporarySnackBar extends SnackBar {
  final String message;

  ZOTemporarySnackBar({
    super.key,
    Color? backgroundColor,
    Duration? duration,
    required this.message,
  }) : super(
          backgroundColor: backgroundColor ?? ZOColors.infoSnackBarBackground,
          duration: duration ?? const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(
            bottom: 32.0,
            left: 16.0,
            right: 16.0,
          ),
          showCloseIcon: true,
          content: Text(message),
        );
}
