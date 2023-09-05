import 'package:flutter/material.dart';
import 'package:zachranobed/shared/constants.dart';

class SupportingText extends StatelessWidget {
  final String text;

  const SupportingText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: FontSize.xxs,
          color: Color(0xFF534341),
        ),
      ),
    );
  }
}
