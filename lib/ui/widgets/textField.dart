import 'package:flutter/material.dart';

class ZachranObedTextField extends StatefulWidget {
  const ZachranObedTextField({
    Key? key,
    required this.text,
    this.obscureText = false,
  }) : super(key: key);

  final String text;
  final bool obscureText;

  @override
  State<ZachranObedTextField> createState() => _ZachranObedTextFieldState();
}

class _ZachranObedTextFieldState extends State<ZachranObedTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        labelText: widget.text,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              width: 2
          ),
          borderRadius: BorderRadius.zero,
        ),
      ),
    );
  }
}
