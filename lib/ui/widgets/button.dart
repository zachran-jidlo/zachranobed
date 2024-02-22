import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

class ZOButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isSecondary;
  final double height;
  final bool fullWidth;

  static const Color _defaultPrimaryColor = ZOColors.primary;
  static const Color _defaultSecondaryColor = ZOColors.secondary;
  static const Color _defaultOnPrimaryColor = ZOColors.onPrimary;
  static const Color _defaultOnSecondaryColor = ZOColors.onSecondary;

  const ZOButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.isSecondary = false,
    this.height = 56.0,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = backgroundColor ??
        (isSecondary ? _defaultSecondaryColor : _defaultPrimaryColor);
    final Color fg = foregroundColor ??
        (isSecondary ? _defaultOnSecondaryColor : _defaultOnPrimaryColor);

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        minimumSize: fullWidth ? Size.fromHeight(height) : null,
        shape: const StadiumBorder(),
      ),
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 18.0,
        color: fg,
      ),
      label: Text(
        text,
        style: TextStyle(
          color: fg,
          fontSize: FontSize.xs,
        ),
      ),
    );
  }
}
