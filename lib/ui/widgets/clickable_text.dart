import 'package:flutter/material.dart';

class ZOClickableText extends StatelessWidget {
  final String clickableText;
  final String? prefixText;
  final Color color;
  final bool underline;
  final VoidCallback onTap;

  const ZOClickableText({
    super.key,
    required this.clickableText,
    this.prefixText,
    this.color = Colors.black,
    this.underline = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: prefixText,
                style: const TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: clickableText,
                style: TextStyle(
                  color: color,
                  decoration: underline ? TextDecoration.underline : null,
                  decorationColor: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
