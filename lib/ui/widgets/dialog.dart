import 'package:flutter/material.dart';

class ZachranObedDialog extends StatelessWidget {
  const ZachranObedDialog({
    Key? key,
    required this.title,
    this.content = "",
    required this.confirmText,
    required this.cancelText,
    required this.onConfirmPressed,
    required this.onCancelPressed,
  }) : super(key: key);

  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirmPressed;
  final VoidCallback onCancelPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: onCancelPressed,
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: onConfirmPressed,
          child: Text(confirmText),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
