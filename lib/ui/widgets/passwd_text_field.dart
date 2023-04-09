import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:zachranobed/shared/constants.dart';

class ZachranObedPasswordTextField extends StatefulWidget {
  final String text;
  final TextEditingController? controller;
  final String? Function(String?)? onValidation;
  final TextInputType? inputType;
  final List<TextInputFormatter>? textInputFormatters;
  final Function(String)? onChanged;
  final String? value;

  const ZachranObedPasswordTextField({
    Key? key,
    required this.text,
    this.controller,
    this.onValidation,
    this.inputType,
    this.textInputFormatters,
    this.onChanged,
    this.value,
  }) : super(key: key);

  @override
  State<ZachranObedPasswordTextField> createState() =>
      _ZachranObedPasswordTextFieldState();
}

class _ZachranObedPasswordTextFieldState
    extends State<ZachranObedPasswordTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: obscureText,
      cursorColor: Colors.black,
      validator: widget.onValidation,
      keyboardType: widget.inputType,
      inputFormatters: widget.textInputFormatters,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.text,
        labelStyle: TextStyle(color: Colors.grey[600]),
        enabledBorder: WidgetStyle.inputBorder,
        focusedBorder: WidgetStyle.inputBorder,
        suffixIcon: IconButton(
          icon: Icon(
            obscureText
                ? MaterialSymbols.visibility
                : MaterialSymbols.visibility_off,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
        ),
      ),
      initialValue: widget.value,
    );
  }
}
