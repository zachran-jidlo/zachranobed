import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

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
            left: WidgetStyle.padding,
            right: WidgetStyle.padding,
          ),
          showCloseIcon: true,
          content: Text(message),
        );
}
