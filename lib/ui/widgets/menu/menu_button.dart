import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';
import 'package:zachranobed/ui/widgets/button.dart';

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final Size? minimumSize;

  const MenuButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.minimumSize = ZOButtonSize.largeMatchParent,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 0.50,
              color: ZOColors.lightBorderColor,
            ),
            borderRadius: BorderRadius.circular(8)),
        minimumSize: minimumSize,
      ),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text, style: const TextStyle(fontSize: FontSize.s)),
    );
  }
}
