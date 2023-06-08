import 'package:flutter/material.dart';
import 'package:zachranobed/shared/constants.dart';

class ZachranObedButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isSecondary;
  final double height;
  final bool fullWidth;

  const ZachranObedButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.isSecondary = false,
    this.height = 56.0,
    this.fullWidth = true,
  });

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
        minimumSize: fullWidth ? Size.fromHeight(height) : null,
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
