import 'package:flutter/material.dart';
import 'package:zachranobed/shared/constants.dart';

class ZachranObedDialog extends StatelessWidget {
  final String title;
  final String content;
  final String? confirmText;
  final String cancelText;
  final IconData icon;
  final VoidCallback? onConfirmPressed;
  final VoidCallback onCancelPressed;

  const ZachranObedDialog({
    super.key,
    required this.title,
    this.content = '',
    this.confirmText,
    required this.cancelText,
    required this.icon,
    this.onConfirmPressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ZachranObedColors.primaryLight,
      surfaceTintColor: Colors.transparent,
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(icon)],
          ),
          const SizedBox(height: 15),
          Row(children: [Text(title)]),
        ],
      ),
      content: Text(content),
      actions: <Widget>[
        TextButton(onPressed: onCancelPressed, child: Text(cancelText)),
        confirmText != null
            ? TextButton.icon(
                onPressed: onConfirmPressed,
                style: TextButton.styleFrom(
                  backgroundColor: ZachranObedColors.secondary,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                icon: Icon(
                  icon,
                  color: ZachranObedColors.onSecondary,
                  size: 18,
                ),
                label: Text(
                  confirmText!,
                  style: const TextStyle(
                    color: ZachranObedColors.onSecondary,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
