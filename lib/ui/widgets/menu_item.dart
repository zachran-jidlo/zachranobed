import 'package:flutter/material.dart';
import 'package:zachranobed/shared/constants.dart';

class MenuItem extends StatelessWidget {
  final IconData leadingIcon;
  final String text;
  final bool isClickable;

  const MenuItem({
    super.key,
    required this.leadingIcon,
    required this.text,
    this.isClickable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ZachranObedColors.cardBackground,
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          children: [
            Icon(leadingIcon),
            const SizedBox(width: 15.0),
            Text(
              text,
              style: const TextStyle(fontSize: 16.0),
            ),
            const Spacer(),
            isClickable
                ? const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
