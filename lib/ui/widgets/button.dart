import 'package:flutter/material.dart';
import 'package:zachranobed/shared/constants.dart';

class ZachranObedButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isSecondary;

  const ZachranObedButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.isSecondary = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isSecondary ? ZachranObedColors.secondary : ZachranObedColors.primary;
    final foregroundColor = isSecondary
        ? ZachranObedColors.onSecondary
        : ZachranObedColors.onPrimary;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: const Size.fromHeight(50),
        shape: const StadiumBorder(),
      ),
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 18.0,
        color: foregroundColor,
      ),
      label: Text(
        text,
        style: TextStyle(
          color: foregroundColor,
          fontSize: 14.0,
        ),
      ),
    );
  }
}
