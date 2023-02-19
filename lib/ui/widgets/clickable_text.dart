import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ZachranObedClickableText extends StatelessWidget {

  final String text;
  final VoidCallback onTap;

  const ZachranObedClickableText({
    Key? key,
    required this.text,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: text,
          style: const TextStyle(
            color: Colors.black,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = onTap
      ),
    );
  }
}
