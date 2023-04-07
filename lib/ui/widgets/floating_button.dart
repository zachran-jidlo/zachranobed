import 'package:flutter/material.dart';
import 'package:zachranobed/shared/constants.dart';

class ZachranObedFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ZachranObedFloatingButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(
        Icons.add,
        color: ZachranObedColors.primary,
      ),
    );
  }
}
