import 'package:flutter/material.dart';

class ZachranObedCloseButton extends StatelessWidget {
  final Color? color;
  final VoidCallback? onPressed;

  const ZachranObedCloseButton({
    super.key,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.highlight_off),
      color: color,
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.maybePop(context);
        }
      },
    );
  }
}
