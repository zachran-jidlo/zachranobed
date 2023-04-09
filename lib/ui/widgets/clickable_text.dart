import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ZachranObedClickableText extends StatelessWidget {
  final String text;
  final Color color;
  final bool underline;
  final VoidCallback onTap;

  const ZachranObedClickableText({
    Key? key,
    required this.text,
    this.color = Colors.black,
    this.underline = true,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: text,
          style: TextStyle(
            color: color,
            decoration: underline ? TextDecoration.underline : null,
          ),
          recognizer: TapGestureRecognizer()..onTap = onTap),
    );
  }
}
