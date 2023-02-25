import 'package:flutter/material.dart';

class ZachranObedDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirmPressed;
  final VoidCallback onCancelPressed;

  const ZachranObedDialog({
    Key? key,
    required this.title,
    this.content = '',
    required this.confirmText,
    required this.cancelText,
    required this.onConfirmPressed,
    required this.onCancelPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(title)),
      content: Text(content),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(onPressed: onCancelPressed, child: Text(cancelText)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(onPressed: onConfirmPressed, child: Text(confirmText)),
          ],
        ),
      ],
    );
  }
}
