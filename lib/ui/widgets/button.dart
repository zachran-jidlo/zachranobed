import 'package:flutter/material.dart';
import 'package:zachranobed/shared/constants.dart';

class ZachranObedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSecondary;

  const ZachranObedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: !isSecondary
            ? ZachranObedColors.primary
            : ZachranObedColors().secondary,
        minimumSize: const Size.fromHeight(50),
        shape: const StadiumBorder(),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: !isSecondary
              ? ZachranObedColors.onPrimary
              : ZachranObedColors.onSecondary,
        ),
      ),
    );
  }
}
