import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zachranobed/shared/constants.dart';

class ZachranObedTextField extends StatelessWidget {
  final String text;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? onValidation;
  final TextInputType? inputType;
  final List<TextInputFormatter>? textInputFormatters;

  const ZachranObedTextField({
    Key? key,
    required this.text,
    this.obscureText = false,
    required this.controller,
    this.onValidation,
    this.inputType,
    this.textInputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: Colors.black,
      validator: onValidation,
      keyboardType: inputType,
      inputFormatters: textInputFormatters,
      decoration: InputDecoration(
        labelText: text,
        labelStyle: TextStyle(color: Colors.grey[600]),
        enabledBorder: WidgetStyle.inputBorder,
        focusedBorder: WidgetStyle.inputBorder,
      ),
    );
  }
}
