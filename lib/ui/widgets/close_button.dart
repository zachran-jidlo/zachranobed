import 'package:flutter/material.dart';

class ZachranObedCloseButton extends StatelessWidget {
  const ZachranObedCloseButton({
    Key? key,
    this.color,
    this.onPressed,
  }) : super(key: key);

  final Color? color;
  final VoidCallback? onPressed;

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
