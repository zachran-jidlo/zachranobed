import 'package:flutter/material.dart';

class ZachranObedTextField extends StatefulWidget {
  const ZachranObedTextField({
    Key? key,
    required this.text,
    this.obscureText = false,
    required this.controller,
    this.onValidation,
    required this.inputType,
  }) : super(key: key);

  final String text;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? onValidation;
  final TextInputType inputType;

  @override
  State<ZachranObedTextField> createState() => _ZachranObedTextFieldState();
}

class _ZachranObedTextFieldState extends State<ZachranObedTextField> {

  final _textFieldBorder = const OutlineInputBorder(
    borderSide: BorderSide(
      width: 2,
      color: Colors.black,
    ),
    borderRadius: BorderRadius.zero,
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      cursorColor: Colors.black,
      validator: widget.onValidation,
      keyboardType: widget.inputType,
      decoration: InputDecoration(
        labelText: widget.text,
        labelStyle: TextStyle(color: Colors.grey[600]),
        enabledBorder: _textFieldBorder,
        focusedBorder: _textFieldBorder,
      ),
    );
  }
}
