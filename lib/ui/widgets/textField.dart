import 'package:flutter/material.dart';

class ZachranObedTextField extends StatefulWidget {
  const ZachranObedTextField({
    Key? key,
    required this.text,
    this.obscureText = false,
    required this.controller,
  }) : super(key: key);

  final String text;
  final bool obscureText;
  final TextEditingController controller;

  @override
  State<ZachranObedTextField> createState() => _ZachranObedTextFieldState();
}

class _ZachranObedTextFieldState extends State<ZachranObedTextField> {

  final TextFieldBorder = const OutlineInputBorder(
    borderSide: BorderSide(
      width: 2,
      color: Colors.black,
    ),
    borderRadius: BorderRadius.zero,
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: widget.text,
        labelStyle: TextStyle(color: Colors.grey[600]),
        enabledBorder: TextFieldBorder,
        focusedBorder: TextFieldBorder,
        focusColor: Colors.redAccent,
      ),
    );
  }
}
