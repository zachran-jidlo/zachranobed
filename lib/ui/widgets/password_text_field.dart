import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:zachranobed/common/constants.dart';

class ZOPasswordTextField extends StatefulWidget {
  final String text;
  final TextEditingController? controller;
  final String? Function(String?)? onValidation;
  final TextInputType? inputType;
  final List<TextInputFormatter>? textInputFormatters;
  final Function(String)? onChanged;
  final String? value;

  const ZOPasswordTextField({
    super.key,
    required this.text,
    this.controller,
    this.onValidation,
    this.inputType,
    this.textInputFormatters,
    this.onChanged,
    this.value,
  });

  @override
  State<ZOPasswordTextField> createState() => _ZOPasswordTextFieldState();
}

class _ZOPasswordTextFieldState extends State<ZOPasswordTextField> {
  bool obscureText = true;
  var focus = FocusNode();

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
      focusNode: focus,
      onTapOutside: (event) => focus.unfocus(),
    );
  }
}
