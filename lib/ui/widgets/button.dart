import 'package:flutter/material.dart';
import 'package:zachranobed/shared/constants.dart';

class ZachranObedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ZachranObedButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        backgroundColor: ZachranObedColors.primaryLight,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
