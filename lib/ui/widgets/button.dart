import 'package:flutter/material.dart';
import 'package:zachranobed/constants.dart';

class ZachranObedButton extends StatelessWidget {
  const ZachranObedButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(50),
        backgroundColor: ZachranObedColors.primaryLight,
      ),
      onPressed: onPressed,
      child: Text(
        text,
      ),
    );
  }
}
