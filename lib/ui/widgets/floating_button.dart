import 'package:flutter/material.dart';

class ZachranObedFloatingButton extends StatelessWidget {
  const ZachranObedFloatingButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.add),
    );
  }
}
