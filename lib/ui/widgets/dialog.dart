import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

class ZODialog extends StatelessWidget {
  final String title;
  final String content;
  final String? confirmText;
  final String cancelText;
  final VoidCallback? onConfirmPressed;
  final VoidCallback onCancelPressed;

  const ZODialog({
    super.key,
    required this.title,
    this.content = '',
    this.confirmText,
    required this.cancelText,
    this.onConfirmPressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ZOColors.primaryLight,
      surfaceTintColor: Colors.transparent,
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(onPressed: onCancelPressed, child: Text(cancelText)),
        confirmText != null
            ? TextButton(
                onPressed: onConfirmPressed,
                style: TextButton.styleFrom(
                  backgroundColor: ZOColors.secondary,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Text(
                  confirmText!,
                  style: const TextStyle(color: ZOColors.onSecondary),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
