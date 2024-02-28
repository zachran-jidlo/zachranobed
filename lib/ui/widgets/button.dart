import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

class ZOButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ZOButtonType type;
  final IconData? icon;
  final double height;
  final bool fullWidth;

  const ZOButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ZOButtonType.primary,
    this.icon,
    this.height = 56.0,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      foregroundColor: type.foregroundColor,
      backgroundColor: type.backgroundColor,
      minimumSize: fullWidth ? Size.fromHeight(height) : null,
      shape: const StadiumBorder(),
      textStyle: const TextStyle(fontSize: FontSize.xs),
    );

    if (icon != null) {
      return ElevatedButton.icon(
        style: style,
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 18.0,
        ),
        label: Text(text),
      );
    } else {
      return ElevatedButton(
        style: style,
        onPressed: onPressed,
        child: Text(text),
      );
    }
  }
}

enum ZOButtonType {
  primary(ZOColors.primary, ZOColors.onPrimary),
  secondary(ZOColors.secondary, ZOColors.onSecondary),
  success(ZOColors.success, ZOColors.onSuccess);

  const ZOButtonType(this.backgroundColor, this.foregroundColor);

  final Color backgroundColor;
  final Color foregroundColor;
}
