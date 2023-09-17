import 'package:flutter/material.dart';
import 'package:zachranobed/common/constants.dart';

class ZODropdown extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final String? Function(String?)? onValidation;
  final Function(String) onChanged;
  final String? initialValue;

  const ZODropdown({
    super.key,
    required this.hintText,
    required this.items,
    this.onValidation,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<ZODropdown> createState() => _ZODropdownState();
}

class _ZODropdownState extends State<ZODropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      hint: Text(widget.hintText),
      validator: widget.onValidation,
      items: widget.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          widget.onChanged(value!);
        });
      },
      value: widget.initialValue,
      decoration: const InputDecoration(
        enabledBorder: WidgetStyle.inputBorder,
        focusedBorder: WidgetStyle.inputBorder,
      ),
    );
  }
}
