import 'package:flutter/material.dart';
import 'package:zachranobed/shared/constants.dart';

class MenuItem extends StatelessWidget {
  final IconData leadingIcon;
  final String text;
  final VoidCallback? onPressed;

  const MenuItem({
    super.key,
    required this.leadingIcon,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: ZachranObedColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Icon(leadingIcon),
              const SizedBox(width: 16.0),
              Text(text, style: const TextStyle(fontSize: 16.0)),
              const Spacer(),
              onPressed != null
                  ? const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
